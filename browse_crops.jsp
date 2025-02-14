<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Crops</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="browse_crops.css">
</head>
<body>
    <h2>Available Crops</h2>

    <!-- Search Bar -->
    <div class="search-bar">
        <form action="browse_crops.jsp" method="get">
            <input
                type="text"
                name="search"
                placeholder="Search by crop name or location..."
                class="search-input"
                value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
            >
            <button type="submit" class="search-button">Search</button>
        </form>
    </div>

    <%
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/contract_farming", "root", "Ramesh26@");

            // Get the search keyword
            String search = request.getParameter("search");

            // Modified query that checks both crop_name and location, and filters out accepted contracts
            String query = "SELECT c.* FROM crops c " +
                           "LEFT JOIN contracts ct ON c.id = ct.crop_id " +
                           "WHERE (c.status = 'available' OR c.status = 'under_contract') " +
                           "AND (c.crop_name LIKE ? OR c.location LIKE ?) " +
                           "AND (ct.contract_status IS NULL OR ct.contract_status != 'accepted')";
            
            pst = con.prepareStatement(query);

            // If the search field is not empty, use the same search term for both crop_name and location
            if (search != null && !search.trim().isEmpty()) {
                // Set the same search parameter for both crop_name and location
                pst.setString(1, "%" + search.trim() + "%");
                pst.setString(2, "%" + search.trim() + "%");
            } else {
                // If no search term, show all available crops
                pst.setString(1, "%");
                pst.setString(2, "%");
            }

            rs = pst.executeQuery();
    %>
            <div class="crop-list-container">
            <%
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
            %>
            <div class="containerBox">
                <!-- Display the image based on the crop name -->
    <%
    String cropName = rs.getString("crop_name");
    String imagePath = "";

    if ("paddy".equalsIgnoreCase(cropName)) {
        imagePath = "./images/paddy.jpg";
    } else if ("wheat(Godhumalu)".equalsIgnoreCase(cropName)) {
        imagePath = "./images/wheat.jpg";
    } else if("maize(Mokkajonna)".equalsIgnoreCase(cropName)){
        imagePath = "./images/maize.jpg";
    } else if("cotton".equalsIgnoreCase(cropName)){
        imagePath = "./images/cotton.avif";
    } else if("sugarcane".equalsIgnoreCase(cropName)){
        imagePath = "./images/sugarcane.jpg";
    } else if("potato".equalsIgnoreCase(cropName)){
        imagePath = "./images/potato.jpg";
    } else if("pigeon pea(Kandulu)".equalsIgnoreCase(cropName)){
        imagePath = "./images/pigeon-pea.jpg";
    } else if("chickpea(Shanagalu)".equalsIgnoreCase(cropName)){
        imagePath = "./images/chickpea.jpg";
    } else if("onion".equalsIgnoreCase(cropName)){
        imagePath = "./images/onion.jpg";
    } else if("red chilly".equalsIgnoreCase(cropName)){
        imagePath = "./images/chilli.jpg";
    } else if("mustard(Avalu)".equalsIgnoreCase(cropName)){
        imagePath = "./images/mustard.jpg";
    }

%>
<img src="<%= imagePath %>" alt="<%= cropName %>" style="width: 100%; height: auto;">
                <p><strong>Crop:</strong> <%= rs.getString("crop_name") %></p>
                <p><strong>Quantity:</strong> <%= rs.getDouble("quantity") %> metric tons</p>
                <p><strong>Price:</strong> $<%= rs.getDouble("price_per_unit") %> per metric ton</p>
                <p><strong>Location:</strong> <%= rs.getString("location") %></p>
                <form action="create_contract.jsp" method="post">
                    <input type="hidden" name="crop_id" value="<%= rs.getInt("id") %>">
                    <input type="submit" value="Initiate Contract" class="initiate_contract">
                </form>
            </div>
            <%
            }
            if (!hasResults) {
            %>
            <p>No crops found matching your search criteria.</p>
            <%
            }
            %>
            </div>
    <%
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            // Ensure database resources are closed
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
            }
        }
    %>
    
    <div class="backbutton">
        <a href="dashboard.jsp"><button>Back</button></a>
    </div>
</body>
</html>
