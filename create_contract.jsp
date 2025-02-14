<%@ page import="java.sql.*" %>
<%
    // Check if the crop_id parameter is present
    String cropIdParam = request.getParameter("crop_id");
    if (cropIdParam == null || cropIdParam.isEmpty()) {
        out.println("Error: crop_id parameter is missing.");
        return;
    }

    int crop_id;
    try {
        crop_id = Integer.parseInt(cropIdParam);
    } catch (NumberFormatException e) {
        out.println("Error: Invalid crop_id format.");
        return;
    }

    String buyer = (String) session.getAttribute("username");
    if (buyer == null) {
        out.println("Error: User not logged in.");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Update to use the correct driver class
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

        String query = "INSERT INTO contracts (crop_id, buyer_id) VALUES (?, (SELECT id FROM users WHERE username = ?))";
        
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, crop_id);
        pst.setString(2, buyer);

        int result = pst.executeUpdate();
        if (result > 0) {

            String updateCropStatusQuery = "UPDATE crops SET status = 'under_contract' WHERE id = ?";
            PreparedStatement updatePst = con.prepareStatement(updateCropStatusQuery);
            updatePst.setInt(1, crop_id);

            int updateResult = updatePst.executeUpdate();
            if (updateResult > 0) {%> <script>
                alert("Contract initiated successfully! Waiting for farmer's approval."); 
                window.location.href='browse_crops.jsp';</script><%
            }
            
        } else {
            out.println("Failed to initiate contract.");
        }

        con.close();
    } catch(Exception e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    }
%>
