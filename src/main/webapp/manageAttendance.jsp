<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoClients" %>  <!-- Correct Import for MongoClient -->
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="org.bson.Document" %>
<%@ page import="com.mongodb.client.model.Filters" %>
<%@ page import="org.bson.conversions.Bson" %>
<%@ page import="com.mongodb.client.FindIterable" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>

<html>
<head>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <title>Manage Attendance</title>
</head>
<body>
    <h1>Manage Attendance</h1>
    <form method="post" action="manageAttendance.jsp">
        <label for="commencementDate">Commencement Date:</label>
        <input type="date" id="commencementDate" name="commencementDate" required>
        <input type="submit" value="Calculate Attendance">
    </form>

<%
    if (request.getMethod().equalsIgnoreCase("post")) {
        String commencementDateStr = request.getParameter("commencementDate");
        MongoClient mongoClient = null;
        String year = request.getParameter("year");
        String section = request.getParameter("section");

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date commencementDate = sdf.parse(commencementDateStr);
            Date today = new Date();
            mongoClient = MongoClients.create("mongodb://localhost:27017");
            MongoDatabase database = mongoClient.getDatabase("college");
            String suffix = year + section;
            MongoCollection<Document> attendanceCollection = database.getCollection("students_attendance_" + suffix);
            MongoCollection<Document> studentCollection = database.getCollection("students"+suffix);
            FindIterable<Document> students = studentCollection.find();


            out.println("<h2>Attendance Summary</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>Reg No</th><th>Name</th><th>Present Days</th><th>Absent Days</th><th>Total Days</th><th>Attendance Percentage</th></tr>");

            boolean foundRecords = false;

            for (Document student : students) {
                String regNo = student.getString("reg_no");
                String name = student.getString("name");

                Bson attendanceFilter = Filters.and(
                    Filters.eq("reg_no", regNo),
                    Filters.gte("attendance_date", commencementDate),
                    Filters.lte("attendance_date", today)
                );

                FindIterable<Document> attendanceRecords = attendanceCollection.find(attendanceFilter);

                int presentDays = 0;
                int absentDays = 0;
                int totalDays = 0;

                for (Document record : attendanceRecords) {
                    String status = record.getString("attendance_status");
                    if ("Present".equalsIgnoreCase(status)) {
                        presentDays++;
                    } else if ("Absent".equalsIgnoreCase(status)) {
                        absentDays++;
                    }
                    totalDays++;
                }

                if (totalDays > 0) {
                    foundRecords = true;
                    double percentage = ((double) presentDays / totalDays) * 100.0;

                    out.println("<tr>");
                    out.println("<td>" + regNo + "</td>");
                    out.println("<td>" + name + "</td>");
                    out.println("<td>" + presentDays + "</td>");
                    out.println("<td>" + absentDays + "</td>");
                    out.println("<td>" + totalDays + "</td>");
                    out.println("<td>" + String.format("%.2f", percentage) + "%</td>");
                    out.println("</tr>");
                }
            }

            out.println("</table>");

            if (!foundRecords) {
                out.println("<p>No attendance records found for the specified commencement date.</p>");
            }

        } catch (ParseException pe) {
            out.println("<p>Error parsing date. Please try again.</p>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>An error occurred: " + e.getMessage() + "</p>");
        } finally {
            if (mongoClient != null) {
                mongoClient.close();
            }
        }
    }
%>

    <br><a href="adminhome">Home</a>
</body>
</html>
