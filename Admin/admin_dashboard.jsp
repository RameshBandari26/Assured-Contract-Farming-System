<%@ page import="javax.servlet.http.*" %>
<%
    // Directly use the session object provided by JSP
    String email = (String) session.getAttribute("admin_email");
    
    if (email == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white shadow-md rounded-lg p-8 w-full max-w-lg">
        <h1 class="text-3xl font-bold text-green-600 mb-6">Welcome, Admin</h1>
        <p class="text-gray-700 mb-4"><strong>Email:</strong> <%= email %></p>
        <div class="space-y-4">
            <a href="manage_users.jsp" class="block text-center bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600">
                Manage Users
            </a>
            <a href="manage_contracts.jsp" class="block text-center bg-green-500 text-white py-2 px-4 rounded hover:bg-green-600">
                Manage Contracts
            </a>
            <a href="logoutadmin.jsp" class="block text-center bg-red-500 text-white py-2 px-4 rounded hover:bg-red-600">
                Logout
            </a>
        </div>
    </div>
</body>
</html>

