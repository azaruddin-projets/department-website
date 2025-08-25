<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
   <link rel="icon" href="images/logo.png" type="image/icon type">
<meta charset="ISO-8859-1">
<title>Student home</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

  * {
    margin: 0;
    padding: 0;
    font-family: 'Poppins', sans-serif;
    box-sizing: border-box;
  }
.student-profile {
    background-color: rgba(30, 30, 30, 0.9); 
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.3); 
    margin: 20px;
    max-width: 300px;
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #FFCB9A;
    position: fixed; 
    right: 20px; 
    top: 100px
  }

  .student-profile img {
    width: 100px;
    height: 150px;
    border-radius: 10px;
    margin-bottom: 15px;
  }

  .student-profile .details {
    text-align: center;
  }
  body {
    background-image: url(images/1.png);
    background-size: cover;
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
    padding-left: 150px;
    padding-top: 50px;
  }

  .grid-item {
    background-color: rgba(255, 255, 255, 0.5);
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 10px;
    text-align: center;
    font-size: 14px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    text-content: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 271.6px;
    height: 271.6px;
  }

  .image-container {
    width: 100px;
    height: 100px;
    margin-bottom: 10px;
    border-radius: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .image-container img {
    width: 100%;
    height: auto;
    object-fit: cover;
    border-radius: 10px;
  }
@media (max-width: 768px) {
 .grid-container {
    grid-template-columns: 1fr;
  }

 .grid-item {
    width: 100%;
    height: auto;
    margin-bottom: 20px;
  }

 .button-container {
    margin-top: 20px;
  }

 .image-container {
    width: 50px;
    height: 50px;
  }

 .image-container img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 10px;
  }

 .button {
    font-size: 12px;
    padding: 10px 15px;
  }
}

@media (max-width: 480px) {
 .grid-item {
    margin-bottom: 10px;
  }

 .button-container {
    margin-top: 10px;
  }

 .image-container {
    width: 30px;
    height: 30px;
  }
@media (max-width: 768px) {
 .grid-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
  }
 .grid-item {
    width: calc(50% - 10px);
    margin: 10px;
  }
}
 .button {
    font-size: 10px;
    padding: 8px 12px;
  }
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
    font-size: 1rem; /* Adjusted font size */
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

  @keyframes glow {
    0% {
      box-shadow: 0 0 5px var(--clr);
    }
    50% {
      box-shadow: 0 0 20px var(--clr), 0 0 30px var(--clr);
    }
    100% {
      box-shadow: 0 0 5px var(--clr);
    }
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
    grid-column: 1 / -1; /* Make it span across all columns */
    margin: 20px auto; /* Center and add margin */
    text-align: center;
  }

  @media (max-width: 768px) {
    .grid-container {
      grid-template-columns: 1fr;
    }

    .grid-item {
      width: 100%;
      height: auto;
    }

    .button-container {
      margin-top: 20px;
    }
  }
</style>
</head>
<body>
<center>
<h1>Student Dashboard</h1>
       
        </center>.
        
<div class="grid-container">
            
            
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
                    <img src="images/result.png" alt="Results">
                </div>
                <div class="button-container">
                    <a href='getresults.jsp'><span>Results</span><i></i></a>
                </div>
            </div>
            <div class="grid-item">
                <div class="image-container">
                    <img src="images/books.png" alt="Add Materials">
                </div>
                <div class="button-container">
                    <a href='getmaterials.jsp'><span>Materials</span><i></i></a>
                </div>
                
            </div>
         <div class="logout-button">
        <div class="button-container">
            <a href="INDEX.jsp"><span>Logout</span><i></i></a>
        </div>
    </div>
        </div>
</body>
</html>