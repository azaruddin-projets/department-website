package com.db.students;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Updates.*;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {

    private static final String DB_NAME = "college";
    private static final String MONGO_URI =
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); // Present / Absent
        String regNo = request.getParameter("regNo");
        String attendanceDate = request.getParameter("attendanceDate"); // STRING
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String filter = request.getParameter("filter");

        if (section != null) section = section.toLowerCase();
        String attendanceCollectionName = "students_attendance_" + year + section;

        try {
            if (attendanceDate == null || attendanceDate.isEmpty()) {
                throw new IllegalArgumentException("Attendance date is required");
            }

            // Sunday check
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateObj = sdf.parse(attendanceDate);
            Calendar cal = Calendar.getInstance();
            cal.setTime(dateObj);

            if (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                request.setAttribute("message", "Attendance cannot be marked on Sundays.");
                request.getRequestDispatcher("attendance.jsp").forward(request, response);
                return;
            }

            if ("filter".equalsIgnoreCase(filter)) {
                request.setAttribute("attendanceDate", attendanceDate);
                request.setAttribute("year", year);
                request.setAttribute("section", section);
                request.getRequestDispatcher("attendance.jsp").forward(request, response);
                return;
            }

            try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
                MongoDatabase db = mongoClient.getDatabase(DB_NAME);
                MongoCollection<Document> attendanceCol =
                        db.getCollection(attendanceCollectionName);

                Document existing = attendanceCol.find(
                        and(eq("reg_no", regNo),
                            eq("attendance_date", attendanceDate))
                ).first();

                if (existing != null) {
                    attendanceCol.updateOne(
                            and(eq("reg_no", regNo),
                                eq("attendance_date", attendanceDate)),
                            set("attendance_status", action)
                    );
                } else {
                    attendanceCol.insertOne(
                            new Document("reg_no", regNo)
                                    .append("attendance_date", attendanceDate)
                                    .append("attendance_status", action)
                    );
                }
            }

            request.setAttribute("attendanceDate", attendanceDate);
            request.setAttribute("year", year);
            request.setAttribute("section", section);
            request.getRequestDispatcher("attendance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", e.getMessage());
            request.getRequestDispatcher("attendance.jsp").forward(request, response);
        }
    }
}
