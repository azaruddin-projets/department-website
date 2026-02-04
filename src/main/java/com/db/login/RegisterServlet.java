package com.db.login;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns={"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String MONGO_URI = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DATABASE_NAME = "college"; 
    private static final String COLLECTION_NAME = "students"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String email = request.getParameter("email");
        String securityQuestion1 = request.getParameter("security-question1");
        String securityAnswer1 = request.getParameter("security-answer1");
        String securityQuestion2 = request.getParameter("security-question2");
        String securityAnswer2 = request.getParameter("security-answer2");
        String year = request.getParameter("year");
        String section = request.getParameter("section");

        System.out.println("Received parameters:");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        System.out.println("Phone: " + phone);
        System.out.println("Date of Birth: " + dob);
        System.out.println("Email: " + email);
        System.out.println("Security Question 1: " + securityQuestion1);
        System.out.println("Security Answer 1: " + securityAnswer1);
        System.out.println("Security Question 2: " + securityQuestion2);
        System.out.println("Security Answer 2: " + securityAnswer2);
        System.out.println("Year: " + year);
        System.out.println("Section: " + section);

        if (!this.isValidUsername(username)) {
            this.sendJsonResponse(response, "error", "Invalid username format.");
            return;
        }
        if (!this.isValidEmail(email)) {
            this.sendJsonResponse(response, "error", "Invalid email format.");
            return;
        }

        MongoClient client = null;
        try {
            client = MongoClients.create(MONGO_URI);
            MongoCollection<Document> collection = client.getDatabase(DATABASE_NAME).getCollection(COLLECTION_NAME);            
            Document existingUser = collection.find(Filters.or(Filters.eq("username", username), Filters.eq("email", email))).first();

            if (existingUser != null) {
                this.sendJsonResponse(response, "error", "Username or email already in use.");
                return;
            }

            Document newUser = new Document("username", username)
                    .append("password", password)
                    .append("phone", phone)
                    .append("dob", dob)
                    .append("security_question1", securityQuestion1)
                    .append("security_answer1", securityAnswer1)
                    .append("security_question2", securityQuestion2)
                    .append("security_answer2", securityAnswer2)
                    .append("year", year)
                    .append("section", section)
                    .append("email", email);

            collection.insertOne(newUser);

            this.sendJsonResponse(response, "success", "New user registered successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            this.sendJsonResponse(response, "error", "An error occurred: " + e.getMessage());
        } finally {
            if (client != null) {
                client.close();             
            }
        }
    }

    private boolean isValidUsername(String username) {
        String pattern1 = "228x1a42[a-j][0-9]";
        String pattern2 = "238x5a42[0-9][0-9]";
        String pattern3 = "228x1a42[0-9][0-9]";
        return username.matches(pattern1) || username.matches(pattern2) || username.matches(pattern3);
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
        return email.matches(emailRegex);
    }

    // Place this method inside RegisterServlet class but outside any other methods
    private void sendJsonResponse(HttpServletResponse response, String status, String message) throws IOException {
        response.setContentType("application/json");  // Ensure JSON response
        response.setCharacterEncoding("UTF-8");

        // Create a JSON response as a string
        String jsonResponse = "{ \"status\": \"" + status + "\", \"message\": \"" + message + "\" }";
        response.getWriter().write(jsonResponse);  // Write response
    }
}
