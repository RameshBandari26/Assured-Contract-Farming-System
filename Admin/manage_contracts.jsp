<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    if (session == null || session.getAttribute("admin_email") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Contracts</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen p-8">
    <div class="container mx-auto">
        <h1 class="text-4xl font-bold text-blue-600 mb-6">Manage Contracts</h1>
        <table class="table-auto w-full border-collapse border border-gray-300 shadow-lg">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border border-gray-300 px-4 py-2">Contract ID</th>
                    <th class="border border-gray-300 px-4 py-2">Farmer</th>
                    <th class="border border-gray-300 px-4 py-2">Buyer</th>
                    <th class="border border-gray-300 px-4 py-2">Crop</th>
                    <th class="border border-gray-300 px-4 py-2">Quantity</th>
                    <th class="border border-gray-300 px-4 py-2">Price</th>
                    <th class="border border-gray-300 px-4 py-2">Status</th>
                    <th class="border border-gray-300 px-4 py-2">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pst = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = db.DBConnection.getConnection();

                        String query = "SELECT c.id AS contract_id, f.username AS farmer, b.username AS buyer, cr.crop_name, " +
                                       "cr.quantity, cr.price_per_unit AS price, c.contract_status " +
                                       "FROM contracts c " +
                                       "JOIN crops cr ON c.crop_id = cr.id " +
                                       "JOIN users f ON cr.farmer_id = f.id " +
                                       "JOIN users b ON c.buyer_id = b.id";

                        pst = conn.prepareStatement(query);
                        rs = pst.executeQuery();

                        while (rs.next()) {
                            int contractId = rs.getInt("contract_id");
                            String farmer = rs.getString("farmer");
                            String buyer = rs.getString("buyer");
                            String cropName = rs.getString("crop_name");
                            double quantity = rs.getDouble("quantity");
                            double price = rs.getDouble("price");
                            String status = rs.getString("contract_status");
                %>
                <tr class="hover:bg-gray-100">
                    <td class="border border-gray-300 px-4 py-2"><%= contractId %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= farmer %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= buyer %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= cropName %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= quantity %></td>
                    <td class="border border-gray-300 px-4 py-2">₹<%= price %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= status %></td>
                    <td class="border border-gray-300 px-4 py-2 text-center">
                        <a href="update_contract.jsp?contract_id=<%= contractId %>" 
                           class="inline-block bg-green-500 text-white py-1 px-3 rounded hover:bg-green-600 transition-all">
                           Update
                        </a>
                        <a href="delete_contract.jsp?contract_id=<%= contractId %>" 
                           class="inline-block bg-red-500 text-white py-1 px-3 rounded hover:bg-red-600 transition-all"
                           onclick="return confirm('Are you sure you want to delete this contract?');">
                           Delete
                        </a>
                    </td>
                    
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p class='text-red-500'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pst != null) pst.close();
                            if (conn != null) conn.close();
                        } catch (SQLException ex) {
                            out.println("<p class='text-red-500'>Error closing resources: " + ex.getMessage() + "</p>");
                        }
                    }
                %>
            </tbody>
        </table>
        <div class="mt-6">
            <a href="admin_dashboard.jsp" class="bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600">
                Back to Dashboard
            </a>
        </div>
    </div>
</body>
</html>
