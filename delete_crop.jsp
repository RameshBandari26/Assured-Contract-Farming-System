<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve crop ID from the request
    String cropIdStr = request.getParameter("crop_id");

    if (cropIdStr != null && !cropIdStr.isEmpty()) {
        int cropId = Integer.parseInt(cropIdStr);

        Connection conn = null;
        PreparedStatement checkContractStmt = null;
        PreparedStatement deleteContractsStmt = null;
        PreparedStatement deleteCropStmt = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = db.DBConnection.getConnection();

            // Check if the crop is under contract
            String checkContractQuery = "SELECT COUNT(*) AS contract_count FROM contracts WHERE crop_id = ?";
            checkContractStmt = conn.prepareStatement(checkContractQuery);
            checkContractStmt.setInt(1, cropId);
            rs = checkContractStmt.executeQuery();

            int contractCount = 0;
            if (rs.next()) {
                contractCount = rs.getInt("contract_count");
            }

            if (contractCount > 0) {
                // If crop is under contract, ask for confirmation
                String confirmDelete = request.getParameter("confirm_delete");
                if (!"yes".equals(confirmDelete)) { %>
                    <script>
                    if (confirm('This crop is under contract. Are you sure you want to delete it?')) {
                        window.location.href = 'delete_crop.jsp?crop_id=<%= cropId %>&confirm_delete=yes';
                    } else {
                        window.location.href = 'dashboard.jsp';
                    }
                    </script>
                    <%
                    return;
                }
            }

            // Delete any associated contracts
            String deleteContractsQuery = "DELETE FROM contracts WHERE crop_id = ?";
            deleteContractsStmt = conn.prepareStatement(deleteContractsQuery);
            deleteContractsStmt.setInt(1, cropId);
            deleteContractsStmt.executeUpdate();

            // Delete the crop from the database
            String deleteCropQuery = "DELETE FROM crops WHERE id = ?";
            deleteCropStmt = conn.prepareStatement(deleteCropQuery);
            deleteCropStmt.setInt(1, cropId);
            int rowsAffected = deleteCropStmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<script>alert('Crop and associated contracts deleted successfully!'); window.location.href='dashboard.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to delete crop. Please try again.'); window.location.href='dashboard.jsp';</script>");
            }

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href='dashboard.jsp';</script>");
        }
    } else {
        out.println("<script>alert('Invalid crop ID provided.'); window.location.href='dashboard.jsp';</script>");
    }
%>
