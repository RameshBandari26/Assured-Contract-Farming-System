<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @keyframes fadeIn {
            0% {
                opacity: 0;
                transform: translateY(-20px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in {
            animation: fadeIn 1s ease-out;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen bg-gradient-to-br from-green-400 to-blue-500">

    <div class="bg-white shadow-lg rounded-lg p-8 w-full max-w-md fade-in">
        <h1 class="text-2xl font-bold text-center text-green-600 mb-4">Admin Login</h1>
        <form action="admin_login.jsp" method="post" class="space-y-6">
            <div class="space-y-2">
                <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="Enter your email" 
                    required 
                    class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-400 focus:outline-none"
                >
            </div>
            <div class="space-y-2">
                <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Enter your password" 
                    required 
                    class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-400 focus:outline-none"
                >
            </div>
            <button 
                type="submit" 
                class="w-full py-3 text-white bg-green-500 hover:bg-green-600 rounded-lg font-medium transition-transform transform hover:scale-105"
            >
                Login
            </button>
        </form>
        <div class="text-center mt-4">
            <a href="../index.html" class="text-green-500 hover:underline font-bold">Back to Home</a>

        </div>
    </div>


    <%
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email != null && password != null) {
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

                String query = "SELECT * FROM admin WHERE email = ? AND password = ?";
                pst = conn.prepareStatement(query);
                pst.setString(1, email);
                pst.setString(2, password);
                
                rs = pst.executeQuery();
                
                if (rs.next()) {
                    session.setAttribute("admin_email", email);
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    out.println("<script>alert('Invalid credentials. Please try again.');</script>");
                }
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        }
    %>
</body>
</html>
