<%@ page import="java.sql.*" %>
<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = db.DBConnection.getConnection();
        String query = "SELECT * FROM users";
        pst = con.prepareStatement(query);
        rs = pst.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen p-8">
    <div class="container mx-auto">
        <h1 class="text-4xl font-bold text-blue-600 mb-8">Users List</h1>
        <table class="table-auto w-full border-collapse border border-gray-300 shadow-md">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border border-gray-300 px-4 py-2 text-left">ID</th>
                    <th class="border border-gray-300 px-4 py-2 text-left">Username</th>
                    <th class="border border-gray-300 px-4 py-2 text-left">Email</th>
                    <th class="border border-gray-300 px-4 py-2 text-left">Role</th>
                    <th class="border border-gray-300 px-4 py-2 text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr class="hover:bg-gray-100">
                    <td class="border border-gray-300 px-4 py-2"><%= rs.getInt("id") %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= rs.getString("username") %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= rs.getString("email") %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= rs.getString("role") %></td>
                    <td class="border border-gray-300 px-4 py-2 text-center">
                        <form action="delete_user.jsp" method="post">
                            <input type="hidden" name="user_id" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="bg-red-500 text-white py-1 px-3 rounded hover:bg-red-600">
                                Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
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

<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>
