<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <meta charset="UTF-8">
    <title>Absentees Report</title>
    <style>

        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            box-sizing: border-box;
        }

        body {
            background-image: url('images/1.png');
            background-size: cover;
            background-color: #000000;
            color: #fff;
            margin: 0;
            padding: 20px;
        }

        h2 {
            color: #FFCB9A;
            text-align: center;
            margin-bottom: 20px;
        }

        form {
            background-color: rgba(30, 30, 30, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
            max-width: 400px;
            margin: 0 auto;
            backdrop-filter: blur(10px);
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #FFCB9A;
        }

        select,
        input[type="submit"],
        input[type="date"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #333;
            border-radius: 5px;
            background-color: rgba(46, 46, 46, 0.8);
            color: #fff;
        }

        input[type="submit"] {
            background-color: #ff004f;
            color: #fff;
            border: none;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            cursor: pointer;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #cc003a; 
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.7);
        }

        input[type="submit"]:active {
            background-color: #b3002f;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
        }

        .message {
            color: #FFCB9A;
            text-align: center;
            margin-top: 20px;
            font-size: 1.2em;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.1); 
            border-radius: 10px; 
            backdrop-filter: blur(8px); 
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.3); 
        }

        table, th, td {
            border: 1px solid rgba(255, 255, 255, 0.3); 
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: rgba(255, 203, 154, 0.7); 
            color: #000;
        }

        tr:nth-child(even) {
            background-color: rgba(46, 46, 46, 0.8); 
        }

        tr:nth-child(odd) {
            background-color: rgba(30, 30, 30, 0.8); 
        }
           .center-container {
    display: flex;
    justify-content: center;
    align-items: center;
   /* Full page height */
}

.back-button {
   background-color: #ff4500;
    color: #fff;
    text-decoration: none;
    border: none;
    padding: 10px 20px;
    cursor: pointer;
    border-radius: 5px;
    font-size: 16px;
    transition: background-color 0.3s ease, transform 0.2s ease;
    animation: pulse 1s infinite;
}

.back-button:hover {
    background-color: #cc3700;
    transform: scale(1.05);
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

    </style>
</head>
<body>
    <h2>Absentee Report</h2>

    <%
        String action = request.getParameter("action");
        String year = request.getParameter("year");
        String section = request.getParameter("section");
        String date = request.getParameter("date");

        if ("Submit".equals(action) && year != null && section != null && date != null && !date.isEmpty()) {
            MongoClient mongoClient = null;
            try {
                mongoClient = MongoClients.create("mongodb://localhost:27017");
                MongoDatabase database = mongoClient.getDatabase("college");
                String suffix = year + section;
                MongoCollection<Document> collection = database.getCollection("students_attendance_" + suffix);

                Document query = new Document("attendance_date", date)
                                 .append("attendance_status", "Absent");

                FindIterable<Document> docs = collection.find(query);

                out.println("<h3>Absentees on " + date + "</h3>");
                out.println("<table>");
                out.println("<tr><th>Roll Number</th><th>Status</th></tr>");

                for (Document doc : docs) {
                    String regNo = doc.getString("reg_no"); // Fixed key
                    String status = doc.getString("attendance_status");
                    out.println("<tr><td>" + regNo + "</td><td>" + status + "</td></tr>");
                }

                out.println("</table>");
            } catch (Exception e) {
                out.println("<p class='message'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                if (mongoClient != null) mongoClient.close();
            }
        }
    %>

    <!-- Form section -->
    <form action="absentees.jsp" method="post">
        <label for="year">Year:</label>
        <select id="year" name="year" required>
            <option value="">Select Year</option>
            <option value="2" <%= "2".equals(year) ? "selected" : "" %>>2ND YEAR</option>
            <option value="3" <%= "3".equals(year) ? "selected" : "" %>>3RD YEAR</option>
            <option value="4" <%= "4".equals(year) ? "selected" : "" %>>4TH YEAR</option>
        </select>

        <label for="section">Section:</label>
        <select id="section" name="section" required>
            <option value="">Select Section</option>
            <option value="a" <%= "a".equals(section) ? "selected" : "" %>>A</option>
            <option value="b" <%= "b".equals(section) ? "selected" : "" %>>B</option>
            <option value="c" <%= "c".equals(section) ? "selected" : "" %>>C</option>
        </select>

        <label for="date">Date:</label>
        <input type="date" id="date" name="date" value="<%= date != null ? date : "" %>" required>

        <input type="submit" name="action" value="Submit">
    </form>

    <div class="center-container">
        <a class="back-button" href="adminhome.jsp">Back to Admin Dashboard</a>
    </div>
</body>
</html>