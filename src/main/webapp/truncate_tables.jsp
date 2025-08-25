<%@ page import="com.mongodb.client.*, org.bson.Document" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.mongodb.MongoClient" %>
<%@ page import="com.mongodb.client.model.Filters" %>
<%@ page import="org.bson.conversions.Bson" %>
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
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date commencementDate = sdf.parse(commencementDateStr);
                Date currentDate = new Date();

                mongoClient = new MongoClient("localhost", 27017);
                MongoDatabase database = mongoClient.getDatabase("college");
                MongoCollection<Document> studentsCollection = database.getCollection("students");
                MongoCollection<Document> attendanceCollection = database.getCollection("student_attendance");

                List<Document> students = studentsCollection.find().into(new ArrayList<>());

                out.println("<h2>Attendance Summary</h2>");
                out.println("<table border='1'>");
                out.println("<tr><th>Reg No</th><th>Name</th><th>Present Days</th><th>Absent Days</th><th>Total Days</th><th>Attendance Percentage</th></tr>");

                boolean foundRecords = false;

                for (Document student : students) {
                    String regNo = student.getString("regno");
                    String name = student.getString("name");

                    Bson filter = Filters.and(
                        Filters.eq("regno", regNo),
                        Filters.gte("date", commencementDate),
                        Filters.lte("date", currentDate)
                    );

                    List<Document> records = attendanceCollection.find(filter).into(new ArrayList<>());
                    int totalDays = records.size();
                    int presentDays = 0, absentDays = 0;

                    for (Document record : records) {
                        String status = record.getString("status");
                        if ("present".equalsIgnoreCase(status)) {
                            presentDays++;
                        } else if ("absent".equalsIgnoreCase(status)) {
                            absentDays++;
                        }
                    }

                    if (totalDays > 0) {
                        foundRecords = true;
                        double percentage = (presentDays * 100.0) / totalDays;
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

            } catch (Exception e) {
                e.printStackTrace();
                out.println("An error occurred: " + e.getMessage());
            } finally {
                if (mongoClient != null) {
                    mongoClient.close();
                }
            }
        }
    %>

    <a href="adminhome">Home</a>
</body>
</html>
