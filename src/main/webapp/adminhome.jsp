<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="icon" href="images/logo.png" type="image/icon type">
<title>Admin Dashboard</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

* {
  margin: 0;
  padding: 0;
  font-family: 'Poppins', sans-serif;
  box-sizing: border-box;
}

body {
  background-image: url(images/1.png);
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
  background-color: #000000;
  color: #fff;
  margin: 0;
}

h1 {
  background-color: rgba(51, 51, 51, 0.5); 
  color: #FFCB9A;
  padding: 10px;
  text-align: center;
  margin-bottom: 20px;
}

@keyframes glow {
  0% {
    text-shadow: 0 0 5px #FFCB9A, 0 0 10px #FFCB9A, 0 0 15px #FFCB9A, 0 0 20px #FFCB9A, 0 0 25px #FFCB9A;
  }
  50% {
    text-shadow: 0 0 10px #FFCB9A, 0 0 20px #FFCB9A, 0 0 30px #FFCB9A, 0 0 40px #FFCB9A, 0 0 50px #FFCB9A;
  }
  100% {
    text-shadow: 0 0 5px #FFCB9A, 0 0 10px #FFCB9A, 0 0 15px #FFCB9A, 0 0 20px #FFCB9A, 0 0 25px #FFCB9A;
  }
}

h2 {
  color: #ff004f;
  animation: glow 1.5s infinite;
}

.announcement-form {
  background-color: rgba(30, 30, 30, 0.9);
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
  margin: 20px auto;
  max-width: 600px;
  backdrop-filter: blur(10px);
}

.announcement-form label {
  display: block;
  margin-bottom: 10px;
  color: #FFCB9A;
}

.announcement-form input,
.announcement-form textarea {
  width: 100%;
  padding: 10px;
  margin-bottom: 10px;
  border: 1px solid #333;
  border-radius: 5px;
  background-color: rgba(46, 46, 46, 0.8);
  color: #fff;
}

.announcement-form input[type="submit"] {
  background-color: #ff4500;
  color: #fff;
  border: none;
  cursor: pointer;
  font-size: 1.1em;
}

.announcement-form input[type="submit"]:hover {
  background-color: #cc3700;
}

.message {
  color: #FFCB9A;
  text-align: center;
  margin: 20px;
  font-size: 1.2em;
}

.image-container {
  width: 100px;
  height: 100px;
  margin: 10px auto;
  border-radius: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 10px;
}

.error {
  color: #d9534f;
}

.grid-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 30px;
  padding: 30px;
  
  position: relative;
}

.grid-item {
  background-color: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(0, 0, 0, 0.1);
  padding: 10px;
  text-align: center;
  font-size: 14px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 271.6px;
  height: 271.6px;
}

.button {
  background-color: rgba(255, 255, 255, 0.2);
  border: none;
  color: #fff;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 14px;
  margin: 4px 2px;
  cursor: pointer;
  border-radius: 10px;
  width: 100%;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(10px);
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.button:hover {
  background-color: rgba(255, 255, 255, 0.3);
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.7);
}

.button:active {
  background-color: rgba(255, 255, 255, 0.4);
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
}

.button-container {
  margin-top: 10px;
  display: flex;
  justify-content: center;
}

.button-container a {
  position: relative;
  background: #fff;
  color: #fff;
  text-decoration: none;
  text-transform: uppercase;
  font-size: 1rem;
  letter-spacing: 0.1em;
  font-weight: 400;
  padding: 10px 30px;
  display: inline-block;
  transition: 0.5s;
}

.button-container a:hover {
  background: var(--clr);
  color: var(--clr);
  letter-spacing: 0.25em;
  box-shadow: 0 0 35px var(--clr);
}

.button-container a::before {
  content: '';
  position: absolute;
  inset: 2px;
  background: #151F28;
}

.button-container a span {
  position: relative;
  z-index: 1;
}

.button-container a i {
  position: absolute;
  inset: 0;
  display: block;
}

.button-container a i::before {
  content: '';
  position: absolute;
  top: 0;
  left: 80%;
  width: 10px;
  height: 4px;
  background: #151F28;
  transform: translateX(-50%) skewX(325deg);
  transition: 0.5s;
}

