package com.db.students;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/resetAttendance")
public class ResetAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI =
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String regNo = request.getParameter("regNo");
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String attendanceDate = request.getParameter("attendanceDate");

        response.setContentType("text/plain;charset=UTF-8");

        if (regNo == null || year == null || section == null || attendanceDate == null ||
            regNo.isEmpty() || year.isEmpty() || section.isEmpty() || attendanceDate.isEmpty()) {

            response.getWriter().write("All fields are required.");
            return;
        }

        section = section.toLowerCase();
        String collectionName = "students_attendance_" + year + section;

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {

            MongoDatabase database = mongoClient.getDatabase(DB_NAME);
            MongoCollection<Document> attendanceCollection =
                    database.getCollection(collectionName);

            long deletedCount = attendanceCollection.deleteOne(
                    Filters.and(
                            Filters.eq("reg_no", regNo),
                            Filters.eq("attendance_date", attendanceDate)
                    )
            ).getDeletedCount();

            if (deletedCount > 0) {
                response.getWriter().write("Attendance reset successfully!");
            } else {
                response.getWriter().write("No attendance record found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
