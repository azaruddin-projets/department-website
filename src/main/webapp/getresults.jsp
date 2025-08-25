<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
   <link rel="icon" href="images/logo.png" type="image/icon type">
    <title>Access Results</title>
    <style>
      
        * {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            box-sizing: border-box;
        }

        body {
            background-color: #000000;
            color: #fff;
            margin: 0;
            display: flex;
            align-items: center;
            flex-direction: column;
            min-height: 100vh;
            padding: 20px;
            background-image: url("images/res.jpg"); 
            background-size: cover;
            background-repeat: no-repeat;
            animation: fadeIn 1s ease-in; 
        }

        h1 {
            background-color: rgba(51, 51, 51, 0.7); 
            color: #FFCB9A;
            padding: 15px;
            text-align: center;
            margin-bottom: 30px;
            border-radius: 8px;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            animation: fadeInUp 1s ease-out; 
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            backdrop-filter: blur(10px); 
            background: rgba(255, 255, 255, 0.1); 
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            animation: fadeInUp 1s ease-out; 
        }

        table, th, td {
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        th, td {
            padding: 15px;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background-color: rgba(51, 51, 51, 0.6); 
            color: #FFCB9A;
        }

        td {
            background-color: rgba(30, 30, 30, 0.6); 
            color: #fff;
        }

        tr:hover td {
            background-color: rgba(51, 51, 51, 0.6);
        }

        .download-btn {
            padding: 10px 20px;
            background-color: #ff4500; 
            color: #fff;
            text-decoration: none;
            border-radius: 25px; 
            transition: background-color 0.3s ease, transform 0.3s ease; 
            animation: pulse 1s infinite; 
            display: inline-block;
        }

        .download-btn:hover {
            background-color: #ff004f; 
            transform: scale(1.05);
        }

        .no-materials {
            text-align: center;
            padding: 20px;
            font-size: 1.2em;
            color: #ccc;
            animation: fadeIn 1s ease-in; 
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
    <h1>Results</h1>
    <table>
        <tr>
            <th>Semester</th>
            <th>Download</th>
        </tr>
        <%
            String folderPath = application.getRealPath("uploads");
            File folder = new File(folderPath);
            File[] files = folder.listFiles();
            
            if (files != null && files.length > 0) {
                for (File file : files) {
                    if (file.isFile()) {
                        String fileName = file.getName();
                        String fileURL = request.getContextPath() + "/uploads/" + fileName;
        %>
        <tr>
            <td><%= fileName %></td>
            <td style="text-align: right;"><a href="<%= fileURL %>" class="download-btn" download>Download</a></td>
        </tr>
        <%
                    }
                }
            } else {
        %>
        <tr>
            <td colspan="2" class="no-materials">No results available.</td>
        </tr>
        <%
            }
        %>
    </table>
                       <div class="center-container">
    <a class="back-button" href="studenthome.jsp">Back to Student Dashboard</a>
</div>
</body>
</html>
