<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    String message = "";
    Connection conn = null;
    PreparedStatement pst = null;

    try {
        int contractId = Integer.parseInt(request.getParameter("contract_id"));
        String paymentMethod = request.getParameter("payment_method");
        String transactionId = request.getParameter("transaction_id");

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = db.DBConnection.getConnection();

        // Insert payment record
        String insertPayment = "INSERT INTO payments (contract_id, payment_method, transaction_id) VALUES (?, ?, ?)";
        pst = conn.prepareStatement(insertPayment);
        pst.setInt(1, contractId);
        pst.setString(2, paymentMethod);
        pst.setString(3, transactionId);

        int rowsAffected = pst.executeUpdate(); 
        if (rowsAffected > 0) {
            // Update contract status to "Paid"
            String updateContract = "UPDATE contracts SET payment_status = 'Paid' WHERE id = ?";
            pst = conn.prepareStatement(updateContract);
            pst.setInt(1, contractId);
            pst.executeUpdate();

            // Update crop status to "Sold"
            String updateCropStatus = 
                "UPDATE crops " +
                "SET status = 'Sold' " +
                "WHERE id = (SELECT crop_id FROM contracts WHERE id = ?)";
            pst = conn.prepareStatement(updateCropStatus);
            pst.setInt(1, contractId);
            pst.executeUpdate();

            message = "Payment successfully processed!";
        } else {
            message = "Payment failed.";
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
    <title>Payment Status</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="process_payment.css">
    <script>
        // Alert message and redirect
        window.onload = function() {
            alert("<%= message %>");
            window.location.href = "view_contracts.jsp";
        };
    </script>
</head>
<body>
    
</body>
</html>
