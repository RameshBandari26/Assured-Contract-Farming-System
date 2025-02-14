<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
    <title>Register</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="register.css">
</head>

<body>
    <div class="title">
        <h1>WELCOME</h1>
        <p id="welcome-message">Join our platform today and experience seamless collaboration between farmers and buyers.</p>
    </div>
    <div class="main">
        <div class="reg">
            <h1>Register</h1><br>
            <form action="register.jsp" method="post">
                <div class="name">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Enter Username" required>
                </div>
                <div class="email">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="Enter Email" required>
                </div>
                <div>
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter Password" required>
                </div>
                <div class="address">
                    <label>Address</label>
                    <input type="text" name="address" placeholder="Enter Address" required>
                </div>
                <div class="role">
                    <label>Role</label>
                    <select name="role" required>
                        <option value="" disabled selected>Select your Role</option>
                        <option value="farmer">Farmer</option>
                        <option value="buyer">Buyer</option>
                    </select>
                </div>
                <div class="button">
                    <button type="submit">Register</button>
                </div>
            </form>
            <a href="index.html"><button type="button">Back</button></a>
        </div>
    </div>

    <%
        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String address = request.getParameter("address");

        if (username != null && email != null && password != null && role != null && address != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");
                
                // Check if the email is already registered
                String checkQuery = "SELECT COUNT(*) AS count FROM users WHERE email = ?";
                PreparedStatement checkStmt = con.prepareStatement(checkQuery);
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next() && rs.getInt("count") > 0) {
                    // Email already exists
                    out.println("<script>alert('This email is already registered. Please log in or use another email.');</script>");
                } else {
                    // Insert new user
                    String query = "INSERT INTO users (username, email, password, role, address) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement pst = con.prepareStatement(query);
                    pst.setString(1, username);
                    pst.setString(2, email);
                    pst.setString(3, password);
                    pst.setString(4, role);
                    pst.setString(5, address);

                    int result = pst.executeUpdate();
                    
                    if (result > 0) {
                        out.println("<script>alert('Registration successful! Redirecting to login page.');</script>");
                        response.sendRedirect("login.jsp");
                    } else {
                        out.println("<script>alert('Registration failed. Please try again.');</script>");
                    }
                }

                con.close();
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            }
        }
    %>

    <script>
        // Adding hover animation
        const welcomeMessage = document.getElementById('welcome-message');

        welcomeMessage.addEventListener('mouseover', () => {
            welcomeMessage.style.transform = 'scale(1.1)';
            welcomeMessage.style.transition = 'transform 0.3s ease';
        });

        welcomeMessage.addEventListener('mouseout', () => {
            welcomeMessage.style.transform = 'scale(1)';
        });
    </script>
</body>

</html>
