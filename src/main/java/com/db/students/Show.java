package com.db.students;

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
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

import static com.mongodb.client.model.Filters.*;

@WebServlet({"/viewstudents"})
public class Show extends HttpServlet {

	private static final List<String> COLLECTIONS = Arrays.asList(
			"students_2a", "students_2b", "students_2c",
			"students_3a", "students_3b", "students_3c",
			"students_4a", "students_4b", "students_4c"
	);

	private static final String DB_NAME = "college";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		String searchQuery = request.getParameter("search");

		pw.print("<!DOCTYPE html>");
		pw.print("<html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'>");
		pw.print("<title>Student List</title><style>");
		pw.print("body { background-color: #000; color: #fff; font-family: 'Poppins', sans-serif; }");
		pw.print("h1 { background-color: #333; color: #FFCB9A; padding: 10px; text-align: center; }");
		pw.print("table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }");
		pw.print("th, td { border: 1px solid #ccc; padding: 15px; text-align: left; }");
		pw.print("th { background-color: #333; color: #FFCB9A; }");
		pw.print("td { background-color: #1e1e1e; color: #fff; }");
		pw.print(".highlight { background-color: #ff0; color: #000; }");
		pw.print("form { text-align: center; margin-bottom: 20px; }");
		pw.print("input[type='text'] { padding: 10px; width: 300px; background-color: #2e2e2e; border: 1px solid #333; color: #fff; }");
		pw.print("input[type='submit'] { padding: 10px 20px; background-color: #ff004f; color: #fff; border: none; border-radius: 5px; cursor: pointer; }");
		pw.print(".back-button { text-align: center; display: block; margin: 20px auto; background: #333; color: #FFCB9A; padding: 10px 20px; text-decoration: none; border-radius: 5px; }");
		pw.print("</style></head><body>");
		pw.print("<h1>Student List</h1>");
		pw.print("<form action='viewstudents' method='get'>");
		pw.print("<input type='text' name='search' placeholder='Search by Reg No, Name, or Branch' value='" + (searchQuery != null ? searchQuery : "") + "'>");
		pw.print("<input type='submit' value='Search'></form>");

		pw.print("<table><tr><th>Reg No</th><th>Name</th><th>Branch</th></tr>");
		try (MongoClient mongoClient = MongoClients.create(
		        "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college")) {


			MongoDatabase db = mongoClient.getDatabase(DB_NAME);
			Pattern searchPattern = null;

			if (searchQuery != null && !searchQuery.trim().isEmpty()) {
				searchPattern = Pattern.compile(Pattern.quote(searchQuery), Pattern.CASE_INSENSITIVE);
			}

			for (String collectionName : COLLECTIONS) {
				MongoCollection<Document> collection = db.getCollection(collectionName);

				List<Document> students;
				if (searchPattern != null) {
					students = collection.find(or(
							regex("reg_no", searchPattern),
							regex("name", searchPattern),
							regex("branch", searchPattern)
					)).into(new java.util.ArrayList<>());
				} else {
					students = collection.find().into(new java.util.ArrayList<>());
				}

				for (Document doc : students) {
					String regNo = doc.getString("reg_no");
					String name = doc.getString("name");
					String branch = doc.getString("branch");

					pw.print("<tr>");
					pw.print("<td>" + highlightMatch(regNo, searchQuery) + "</td>");
					pw.print("<td>" + highlightMatch(name, searchQuery) + "</td>");
					pw.print("<td>" + highlightMatch(branch, searchQuery) + "</td>");
					pw.print("</tr>");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			pw.print("<tr><td colspan='3'>An error occurred while fetching student data.</td></tr>");
		}

		pw.print("</table>");
		pw.print("<a href='adminhome.jsp' class='back-button'>Back</a>");
		pw.print("</body></html>");
	}

	private String highlightMatch(String text, String searchQuery) {
		if (searchQuery != null && !searchQuery.trim().isEmpty() && text != null) {
			String regex = "(?i)(" + Pattern.quote(searchQuery) + ")";
			return text.replaceAll(regex, "<span class='highlight'>$1</span>");
		} else {
			return text != null ? text : "";
		}
	}
}
