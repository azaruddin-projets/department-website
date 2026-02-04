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

@WebServlet({"/addStudent"})
public class AddStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String CONNECTION_STRING = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DATABASE_NAME = "college"; // replace with your DB name

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String regNo = request.getParameter("regNo");
        String studentName = request.getParameter("studentName");
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String branch = request.getParameter("branch");

        String message = "";

        try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);

            // Collections for students and attendance, dynamically named like Oracle tables
            String studentsCollectionName = "students_" + year + section.toLowerCase();
            String attendanceCollectionName = "students_attendance_" + year + section.toLowerCase();

            MongoCollection<Document> studentsCollection = database.getCollection(studentsCollectionName);
            MongoCollection<Document> attendanceCollection = database.getCollection(attendanceCollectionName);

            // Insert student document
         // Check duplicate student
            Document existingStudent = studentsCollection.find(
                    new Document("reg_no", regNo)
            ).first();

            if (existingStudent != null) {
                message = "Student already exists!";
                request.setAttribute("message", message);
                request.getRequestDispatcher("manageStudents.jsp").forward(request, response);
                return;
            }

            // Insert student
            Document studentDoc = new Document("reg_no", regNo)
                    .append("name", studentName)
                    .append("branch", branch);
            studentsCollection.insertOne(studentDoc);

            // Insert attendance (STRING date)
            String today = new java.text.SimpleDateFormat("yyyy-MM-dd")
                    .format(new java.util.Date());

            Document attendanceDoc = new Document("reg_no", regNo)
                    .append("attendance_date", today)
                    .append("attendance_status", "Present");
            attendanceCollection.insertOne(attendanceDoc);


            message = "Student added successfully!";

        } catch (Exception e) {
            e.printStackTrace();
            message = "Error adding student: " + e.getMessage();
        }

        request.setAttribute("message", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("manageStudents.jsp");
        dispatcher.forward(request, response);
    }
}
