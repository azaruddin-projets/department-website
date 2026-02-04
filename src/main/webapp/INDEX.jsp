<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="org.bson.Document" %>
<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.FindIterable" %>


<html lang="en">
<head>
<script src="js/scripts.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KHIT AIML DEPT</title>
    <link rel="icon" href="images/logo.png" type="image/icon type">
    <link rel="stylesheet" href="css/khit.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
.announcement {
  border: 1px solid #2f2f2f; 
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 20px;
  background-color: #1a1a1a; 
  color: #fff; 
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.6);
  transition: box-shadow 0.3s ease-in-out;
}
html {
    scroll-behavior: smooth;
}

.login-box{
    position: relative;
    color: #ff004f;
    width: 400px;
    height: 450px;
    background:transparent;
    border: 2px solid rgba(255,255,255,0.5);
    border-radius: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    backdrop-filter: blur(15px);
}
h2{
    font-size: 2em;
    color: #fff;
    text-align: center;
}
.input-box{
    position: relative;
    width: 310px;
    margin: 30px 0;
    border-bottom: 2px solid #fff;
}
.input-box label{
    position: absolute;
    top: 50%;
    left: 5px;
    transform:translateY(-50%);
    font-size: 1em;
    color: #fff;
    pointer-events: none;
    transition: 0.5s;
}
.input-box input:focus~label,
.input-box input:valid~label{
    top: -5px;
    color: #fff;
}

.input-box input{
    width: 100%;
    height: 50px;
    background: transparent;
    border: none;
    outline: none;
    font-size: 1em;
    color: #fff;
    padding: 0 35px 0 5px;
}
.input-box .icon{
    position: absolute;
    right: 8px;
    color: #fff;
    font-size: 1.2em;
    line-height: 57px;
}
.remember-forget{
    margin: -15px 0 15px;
    font-size: .9em;
    color: #fff;
    display: flex;
    justify-content: space-between;
}
.remember-forget label input{
    margin-right: 3px;
}
.remember-forget a{
    color: #fff;
    text-decoration: none;
}
.remember-forget a:hover{
    text-decoration: underline;
}
.input-box input,
.input-box textarea {
    width: 100%;
    padding: 12px;
    border: none; 
    border-radius: 6px;
    background: transparent; 
    color: #fff; 
    font-size: 1em;
    outline: none; 
}

.input-box input:focus,
.input-box textarea:focus {
    border-color: transparent; 
    background: transparent; 
}

.input-box label {
    position: absolute;
    top: -10px;
    left: 15px;
    font-size: 0.75em;
    color: #ff004f; 
    transition: 0.3s;
}
.input-box input,
.input-box textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #fff; 
    border-radius: 6px;
    background: transparent;
    color: #fff;
    font-size: 1em;
    outline: none;
}

.input-box input:focus,
.input-box textarea:focus {
    border-color: #ff004f; 
    background: transparent;
}

.input-box input:focus ~ label,
.input-box input:valid ~ label,
.input-box textarea:focus ~ label,
.input-box textarea:valid ~ label {
    top: -20px;
    left: 5px;
    font-size: 0.7em;
    color: #FFCB9A;
}

button{
    width: 100%;
    height: 40px;
    background: #fff;
    border: none;
    outline: none;
    border-radius: 40px;
    cursor: pointer;
    font-size: 1em;
    color: #000;
    font-weight: 500;
}
.register-link{
    font-size: .9em;
    color: #fff;
    text-align: center;
    margin: 25px 0 10px;
}
.register-link p a{
    color: #fff;
    text-decoration: none;
    font-weight: 600;
}
.register-link p a:hover{
    text-decoration: underline;
}
.announcement:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.8);
}

.announcement h3 {
  color: #ff004f; 
  text-align: center;
  font-weight: bold;
  transition: color 0.3s ease-in-out;
  text-size:15px;
}

.announcement:hover h3 {
  color: #FFCB9A;
}
input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
textarea:-webkit-autofill,
textarea:-webkit-autofill:hover,
textarea:-webkit-autofill:focus,
select:-webkit-autofill,
select:-webkit-autofill:hover,
select:-webkit-autofill:focus {
  -webkit-box-shadow: 0 0 0 1000px #fff inset;
  -webkit-text-fill-color: #fff;
}
.announcement p {
  margin: 0;
  text-align: center;
}

