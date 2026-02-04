<%@ page import="com.mongodb.client.*, com.mongodb.client.model.Filters, org.bson.Document, java.util.*" %>
<%@ page import="com.mongodb.client.MongoClients" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Attendance</title>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <style>
     body {
            background-color: #000000;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background-image: url("images//att2.jpg");
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

        button {
            background-color: #ff4500;
            color: #fff;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            margin-right: 5px;
            transition: background-color 0.3s ease, transform 0.2s ease; 
            animation: pulse 1s infinite; 
        }

        button:hover {
            background-color: #cc3700;
            transform: scale(1.05); 
        }

        a {
            display: block;
            text-align: center;
            color: #FFCB9A;
            text-decoration: none;
            font-size: 18px;
            margin-top: 20px;
            transition: color 0.3s ease; 
        }

        a:hover {
            text-decoration: underline;
            color: #e6c2a7; 
        }

        .disabled {
            background-color: #555;
            cursor: not-allowed;
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

        .date-picker-input {
            background-color: rgba(51, 51, 51, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.5);
            color: #fff;
            padding: 10px;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
            outline: none;
            margin-right: 10px;
        }

        .date-picker-input:hover {
            background-color: rgba(51, 51, 51, 1);
        }

        .date-picker-input:focus {
            background-color: rgba(51, 51, 51, 1);
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

        @keyframes focusGlow {
            from { box-shadow: 0 0 5px rgba(255, 203, 154, 0.5); }
            to { box-shadow: 0 0 10px rgba(255, 203, 154, 1); }
        }

        

      
        @media (max-width: 600px) {
            .container {
                flex-direction: column;
                align-items: stretch;
            }

            form {
                min-width: auto;
            }
        }
    </style>
</head>
<body>
    <h1>Student Attendance</h1>

    <form action="AttendanceServlet" method="post">
        <div class="date-picker-container">
            <label for="year" class="date-picker-label">Year:</label>
            <select id="year" name="year" class="date-picker-input">
                <option value="">Select Year</option>
                <option value="2" <%= "2".equals(request.getAttribute("year")) ? "selected" : "" %>>2nd Year</option>
                <option value="3" <%= "3".equals(request.getAttribute("year")) ? "selected" : "" %>>3rd Year</option>
                <option value="4" <%= "4".equals(request.getAttribute("year")) ? "selected" : "" %>>4th Year</option>
            </select>

            <label for="section" class="date-picker-label">Section:</label>
            <select id="section" name="section" class="date-picker-input">
                <option value="">Select Section</option>
                <option value="a" <%= "a".equals(request.getAttribute("section")) ? "selected" : "" %>>A</option>
                <option value="b" <%= "b".equals(request.getAttribute("section")) ? "selected" : "" %>>B</option>
                <option value="c" <%= "c".equals(request.getAttribute("section")) ? "selected" : "" %>>C</option> 
            </select>

            <label for="attendanceDate" class="date-picker-label">Select Date:</label>
            <input type="date" id="attendanceDate" name="attendanceDate" class="date-picker-input" value="<%= request.getAttribute("attendanceDate") != null ? request.getAttribute("attendanceDate") : "" %>" required>
            <button type="submit" name="filter" value="filter" class="filter-button">Filter</button>
        </div>
    </form>

    <form action="AttendanceServlet" method="post">
        <input type="hidden" name="attendanceDate" value="<%= request.getAttribute("attendanceDate") != null ? request.getAttribute("attendanceDate") : "" %>">
        <input type="hidden" name="year" value="<%= request.getAttribute("year") != null ? request.getAttribute("year") : "" %>">
        <input type="hidden" name="section" value="<%= request.getAttribute("section") != null ? request.getAttribute("section") : "" %>">

        <table>
            <thead>
                <tr>
                    <th>Registration Number</th>
                    <th>Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    MongoClient mongoClient = null;
                    try {
                        String year = request.getAttribute("year") != null ? (String) request.getAttribute("year") : "";
                        String section = request.getAttribute("section") != null ? (String) request.getAttribute("section") : "";
                        String attendanceDate = request.getAttribute("attendanceDate") != null ? (String) request.getAttribute("attendanceDate") : "";

                        String studentTable = "students_" + year + section;
                        String attendanceTable = "students_attendance_" + year + section;

                        mongoClient = MongoClients.create("mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college");
                        MongoDatabase database = mongoClient.getDatabase("college");
                        MongoCollection<Document> studentsCol = database.getCollection(studentTable);
                        MongoCollection<Document> attendanceCol = database.getCollection(attendanceTable);

                        FindIterable<Document> students = studentsCol.find();
                        for (Document student : students) {
                            String regNo = student.getString("reg_no");
                            String name = student.getString("name");

                            Document attendance = attendanceCol.find(Filters.and(
                            		Filters.eq("reg_no", regNo),
                            		Filters.eq("attendance_date", attendanceDate)

                            )).first();

                            String status = attendance != null ? attendance.getString("attendance_status") : "Not Marked";

                            String presentClass = "button";
                            String absentClass = "button";
                            String resetClass = "button";

                            if ("Present".equals(status)) {
                                presentClass += " disabled";
                                absentClass += " disabled";
                                resetClass += " enabled";
                            } else if ("Absent".equals(status)) {
                                presentClass += " disabled";
                                absentClass += " disabled";
                                resetClass += " enabled";
                            }
                %>
                <tr>
                    <td><%= regNo %></td>
                    <td><%= name %></td>
                    <td>
                       <button type="submit"
        name="action"
        value="Present"
        formaction="AttendanceServlet?regNo=<%= regNo %>"
        <%= ("Present".equals(status) || "Absent".equals(status)) ? "disabled" : "" %>>
    Mark Present
</button>

                        <button type="submit"
        name="action"
        value="Absent"
        formaction="AttendanceServlet?regNo=<%= regNo %>"
        <%= ("Present".equals(status) || "Absent".equals(status)) ? "disabled" : "" %>>
    Mark Absent
</button>

                        <button type="submit"
        formaction="resetAttendance"
        formmethod="post"
        class="<%= resetClass %>">
    Reset
</button>

<input type="hidden" name="regNo" value="<%= regNo %>">
<input type="hidden" name="year" value="<%= year %>">
<input type="hidden" name="section" value="<%= section %>">
<input type="hidden" name="attendanceDate" value="<%= attendanceDate %>">

                    </td>
                </tr>
                <% 
                        } // end loop
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (mongoClient != null) mongoClient.close();
                    }
                %>
              
            </tbody>
        </table>
    </form>
    <div class="center-container">
    <a class="back-button" href="adminhome.jsp">Back to Admin Dashboard</a>
</div>


    <% if (request.getAttribute("message") != null) { %>
        <p style="color: red;"><%= request.getAttribute("message") %></p>
    <% } %>
       
     
</body>
</html>
