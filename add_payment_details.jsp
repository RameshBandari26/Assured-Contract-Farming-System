<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    String message = "";
    String username = (String) session.getAttribute("username"); // Get logged-in username
    if (session == null || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String upiId = null;
    String accountNumber = null;
    String ifscCode = null;
    boolean hasDetails = false;
    boolean isEditing = "true".equals(request.getParameter("edit"));

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        // Check if the user already has payment details
        String checkQuery = "SELECT upi_id, account_number, ifsc_code FROM users WHERE username = ?";
        pst = conn.prepareStatement(checkQuery);
        pst.setString(1, username);
        rs = pst.executeQuery();

        if (rs.next()) {
            upiId = rs.getString("upi_id");
            accountNumber = rs.getString("account_number");
            ifscCode = rs.getString("ifsc_code");

            // If details exist, set the flag to true
            hasDetails = upiId != null || accountNumber != null || ifscCode != null;
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }

    // Handle form submission for updating payment details
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        upiId = request.getParameter("upi_id");
        accountNumber = request.getParameter("account_number");
        ifscCode = request.getParameter("ifsc_code");

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

            // Update payment details for the logged-in user
            String updateQuery = "UPDATE users SET upi_id = ?, account_number = ?, ifsc_code = ? WHERE username = ?";
            pst = conn.prepareStatement(updateQuery);
            pst.setString(1, upiId);
            pst.setString(2, accountNumber);
            pst.setString(3, ifscCode);
            pst.setString(4, username);

            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                message = "Payment details updated successfully!";
                hasDetails = true;
                isEditing = false; // Exit edit mode after saving
            } else {
                message = "Failed to update payment details. Please try again.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Details</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="add_payment_details.css">
</head>
<body>
    <div class="container">
        <h1>Payment Details</h1>
        <% if (!message.isEmpty()) { %>
            <p style="color: green;"><%= message %></p>
        <% } %>

        <% if (hasDetails && !isEditing) { %>
            
            <h2>Your Payment Details</h2>
            <p><strong>UPI ID:</strong> <%= upiId != null ? upiId : "Not Provided" %></p>
            <p><strong>Account Number:</strong> <%= accountNumber != null ? accountNumber : "Not Provided" %></p>
            <p><strong>IFSC Code:</strong> <%= ifscCode != null ? ifscCode : "Not Provided" %></p>

            <form action="add_payment_details.jsp" method="get">
                <input type="hidden" name="edit" value="true">
                <button type="submit" class="submit-btn">Edit Details</button>
            </form>
        <% } else { %>
            
            <h2><%= hasDetails ? "Edit Payment Details" : "Add Payment Details" %></h2>
            <form action="add_payment_details.jsp" method="post">
                <div class="form-group">
                    <label for="upi_id">UPI ID:</label>
                    <input type="text" name="upi_id" id="upi_id" placeholder="e.g., farmer@upi" value="<%= upiId != null ? upiId : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="account_number">Bank Account Number:</label>
                    <input type="text" name="account_number" id="account_number" placeholder="e.g., 1234567890" value="<%= accountNumber != null ? accountNumber : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="ifsc_code">IFSC Code:</label>
                    <input type="text" name="ifsc_code" id="ifsc_code" placeholder="e.g., SBIN0001234" value="<%= ifscCode != null ? ifscCode : "" %>" required>
                </div>
                <button type="submit" class="submit-btn">Save Details</button>
            </form>
        <% } %>

        <div class="back">
            <a href="dashboard.jsp" class="backbtn">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
