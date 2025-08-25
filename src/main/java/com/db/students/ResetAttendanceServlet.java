package com.db.students;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/resetAttendance")
public class ResetAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DATE_FORMAT = "yyyy-MM-dd";

    // MongoDB connection info
    private static final String CONNECTION_STRING = "mongodb://localhost:27017";
    private static final String DATABASE_NAME = "college"; // Replace with your DB name

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String regNo = request.getParameter("regNo");
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String attendanceDateStr = request.getParameter("attendanceDate");

        response.setContentType("text/plain;charset=UTF-8");

        if (regNo == null || regNo.isEmpty() ||
            year == null || year.isEmpty() ||
            section == null || section.isEmpty() ||
            attendanceDateStr == null || attendanceDateStr.isEmpty()) {

            response.getWriter().write("One or more required parameters are missing or empty.");
            return;
        }

        if (!isValidDate(attendanceDateStr)) {
            response.getWriter().write("Invalid date format. Expected format: yyyy-MM-dd.");
            return;
        }

        section = section.toLowerCase();
        String collectionName = "students_attendance_" + year + section;

        try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
            MongoCollection<Document> attendanceCollection = database.getCollection(collectionName);

            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
            Date attendanceDate = sdf.parse(attendanceDateStr);

            // Delete the attendance document matching reg_no and attendance_date
            long deletedCount = attendanceCollection.deleteOne(
                Filters.and(
                    Filters.eq("REG_NO", regNo),
                    Filters.eq("ATTENDANCE_DATE", attendanceDate)
                )
            ).getDeletedCount();

            if (deletedCount > 0) {
                response.getWriter().write("Attendance reset successfully!");
            } else {
                response.getWriter().write("No record found for the given registration number and date.");
            }

        } catch (ParseException e) {
            response.getWriter().write("Date parsing error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("An error occurred: " + e.getMessage());
        }
    }

    private boolean isValidDate(String dateStr) {
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        sdf.setLenient(false);
        try {
            sdf.parse(dateStr);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }
}