.announcement .date-container {
  position: absolute;
  left: 30px;
  transition: left 0.3s ease-in-out;
}
#contact {
    background-color: #1a1a1a;
    color: #fff;
    padding: 40px 0;
}

.contact-col-1,
.contact-col-2 {
    width: 50%;
    padding: 20px;
}

.contact-col-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.contact-col-2 {
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.video-container {
    position: relative;
    padding-bottom: 56.25%; 
    height: 0;
    overflow: hidden;
    max-width: 100%;
    background: #000;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
}

.video-container video {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: none;
}

.announcement:hover .date-container {
  left: 25px;
}

.date-button {
  background-color: #2f2f2f;
  color: #FFCB9A;
  border: none;
  padding: 10px 36px;
  font-size: 22px;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
  transition: background-color 0.3s ease-in-out;
}

.date-button:hover {
  background-color: #1a1a1a;
}
#contact {
    position: relative;
    width: 100%;
    height: 100vh; 
    overflow: hidden;
}

.video-container {
    position: relative;
    width: 100%;
    height: 100%;
    overflow: hidden;
}

.video-container video {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover; 
}

.form-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(0, 0, 0, 0.7); 
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
    color: #fff;
    width: 80%;
    max-width: 600px;
}

.form-overlay h2 {
    text-align: center;
    margin-bottom: 20px;
}

.input-box {
    position: relative;
    margin-bottom: 20px;
}

.input-box input,
.input-box textarea {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 6px;
    background: #fff;
    color: #000;
    font-size: 1em;
    outline: none;
}

.input-box textarea {
    height: 100px;
    resize: none;
}

.input-box label {
    position: absolute;
    top: 0;
    left: 10px;
    font-size: 0.8em;
    color: #fff;
    transition: 0.3s;
}

.input-box input:focus ~ label,
.input-box input:valid ~ label,
.input-box textarea:focus ~ label,
.input-box textarea:valid ~ label {
    top: -20px;
    left: 5px;
    font-size: 0.7em;
}

button {
    width: 100%;
    padding: 10px;
    background:#ff004f;;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1em;
    color: #000;
    font-weight: bold;
}

button:hover {
    background: #FFC107;
}

.date-button:active {
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
  transform: translateY(2px);
}
.input-box input[type="text"]:autofill,
.input-box input[type="password"]:autofill {
  -webkit-box-shadow: 0 0 0px 1000px transparent inset !important;
  box-shadow: 0 0 0px 1000px transparent inset !important;
  background-color: transparent !important;
  background-image: none !important;
  color: #fff !important;
}
     #contact {
    position: relative;
    width: 100%;
    height: 100vh; 
    overflow: hidden;
}

.video-container {
    position: relative;
    width: 100%;
    height: 100%;
}

.video-container video {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover; 
}


.form-container {
    position: absolute;
    top: 50%;
    right: -360px; 
    transform: translateY(-50%);
    width: 360px; 
    transition: right 1s ease-out;
}


.form-container.active {
    right: 50%; 
    transform: translate(50%, -50%); 
}


.form-overlay {
    background: rgba(255, 255, 255, 0.1); 
    backdrop-filter: blur(10px); 
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
    color: #fff;
    width: 100%;
    height: auto;
}


.form-overlay h2 {
    text-align: center;
    margin-bottom: 20px;
}

.input-box {
    position: relative;
    margin-bottom: 20px;
}
.input-box {
    position: relative;
    width: 310px;
    margin: 30px 0;
    border: none; 
}


.input-box input {
    width: 100%;
    height: 50px;
    background: transparent; 
    border: none;
    outline: none;
    font-size: 1em;
    color: #fff;
    padding: 0 35px 0 5px;
}


.input-box label {
    position: absolute;
    top: 50%;
    left: 5px;
    transform: translateY(-50%);
    font-size: 1em;
    color: #fff;
    pointer-events: none;
    transition: .5s;
}
.input-box input,
.input-box textarea {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 6px;
    background: #fff;
    color: #000;
    font-size: 1em;
    outline: none;
}

