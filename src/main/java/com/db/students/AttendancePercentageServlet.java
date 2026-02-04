package com.db.students;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/AttendancePercentageServlet")
public class AttendancePercentageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // MongoDB connection string and DB name
    private static final String CONNECTION_STRING = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DATABASE_NAME = "college";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String year = request.getParameter("year");
        String section = request.getParameter("section");

        response.setContentType("text/html;charset=UTF-8");

        if (startDateStr == null || endDateStr == null || year == null || section == null ||
            startDateStr.trim().isEmpty() || endDateStr.trim().isEmpty() ||
            year.trim().isEmpty() || section.trim().isEmpty()) {

            request.setAttribute("message", "Start date, end date, year, and section are all required.");
            request.getRequestDispatcher("calc.jsp").forward(request, response);
            return;
        }

        section = section.toLowerCase();

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);

            // Setup Mongo client and collections
            try (MongoClient mongoClient = MongoClients.create(CONNECTION_STRING)) {
                MongoDatabase database = mongoClient.getDatabase(DATABASE_NAME);
                String studentCollectionName = "students_" + year + section;
                String attendanceCollectionName = "students_attendance_" + year + section;

                MongoCollection<Document> studentsCollection = database.getCollection(studentCollectionName);

                // Aggregation pipeline
                List<Document> pipeline = Arrays.asList(

                	    new Document("$lookup", new Document()
                	        .append("from", attendanceCollectionName)
                	        .append("localField", "reg_no")
                	        .append("foreignField", "reg_no")
                	        .append("as", "attendance_records")
                	    ),

                	    new Document("$addFields", new Document("attendance_records",
                	        new Document("$filter", new Document()
                	            .append("input", "$attendance_records")
                	            .append("as", "record")
                	            .append("cond", new Document("$and", Arrays.asList(
                	                new Document("$gte", Arrays.asList("$$record.attendance_date", startDate)),
                	                new Document("$lte", Arrays.asList("$$record.attendance_date", endDate))
                	            )))
                	        )
                	    )),

                	    new Document("$addFields",
                	        new Document("total_days",
                	            new Document("$size", "$attendance_records")
                	        )
                	    ),

                	    new Document("$addFields",
                	        new Document("present_days",
                	            new Document("$size",
                	                new Document("$filter", new Document()
                	                    .append("input", "$attendance_records")
                	                    .append("as", "record")
                	                    .append("cond",
                	                        new Document("$eq",
                	                            Arrays.asList("$$record.attendance_status", "Present")
                	                        )
                	                    )
                	                )
                	            )
                	        )
                	    ),

                	    new Document("$project", new Document()
                	        .append("_id", 0)
                	        .append("reg_no", 1)
                	        .append("name", 1)
                	        .append("total_days", 1)
                	        .append("present_days", 1)
                	    )
                	);


                // Execute aggregation and collect results
                List<Document> results = new ArrayList<>();
                studentsCollection.aggregate(pipeline).into(results);

                // Set results as request attribute
                request.setAttribute("attendanceResults", results);
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
                request.setAttribute("year", year);
                request.setAttribute("section", section);

                // Forward to JSP page to display results
                request.getRequestDispatcher("calc.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("calc.jsp").forward(request, response);
        }
    }
}
