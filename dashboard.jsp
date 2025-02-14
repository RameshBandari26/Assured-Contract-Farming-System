<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // Check if session exists and user is logged in
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if the user is not logged in
        return; // Ensure no further code runs after the redirect
    }

    // Fetch username and role from the session
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Declare and initialize the database connection
    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");
    } catch (Exception e) {
        out.println("Error establishing database connection: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <header>
        <h1><img src="logo.png" width="5%" height="5%" class="logo"> Welcome, <%= username %>!</h1>
        <nav>
            <a href="profile.jsp">Profile</a>
            <a href="view_contracts.jsp">View Contracts</a>
            <% if ("farmer".equals(role)) { %>
            <a href="add_payment_details.jsp">Add Payment</a>
            <% } %>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>
    <main>
        <h2>Dashboard</h2>
        
        <% if ("farmer".equals(role)) { %>
            <!-- Farmer's Dashboard -->
            <a href="list_crops.jsp" class="listCrop">List New Crop</a>
            <h3>Your Listed Crops</h3>
            <p>Here you can view the crops you have listed and manage your contracts.</p>
            
            <ul>
                <%
                    if (con != null) {
                        // Fetch the crops listed by the farmer, including the location
                        String cropQuery = "SELECT id, crop_name, quantity, price_per_unit, status, location FROM crops WHERE farmer_id = (SELECT id FROM users WHERE username = ?)";
                        PreparedStatement cropStmt = con.prepareStatement(cropQuery);
                        cropStmt.setString(1, username);
                        ResultSet rs = cropStmt.executeQuery();
                        %>
                        <div class="crop-list-container">
                        <%
                        while (rs.next()) {
                            int cropId = rs.getInt("id");
                            String cropName = rs.getString("crop_name");
                            double quantity = rs.getDouble("quantity");
                            double price = rs.getDouble("price_per_unit");
                            String status = rs.getString("status");
                            String location = rs.getString("location");

                            String imagePath = "";
                            
                            // Assign appropriate image based on crop name
                            if ("paddy".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/paddy.jpg";
                            } else if ("wheat(Godhumalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/wheat.jpg";
                            } else if ("maize(Mokkajonna)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/maize.jpg";
                            } else if ("cotton".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/cotton.avif";
                            } else if ("sugarcane".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/sugarcane.jpg";
                            } else if ("potato".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/potato.jpg";
                            } else if ("pigeon pea(Kandulu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/pigeon-pea.jpg";
                            } else if ("chickpea(Shanagalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/chickpea.jpg";
                            } else if ("onion".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/onion.jpg";
                            } else if ("red chilly".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/chilli.jpg";
                            } else if ("mustard(Avalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/mustard.jpg";
                            } else {
                                imagePath = "./images/default.jpg";
                            }

                            String imageStyle = "sold".equalsIgnoreCase(status) ? "filter: grayscale(100%);" : "";
                %>
                <div class="containerBox">

                    <img src="<%= imagePath %>" alt="<%= cropName %>" style="width: 100%; height: auto; <%= imageStyle %>"/>

                    <strong>Crop Name:</strong> <%= cropName %> <br>
                    <strong>Quantity:</strong> <%= quantity %> metric tons<br>
                    <strong>Price per Ton:</strong> $<%= price %> <br>
                    <strong>Status:</strong> <%= status %> <br>
                    <strong>Location:</strong> <%= location %> <br>
                    <div class="buttons">
                        <form action="update_crop.jsp" method="post">
                            <input type="hidden" name="crop_id" value="<%= cropId %>">
                            <input type="submit" value="Update Crop" class="update">
                        </form>
                        <form action="delete_crop.jsp" method="post">
                            <input type="hidden" name="crop_id" value="<%= cropId %>">
                            <input type="submit" value="Delete Crop" class="delete">
                        </form>
                    </div>
                </div>
                <% 
                        } %></div>
                        <%
                    } 
                %>
            </ul>
            <br><br>
            
        <% } else if ("buyer".equals(role)) { %>
            <!-- Buyer's Dashboard -->
            <a href="browse_crops.jsp" class="listCrop">Browse Crop</a>
            <h3>Your Purchased Crops</h3>
            <p>Below are the crops you have purchased:</p>
            <ul>
                <%
                    if (con != null) {
                        // Fetch the crops purchased by the buyer
                        String purchasedCropsQuery = "SELECT crops.id, crops.crop_name, crops.quantity, crops.price_per_unit, crops.status, crops.location " +
                                                     "FROM crops " +
                                                     "INNER JOIN contracts ON crops.id = contracts.crop_id " +
                                                     "WHERE contracts.buyer_id = (SELECT id FROM users WHERE username = ?)";
                        PreparedStatement purchasedStmt = con.prepareStatement(purchasedCropsQuery);
                        purchasedStmt.setString(1, username);
                        ResultSet purchasedRs = purchasedStmt.executeQuery();
                    %>
                    <div class="crop-list-container">
                    <%
                        while (purchasedRs.next()) {
                            int cropId = purchasedRs.getInt("id");
                            String cropName = purchasedRs.getString("crop_name");
                            double quantity = purchasedRs.getDouble("quantity");
                            double price = purchasedRs.getDouble("price_per_unit");
                            String status = purchasedRs.getString("status");
                            String location = purchasedRs.getString("location");

                            String imagePath = "";
                            
                            // Assign appropriate image based on crop name
                            if ("paddy".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/paddy.jpg";
                            } else if ("wheat(Godhumalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/wheat.jpg";
                            } else if ("maize(Mokkajonna)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/maize.jpg";
                            } else if ("cotton".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/cotton.avif";
                            } else if ("sugarcane".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/sugarcane.jpg";
                            } else if ("potato".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/potato.jpg";
                            } else if ("pigeon pea(Kandulu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/pigeon-pea.jpg";
                            } else if ("chickpea(Shanagalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/chickpea.jpg";
                            } else if ("onion".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/onion.jpg";
                            } else if ("red chilly".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/chilli.jpg";
                            } else if ("mustard(Avalu)".equalsIgnoreCase(cropName)) {
                                imagePath = "./images/mustard.jpg";
                            } else {
                                imagePath = "./images/default.jpg";
                            }
                %>
                <div class="containerBox">
                    <img src="<%= imagePath %>" alt="<%= cropName %>" style="width: 100%; height: auto;">
                    <strong>Crop Name:</strong> <%= cropName %> <br>
                    <strong>Quantity:</strong> <%= quantity %> metric tons<br>
                    <strong>Price per Ton:</strong> $<%= price %> <br>
                    <strong>Status:</strong> <%= status %> <br>
                    <strong>Location:</strong> <%= location %> <br>
                </div>
                <%
                        } %></div>
                        <%
                    } 
                %>
            </ul>
        <% } %>
    </main>
</body>
</html>
