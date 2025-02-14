<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <div class="wrapper">
        <div class="form-box">
            <h1>Login</h1>
            <form action="login.jsp" method="post">
                <div class="input-box">
                    <input type="email" name="email" required>
                    <label>Email</label>
                </div>
                <div class="input-box">
                    <input type="password" name="password" required>
                    <label>Password</label>
                </div>
                <div>
                    <input type="submit" value="Login" class="button">
                </div><br>
            </form>
            <div class="Register">
                <div class="forgotPassword"><a href="forgot_password.jsp">Forgot Password?</a></div>
                <p>If you don't have an account?<br>
                    <a href="register.jsp"><button class="bt">Register</button></a> (or)
                    <a href="index.html"><button class="bt">Home Page</button></a>
                </p>
            </div>
        </div>
    </div>


    <% 
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null && password != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

                String query = "SELECT * FROM users WHERE email = ? AND password = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, email);
                pst.setString(2, password);

                ResultSet rs = pst.executeQuery();
                if (rs.next()) {
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setAttribute("email", rs.getString("email"));
                    response.sendRedirect("dashboard.jsp");
                } else {
                    out.println("Invalid credentials.");
                }

                con.close();
            } catch(Exception e) {
                out.println(e);
            }
        }
    %>
</body>
</html>
