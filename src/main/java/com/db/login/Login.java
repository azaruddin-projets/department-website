package com.db.login;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet({"/validate"})
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Login.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		String id = request.getParameter("MYUSER");
		String pwd = request.getParameter("MYPWD");
		String otpStr = request.getParameter("MYOTP");

		if ("admin".equals(id) && "aiml$2022".equals(pwd)) {
			if (otpStr != null && !otpStr.trim().isEmpty()) {
				int otp;
				try {
					otp = Integer.parseInt(otpStr);
				} catch (NumberFormatException e) {
					logger.error("Invalid OTP format: {}", otpStr, e);
					response.sendRedirect("INDEX.jsp?error=Invalid OTP format");
					return;
				}

				String secret = getAdminSecret();
				GoogleAuthenticator gAuth = new GoogleAuthenticator();
				boolean isValidOTP = gAuth.authorize(secret, otp);
				if (isValidOTP) {
					response.sendRedirect("adminhome.jsp");
				} else {
					response.sendRedirect("INDEX.jsp?error=Invalid OTP");
				}
			} else {
				response.sendRedirect("INDEX.jsp?error=OTP is required");
			}
		} else {
			MongoClient mongoClient = null;
			try {
			    mongoClient = MongoClients.create(
			        "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college"
			    );

			    MongoDatabase database = mongoClient.getDatabase("college");
				MongoCollection<Document> collection = database.getCollection("students");

				Document query = new Document("username", id);
				Document user = collection.find(query).first();

				if (user != null) {
					String storedPwd = user.getString("password");
					if (pwd.equals(storedPwd)) {
						response.sendRedirect("studenthome.jsp");
					} else {
						response.sendRedirect("INDEX.jsp?error=Incorrect password");
					}
				} else {
					response.sendRedirect("INDEX.jsp?error=Username not found");
				}
			} catch (Exception e) {
				logger.error("MongoDB error", e);
				response.sendRedirect("INDEX.jsp?error=Database error");
			} finally {
				if (mongoClient != null) {
					mongoClient.close();
				}
			}
		}
	}

	private String getAdminSecret() {
		return "JBSWY3DPEHPK3PXP";
	}
}
