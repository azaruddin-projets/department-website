package student;

import java.io.IOException;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;

import org.bson.Document;

@WebServlet("/studentDashboard")
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String MONGO_URI =
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";
    private static final String DB_NAME = "college";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("INDEX.jsp");
            return;
        }

        double attendancePercentage = 0.0;
        double absencePercentage = 0.0;

        try (MongoClient mongoClient = MongoClients.create(MONGO_URI)) {
            MongoDatabase database = mongoClient.getDatabase(DB_NAME);

            // ✅ Get student by username
            MongoCollection<Document> studentsCollection =
                    database.getCollection("students");

            Document student = studentsCollection
                    .find(Filters.eq("username", username))
                    .first();

            if (student == null) {
                request.setAttribute("attendancePercentage", 0);
                request.setAttribute("absencePercentage", 0);
                request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
                return;
            }

            String regNo = student.getString("reg_no");

            // ⚠️ Change year/section if dynamic
            MongoCollection<Document> attendanceCollection =
                    database.getCollection("students_attendance_2a");

            var pipeline = Arrays.asList(
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
            );

            Document result = attendanceCollection.aggregate(pipeline).first();

            if (result != null) {
                int total = result.getInteger("total", 0);
                int present = result.getInteger("present", 0);

                if (total > 0) {
                    attendancePercentage = (present * 100.0) / total;
                    absencePercentage = 100.0 - attendancePercentage;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("username", username);
        request.setAttribute("attendancePercentage", attendancePercentage);
        request.setAttribute("absencePercentage", absencePercentage);
        request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
    }
}