.input-box textarea {
    height: 100px;
    resize: none;
}

.input-box label {
    position: absolute;
    top: 0;
    left: 10px;
    font-size: 0.8em;
    color: #fff;
    transition: 0.3s;
}

.input-box input:focus ~ label,
.input-box input:valid ~ label,
.input-box textarea:focus ~ label,
.input-box textarea:valid ~ label {
    top: -20px;
    left: 5px;
    font-size: 0.7em;
}

button {
    width: 100%;
    padding: 10px;
    background:  #ff004f;;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1em;
    color: #000;
    font-weight: bold;
}

button:hover {
    background: #FFC107;
}
       @media only screen and (max-width: 768px) {
    .announcement {
        padding: 20px;
        flex-direction: column;
        align-items: flex-start;
        box-shadow: none;
    }

    .announcement .date-container {
        position: static;
        margin-bottom: 15px;
        text-align: center;
    }

    .date-button {
        font-size: 18px;
        padding: 8px 24px;
    }

    .announcement h3 {
        font-size: 1.5rem;
    }

    .announcement p {
        font-size: 0.9rem;
    }
}

@media only screen and (max-width: 480px) {
    .announcement {
        padding: 15px;
    }

    .date-button {
        font-size: 16px;
        padding: 6px 20px;
    }

    .announcement h3 {
        font-size: 1.2rem;
    }

    .announcement p {
        font-size: 0.8rem;
    }
}
    </style>
    
</head>
<body>
    <div id="header">
        <div class="container">
            <nav>
                <div class="logo-container">
                    <img src="images/logo.png" alt="KHIT Logo" height="80" class="logo" style="background-size:cover;">
                    <h1 id="clg">KHIT</h1>
                </div>
                <div id=fix>
                <ul id="sidemenu">
                    <li><a href="INDEX.jsp">Home</a></li>
                    <li><a href="#announcements">Announcements</a></li>
                    <li><a href="#department-hod">Faculty</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#contact">Contact</a></li>
                    <i class="fas fa-times" onclick="closemenu()"></i>
                </ul></div>
              <i class="fas fa-bars" onclick="openmenu()"></i>
            </nav>
             <div class="header-text">
                <h1>Welcome to <span>AIML Department</span></h1>
                <p><span>Kallam Haranadha Reddy Institute of Technology</span></p>
            </div>
</div>

    <div id="int" style="
    padding-right: 50px;
    margin-top: 0px;
">
    <div class="login-box">
        <form method="post" action="validate">
            <h2>Login</h2>
            <div class="input-box">
                <input type="text" name="MYUSER" required="" autocomplete="off">

                <label>REG.NO</label>
                <span class="icon"></span>
            </div>
            <div class="input-box">
                <input type="password" name="MYPWD" required="" autocomplete="off">
                <label>PASSWORD</label>
                <span class="icon"></span>
            </div>
             <div class="input-box">
                <input type="text" name="MYOTP"  required autocomplete="off"/>
                <label>OTP</label>
                <span class="icon"></span>
            </div>
            <div class="remember-forget">
                <label><input type="checkbox">Remember me</label>
                <a href="forgotpassword.jsp">Forgot password?</a>
            </div>
            <button type="submit">LOGIN</button>
            <div class="register-link">
                <p>Don't have an account? <a href="registrationform.html">CREATE AN ACCOUNT</a></p>
            </div>
        </form>
    </div>
</div>
    </div>
    <div id="announcements">
        <div class="container">
            <h2 class="section-title" style="
    padding-bottom: 30px;
    padding-top: 20px;">Events & Announcements</h2>
            <div id="announcement-list">
<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="com.mongodb.MongoClientSettings" %>
<%@ page import="com.mongodb.client.MongoClients" %>

