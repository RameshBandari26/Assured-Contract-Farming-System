<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="style.css">
    
    <style>
body {
    display: flex;
    flex-direction: column;
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
    flex: 1;
    padding: 40px;
    background: #f9f9f9;
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    margin: 30px auto;
    max-width: 800px;
    color: #333;
}

main h2 {
    text-align: center;
    font-size: 32px;
    color: #2c3e50;
    margin-bottom: 20px;
    font-weight: bold;
}

main h3 {
    font-size: 20px;
    color: #34495e;
    margin-top: 25px;
    margin-bottom: 15px;
    padding-left: 10px;
    font-weight: bold;
}

main p {
    font-size: 16px;
    line-height: 1.6;
    color: #555;
    margin-bottom: 20px;
    text-align: justify;
}

main ul {
    list-style-type: none;
    padding-left: 20px;
    margin-bottom: 20px;
}

main ul li {
    font-size: 16px;
    color: #555;
    margin-bottom: 10px;
}

footer {
    background-color: #2c3e50;
    color: #fff;
    text-align: center;
    padding: 20px;
    font-size: 14px;
    border-top: 3px solid #4CAF50;
    margin-top: auto;
}
footer p {
    margin: 0;
}

@media (max-width: 768px) {
    main {
        padding: 20px;
    }

    main h2 {
        font-size: 28px;
    }

    main h3 {
        font-size: 18px;
    }

    main p,
    main ul li {
        font-size: 14px;
    }

    footer {
        font-size: 12px;
        padding: 15px;
    }
}

    </style>
</head>
<body>
    <header>
        <div class="container">
            <h1>About Us</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="privacy_policy.jsp">Privacy Policy</a>
                <a href="contact.jsp">Contact Us</a>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <h2>Who We Are</h2>
            <p>
                Assured Contract Farming System is a platform designed to bridge the gap between farmers and buyers, ensuring fair and transparent farming contracts. Our goal is to create a reliable ecosystem where farmers can secure stable income, and buyers can access quality produce.
            </p>
            <h3>Our Mission</h3>
            <p>
                To empower farmers and buyers through innovative technology, ensuring trust and stability in the agricultural sector.
            </p>
            <h3>What We Do</h3>
            <ul>
                <li>Provide a platform for creating and managing farming contracts.</li>
                <li>Ensure secure payment processing for all transactions.</li>
                <li>Facilitate transparent price negotiations.</li>
            </ul>
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2024 Assured Contract Farming System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>