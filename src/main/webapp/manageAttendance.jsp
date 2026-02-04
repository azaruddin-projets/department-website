<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="org.bson.Document" %>
<%@ page import="com.mongodb.client.model.Filters" %>
<%@ page import="org.bson.conversions.Bson" %>
<%@ page import="com.mongodb.client.FindIterable" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <title>Manage Attendance</title>
</head>
<body>

<h1>Manage Attendance</h1>

<!-- ✅ FORM (FIXED: year & section added) -->
<form method="post" action="manageAttendance.jsp">
    <label>Year:</label>
    <select name="year" required>
        <option value="">Select</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
    </select>

    <label>Section:</label>
    <select name="section" required>
        <option value="">Select</option>
        <option value="a">A</option>
        <option value="b">B</option>
        <option value="c">C</option>
    </select>

    <br><br>

    <label for="commencementDate">Commencement Date:</label>
    <input type="date" id="commencementDate" name="commencementDate" required>

    <input type="submit" value="Calculate Attendance">
</form>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String commencementDateStr = request.getParameter("commencementDate");
    String year = request.getParameter("year");
    String section = request.getParameter("section");

    MongoClient mongoClient = null;

    try {
        section = section.toLowerCase();   
        String suffix = year + section;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date commencementDate = sdf.parse(commencementDateStr);
        Date today = new Date();
        mongoClient = MongoClients.create(
            "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college"
        );

        MongoDatabase database = mongoClient.getDatabase("college");
        MongoCollection<Document> attendanceCollection =
            database.getCollection("students_attendance_" + suffix);

        MongoCollection<Document> studentCollection =
            database.getCollection("students_" + suffix);

        FindIterable<Document> students = studentCollection.find();

        out.println("<h2>Attendance Summary</h2>");
        out.println("<table border='1'>");
        out.println("<tr>");
        out.println("<th>Reg No</th>");
        out.println("<th>Name</th>");
        out.println("<th>Present Days</th>");
        out.println("<th>Absent Days</th>");
        out.println("<th>Total Days</th>");
        out.println("<th>Attendance %</th>");
        out.println("</tr>");

        boolean foundRecords = false;

        for (Document student : students) {
            String regNo = student.getString("reg_no");
            String name = student.getString("name");

            Bson filter = Filters.and(
                Filters.eq("reg_no", regNo),
                Filters.gte("attendance_date", commencementDate),
                Filters.lte("attendance_date", today)
            );

            FindIterable<Document> records = attendanceCollection.find(filter);

            int present = 0;
            int absent = 0;
            int total = 0;

            for (Document record : records) {
                String status = record.getString("attendance_status");
                if ("Present".equalsIgnoreCase(status)) {
                    present++;
                } else if ("Absent".equalsIgnoreCase(status)) {
                    absent++;
                }
                total++;
            }

            if (total > 0) {
                foundRecords = true;
                double percentage = (present * 100.0) / total;

                out.println("<tr>");
                out.println("<td>" + regNo + "</td>");
                out.println("<td>" + name + "</td>");
                out.println("<td>" + present + "</td>");
                out.println("<td>" + absent + "</td>");
                out.println("<td>" + total + "</td>");
                out.println("<td>" + String.format("%.2f", percentage) + "%</td>");
                out.println("</tr>");
            }
        }

        out.println("</table>");

        if (!foundRecords) {
            out.println("<p>No attendance records found.</p>");
        }

    } catch (ParseException e) {
        out.println("<p>Invalid date format.</p>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (mongoClient != null) {
            mongoClient.close();
        }
    }
}
%>

<br>
<a href="adminhome.jsp">Back to Admin Dashboard</a>

</body>
</html>