<%
MongoClient mongoClient = null;
try {
    String mongoUri = "mongodb+srv://khit_user:Khit%40123@khit.cgvx7lk.mongodb.net/college";

    mongoClient = MongoClients.create(mongoUri);
    MongoDatabase database = mongoClient.getDatabase("college");
    MongoCollection<Document> collection =
            database.getCollection("announcements");

    FindIterable<Document> announcements =
            collection.find().sort(new Document("post_date", -1));

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");

    for (Document doc : announcements) {
        String title = doc.getString("title");
        String message = doc.getString("message");
        Date postDate = doc.getDate("post_date");
%>
        <div class="announcement">
            <div class="date-container">
                <button class="date-button">
                    <span><%= dateFormat.format(postDate) %></span>
                </button>
            </div>
            <div>
                <h3><%= title %></h3>
                <p><%= message %></p>
            </div>
        </div>
<%
    }
} catch (Exception e) {
%>
    <div class="announcement">
        <p>Error fetching announcements: <%= e.getMessage() %></p>
    </div>
<%
} finally {
    if (mongoClient != null) mongoClient.close();
}
%>


               
            </div>
        </div>
    </div>

  
<div id="department-hod" class="animate" style="
    padding-bottom: 0px;">
    <div class="container" style="
    padding-bottom: 0px;
    margin-bottom: 0px;
">
        <div class="row">
            <div class="hod-text">
                <h3 class="sub-title">Meet Our Department Head</h3>
                <h2>Dr. G J Sunny Deol</h2>
                <p><strong>Professor and Head of the AIML Department</strong></p>
                <p>With a Ph.D. and 16 years of experience, Dr. Deol is a leading academic figure specializing in Machine Learning, Big Data, and Computer Networks. Known for his innovative teaching and impactful research, he fosters a dynamic learning environment and inspires students and colleagues alike.</p>
                <p>For academic inquiries or collaborations, reach out to Dr. Deol at <a href="mailto:hod-aiml@khitguntur.ac.in">hod-aiml@khitguntur.ac.in</a> or 7799374771.</p>
                <p><strong>Message from the Head:</strong> "At the AIML Department, we are committed to fostering innovation and nurturing talent. Our goal is to empower students with the knowledge and skills needed to excel in the world of AI and ML. Join us in shaping the future of technology."</p>
            </div>
            <div class="hod-image">
                <img src="images/hod.jpg" alt="Department Head">
            </div>
        </div>
    </div>
</div>

<div id="about">
    <div class="container">
        <div class="row">
            <div class="about-col-1">
                <img src="images/a3.jpg" alt="About AIML Image">
            </div>
            <div class="about-col-2">
                <h2 class="sub-title">About AIML</h2>
                <p>At KHIT's AIML Department, we delve into the transformative fields of Artificial 
                    Intelligence (AI) and Machine Learning (ML), shaping the future of technology through 
                    innovation and education. Our commitment to excellence and cutting-edge research equips 
                    students with the skills to tackle complex challenges and lead in a rapidly evolving digital
                    landscape.</p><br>
                    <p><strong>Our Vision:</strong>
                            We envision a world where AI and ML drive significant advancements across various domains,
                            from healthcare and finance to robotics and beyond. Our department strives to be at the forefront 
                            of this technological revolution, preparing our students to be pioneers and thought leaders in these fields.</p>
    <br>
                    <p><strong>Academic Excellence:</strong>

                    Our curriculum is meticulously designed to cover the fundamentals
                    of AI and ML, including deep learning, natural language processing, computer vision, and 
                    reinforcement learning. We emphasize a hands-on approach, allowing students to work on real-world projects
                    and collaborate with industry experts.</p>
            </div>
        </div>
    </div>
</div>
<style>
   
/* Base styling for the form overlay */
.form-overlay {
    background: rgba(28, 28, 28, 0.7);
    backdrop-filter: blur(15px);
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.8);
    color: #fff;
    width: 80%;
    max-width: 600px;
    margin: auto;
    text-align: center;
    
    top: 50%;
    left: 50%; /* Center horizontally */
    transform: translate(-50%, -50%) translateX(-100%); /* Start off-screen */
    opacity: 0; /* Initially hidden */
    visibility: hidden; /* Initially hidden */
    transition: opacity 0.5s ease-in-out; /* Smooth transition for opacity */
    z-index: 1000; /* Ensure it's on top of other content */
}

