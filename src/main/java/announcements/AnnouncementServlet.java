package announcements; 
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AnnouncementServlet")  
public class AnnouncementServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MongoClient mongoClient = null;

        try {
        	mongoClient = MongoClients.create(
        		    "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college"
        		);


        	MongoDatabase database = mongoClient.getDatabase("college");

            MongoCollection<Document> collection = database.getCollection("announcements");

            
            String title = request.getParameter("title");
            String message = request.getParameter("message");

            
            if (title != null && message != null && !title.isEmpty() && !message.isEmpty()) {
                Document announcement = new Document("title", title)
                        .append("message", message)
                        .append("post_date", new java.util.Date());
                collection.insertOne(announcement); 
                request.setAttribute("message", "Announcement added successfully!");
            }
            if ("delete".equals(request.getParameter("action"))) {
                String id = request.getParameter("id");
                if (id != null && !id.isEmpty()) {
                    collection.deleteOne(new Document("_id", new ObjectId(id)));
                    request.setAttribute("message", "Announcement deleted successfully!");
                }
            }

            request.getRequestDispatcher("add_announcement.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("add_announcement.jsp").forward(request, response);
        } finally {
            if (mongoClient != null) {
                mongoClient.close(); 
            }
        }
    }
}
