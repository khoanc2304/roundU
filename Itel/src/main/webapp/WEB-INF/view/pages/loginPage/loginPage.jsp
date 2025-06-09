<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Page</title>
    </head>
    <body>
        <div class="login-container">
            <div class="logo-container">
                <img src="resources/itel.png" alt="Website Logo">
            </div>

            <form id="loginForm" action="main" method="POST">
                <input type="hidden" name="action" value="login">
                <input type="email" id="email" name="email" placeholder="Email" required>
                <div id="emailError" class="error-message">Please enter a valid email address.</div>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Login</button>
            </form>
            <a href="#">Forgot Password?</a>
            <a href="#">Create an Account</a>
        </div>

        <script>
            document.getElementById('loginForm').addEventListener('submit', function (event) {
                const emailInput = document.getElementById('email');
                const emailError = document.getElementById('emailError');
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailPattern.test(emailInput.value)) {
                    emailError.style.display = 'block';
                    event.preventDefault();
                } else {
                    emailError.style.display = 'none';
                }
            });

            document.getElementById('email').addEventListener('input', function () {
                const emailError = document.getElementById('emailError');
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailPattern.test(this.value)) {
                    emailError.style.display = 'block';
                } else {
                    emailError.style.display = 'none';
                }
            });
        </script>

        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>

<style>
    body {
        background: linear-gradient(135deg, #ffffff, #87CEEB);
        color: white;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        font-family: Arial, sans-serif;
    }

    .login-container {
        background-color: #f5f5f5;
        padding: 40px;
        border-radius: 15px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        width: 300px;
        color: #333;
    }

    .logo-container {
        margin-bottom: 20px;
    }

    .logo-container img {
        width: 250px;
        height: auto;
    }

    .logo-container h1 {
        margin-top: 10px;
        font-size: 24px;
        color: #e6b800;
    }

    .login-container h2 {
        margin-bottom: 20px;
        font-size: 20px;
        color: #e6b800;
    }

    .login-container input {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: none;
        border-radius: 5px;
        background-color: #ddd;
        color: #333;
    }

    .login-container input::placeholder {
        color: #888;
    }

    .login-container button {
        width: 100%;
        padding: 10px;
        margin-top: 20px;
        border: none;
        border-radius: 5px;
        background-color: #e6b800;
        color: #242424;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .login-container button:hover {
        background-color: #ffd700;
    }

    .login-container a {
        color: #e6b800;
        text-decoration: none;
        font-size: 14px;
        display: block;
        margin-top: 10px;
    }

    .login-container a:hover {
        text-decoration: underline;
    }

    .error-message {
        color: #ff4444;
        font-size: 14px;
        margin-top: 5px;
        display: none;
    }
</style>