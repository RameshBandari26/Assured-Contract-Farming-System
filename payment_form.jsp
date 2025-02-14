<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (!"buyer".equalsIgnoreCase(role)) {
        response.sendRedirect("view_contracts.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    ResultSet farmerDetailsRS = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        // Query to fetch accepted contracts for this buyer
        String query = "SELECT c.id AS contract_id, cr.crop_name, cr.quantity, cr.price_per_unit, f.upi_id, f.ifsc_code, f.account_number " +
                       "FROM contracts c " +
                       "JOIN crops cr ON c.crop_id = cr.id " +
                       "JOIN users f ON cr.farmer_id = f.id " +
                       "WHERE c.buyer_id = (SELECT id FROM users WHERE username = ?) AND c.contract_status = 'Accepted'";
        pst = conn.prepareStatement(query);
        pst.setString(1, username);
        rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="payment_form.css">
    <script>
        function displayPaymentDetails() {
            const paymentMethod = document.getElementById("payment_method").value;
            const upiSection = document.getElementById("upi-details");
            const bankSection = document.getElementById("bank-details");

            if (paymentMethod === "UPI") {
                upiSection.style.display = "block";
                bankSection.style.display = "none";
            } else if (paymentMethod === "Net Banking") {
                upiSection.style.display = "none";
                bankSection.style.display = "block";
            } else {
                upiSection.style.display = "none";
                bankSection.style.display = "none";
            }
        }
    </script>
</head>
<body>
    <div class="payment-container">
        <h1>Make Payment</h1>

        <form action="process_payment.jsp" method="post">
            <label for="contract">Select Contract:</label>
            <select id="contract" name="contract_id" required>
                <option value="">-- Select Contract --</option>
                <%
                while (rs.next()) {
                    int contractId = rs.getInt("contract_id");
                    String cropName = rs.getString("crop_name");
                    int quantity = rs.getInt("quantity");
                    double pricePerUnit = rs.getDouble("price_per_unit");
                    double totalPrice = quantity * pricePerUnit;

                    // Fetch farmer's details
                    String upiId = rs.getString("upi_id");
                    String ifscCode = rs.getString("ifsc_code");
                    String accountNumber = rs.getString("account_number");
                %>
                <option 
                    value="<%= contractId %>" 
                    data-upi="<%= upiId %>" 
                    data-ifsc="<%= ifscCode %>" 
                    data-account="<%= accountNumber %>">
                    Contract #<%= contractId %>: <%= cropName %> - ₹<%= totalPrice %>
                </option>
                <%
                }
                %>
            </select>

            <label for="payment_method">Payment Method:</label>
            <select id="payment_method" name="payment_method" required onchange="displayPaymentDetails()">
                <option value="">-- Select Payment Method --</option>
                <option value="UPI">UPI</option>
                <option value="Net Banking">Net Banking</option>
            </select>

            <div id="upi-details" style="display: none; margin-top: 10px;">
                <p><strong>Farmer UPI ID:</strong> <span id="upi-id"></span></p>
            </div>

            <div id="bank-details" style="display: none; margin-top: 10px;">
                <p><strong>Farmer IFSC Code:</strong> <span id="ifsc-code"></span></p>
                <p><strong>Farmer Account Number:</strong> <span id="account-number"></span></p>
            </div>

            <label for="transaction_id">Transaction ID:</label>
            <input type="text" id="transaction_id" name="transaction_id" required>

            <button type="submit" class="paybtn">Submit Payment</button>
        </form>

        <a href="view_contracts.jsp" class="backbtn">Back to Contracts</a>
    </div>

    <script>
        // Dynamically update UPI/Bank details based on selected contract
        document.getElementById("contract").addEventListener("change", function() {
            const selectedOption = this.options[this.selectedIndex];
            document.getElementById("upi-id").textContent = selectedOption.dataset.upi || "N/A";
            document.getElementById("ifsc-code").textContent = selectedOption.dataset.ifsc || "N/A";
            document.getElementById("account-number").textContent = selectedOption.dataset.account || "N/A";
        });
    </script>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>
