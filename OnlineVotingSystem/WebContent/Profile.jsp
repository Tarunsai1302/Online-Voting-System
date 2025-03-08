<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f9fa; }
        .sidebar { width: 250px; height: 100vh; background: #007bff; color: white; position: fixed; left: 0; top: 0; padding-top: 20px; }
        .sidebar a { display: block; padding: 15px; color: white; text-decoration: none; }
        .sidebar a:hover { background: #0056b3; }
        .content { margin-left: 260px; padding: 20px; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h3>Voter Panel</h3>
    <a href="Voterdash.jsp" class="active">Dashboard</a>
    <a href="Profile.jsp">Profile</a>
    <a href="voterassembly.jsp">Assembly Constituencies</a>
    <a href="voterparliment.jsp">Parliament Constituencies</a>
    <a href="votervrify.jsp">Cast Vote</a>
    <a href="results.jsp">View Results</a>
    <a href="Voterlog.html">Logout</a>
</div>

<!-- Content Section -->
<div class="content">
    <div class="container mt-4">
        <h2 class="text-center" style="padding-bottom:50px;">Voter Profile</h2>

        <%
            HttpSession httpSession = request.getSession();
            Object voterIdObj = httpSession.getAttribute("voterId");

            if (voterIdObj == null) {
                out.println("<p class='text-danger text-center'>Error: User is not logged in!</p>");
                return;
            }

            String voterId = voterIdObj.toString();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

                PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter WHERE voterid=?");
                pst.setString(1, voterId);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    String voterImage = rs.getString("profile");

                    // If no image is found, use default.png
                    if (voterImage == null || voterImage.trim().isEmpty()) {
                        voterImage = "default.png";
                    }

                    // Store updated image path in session
                    String updatedImagePath = "uploads/" + voterImage;
                    httpSession.setAttribute("profilePic", voterImage);
        %>

        <div class="row align-items-center">
            <div class="col-md-4 text-center">
                <img src="<%= updatedImagePath %>?t=<%= System.currentTimeMillis() %>" class="img-thumbnail" width="300" height="300">
            </div>

            <div class="col-md-8">
                <table class="table table-bordered">
                    <tr><th>Name:</th><td><%= rs.getString("name") %></td></tr>
                    <tr><th>Father's Name:</th><td><%= rs.getString("fathername") %></td></tr>
                    <tr><th>Mother's Name:</th><td><%= rs.getString("mothername") %></td></tr>
                    <tr><th>Address:</th><td><%= rs.getString("address") %></td></tr>
                    <tr><th>State:</th><td><%= rs.getString("state") %></td></tr>
                    <tr><th>Assembly Constituency:</th><td><%= rs.getString("assemblyconstituency") %></td></tr>
                    <tr><th>Parliament Constituency:</th><td><%= rs.getString("parlimentconstituency") %></td></tr>
                    <tr><th>Gender:</th><td><%= rs.getString("gender") %></td></tr>
                    <tr><th>Mobile Number:</th><td><%= rs.getLong("mobile") %></td></tr>
                    <tr><th>Date of Birth:</th><td><%= rs.getString("dob") %></td></tr>
                    <tr><th>Voter ID:</th><td><%= rs.getString("voterid") %></td></tr>
                </table>

                <div class="mt-4">
                    <button class="btn btn-secondary" onclick="history.back()">Back</button>
                    <a href="updateprof.jsp?mobile=<%= rs.getString("mobile") %>" class="btn btn-primary">Update Profile</a>
                </div>
            </div>
        </div>

        <%
                } else {
                    out.println("<p class='text-danger text-center'>User not found!</p>");
                }

                rs.close();
                pst.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p class='text-danger text-center'>Something went wrong. Please try again later.</p>");
            }
        %>
    </div>
</div>

</body>
</html>
