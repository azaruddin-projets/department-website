<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="icon" href="images/logo.png" type="image/icon type">
    <title>Manage Students</title>
    <style>
      
        * {
            margin: 0;
            padding: 0;
            font-family: 'Poppins', sans-serif;
            box-sizing: border-box;
              background-size:cover;
        }

        body {
            background-color: #000000; 
            color: #fff;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-x: hidden;
            animation: fadeIn 1s ease-in;
            background-image:url("images//manage.jpg");
          
        }

        h1, h2 {
            background-color: rgba(51, 51, 51, 0.8); 
            color: #FFCB9A; 
            padding: 10px;
            text-align: center;
            margin-bottom: 20px;
            width: 100%;
            border-radius: 10px;
            backdrop-filter: blur(10px); 
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            animation: slideIn 1s ease-out;
        }

        .container {
            width: 100%;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        form {
            background: rgba(30, 30, 30, 0.6); 
            padding: 20px;
            border-radius: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
            flex: 1;
            min-width: 300px;
            max-width: 400px;
            backdrop-filter: blur(15px); 
            animation: fadeInUp 1s ease-out;
        }

        label {
            color: #FFCB9A; 
            font-size: 18px;
            display: block;
            margin-bottom: 10px;
            transition: color 0.3s;
        }

        input[type="text"], select {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2); 
            border-radius: 4px;
            font-size: 16px;
            background: rgba(51, 51, 51, 0.8); 
            color: #fff; 
            transition: border-color 0.3s, background-color 0.3s;
        }

        input[type="text"]:focus, select:focus {
            border-color: #FFCB9A; 
            background-color: rgba(51, 51, 51, 0.9); 
            outline: none;
            animation: focusGlow 0.5s ease-in-out;
        }

        ::placeholder {
            color: #aaa; 
            font-size: 14px; 
        }

        button[type="submit"] {
            width: 100%;
            background-color: #ff004f; 
            color: #fff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.3s;
            position: relative;
            overflow: hidden;
        }

        button[type="submit"]::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 300%;
            height: 300%;
            background: linear-gradient(45deg, #ff004f, #ffcb9a);
            transition: transform 0.5s;
            transform: translate(-50%, -50%) scale(0);
            border-radius: 50%;
            z-index: 0;
        }

        button[type="submit"]:hover::before {
            transform: translate(-50%, -50%) scale(1);
        }

        button[type="submit"]:hover {
            background-color: #cc3700; 
            transform: scale(1.05);
        }

        hr {
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.2); 
            margin: 20px 0;
            width: 100%;
        }

        a {
            display: block;
            text-align: center;
            color: #FFCB9A; 
            text-decoration: none;
            font-size: 18px;
            margin-top: 20px;
            margin-bottom: 20px;
            transition: color 0.3s;
        }

        a:hover {
            color: #ff004f; 
            text-decoration: underline;
        }


        .back-button {
            display: inline-block;
            text-align: center;
            background-color: rgba(51, 51, 51, 0.8); 
            color: #FFCB9A; 
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            transition: background-color 0.3s, color 0.3s;
        }

        .back-button:hover {
            background-color: #FFCB9A; 
            color: #333; 
        }

        .message {
            text-align: center;
            color: #FFCB9A; 
            margin: 20px 0;
            animation: fadeInUp 1s ease-out;
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
    <h1>Manage Students</h1>
    <div class="container">
        <form action="viewstudents" method="get" style="height: 90px;">
            <button type="submit">View All Students</button>
        </form>
        <form action="addStudent" method="post">
            <h2>Add New Student</h2>
            <label for="regNo">Reg No:</label>
            <input type="text" id="regNo" name="regNo" required placeholder="Enter registration number">
            <label for="studentName">Name:</label>
            <input type="text" id="studentName" name="studentName" required placeholder="Enter student name">
            <label for="year">Year:</label>
            <select id="year" name="year" required>
                <option value="" disabled selected>Select year</option>
                
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
            </select>
            <label for="section">Section:</label>
            <select id="section" name="section" required>
                <option value="" disabled selected>Select section</option>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <!-- Add more sections if needed -->
            </select>
            <label for="branch">Branch:</label>
            <input type="text" id="branch" name="branch" required placeholder="Enter student branch">
            <button type="submit">Add Student</button>
        </form>
        <form action="removeStudent" method="post">
            <h2>Remove Student</h2>
            <label for="regNoRemove">Reg No:</label>
            <input type="text" id="regNoRemove" name="regNoRemove" required placeholder="Enter registration number">
            <label for="yearRemove">Year:</label>
            <select id="yearRemove" name="year" required>
                <option value="" disabled selected>Select year</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
            </select>
            <label for="sectionRemove">Section:</label>
            <select id="sectionRemove" name="section" required>
                <option value="" disabled selected>Select section</option>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <!-- Add more sections if needed -->
            </select>
            <button type="submit">Remove Student</button>
        </form>
    </div>

    <a class="back-button" href="adminhome.jsp">Back to Admin Dashboard</a>
    <!-- Display the message -->
    <div class="message">
        <p>
            <%= request.getAttribute("message") != null ? request.getAttribute("message") : "No message available" %>
        </p>
    </div>
</body>
</html>
