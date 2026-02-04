package com.db.login;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.json.JSONObject;

@WebServlet({"/GetSecurityQuestionsServlet"})
public class GetSecurityQuestionsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("username");
		String[] questions = getSecurityQuestions(username);
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		if (questions != null) {
			JSONObject json = new JSONObject();
			json.put("status", "success");
			json.put("question1", questions[0]);
			json.put("question2", questions[1]);
			out.println(json.toString());
		} else {
			out.println("{\"status\":\"error\", \"message\":\"Username not found.\"}");
		}
	}

	private String[] getSecurityQuestions(String username) {
		String[] questions = null;
		MongoClient mongoClient = null;

		try {
			mongoClient = MongoClients.create(
				    "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college"
				);

			MongoDatabase database = mongoClient.getDatabase("college");
			MongoCollection<Document> collection = database.getCollection("students");

			Document query = new Document("username", username);
			Document user = collection.find(query).first();

			if (user != null) {
				questions = new String[]{
					user.getString("security_question1"),
					user.getString("security_question2")
				};
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (mongoClient != null) {
				mongoClient.close();
			}
		}

		return questions;
	}
}
