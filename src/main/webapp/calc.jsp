<%@ page import="com.mongodb.client.*, com.mongodb.client.model.Filters" %>
<%@ page import="org.bson.Document, org.bson.conversions.Bson" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <title>Attendance Percentage</title>
    <style>
        body {
            background-color: #000000;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background-image: url("images//calc.jpg");
            background-size: cover;
            background-repeat: no-repeat;
            animation: fadeIn 1s ease-in;
        }

        h1 {
            background-color: #333;
            color: #FFCB9A;
            padding: 10px;
            text-align: center;
            margin-bottom: 20px;
            border-radius: 15px;
            animation: slideIn 1s ease-out;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            animation: fadeInUp 1s ease-out;
        }

        table, th, td {
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        th {
            background-color: rgba(51, 51, 51, 0.6);
            color: #FFCB9A;
        }

        td {
            background-color: rgba(30, 30, 30, 0.6);
            color: #fff;
        }

        .percentage {
            color: #ff4500;
            animation: fadeIn 1s ease-in;
        }

        .date-picker-container {
            margin-bottom: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 10px;
            animation: fadeInUp 1s ease-out;
        }

        .date-picker-label {
            color: #FFCB9A;
            font-size: 18px;
            margin-right: 10px;
        }

        .date-picker-input, .dropdown {
            background-color: #333;
            border: 1px solid #555;
            color: #fff;
            padding: 10px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease, border-color 0.3s ease;
            outline: none;
            margin-right: 10px;
        }

        .date-picker-input:hover, .dropdown:hover {
            background-color: #444;
        }

        .date-picker-input:focus, .dropdown:focus {
            background-color: #555;
            border-color: #FFCB9A;
            box-shadow: 0 0 5px #FFCB9A;
        }

        .filter-button {
            background-color: #ff4500;
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease;
            animation: pulse 1s infinite;
        }

        .filter-button:hover {
            background-color: #cc3700;
            transform: scale(1.05);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from { transform: translateX(-100%); }
            to { transform: translateX(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 600px) {
            .date-picker-container {
                flex-direction: column;
                align-items: stretch;
            }

            .date-picker-input, .dropdown, .filter-button {
                margin-bottom: 10px;
                width: 100%;
            }
        }
          
        .center-container {
    display: flex;
    justify-content: center;
    align-items: center; /* Full page height */
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
<h1>Attendance Percentage Calculation</h1>

<form action="calc.jsp" method="post">
    <div class="date-picker-container">
        <label for="startDate" class="date-picker-label">Start Date:</label>
        <input type="date" id="startDate" name="startDate" class="date-picker-input" required>
        <label for="endDate" class="date-picker-label">End Date:</label>
        <input type="date" id="endDate" name="endDate" class="date-picker-input" required>

        <label for="year" class="date-picker-label">Year:</label>
        <select id="year" name="year" class="dropdown" required>
            <option value="">Select Year</option>
            <option value="2">2nd Year</option>
            <option value="3">3rd Year</option>
            <option value="4">4th Year</option>
        </select>

        <label for="section" class="date-picker-label">Section:</label>
        <select id="section" name="section" class="dropdown" required>
            <option value="">Select Section</option>
            <option value="a">A</option>
            <option value="b">B</option>
            <option value="c">C</option>
        </select>

        <button type="submit" name="filter" value="filter" class="filter-button">Filter</button>
    </div>
</form>

<table>
    <thead>
        <tr>
            <th>Registration Number</th>
            <th>Name</th>
            <th>Total Days</th>
            <th>Present Days</th>
            <th>Absent Days</th>
            <th>Percentage</th>
        </tr>
    </thead>
    <tbody>
<%
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");
    String year = request.getParameter("year");
    String section = request.getParameter("section");

    if (startDateStr != null && endDateStr != null && year != null && section != null) {
        try (MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017")) {
            MongoDatabase database = mongoClient.getDatabase("college");
            String studentCol = "students_" + year + section;
            String attendanceCol = "students_attendance_" + year + section;

            MongoCollection<Document> studentCollection = database.getCollection(studentCol);
            MongoCollection<Document> attendanceCollection = database.getCollection(attendanceCol);

            List<Document> students = studentCollection.find().into(new ArrayList<Document>());
            for (Document student : students) {
                String regNo = student.getString("reg_no");
                String name = student.getString("name");

                // Create filter with string comparison
                Bson dateFilter = Filters.and(
                    Filters.eq("reg_no", regNo),
                    Filters.gte("attendance_date", startDateStr),
                    Filters.lte("attendance_date", endDateStr)
                );

                List<Document> attendanceRecords = attendanceCollection.find(dateFilter).into(new ArrayList<Document>());
                int totalDays = attendanceRecords.size();
                int presentDays = 0;
                for (Document record : attendanceRecords) {
                    if ("Present".equalsIgnoreCase(record.getString("attendance_status"))) {
                        presentDays++;
                    }
                }
                int absentDays = totalDays - presentDays;
                double percentage = totalDays > 0 ? (presentDays * 100.0 / totalDays) : 0.0;
%>
        <tr>
            <td><%= regNo %></td>
            <td><%= name %></td>
            <td><%= totalDays %></td>
            <td><%= presentDays %></td>
            <td><%= absentDays %></td>
            <td class="percentage"><%= String.format("%.2f", percentage) %>%</td>
        </tr>
<%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
        }
    } else {
        out.println("<tr><td colspan='6'>No data available. Please select date range and year/section.</td></tr>");
    }
%>


