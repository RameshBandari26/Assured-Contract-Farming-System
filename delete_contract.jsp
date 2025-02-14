<%@ page import="java.sql.*" %>

<%
    String contractId = request.getParameter("contract_id");

    if (contractId != null) {
        Connection conn = null;
        PreparedStatement pst = null;
        PreparedStatement updatePst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

            // Retrieve crop_id associated with the contract
            String fetchCropIdQuery = "SELECT crop_id FROM contracts WHERE id = ?";
            pst = conn.prepareStatement(fetchCropIdQuery);
            pst.setInt(1, Integer.parseInt(contractId));
            rs = pst.executeQuery();

            int cropId = -1;
            if (rs.next()) {
                cropId = rs.getInt("crop_id");
            }

            if (cropId != -1) {
                // Delete the contract
                String deleteQuery = "DELETE FROM contracts WHERE id = ?";
                pst = conn.prepareStatement(deleteQuery);
                pst.setInt(1, Integer.parseInt(contractId));
                int rowsAffected = pst.executeUpdate();

                // Update crop status
                String updateCropStatusQuery = "UPDATE crops SET status = 'available' WHERE id = ?";
                updatePst = conn.prepareStatement(updateCropStatusQuery);
                updatePst.setInt(1, cropId);
                int updateResult = updatePst.executeUpdate();

                if (rowsAffected > 0 && updateResult > 0) {
                    out.println("<script>alert('Contract deleted successfully and crop status updated!'); window.location.href='view_contracts.jsp';</script>");
                } else {
                    out.println("<script>alert('Failed to delete contract or update crop status.'); window.location.href='view_contracts.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Failed to retrieve crop information.'); window.location.href='view_contracts.jsp';</script>");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("<script>alert('No contract ID provided.'); window.location.href='view_contracts.jsp';</script>");
    }
%>
