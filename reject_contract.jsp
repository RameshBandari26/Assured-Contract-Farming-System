<%@ page import="java.sql.*" %>
<%
    String contractId = request.getParameter("contract_id");

    Connection conn = null;
    PreparedStatement pst = null;
    PreparedStatement updatePst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        // Retrieve the crop ID associated with the contract
        String fetchCropIdQuery = "SELECT crop_id FROM contracts WHERE id = ?";
        pst = conn.prepareStatement(fetchCropIdQuery);
        pst.setInt(1, Integer.parseInt(contractId));
        rs = pst.executeQuery();

        int cropId = 0;
        if (rs.next()) {
            cropId = rs.getInt("crop_id");
        }

        // Update the contract status to 'Rejected'
        String rejectContractQuery = "UPDATE contracts SET contract_status = 'Rejected' WHERE id = ?";
        pst = conn.prepareStatement(rejectContractQuery);
        pst.setInt(1, Integer.parseInt(contractId));
        int rowsAffected = pst.executeUpdate();

        // Update the crop status to 'Available'
        String updateCropStatusQuery = "UPDATE crops SET status = 'Available' WHERE id = ?";
        updatePst = conn.prepareStatement(updateCropStatusQuery);
        updatePst.setInt(1, cropId);
        int updateResult = updatePst.executeUpdate();

        if (rowsAffected > 0 && updateResult > 0) {
            response.sendRedirect("view_contracts.jsp?message=Contract rejected successfully!");
        } else {
            response.sendRedirect("view_contracts.jsp?message=Failed to reject contract!");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (updatePst != null) try { updatePst.close(); } catch (SQLException ignored) {}
        if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