/* Styling for the heading */
.form-overlay h2 {
    color: #ff004f;
    margin-bottom: 20px;
}

/* Styling for input fields and textarea */
.input-box {
    position: relative;
    margin-bottom: 20px;
}

.input-box input,
.input-box textarea {
    width: 100%;
    padding: 12px;
    border: 2px solid #fff;
    border-radius: 6px;
    background: #1a1a1a;
    color: #fff;
    font-size: 1em;
    outline: none;
}

.input-box textarea {
    height: 120px;
    resize: vertical;
}

/* Styling for labels */
.input-box label {
    position: absolute;
    top: 10px;
    left: 15px;
    font-size: 0.75em;
    color: #FFCB9A;
    pointer-events: none;
    transition: 0.3s;
}

.input-box input:focus + label,
.input-box input:valid + label,
.input-box textarea:focus + label,
.input-box textarea:valid + label {
    top: -20px;
    left: 10px;
    font-size: 0.7em;
}

/* Styling for the button */
button {
    width: 100%;
    padding: 12px;
    background: #ff004f;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 1em;
    color: #000;
    font-weight: bold;
    transition: background 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
}

button:hover {
    background: #FFCB9A;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
}

/* Input field and textarea focus effect */
.input-box input:focus,
.input-box textarea:focus {
    border-color: #ff004f;
}

/* Animation keyframes */
@keyframes slideFromLeft {
    from {
        transform: translate(-50%, -50%) translateX(1100%); /* Start off-screen */
    }
    to {
        transform: translate(-50%, -50%) translateX(-10%); /* End at 60% */
    }
}

/* Apply animation when showing */
.form-overlay.show {
    opacity: 1;
    visibility: visible;
    animation: slideFromLeft 0.5s ease-out forwards; /* Animation only runs once */
}

    
</style>

 <div id="contact" style="padding-top: 0px;">
        <div class="video-container">
            <video id="background-video" autoplay="" muted="">
                <source src="videos/contact.mp4" type="video/mp4">
                Your browser does not support the video tag.
            </video>
            <div class="form-overlay" style="width: 380px;">
                <h2>Contact Us</h2>
                <form name="submit-to-google-sheet">
                    <div class="input-box">
                        <input type="text" name="name" required="">
                        <label>Name</label>
                    </div>
                    <div class="input-box">
                        <input type="email" name="email" required="">
                        <label>Email</label>
                    </div>
                    <div class="input-box">
                        <textarea name="message" required=""></textarea>
                        <label>Message</label>
                    </div>
                    <button type="submit">Send Message</button>
                </form>
                <span id="msg"></span>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const formContainer = document.querySelector('.form-container');
            formContainer.classList.add('active');

            const video = document.getElementById('background-video');
            const loopDuration = 4; 
            let loopStart = 0; 

            video.addEventListener('loadedmetadata', () => {
                
                loopStart = Math.max(video.duration - loopDuration, 0);
                video.currentTime = 0; 
            });

            video.addEventListener('timeupdate', () => {
                if (video.currentTime >= video.duration - loopDuration) {
                    video.currentTime = loopStart;
                }
            });
        });
    </script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
        var formOverlay = document.querySelector('.form-overlay');
        if (!formOverlay.classList.contains('show')) {
            formOverlay.classList.add('show');
        }
    }, 4000); // 4 seconds delay
});
</script>



<!-- Divider -->
<script>
  const scriptURL = 'https://script.google.com/macros/s/AKfycbymc0h9vizDyQTvGrlZAHzPkx7T5sUtUEpPaFCmQa6ZASzgNrMUkaNI4xIbb2s3fQeiAg/exec';
  const form = document.forms['submit-to-google-sheet'];
  const msg = document.getElementById("msg");

  form.addEventListener('submit', e => {
    e.preventDefault();
    fetch(scriptURL, { method: 'POST', body: new FormData(form)})
      .then(response => {
        msg.innerHTML = "Message sent successfully";
        setTimeout(() => {
          msg.innerHTML = "";
        }, 5000);
        form.reset();
      })
      .catch(error => {
        console.error('Error!', error.message);
        msg.innerHTML = "Something went wrong!";
      });
  });
</script>


</body>
</html>