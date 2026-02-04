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

<!-- FORM -->
<form action="AttendancePercentageServlet" method="post">
    <div class="form-box">
        <label>Start Date:</label>
        <input type="date" name="startDate" required>

        <label>End Date:</label>
        <input type="date" name="endDate" required>

        <label>Year:</label>
        <select name="year" required>
            <option value="">Select</option>
            <option value="2">2nd</option>
            <option value="3">3rd</option>
            <option value="4">4th</option>
        </select>

        <label>Section:</label>
        <select name="section" required>
            <option value="">Select</option>
            <option value="a">A</option>
            <option value="b">B</option>
            <option value="c">C</option>
        </select>

        <button type="submit">Calculate</button>
    </div>
</form>

<!-- RESULT TABLE -->
<table>
    <tr>
        <th>Reg No</th>
        <th>Name</th>
        <th>Total Days</th>
        <th>Present</th>
        <th>Absent</th>
        <th>Percentage</th>
    </tr>

<%
    List<Document> results =
        (List<Document>) request.getAttribute("attendanceResults");

    if (results != null && !results.isEmpty()) {
        for (Document d : results) {
            int total = d.getInteger("total_days", 0);
            int present = d.getInteger("present_days", 0);
            int absent = total - present;
            int percent = (total == 0) ? 0 : (present * 100 / total);
%>
    <tr>
        <td><%= d.getString("REG_NO") %></td>
        <td><%= d.getString("NAME") %></td>
        <td><%= total %></td>
        <td><%= present %></td>
        <td><%= absent %></td>
        <td><%= percent %>%</td>
    </tr>
<%
        }
    }
%>
</table>

<br>
<center>
    <a href="adminhome.jsp" class="back-button">Back to Dashboard</a>
</center>

</body>
</html>

