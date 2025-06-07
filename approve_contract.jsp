<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role"); // 'farmer', 'buyer', or 'admin'

    if (!"farmer".equalsIgnoreCase(role)) {
        response.sendRedirect("view_contracts.jsp");
        return;
    }

    String message = "";
    Connection conn = null;
    PreparedStatement pst = null;

    try {
        // Retrieve contract_id from the form
        int contractId = Integer.parseInt(request.getParameter("contract_id"));

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = db.DBConnection.getConnection();


        // Update contract status to 'Accepted'
        String updateQuery = "UPDATE contracts SET contract_status = 'Accepted' WHERE id = ?";
        pst = conn.prepareStatement(updateQuery);
        pst.setInt(1, contractId);

        int rowsAffected = pst.executeUpdate();
        if (rowsAffected > 0) {
            message = "Contract approved successfully!";
        } else {
            message = "Failed to approve the contract.";
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Contract</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="approve_contract.css">
    <script>
        window.onload = function() {
            alert("<%= message %>");
            window.location.href = "view_contracts.jsp";
        };
    </script>
</head>
<body>
    
</body>
</html>
