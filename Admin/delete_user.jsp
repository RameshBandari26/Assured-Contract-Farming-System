<%@ page import="java.sql.*" %>
<%
    int userId = Integer.parseInt(request.getParameter("user_id"));
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = db.DBConnection.getConnection();
        String query = "DELETE FROM users WHERE id = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setInt(1, userId);
        int result = pst.executeUpdate();
        if (result > 0) {
            out.println("User deleted successfully.");
        } else {
            out.println("Failed to delete user.");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<a href="manage_users.jsp">Back to Manage Users</a>
