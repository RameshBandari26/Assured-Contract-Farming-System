<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
            color: #333;
            background-color: #f5f5f5;
        }

        main {
            flex: 1;
            padding: 40px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
            max-width: 800px;
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
            padding-left: 40px;
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
            /* Push footer to the bottom if content is short */
        }

        footer p {
            margin: 0;
        }

        /* Responsive Design */
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
            <h1>Privacy Policy</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="about.jsp">About Us</a>
                <a href="contact.jsp">Contact Us</a>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <h2>Our Commitment to Privacy</h2>
            <p>
                Your privacy is important to us. This privacy policy outlines the types of personal information we
                collect and how we use, share, and protect that information.
            </p>
            <h3>Information We Collect</h3>
            <ul type="none">
                <li>Personal information provided during registration (e.g., name, email, and Address).</li>
                <li>Transactional data related to contracts and payments.</li>
                <li>Usage data to improve the platform experience.</li>
            </ul>
            <h3>How We Use Your Information</h3>
            <p>We use your data to facilitate contract farming agreements, improve platform performance, and ensure
                secure transactions.</p>
            <h3>Sharing Your Information</h3>
            <p>We do not share your personal information with third parties except as necessary for contract and payment
                processing or as required by law.</p>
            <h3>Your Choices</h3>
            <p>You can review and update your personal information through your account settings. For more information,
                contact our support team.</p>
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2024 Assured Contract Farming System. All rights reserved.</p>
        </div>
    </footer>
</body>

</html>