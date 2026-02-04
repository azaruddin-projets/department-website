package com.db.login;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.bson.conversions.Bson;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private static final String MONGO_URI = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";
    private static final String USER_COLLECTION = "students";
    private static final String OTP_COLLECTION = "otp";

    private static final String EMAIL_USER = System.getenv("EMAIL_USER");
    private static final String EMAIL_PASSWORD = System.getenv("EMAIL_PASSWORD");


    private MongoClient mongoClient;

    @Override
    public void init() throws ServletException {
        mongoClient = MongoClients.create(MONGO_URI);
    }

    @Override
    public void destroy() {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");
        String otp = request.getParameter("otp");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (otp != null && !otp.isEmpty()) {
            if (verifyOtp(username, otp)) {
                if (resetPassword(username, newPassword)) {
                    out.println("{\"status\":\"success\", \"message\":\"Password reset successful.\"}");
                } else {
                    out.println("{\"status\":\"error\", \"message\":\"Failed to reset password.\"}");
                }
            } else {
                out.println("{\"status\":\"error\", \"message\":\"Invalid or expired OTP.\"}");
            }
        } else {
            String generatedOtp = generateOtp();
            if (sendOtpEmail(username, generatedOtp)) {
                saveOtpToDatabase(username, generatedOtp);
                out.println("{\"status\":\"success\", \"message\":\"OTP sent to email.\"}");
            } else {
                out.println("{\"status\":\"error\", \"message\":\"Failed to send OTP.\"}");
            }
        }
    }

    private boolean resetPassword(String username, String newPassword) {
        MongoDatabase db = mongoClient.getDatabase(DB_NAME);
        MongoCollection<Document> users = db.getCollection(USER_COLLECTION);

        Bson filter = Filters.eq("username", username);
        Bson update = new Document("$set", new Document("password", newPassword));

        return users.updateOne(filter, update).getModifiedCount() > 0;
    }

    private String generateOtp() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }

    private boolean sendOtpEmail(String username, String otp) {
        String email = getUserEmail(username);
        if (email == null) return false;

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USER, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Your OTP Code");
            message.setText("Your OTP is: " + otp + "\nIt will expire in 5 minutes.");
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String getUserEmail(String username) {
        MongoDatabase db = mongoClient.getDatabase(DB_NAME);
        MongoCollection<Document> users = db.getCollection(USER_COLLECTION);

        Document user = users.find(Filters.eq("username", username)).first();
        return user != null ? user.getString("email") : null;
    }

    private void saveOtpToDatabase(String username, String otp) {
        MongoDatabase db = mongoClient.getDatabase(DB_NAME);
        MongoCollection<Document> otps = db.getCollection(OTP_COLLECTION);

        Timestamp expiry = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000);

        Document otpDoc = new Document("username", username)
                .append("otp", otp)
                .append("otp_expiry", expiry);

        otps.deleteMany(Filters.eq("username", username));
        otps.insertOne(otpDoc);
    }

    private boolean verifyOtp(String username, String otp) {
        MongoDatabase db = mongoClient.getDatabase(DB_NAME);
        MongoCollection<Document> otps = db.getCollection(OTP_COLLECTION);

        Document doc = otps.find(Filters.eq("username", username)).first();

        if (doc != null) {
            String storedOtp = doc.getString("otp");
            Date expiry = doc.getDate("otp_expiry");

            return otp.equals(storedOtp) && expiry != null && expiry.after(new Date());
        }

        return false;
    }
}
