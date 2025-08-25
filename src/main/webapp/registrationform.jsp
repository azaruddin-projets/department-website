<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registration Form</title>
<link href="reg.css" rel="stylesheet"/>
   <link rel="icon" href="images/logo.png" type="image/icon type">
<style>

body {
    background-image: url("images/regis.jpg");
    background-size: cover;
    background-repeat: no-repeat;
    animation: fadeIn 1s ease-in; 
    font-family: Arial, sans-serif;
}
.registrationForm {
    backdrop-filter: blur(10px); 
    background: rgba(255, 255, 255, 0.1); 
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    width: 80%;
    max-width: 800px;
    margin: 0 auto;
}

input[type="text"],
input[type="password"],
input[type="email"],
input[type="date"],
select {
    padding: 8px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    width: 100%;
    box-sizing: border-box; 
}


.invalid {
    color: red;
    font-size: 0.9em;
}


.valid {
    color: green;
    font-size: 0.9em;
}


select {
    padding: 8px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    width: 100%;
}


label {
    display: block;
    margin-bottom: 10px;
    color: #FFCB9A;
}


.step {
    display: none;
}


.step.active {
    display: block;
}


button {
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    background-color: #FFCB9A;
    color: white;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

button:hover {
    background-color: #e0a86b;
}

button:disabled {
    background-color: #ccc;
}


@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

@keyframes slideIn {
    from {
        transform: translateY(30px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

.step.active {
    animation: slideIn 0.5s ease-out;
}
</style>
</head>
<body>
<h1>User Registration</h1>

<form id="registrationForm">
  
    <div class="step active" id="step1">
        <label for="year">Year:</label>
        <select id="year" name="year" required>
            <option value="">Select Year</option>
         
            <option value="Second Year">Second Year</option>
            <option value="Third Year">Third Year</option>
            <option value="Fourth Year">Fourth Year</option>
        </select>
        
        <label for="section">Section:</label>
        <select id="section" name="section" required>
            <option value="">Select Section</option>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="C">C</option>
          
        </select>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>
        <span id="password-hint" class="invalid">Password must be at least 8 characters long and include a number.</span>
        
        <label for="confirm-password">Re-enter Password:</label>
        <input type="password" id="confirm-password" name="confirm-password" placeholder="Re-enter password" required>
        <span id="confirm-password-hint" class="invalid" style="display: none;">Passwords do not match.</span>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" placeholder="Enter email" required>
        <span id="email-hint" class="invalid" style="display: none;">Please enter a valid email address.</span>
        
        <label for="phone">Phone Number:</label>
        <input type="text" id="phone" name="phone" placeholder="Enter phone number" required>
        
        <label for="dob">Date of Birth:</label>
        <input type="date" id="dob" name="dob" required>
        
        <button type="button" id="next1">Next</button>
    </div>

    <div class="step" id="step2">
        <label for="security-question1">Security Question 1:</label>
        <select id="security-question1" name="security-question1" required>
            <option value="">Select a security question</option>
            <option value="What is your Favorite color">What is your Favorite color</option>
            <option value="What is your pet name">What is your pet name </option>
        </select>

        <label for="security-answer1">Answer:</label>
        <input type="text" id="security-answer1" name="security-answer1" placeholder="Enter answer" required>

        <label for="security-question2">Security Question 2:</label>
        <select id="security-question2" name="security-question2" required>
            <option value="">Select a security question</option>
            <option value="What is your native place">What is your native place</option>
            <option value="What is your favorite country">What is your favorite country</option>
        </select>

        <label for="security-answer2">Answer:</label>
        <input type="text" id="security-answer2" name="security-answer2" placeholder="Enter answer" required>

        <button type="button" id="prev1">Back</button>
        <button type="button" id="next2">Next</button>
    </div>
    <div class="step" id="step3">
        <h2>Confirm Your Details</h2>
        <p><strong>Username:</strong> <span id="confirm-username"></span></p>
        <p><strong>Email:</strong> <span id="confirm-email"></span></p>
        <p><strong>Phone Number:</strong> <span id="confirm-phone"></span></p>
        <p><strong>Date of Birth:</strong> <span id="confirm-dob"></span></p>
        <p><strong>Year:</strong> <span id="confirm-year"></span></p>
        <p><strong>Section:</strong> <span id="confirm-section"></span></p>
        <p><strong>Security Question 1:</strong> <span id="confirm-security-question1"></span></p>
        <p><strong>Answer:</strong> <span id="confirm-security-answer1"></span></p>
        <p><strong>Security Question 2:</strong> <span id="confirm-security-question2"></span></p>
        <p><strong>Answer:</strong> <span id="confirm-security-answer2"></span></p>

        <button type="button" id="prev2">Back</button>
        <button type="submit" id="submit-btn">Submit</button>
    </div>

    <div id="registrationResult"></div>
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        let currentStep = 1;

        function showStep(step) {
            $('.step').removeClass('active');
            $('#step' + step).addClass('active');
        }

        function validateStep1() {
            let passwordValid = $('#password-hint').hasClass('valid');
            let confirmPasswordValid = $('#confirm-password-hint').hasClass('valid');
            let emailValid = $('#email-hint').hasClass('valid');
            return passwordValid && confirmPasswordValid && emailValid;
        }

        function updateConfirmation() {
            $('#confirm-username').text($('#username').val());
            $('#confirm-email').text($('#email').val());
            $('#confirm-phone').text($('#phone').val());
            $('#confirm-dob').text($('#dob').val());
            $('#confirm-year').text($('#year').val());
            $('#confirm-section').text($('#section').val());
            $('#confirm-security-question1').text($('#security-question1').find('option:selected').text());
            $('#confirm-security-answer1').text($('#security-answer1').val());
            $('#confirm-security-question2').text($('#security-question2').find('option:selected').text());
            $('#confirm-security-answer2').text($('#security-answer2').val());
        }

        $('#next1').click(function() {
            if (validateStep1()) {
                currentStep = 2;
                showStep(currentStep);
            } else {
                alert('Please correct the errors in Step 1.');
            }
        });

        $('#prev1').click(function() {
            currentStep = 1;
            showStep(currentStep);
        });

        $('#next2').click(function() {
            updateConfirmation();
            currentStep = 3;
            showStep(currentStep);
        });

        $('#prev2').click(function() {
            currentStep = 2;
            showStep(currentStep);
        });

        $('#registrationForm').submit(function(event) {
            event.preventDefault();
            
            var formData = $(this).serialize();

           
            $.ajax({
                type: 'POST',
                url: 'RegisterServlet',
                data: formData,
                dataType: 'json',
                success: function(response) {
                    if (response.status === 'success') {
                        $('#registrationResult').html('<p class="valid">' + response.message + '</p>');
                        $('#registrationForm')[0].reset(); 
                        currentStep = 1;
                        showStep(currentStep);
                    } else {
                        $('#registrationResult').html('<p class="invalid">' + response.message + '</p>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error:', error);
                    $('#registrationResult').html('<p class="invalid">An error occurred while processing your request.</p>');
                }
            });
        });

        
        $('#password').on('input', function() {
            var password = $(this).val();
            var regex = /^(?=.*[0-9]).{8,}$/;
            if (regex.test(password)) {
                $('#password-hint').text('Password meets the requirements.').removeClass('invalid').addClass('valid');
            } else {
                $('#password-hint').text('Password must be at least 8 characters long and include a number.').removeClass('valid').addClass('invalid');
            }
            validateConfirmPassword();
            validateEmail();
        });

        $('#confirm-password').on('input', function() {
            validateConfirmPassword();
        });

      
        $('#email').on('input', function() {
            validateEmail();
        });

        function validateConfirmPassword() {
            var confirmPassword = $('#confirm-password').val();
            var password = $('#password').val();
            if (confirmPassword === "") {
                $('#confirm-password-hint').hide();
            } else if (password === confirmPassword) {
                $('#confirm-password-hint').text('Passwords match.').removeClass('invalid').addClass('valid').show();
            } else {
                $('#confirm-password-hint').text('Passwords do not match.').removeClass('valid').addClass('invalid').show();
            }
        }

        function validateEmail() {
            var email = $('#email').val();
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailRegex.test(email)) {
                $('#email-hint').text('Valid email address.').removeClass('invalid').addClass('valid').show();
            } else {
                $('#email-hint').text('Please enter a valid email address.').removeClass('valid').addClass('invalid').show();
            }
        }
    });
</script>
</body>
</html>
