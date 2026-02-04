package com.db.login;

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

@WebServlet({"/VerifySecurityAnswersServlet"})
public class VerifySecurityAnswersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String CONNECTION_STRING = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DATABASE_NAME = "college";  // Replace with your DB name
    private static final String COLLECTION_NAME = "students";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String answer1 = request.getParameter("answer1");
        String answer2 = request.getParameter("answer2");

        boolean validAnswers = verifySecurityAnswers(username, answer1, answer2);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        if (validAnswers) {
            out.println("{\"status\":\"success\"}");
        } else {
            out.println("{\"status\":\"error\", \"message\":\"Security answers are incorrect.\"}");
        }
    }

    private boolean verifySecurityAnswers(String username, String answer1, String answer2) {
        boolean valid = false;

        try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
            MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
            MongoCollection<Document> collection = database.getCollection(COLLECTION_NAME);

            Document query = new Document("username", username);
            Document userDoc = collection.find(query).first();

            if (userDoc != null) {
                String correctAnswer1 = userDoc.getString("security_answer1");
                String correctAnswer2 = userDoc.getString("security_answer2");
                valid = correctAnswer1 != null && correctAnswer2 != null
                        && correctAnswer1.equals(answer1)
                        && correctAnswer2.equals(answer2);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return valid;
    }
}
