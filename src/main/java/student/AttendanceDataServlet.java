package student;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.bson.Document;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;

@WebServlet("/attendanceDataServlet")
public class AttendanceDataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI =
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");

        if (username == null) {
            out.print("{\"error\":\"User not logged in\"}");
            return;
        }

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            // ✅ Correct collection
            MongoCollection<Document> studentsCollection =
                    database.getCollection("students");

            Document student = studentsCollection
                    .find(Filters.eq("username", username))
                    .first();

            if (student == null) {
                out.print("{\"error\":\"Student not found\"}");
                return;
            }

            String regNo = student.getString("reg_no");

            // ⚠️ Change year/section logic here if needed
            MongoCollection<Document> attendanceCollection =
                    database.getCollection("students_attendance_2a");

            AggregateIterable<Document> result =
                    attendanceCollection.aggregate(Arrays.asList(
                            Aggregates.match(Filters.eq("reg_no", regNo)),
                            Aggregates.group(null,
                                    Accumulators.sum("total", 1),
                                    Accumulators.sum("present",
                                            new Document("$cond", Arrays.asList(
                                                    new Document("$eq",
                                                            Arrays.asList("$attendance_status", "Present")),
                                                    1,
                                                    0
                                            ))
                                    )
                            )
                    ));

            Document stats = result.first();

            int total = stats != null ? stats.getInteger("total", 0) : 0;
            int present = stats != null ? stats.getInteger("present", 0) : 0;
            int absent = total - present;

            int presentPercent = total == 0 ? 0 : (present * 100) / total;
            int absentPercent = total == 0 ? 0 : (absent * 100) / total;

            out.print("{\"present\":" + presentPercent +
                      ",\"absent\":" + absentPercent + "}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"Server error\"}");
        }
    }
}
