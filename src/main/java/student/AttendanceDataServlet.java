package student;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.bson.Document;
import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;

import java.util.Arrays;

@WebServlet("/attendanceDataServlet")
public class AttendanceDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI = "mongodb://localhost:27017";
    private static final String DB_NAME = "college"; // Your database name

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            out.println("{\"error\": \"User not logged in.\"}");
            return;
        }

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            // Get student_id from stulogin collection
            MongoCollection<Document> stuloginCollection = database.getCollection("college");
            Document userDoc = stuloginCollection.find(Filters.eq("username", username)).first();

            if (userDoc == null) {
                out.println("{\"error\": \"User not found.\"}");
                return;
            }

            String studentId = userDoc.getString("REG_NO");

            MongoCollection<Document> attendanceCollection = database.getCollection("attendance");

            // Aggregate total count and present count
            AggregateIterable<Document> result = attendanceCollection.aggregate(Arrays.asList(
                Aggregates.match(Filters.eq("REG_NO", studentId)),
                Aggregates.group(null,
                    Accumulators.sum("total", 1),
                    Accumulators.sum("present", new Document("$cond", Arrays.asList(new Document("$eq", Arrays.asList("$ATTENDANCE_STATUS", "Present")), 1, 0)))
                )
            ));

            Document stats = result.first();

            if (stats != null) {
                int total = stats.getInteger("total", 0);
                int present = stats.getInteger("present", 0);
                int absent = total - present;

                // To avoid division by zero
                int presentPercent = total == 0 ? 0 : present * 100 / total;
                int absentPercent = total == 0 ? 0 : absent * 100 / total;

                out.println("{");
                out.println("  \"present\": " + presentPercent + ",");
                out.println("  \"absent\": " + absentPercent);
                out.println("}");
            } else {
                out.println("{\"present\": 0, \"absent\": 0}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"error\": \"An error occurred.\"}");
        }
    }
}
