<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter List</title>
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>
    <style>
    :root {
            --primary: #06BBCC;
            --light: #F0FBFC;
            --dark: #181d38;
        }
        body { 
        font-family: Arial, sans-serif; 
        background: linear-gradient(to right, #84fab0, #4FA3D1); 
        margin: 0; padding: 0; 
        }
        .container { 
        max-width: 95%; 
        margin: 30px auto; 
        padding: 20px; 
        background: white; 
        border-radius: 10px; 
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); 
        text-align: center; 
        overflow-x: auto; 
        }
        h2 { 
        color: #007bff; 
        text-align: center; 
        }
        table { 
        width: 100%; 
        border-collapse: collapse; 
        margin-top: 20px; 
        }
        th, td { 
        padding: 12px; 
        border: 1px solid #ddd; 
        text-align: center; 
        }
        th { 
        background-color: #007bff; 
        color: white; 
        }
        tr:nth-child(even) { 
        background-color: #f2f2f2; 
        }
        .thead {
        background-color: var(--primary);
        }
        img { 
        width: 150px; 
        height: 150px; 
        border-radius: 5px; 
        }
    </style>
</head>
<body>
    <div class='container'>
        <h2>Registered Voters</h2>
        <table class='table'>
            <thead class='thead'>
                <tr>
                    <th>Voter Name</th><th>Father Name</th><th>Mother Name</th><th>State</th><th>Address</th>
                    <th>Assembly Constituency</th><th>Parliament Constituency</th><th>Gender</th><th>Mobile</th>
                    <th>Date Of Birth</th><th>Aadhar</th><th>Profile Pic</th><th>Voter ID</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
                        PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter");
                        ResultSet rs = pst.executeQuery();
                        while (rs.next()) {
                            String imagePath = "uploads/" + rs.getString(12);  // Corrected image path
                %>
                <tr>
                    <td><%= rs.getString(1) %></td>
                    <td><%= rs.getString(2) %></td>
                    <td><%= rs.getString(3) %></td>
                    <td><%= rs.getString(4) %></td>
                    <td><%= rs.getString(5) %></td>
                    <td><%= rs.getString(6) %></td>
                    <td><%= rs.getString(7) %></td>
                    <td><%= rs.getString(8) %></td>
                    <td><%= rs.getLong(9) %></td>
                    <td><%= rs.getString(10) %></td>
                    <td><%= rs.getLong(11) %></td>
                    <td><img src='<%= request.getContextPath() + "/" + imagePath %>' class='img-thumbnail'></td>
                    <td><%= rs.getString(13) %></td>
                    <td>
                        <div class='btn-group'>
                            <button class='btn btn-danger' onclick="deleteVoter('<%= rs.getString(9) %>')">Delete</button>
                        </div>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        pst.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr><td colspan='13' class='alert alert-danger text-center'>Error fetching data. Please try again.</td></tr>
                <% } %>
            </tbody>
        </table>
        <div class='mt-4'>
            <button class='btn btn-secondary' onclick='history.back()'>Back</button>
        </div>
    </div>
<script>
function deleteVoter(mobile) {
    if (confirm("Are you sure you want to delete this voter?")) {
        window.location.href = "deletevoter?mobile=" + mobile;
    }
}
</script>
</body>
</html>
