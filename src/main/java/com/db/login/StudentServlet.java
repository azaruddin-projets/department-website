package com.db.login;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet({"/student"})
public class StudentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String CONNECTION_STRING = "mongodb://localhost:27017";
	private static final String DATABASE_NAME = "college"; // Replace with your DB name
	private static final String COLLECTION_NAME = "students";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		String username = request.getParameter("username");

		try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
			MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
			MongoCollection<Document> collection = database.getCollection(COLLECTION_NAME);

			Document query = new Document("username", username);
			FindIterable<Document> result = collection.find(query);

			Document student = result.first();

			if (student != null) {
				String attendancePercentage = student.get("attendance_percentage").toString();
				pw.print("<h1>Student Attendance</h1>");
				pw.print("<p>Attendance Percentage: " + attendancePercentage + "%</p>");
			} else {
				pw.print("<h1>No attendance data found.</h1>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			pw.print("<h1>An error occurred. Please try again later.</h1>");
		} finally {
			pw.print("<a href='INDEX.html'>Home</a>");
		}
	}
}
