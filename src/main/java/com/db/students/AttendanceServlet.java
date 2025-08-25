package com.db.students;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Updates.*;

@WebServlet({"/AttendanceServlet"})
public class AttendanceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String DB_NAME = "college";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action"); // Present / Absent
		String regNo = request.getParameter("regNo");
		String name = request.getParameter("student_name"); // optional
		String attendanceDate = request.getParameter("attendanceDate");
		String year = request.getParameter("year");
		String section = request.getParameter("section");
		String filter = request.getParameter("filter");

		if (section != null) section = section.toLowerCase();
		String attendanceCollectionName = "students_attendance_" + year + section;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date dateObj;

		try {
			if (attendanceDate == null || attendanceDate.trim().isEmpty())
				throw new IllegalArgumentException("Attendance date is required.");

			dateObj = sdf.parse(attendanceDate);
			Calendar cal = Calendar.getInstance();
			cal.setTime(dateObj);
			int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
			if (dayOfWeek == Calendar.SUNDAY) {
				request.setAttribute("message", "Attendance cannot be marked on Sundays.");
				request.getRequestDispatcher("attendance.jsp").forward(request, response);
				return;
			}

			Calendar today = Calendar.getInstance();
			if (!cal.after(today)) {

				// Handle filter action
				if ("filter".equalsIgnoreCase(filter)) {
					request.setAttribute("attendanceDate", attendanceDate);
					request.setAttribute("year", year);
					request.setAttribute("section", section);
					request.getRequestDispatcher("attendance.jsp").forward(request, response);
					return;
				}

				try (MongoClient mongoClient = new MongoClient("localhost", 27017)) {
					MongoDatabase db = mongoClient.getDatabase(DB_NAME);
					MongoCollection<Document> attendanceCol = db.getCollection(attendanceCollectionName);

					// Check if entry already exists
					Document existing = attendanceCol.find(
							and(eq("reg_no", regNo), eq("attendance_date", attendanceDate))
					).first();

					if (existing != null) {
						// Update existing document
						attendanceCol.updateOne(
								and(eq("reg_no", regNo), eq("attendance_date", attendanceDate)),
								set("attendance_status", action)
						);
					} else {
						// Insert new document
						Document doc = new Document("reg_no", regNo)
								.append("attendance_date", attendanceDate)
								.append("attendance_status", action);
						attendanceCol.insertOne(doc);
					}
				}

				// Set attributes and redirect to JSP
				request.setAttribute("attendanceDate", attendanceDate);
				request.setAttribute("year", year);
				request.setAttribute("section", section);
				request.getRequestDispatcher("attendance.jsp").forward(request, response);
				return;
			}

			request.setAttribute("message", "Attendance cannot be marked for future dates.");
			request.getRequestDispatcher("attendance.jsp").forward(request, response);

		} catch (ParseException e) {
			request.setAttribute("message", "Invalid date format. Please use yyyy-MM-dd.");
			request.getRequestDispatcher("attendance.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("message", "An error occurred while processing the request.");
			request.getRequestDispatcher("attendance.jsp").forward(request, response);
		}
	}
}
