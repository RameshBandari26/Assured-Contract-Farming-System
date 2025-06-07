<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    int cropId = Integer.parseInt(request.getParameter("crop_id"));
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String cropName = "";
    int quantity = 0;
    double pricePerUnit = 0.0;
    String location = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = db.DBConnection.getConnection();

        String fetchQuery = "SELECT crop_name, quantity, price_per_unit, location FROM crops WHERE id = ?";
        pst = conn.prepareStatement(fetchQuery);
        pst.setInt(1, cropId);
        rs = pst.executeQuery();

        if (rs.next()) {
            cropName = rs.getString("crop_name");
            quantity = rs.getInt("quantity");
            pricePerUnit = rs.getDouble("price_per_unit");
            location = rs.getString("location");  // Fetch location
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pst != null) try { pst.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Crop</title>
    <link rel="website icon" type="png" href="logo.png">
    <link rel="stylesheet" href="dashboard.css">
    <style>

        p {
            font-size: larger;
            font-weight: bold;
        }
        label {
            margin-right: 10px;
        }
        .container {
            width: 800px;
            margin: auto;
            margin-top: 30px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .form-group {
            margin-bottom: 15px;
        }
        input[type="text"], input[type="number"] {
            padding: 10px;
            margin: 5px;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: blue;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: darkblue;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Update Crop</h1>
        <form action="update_crop_action.jsp" method="post">
            <input type="hidden" name="crop_id" value="<%= cropId %>">
            <p id="crop_name"><label for="crop_name">Crop Name:</label><%= cropName %></p>

            <div class="form-group">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" value="<%= quantity %>" required>
            </div>

            <div class="form-group">
                <label for="price_per_unit">Price per Unit:</label>
                <input type="text" id="price_per_unit" name="price_per_unit" value="<%= pricePerUnit %>" required>
            </div>

            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" value="<%= location %>">
            </div>

            <input type="submit" value="Update">
        </form>
    </div>
</body>
</html>