.button-container a:hover i::before {
  width: 20px;
  left: 20%;
}

.button-container a i::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  width: 10px;
  height: 4px;
  background: #151F28;
  transform: translateX(-50%) skewX(325deg);
  transition: 0.5s;
}

.button-container a:hover i::after {
  width: 20px;
  left: 80%;
}

.button-container a {
  animation: glow 1.5s infinite;
}

.button-container a:nth-child(1) {
  --clr: #1e9bff;
}

.button-container a:nth-child(2) {
  --clr: #6eff3e;
}

.button-container a:nth-child(3) {
  --clr: #ff1867;
}

.button-container a:nth-child(4) {
  --clr: #1e9bff;
}

.button-container a:nth-child(5) {
  --clr: #6eff3e;
}

.button-container a:nth-child(6) {
  --clr: #ff1867;
}

.logout-button {
  grid-column: 1 / -1; 
  margin: 20px auto;
  text-align: center;
}

.reset-button {
  position: absolute;
  top: 10px;
  right: 20px;
  background-color: #ff004f; 
  border: none;
  color: #fff;
  padding: 10px 20px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  cursor: pointer;
  border-radius: 10px;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

.reset-button:hover {
  background-color: #d30047;
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.7);
}

.reset-button:active {
  background-color: #b3002f;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
}

@media (max-width: 600px) {
  .grid-container {
    display: flex;
    flex-direction: row !important; 
    overflow-x: auto;
    padding: 20px;
    gap: 20px;
    justify-content: center; 
    padding-left: 0;
  }

  .grid-item {
    flex: 0 0 auto; 
    width: 250px; 
    height: 250px;
  }

  .button-container {
    margin-top: 10px;
  }

  .reset-button {
    position: static; 
    margin-top: 20px;
    width: 100%; 
  }

  .image-container {
    width: 50px;
    height: 50px; 
  }
}

@media (max-width: 480px) {
  .grid-item {
    width: 200px;
    height: 200px; 
    margin-bottom: 10px;
  }

  .button-container {
    margin-top: 10px;
  }

  .reset-button {
    width: 100%;
    padding: 8px 12px;
  }
}
.absentees-button {
    
    top: 10px; 
    left: 10px;
    background-color: #ff004f;
    color: #fff; 
      padding: 10px 20px; 
    font-size: 1em; 
    border-radius: 10px; 
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2); 
    z-index: 1000; 
    text-decoration: none; 
    display: inline-block; 
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.absentees-button:hover {
   background-color: #d30047;
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.7);
}

</style>
</head>
<body>
    <div class="dashboard">
          <a href="absentees.jsp" class="absentees-button">Absentees</a> <h1>Admin Dashboard</h1>
        <center><h2>Welcome, Admin!</h2></center>
  
        <div class="grid-container" style=" padding-left: 150px;">
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/12.png" alt="Manage Students">
                </div>
                <div class="button-container">
                    <a href='manageStudents.jsp'><span>Manage Students</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/immigration.png" alt="Mark Attendance">
                </div>
                <div class="button-container">
                    <a href='attendance.jsp'><span>Mark Attendance</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/marketing.png" alt="Calculate Attendance">
                </div>
                <div class="button-container">
                    <a href='calc.jsp'><span>Calculate Attendance</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/megaphone.png" alt="Add Announcement">
                </div>
                <div class="button-container">
                    <a href='add_announcement.jsp'><span>Add Announcement</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/result.png" alt="Results">
                </div>
                <div class="button-container">
                    <a href='results.jsp'><span>Results</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/books.png" alt="Add Materials">
                </div>
                <div class="button-container">
                    <a href='materials.jsp'><span>Add Materials</span><i></i></a>
                </div>
            </div>
        </div>

        <a href="truncate_tables.jsp" class="reset-button">Reset DB</a>

        <div class="logout-button">
            <div class="button-container">
                <a href="INDEX.jsp"><span>Logout</span><i></i></a>
            </div>
        </div>
    </div>
    
</body>
</html>
