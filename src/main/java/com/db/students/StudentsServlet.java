package com.db.students;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.bson.Document;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;

@WebServlet("/StudentsServlet")
public class StudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String attendanceDateStr = request.getParameter("attendanceDate");

        if (year == null || section == null || attendanceDateStr == null || year.isEmpty() || section.isEmpty() || attendanceDateStr.isEmpty()) {
            request.setAttribute("message", "Year, Section, and Attendance Date are required.");
            request.getRequestDispatcher("attendance.jsp").forward(request, response);
            return;
        }

        String studentClass = year + section.toLowerCase(); // lowercase section
        String studentCollectionName = "students_" + studentClass;
        String attendanceCollectionName = "students_attendance_" + studentClass;

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            MongoCollection<Document> studentCollection = database.getCollection(studentCollectionName);
            MongoCollection<Document> attendanceCollection = database.getCollection(attendanceCollectionName);

            List<Document> studentsWithAttendance = new ArrayList<>();

            // Fetch all students with correct field names
            FindIterable<Document> students = studentCollection.find()
                    .projection(Projections.include("reg_no", "name"));

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(attendanceDateStr);
            // End of day: 23:59:59.999
            Date endDate = new Date(startDate.getTime() + 24 * 60 * 60 * 1000 - 1);

            for (Document student : students) {
                String regNo = student.getString("reg_no");

                Document attendance = attendanceCollection.find(Filters.and(
                    Filters.eq("reg_no", regNo),
                    Filters.gte("attendance_date", startDate),
                    Filters.lte("attendance_date", endDate)
                )).first();

                String status = (attendance != null) ? attendance.getString("attendance_status") : "Not Marked";

                Document result = new Document()
                        .append("reg_no", regNo)
                        .append("name", student.getString("name"))
                        .append("attendance_status", status);

                studentsWithAttendance.add(result);
            }

            request.setAttribute("students", studentsWithAttendance);
            request.setAttribute("attendanceDate", attendanceDateStr);
            request.setAttribute("year", year);
            request.setAttribute("section", section);
            request.getRequestDispatcher("attendance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("attendance.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
