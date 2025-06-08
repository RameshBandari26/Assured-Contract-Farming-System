<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="style.css">
    <style>
body {

    min-height: 100vh;
    margin: 0;
    font-family: 'Arial', sans-serif;
    color: #333;
}

header {
    background-color: #2c3e50;
    color: white;
    padding: 8px 0;
    text-align: center;
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
}
main {
    padding: 40px;
    background: #f4f8fb;
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    margin: 30px auto;
    max-width: 800px;
    font-family: 'Arial', sans-serif;
    color: #222;
}

main h2 {
    text-align: center;
    font-size: 32px;
    color: #2c3e50;
    margin-bottom: 20px;
    font-weight: bold;
}

main p {
    text-align: center;
    font-size: 16px;
    color: #666;
    margin-bottom: 30px;
    line-height: 1.6;
}

main h3 {
    font-size: 20px;
    color: #34495e;
    margin-top: 20px;
    margin-bottom: 15px;
    padding-left: 10px;
    font-weight: bold;
}

main ul {
    padding-left: 0;
    list-style: none;
    margin-bottom: 20px;
}

main ul li {
    font-size: 16px;
    color: #555;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}

main ul li::before {
    
    font-family: "Font Awesome 5 Free";
    font-weight: 900;
    font-size: 16px;
    color: #4CAF50;
    margin-right: 10px;
}

form {
    background: #ffffff;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 25px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
    margin-top: 25px;
}

form label {
    font-weight: bold;
    color: #333;
    font-size: 14px;
    display: block;
    margin-bottom: 8px;
}

form input[type="text"],
form input[type="email"],
form textarea {
    width: 90%;
    padding: 12px 15px;
    margin-bottom: 20px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 8px;
    transition: border-color 0.3s ease;
}

form input:focus,
form textarea:focus {
    border-color: #4CAF50;
    outline: none;
}

form textarea {
    resize: vertical;
    min-height: 120px;
}

form button {
    background-color: #4CAF50;
    color: #fff;
    border: none;
    padding: 12px 20px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 8px;
    transition: all 0.3s ease;
    width: 100%;
}

form button:hover {
    background-color: #45a049;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

footer {
    background-color: #2c3e50;
    color: #fff;
    text-align: center;
    padding: 20px;
    font-size: 14px;
    border-top: 3px solid #4CAF50;
    margin-top: auto; /* Push footer to the bottom if content is short */
}

footer p {
    margin: 0;
}

@media (max-width: 768px) {
    main {
        padding: 20px;
    }

    form button {
        width: 100%;
        padding: 14px;
    }
}


    </style>
</head>
<body>
    <header>
        <div class="container">
            <h1>Contact Us</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="about.jsp">About Us</a>
                <a href="privacy_policy.jsp">Privacy Policy</a>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <h2>We'd Love to Hear from You</h2>
            <p>
                If you have any questions, feedback, or need support, feel free to reach out to us.
            </p>
            <h3>Contact Information</h3>
            <ul >
                <li>Email: support@contractfarming.com</li>
                <li>Phone: +1-800-555-1234</li>
                <li>Address: 123 Agriculture Lane, Greenfield, USA</li>
            </ul>
            <h3>Send Us a Message</h3>
            <form action="https://api.web3forms.com/submit" method="post">
                <label for="name">Name:</label><br>
                <input type="text" id="name" name="name" required><br><br>
                <label for="email">Email:</label><br>
                <input type="email" id="email" name="email" required><br><br>
                <label for="message">Message:</label><br>
                <textarea id="message" name="message" rows="5" required></textarea><br><br>
                <button type="submit">Submit</button>
            </form>
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2024 Assured Contract Farming System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
