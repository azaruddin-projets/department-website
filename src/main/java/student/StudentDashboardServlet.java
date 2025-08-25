package student;

import java.io.IOException;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;

import org.bson.Document;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;

@WebServlet({"/studentDashboard"})
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.html");
            return;
        }

        double attendancePercentage = 0.0;
        double absencePercentage = 0.0;

        try (MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017")) {
            MongoDatabase database = mongoClient.getDatabase("your_database_name"); // Change this
            MongoCollection<Document> attendanceCollection = database.getCollection("students_attendance");

            var pipeline = Arrays.asList(
                Aggregates.match(Filters.eq("reg_no", username)),
                Aggregates.group(null,
                    Accumulators.sum("total_classes", 1),
                    Accumulators.sum("attended_classes",
                        new Document("$cond", Arrays.asList(
                            new Document("$eq", Arrays.asList("$attendance_status", "Present")),
                            1,
                            0
                        ))
                    )
                )
            );

            Document result = attendanceCollection.aggregate(pipeline).first();

            if (result != null) {
                int totalClasses = result.getInteger("total_classes", 0);
                int attendedClasses = result.getInteger("attended_classes", 0);

                if (totalClasses > 0) {
                    attendancePercentage = (attendedClasses * 100.0) / totalClasses;
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
