<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    // Check if the user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if the user is not logged in
        return;
    }

    // Get user details from the session
    String username = (String) session.getAttribute("username");
    String address = (String) session.getAttribute("address");
    String role = (String) session.getAttribute("role");  
    String email = (String) session.getAttribute("email");

    // Ensure variables are not null
    if (username == null) username = "Unknown";
    if (role == null) role = "Buyer"; // Default role
    if (email == null) email = "Not Provided";
    if (address == null || address.equals("Not Provided")) {
        try {
            // Fetch the address from the database if not available in the session
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
                session.setAttribute("address", address); // Update the session with the fetched address
            }

            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (Exception e) {
            address = "Error fetching address!";
        }
    }

    // Feedback message
    String message = "";

    // Flag for edit mode
    boolean isEditing = "edit".equals(request.getParameter("action"));

    // Handle form submission (update user details)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newUsername = request.getParameter("username");
        String newAddress = request.getParameter("address");

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = db.DBConnection.getConnection();

            // Update only username and address in the database
            String updateQuery = "UPDATE users SET username = ?, address = ? WHERE username = ?";
            stmt = con.prepareStatement(updateQuery);
            stmt.setString(1, newUsername);
            stmt.setString(2, newAddress);
            stmt.setString(3, username);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                // Update session variables
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="profile.css">
</head>
<body>
    <div class="profile-container">
        <div class="left-panel">
            <%
            String imagePath = "";
            if ("farmer".equalsIgnoreCase(role)) {
                imagePath = "farmer.jpg";
            } else if ("buyer".equalsIgnoreCase(role)) {
                imagePath = "buyer.jpg";
            }
            %>
            <img src="<%= imagePath %>" alt="Profile">
            <h1><%= username %></h1>
            <p><%= (role.equalsIgnoreCase("farmer")) ? "Farmer" : "Buyer" %></p>
        </div>

        <div class="right-panel">
            <h2>Profile Details</h2><div class="container">
            <% if (!message.isEmpty()) { %>
                <p style="color: green;"><%= message %></p>
            <% } %>

            <!-- Toggle between view and edit mode -->
            <% if (!isEditing) { %>
                <!-- View mode -->
                <p class="details"><strong>Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong> <%= username %></p>
                <p class="details"><strong>Role &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong> <%= role %></p>
                <p class="details"><strong>Email &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </strong> <%= email %></p>
                <p class="details"><strong>Address &nbsp;&nbsp;: </strong> <%= address %></p>
                <form action="profile.jsp" method="get">
                    <input type="hidden" name="action" value="edit">
                    <button type="submit" class="edit-button">Edit Profile</button>
                    <a href="dashboard.jsp" class="cancel-button">Dashboard</a>
                </form>
            <% } else { %>
                <!-- Edit mode -->
                <form action="profile.jsp" method="post">
                    <p class="details"><strong>Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong>
                    <input type="text" id="username" name="username" value="<%= username %>" required></p>
                    <input type="hidden" name="role" value="<%= role %>">
                    <input type="hidden" name="email" value="<%= email %>">
                    <p class="details"><strong>Role &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= role %></p>
                    <p class="details"><strong>Email &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong> <%= email %></p>
                    <p class="details"><strong>Address &nbsp;&nbsp;:</strong>
                    <input type="text" id="address" name="address" value="<%= address %>" required></p>
                    <button type="submit" class="save-button">Save Changes</button>
                    <a href="profile.jsp" class="cancel-button">Cancel</a>
                </form>
            <% } %>
        </div></div>
    </div>
</body>
</html>
