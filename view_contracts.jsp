<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role"); // 'farmer', 'buyer', or 'admin'
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        // Query to fetch contracts
        String query = "SELECT " +
        "    c.id AS contract_id, " +
        "    cr.crop_name, " +
        "    cr.quantity, " +
        "    cr.price_per_unit, " +
        "    f.username AS farmer_name, " +
        "    b.username AS buyer_name, " +
        "    c.contract_status, " +
        "    c.payment_status " +  // Include payment_status in the SELECT clause
        "FROM contracts c " +
        "JOIN crops cr ON c.crop_id = cr.id " +
        "JOIN users f ON cr.farmer_id = f.id " +
        "JOIN users b ON c.buyer_id = b.id " +
        "WHERE f.username = ? OR b.username = ?";


        pst = conn.prepareStatement(query);
        pst.setString(1, username);  // For farmer
        pst.setString(2, username);  // For buyer
        rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Contracts</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="view_contracts.css">
</head>
<body>
    <div class="container">
        <h1>Contracts for <%= username %></h1>
        <table>
            <thead>
                <tr>
                    <th>Contract ID</th>
                    <th>Farmer Name</th>
                    <th>Buyer Name</th>
                    <th>Crop</th>
                    <th>Quantity</th>
                    <th>Price per Unit</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                %>
                <tr>
                    <td><%= rs.getInt("contract_id") %></td>
                    <td><%= rs.getString("farmer_name") %></td>
                    <td><%= rs.getString("buyer_name") %></td>
                    <td><%= rs.getString("crop_name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td><%= rs.getDouble("price_per_unit") %></td>
                    <td><%= rs.getString("contract_status") %></td>
                    <td>
                        <% if ("farmer".equalsIgnoreCase(role) && "Pending".equalsIgnoreCase(rs.getString("contract_status"))) { %>
                            <!-- Approve Button (only visible to non-buyers) -->
                        <form action="approve_contract.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="contract_id" value="<%= rs.getInt("contract_id") %>">
                            <input type="submit" value="Approve" class="approve">
                        </form>
                            <!-- Reject Button for farmers -->
                            <form action="reject_contract.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="contract_id" value="<%= rs.getInt("contract_id") %>">
                                <input type="submit" value="Reject" class="delete">
                            </form>
                        <% } %>
                        <% 
if ("buyer".equalsIgnoreCase(role)) { 
    String contractStatus = rs.getString("contract_status"); // Fetch contract_status
    String paymentStatus = rs.getString("payment_status");   // Fetch payment_status
%>
    <!-- Delete Button -->
    <form action="delete_contract.jsp" method="post" style="display:inline;">
        <input type="hidden" name="contract_id" value="<%= rs.getInt("contract_id") %>">
        <input type="submit" value="Delete" class="delete" <%= "paid".equalsIgnoreCase(paymentStatus) ? "disabled" : "" %> >
    </form>
    
    <% if ("accepted".equalsIgnoreCase(contractStatus)) { %>
        <% if ("paid".equalsIgnoreCase(paymentStatus)) { %>
            <span class="status">Paid</span> <!-- Show "Paid" status -->
        <% } else { %>
            <form action="payment_form.jsp" method="post" style="display:inline;">
                <input type="hidden" name="contract_id" value="<%= rs.getInt("contract_id") %>">
                <input type="submit" value="Payment" class="approve">
            </form>
        <% } %>
    <% } %>
<% } %>

                    </td>
                </tr>
                <%
                }
                if (!hasResults) {
                %>
                <tr>
                    <td colspan="8">No contracts found for <%= username %>.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <div class="back">
            <a href="dashboard.jsp" class="backbtn">Back to Dashboard</a>
        </div>
    </div>
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
