<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Truncate Collections</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            box-sizing: border-box;
        }

        body {
            background-image: url('images/1.png'); /* Adjust as needed */
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
            background-color: rgba(30, 30, 30, 0.9); /* Semi-transparent background */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.3); /* Soft box shadow */
            max-width: 400px;
            margin: 0 auto;
            backdrop-filter: blur(10px); /* Blur effect */
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #FFCB9A;
        }

        select,
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #333;
            border-radius: 5px;
            background-color: rgba(46, 46, 46, 0.8); /* Semi-transparent background */
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
            background-color: #cc003a; /* Darker shade on hover */
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.7);
        }

        input[type="submit"]:active {
            background-color: #b3002f; /* Darker shade on active */
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
        }

        .message {
            color: #FFCB9A;
            text-align: center;
            margin-top: 20px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <h2>Truncate Collections</h2>

<%
    String action = request.getParameter("action");
    String year = request.getParameter("year");
    String section = request.getParameter("section");

    if ("Submit".equals(action) && year != null && section != null) {

        section = section.toLowerCase();   // ✅ IMPORTANT

        try (MongoClient mongoClient =
                MongoClients.create("mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college")) {

            MongoDatabase db = mongoClient.getDatabase("college");

            String suffix = year + section;

            MongoCollection<Document> students =
                    db.getCollection("students_" + suffix);

            MongoCollection<Document> attendance =
                    db.getCollection("students_attendance_" + suffix);

            students.deleteMany(new Document());
            attendance.deleteMany(new Document());
%>
            <div class="message">
                ✅ Collections reset successfully for <b><%= suffix %></b>
            </div>
<%
        } catch (Exception e) {
%>
            <div class="message">
                ❌ Error: <%= e.getMessage() %>
            </div>
<%
        }
    } else {
%>

<form method="post">
    <label>Year</label>
    <select name="year" required>
        <option value="">Select Year</option>
        <option value="2">2nd Year</option>
        <option value="3">3rd Year</option>
        <option value="4">4th Year</option>
    </select>

    <label>Section</label>
    <select name="section" required>
        <option value="">Select Section</option>
        <option value="a">A</option>
        <option value="b">B</option>
        <option value="c">C</option>
    </select>

    <input type="submit" name="action" value="Submit">
</form>

<%
    }
%>

</body>
</html>