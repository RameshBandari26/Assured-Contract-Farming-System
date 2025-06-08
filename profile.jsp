<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String address = (String) session.getAttribute("address");
    String role = (String) session.getAttribute("role");
    String email = (String) session.getAttribute("email");

    if (username == null) username = "Unknown";
    if (role == null) role = "Buyer";
    if (email == null) email = "Not Provided";

    if (address == null || address.equals("Not Provided")) {
        try {
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = db.DBConnection.getConnection();
            String query = "SELECT address FROM users WHERE username = ?";
            stmt = con.prepareStatement(query);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                address = rs.getString("address");
                session.setAttribute("address", address);
            }

            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (Exception e) {
            address = "Error fetching address!";
        }
    }

    String message = "";
    boolean isEditing = "edit".equals(request.getParameter("action"));

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newUsername = request.getParameter("username");
        String newAddress = request.getParameter("address");

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = db.DBConnection.getConnection();

            String updateQuery = "UPDATE users SET username = ?, address = ? WHERE username = ?";
            stmt = con.prepareStatement(updateQuery);
            stmt.setString(1, newUsername);
            stmt.setString(2, newAddress);
            stmt.setString(3, username);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                session.setAttribute("username", newUsername);
                session.setAttribute("address", newAddress);
                username = newUsername;
                address = newAddress;
                message = "Profile updated successfully!";
            } else {
                message = "Failed to update profile.";
            }
        } catch (Exception e) {
            message = "Error updating profile: " + e.getMessage();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (con != null) try { con.close(); } catch (SQLException ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link rel="website icon" type="png" href="logo.png">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="font-sans text-white bg-gradient-to-r from-[#f4505b] via-[#bf6fe2] to-[#2bbde6] flex justify-center items-center h-screen m-0">

    <div class="flex flex-col md:flex-row overflow-hidden h-auto md:h-[60%] max-w-7xl w-full">

        <!-- Left Panel -->
        <div class="w-full max-w-[300px] md:max-w-[400px] mr-4 bg-gradient-to-r from-[#3a3a3a] to-[#040404] flex flex-col justify-center items-center p-5 text-white rounded-[15px]">

            <%
            String imagePath = "";
            if ("farmer".equalsIgnoreCase(role)) {
                imagePath = "farmer.jpg";
            } else if ("buyer".equalsIgnoreCase(role)) {
                imagePath = "buyer.jpg";
            }
            %>
            <img src="<%= imagePath %>" alt="Profile" class="w-[200px] h-[200px] md:w-[300px] md:h-[300px] rounded-full mb-2 border-[3px] border-white">
            <h1 class="text-[20px] mb-1"><%= username %></h1>
            <p class="text-[16px] m-0"><%= (role.equalsIgnoreCase("farmer")) ? "Farmer" : "Buyer" %></p>
        </div>

        <!-- Right Panel -->
        <div class="w-full max-w-4xl md:max-w-5xl bg-gradient-to-r from-[#040404] to-[#3a3a3a] p-5 rounded-[15px] flex flex-col justify-center">
            <h2 class="text-center text-[35px] border-b-2 border-[#555] pb-2 mb-5">Profile Details</h2>
            <div class="pl-5 md:pl-[200px]">
                <% if (!message.isEmpty()) { %>
                    <p class="text-green-400"><%= message %></p>
                <% } %>

                <% if (!isEditing) { %>
                    <p class="text-[24px] my-2 -ml-[10%]"><strong class="text-[#ff7f50]">Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= username %></p>
                    <p class="text-[24px] my-2 -ml-[10%]"><strong class="text-[#ff7f50]">Role &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= role %></p>
                    <p class="text-[24px] my-2 -ml-[10%]"><strong class="text-[#ff7f50]">Email &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= email %></p>
                    <p class="text-[24px] my-2 -ml-[10%]"><strong class="text-[#ff7f50]">Address &nbsp;&nbsp;:</strong> <%= address %></p>

                    <form action="profile.jsp" method="get">
                        <input type="hidden" name="action" value="edit">
                        <button type="submit" class="mt-2.5 -ml-[10%] w-[250px] p-2.5 border-none rounded-[10px] cursor-pointer bg-green-600 font-bold">Edit Profile</button>
                        <a href="dashboard.jsp" class="flex justify-center text-center mt-2.5 -ml-[10%] w-[250px] bg-[#bf6fe2] p-2.5 rounded-[10px] no-underline font-bold text-black">Dashboard</a>
                    </form>
                <% } else { %>
                    <form action="profile.jsp" method="post">
                        <p class="text-[24px] my-2 leading-[1.5]">
                            <strong class="text-[#ff7f50] -ml-[10%]">Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong>
                            <input type="text" id="username" name="username" value="<%= username %>" required class="p-2.5 border-none rounded-[10px] text-black">
                        </p>
                        <input type="hidden" name="role" value="<%= role %>">
                        <input type="hidden" name="email" value="<%= email %>">
                        <p class="text-[24px] my-2 leading-[1.5] -ml-[10%]"><strong class="text-[#ff7f50]">Role &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= role %></p>
                        <p class="text-[24px] my-2 leading-[1.5] -ml-[10%]"><strong class="text-[#ff7f50]">Email &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= email %></p>
                        <p class="text-[24px] my-2 leading-[1.5] -ml-[10%]">
                            <strong class="text-[#ff7f50]">Address &nbsp;&nbsp;:</strong>
                            <input type="text" id="address" name="address" value="<%= address %>" required class="p-2.5 border-none rounded-[10px] text-black">
                        </p>
                        <button type="submit" class="mt-2.5 -ml-[10%] w-[300px] p-2.5 border-none rounded-[10px] cursor-pointer bg-green-600 font-bold">Save Changes</button>
                        <a href="profile.jsp" class="flex justify-center text-center mt-2.5 -ml-[10%] w-[300px] bg-[#bf6fe2] p-2.5 rounded-[10px] no-underline font-bold text-black">Cancel</a>
                    </form>
                <% } %>
            </div>
        </div>
    </div>

</body>
</html>
