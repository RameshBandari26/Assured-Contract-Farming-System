<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>List Crops</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="list_crop.css">
</head>
<body>
    <div class="container">
        <div class="sub-container">
            <h2 class="heading">List Your Crop for Contract</h2>
            <form action="list_crops.jsp" method="post">
                <label>Crop Name :</label>
                <select class="form" name="crop_name" required>
                    <option value="" disabled selected>Select Crop</option>
                    <option value="Chickpea(Shanagalu)">Chickpea(Shanagalu)</option>
                    <option value="Cotton">Cotton</option>
                    <option value="Maize(Mokkajonna)">Maize(Mokkajonna)</option>
                    <option value="Mustard(Avalu)">Mustard(Avalu)</option>
                    <option value="Onion">Onion</option>
                    <option value="Paddy">Paddy</option>
                    <option value="Pigeon Pea(Kandulu)">Pigeon Pea(Kandulu)</option>
                    <option value="Potato">Potato</option>
                    <option value="Red Chilly">Red Chilly</option>
                    <option value="Sugarcane">Sugarcane</option>
                    <option value="Wheat(Godhumalu)">Wheat(Godhumalu)</option>
                    
                </select><br>
                
                <label>Quantity &nbsp;&nbsp;&nbsp;&nbsp;: </label>
                <input class="form" placeholder="Enter in metric ton" type="number" name="quantity" min="0" required><br>
                
                <label>Price &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: </label>
                <input class="form" placeholder="Enter per metric ton" type="number" step="0.01" name="price_per_unit" min="0" required><br>
                
                <label>Location &nbsp;&nbsp;&nbsp;: </label>
                <input class="form" placeholder="Enter location" type="text" name="location" required><br>

                <input class="btn1" type="submit" value="List Crop">
            </form>
            <a href="dashboard.jsp"><button class="btn2">Back</button></a>
        </div>
    </div>

    <% 
        String crop_name = request.getParameter("crop_name");
        String quantity = request.getParameter("quantity");
        String price_per_unit = request.getParameter("price_per_unit");
        String location = request.getParameter("location");
        String farmer = (String) session.getAttribute("username");

        if (crop_name != null && quantity != null && price_per_unit != null && location != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = db.DBConnection.getConnection();

                String query = "INSERT INTO crops (farmer_id, crop_name, quantity, price_per_unit, location) VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, farmer);
                pst.setString(2, crop_name);
                pst.setString(3, quantity);
                pst.setString(4, price_per_unit);
                pst.setString(5, location); // Insert location into the database

                int result = pst.executeUpdate();
                if (result > 0) {
                    %>
                    <script>
                        alert("Crop listed successfully!");
                        window.location.href = "dashboard.jsp";
                    </script>
    <%
                } else {
                    %>
                    <script>
                        alert("Failed to list crop. Please try again.");
                    </script>
    <%
                }

                con.close();
            } catch(Exception e) {
                out.println(e);
            }
        }
    %>
</body>
</html>
