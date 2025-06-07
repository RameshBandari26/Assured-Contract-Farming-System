<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.util.*, java.security.SecureRandom" %>
<%
    String message = "";
    String email = request.getParameter("email");
    String tempPassword = "";

    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&";
    SecureRandom random = new SecureRandom();
    StringBuilder password = new StringBuilder();
    for (int i = 0; i < 8; i++) {
        password.append(characters.charAt(random.nextInt(characters.length())));
    }
    tempPassword = password.toString(); // The generated password

    if (email != null) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
           
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = db.DBConnection.getConnection();

            String checkQuery = "SELECT * FROM users WHERE email = ?";
            pst = conn.prepareStatement(checkQuery);
            pst.setString(1, email);
            rs = pst.executeQuery();

            if (rs.next()) {
                
                String updateQuery = "UPDATE users SET password = ? WHERE email = ?";
                pst = conn.prepareStatement(updateQuery);
                pst.setString(1, tempPassword);
                pst.setString(2, email);

                int rowsAffected = pst.executeUpdate();
                if (rowsAffected > 0) {
                    message = "A temporary password has been set. Please check your email.";
                    // Set attributes to pass to JavaScript for the alert message
                    request.setAttribute("email", email);
                    request.setAttribute("tempPassword", tempPassword);
                } else {
                    message = "Failed to update password. Please try again.";
                }
            } else {
                message = "No account found with this email.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="forgot_password.css">
    <script>

        <% if (request.getAttribute("email") != null && request.getAttribute("tempPassword") != null){ %>
            window.onload = function() {
                var email = "<%= request.getAttribute("email") %>";
                var tempPassword = "<%= request.getAttribute("tempPassword") %>";
                alert("Email: " + email + "\nTemporary Password: " + tempPassword);
            }
        <% } %>
    </script>
</head>
<body>
    <div class="container">
        <h1>Forgot Password</h1>
        <p><%= message %></p>

        <form action="forgot_password.jsp" method="post">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" placeholder="Enter your registered email" required>
            </div>
            <button type="submit" class="submit-btn">Reset Password</button>
        </form>

        <a href="login.jsp" class="back-link">Back to Login</a>
    </div>
</body>
</html>
