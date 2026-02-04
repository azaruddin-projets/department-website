package com.db.students;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

import org.bson.Document;

import static com.mongodb.client.model.Filters.eq;

@WebServlet("/removeStudent")
public class RemoveStudentServlet extends HttpServlet {

    private static final String MONGO_URI =
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String regNo = request.getParameter("regNoRemove");
        String year = request.getParameter("year");
        String section = request.getParameter("section");

        String message;

        if (regNo == null || year == null || section == null ||
            regNo.isEmpty() || year.isEmpty() || section.isEmpty()) {

            message = "All fields are required!";
            request.setAttribute("message", message);
            request.getRequestDispatcher("manageStudents.jsp").forward(request, response);
            return;
        }

        section = section.toLowerCase();

        String studentsCollectionName = "students_" + year + section;
        String attendanceCollectionName = "students_attendance_" + year + section;

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {

            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            MongoCollection<Document> studentsCollection =
                    database.getCollection(studentsCollectionName);

            MongoCollection<Document> attendanceCollection =
                    database.getCollection(attendanceCollectionName);

            long studentDeleted =
                    studentsCollection.deleteOne(eq("reg_no", regNo)).getDeletedCount();

            long attendanceDeleted =
                    attendanceCollection.deleteMany(eq("reg_no", regNo)).getDeletedCount();

            if (studentDeleted > 0) {
                message = "Student removed successfully!";
            } else {
                message = "Student not found!";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "Error removing student: " + e.getMessage();
        }

        request.setAttribute("message", message);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("manageStudents.jsp");
        dispatcher.forward(request, response);
    }
}
