<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int cropId = Integer.parseInt(request.getParameter("crop_id"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    double pricePerUnit = Double.parseDouble(request.getParameter("price_per_unit"));
    String location = request.getParameter("location"); // Get the location value
    String cropName = ""; // Define crop_name to retrieve it back.

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        // Fetch crop_name from the database (if needed)
        String fetchQuery = "SELECT crop_name FROM crops WHERE id = ?";
        pst = conn.prepareStatement(fetchQuery);
        pst.setInt(1, cropId);
        rs = pst.executeQuery();

        if (rs.next()) {
            cropName = rs.getString("crop_name");
        }

        // Update query to include location
        String updateQuery = "UPDATE crops SET quantity = ?, price_per_unit = ?, location = ? WHERE id = ?";
        pst = conn.prepareStatement(updateQuery);
        pst.setInt(1, quantity);
        pst.setDouble(2, pricePerUnit);
        pst.setString(3, location); // Set location in the update query
        pst.setInt(4, cropId);

        int rowsUpdated = pst.executeUpdate();
        if (rowsUpdated > 0) {
            response.sendRedirect("dashboard.jsp?message=Crop updated successfully");
        } else {
            out.println("Error: Could not update the crop.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
