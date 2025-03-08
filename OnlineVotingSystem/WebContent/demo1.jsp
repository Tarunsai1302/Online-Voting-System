<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>List of Candidates</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .header {
            background: linear-gradient(to right, #d62b7e, #fa709a);
            color: white;
            padding: 15px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }
        .candidate-card {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .candidate-img {
            width: 200px;  /* Optimized size */
            height: 200px;
            border-radius: 5px;
            object-fit: cover; /* Maintains aspect ratio */
            margin-right: 20px;
        }
        .candidate-info {
            flex-grow: 1;
        }
        .candidate-header {
            padding: 10px;
            font-weight: bold;
            color: white;
            border-radius: 10px 10px 0 0;
        }
        .blue { background-color: #2196F3; }
        .green { background-color: #4CAF50; }
        .pink-button {
            background-color: #f06292;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-3 w-100">
        <div class="container">
            <a href="index.html" class="navbar-brand d-flex align-items-center">
                <img src="img/logo.png" alt="Election Commission Logo" width="50" height="50" class="me-2">
                <h2 class="m-0 text-primary">Online Voting System</h2>
            </a>
            <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a href="index.html" class="nav-link active">Home</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
<div class="header">List of Candidates</div>

<div class="container mt-4">
    <%
        Connection conn = null;
        try {
            // Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Query to fetch candidates
            String sql = "SELECT * FROM candidates";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            int count = 0; // To alternate colors

            while (rs.next()) {
            	String pos=rs.getString("position");
                String name = rs.getString("candidate_name");
                String party = rs.getString("party");
                String state = rs.getString("state");
                String constituency = rs.getString("constituency");
                String status = rs.getString("status");
                String imageName = rs.getString("candidate_picture");

                // Ensure valid image path
                String imagePath = (imageName != null && !imageName.isEmpty()) ? "uploads/" + imageName : "images/default.png";

                // Alternate card colors
                String colorClass = (count % 2 == 0) ? "blue" : "green";
                count++;
    %>

    <!-- Candidate Card -->
    <div class="candidate-card">
        <img src="<%= request.getContextPath() + "/" + imagePath %>" 
             class="img-thumbnail candidate-img" 
             alt="Candidate Image" 
             loading="lazy"
             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/default.png';">
        <div class="candidate-info">
            <div class="candidate-header <%= colorClass %> p-2">
                <h5 class="mb-0 text-white"><%= name %></h5>
            </div>
            <p><strong>Party: </strong> <%= party %></p>
            <p><strong>Position: </strong><%= pos %></p>
            <p><strong>State: </strong> <%= state %></p>
            <p><strong>Constituency: </strong> <%= constituency %></p>
            <p><strong>Status: </strong> <span class="text-success"><%= status %></span></p>
        </div>
        <div class='mt-4'>
            <button class='btn btn-secondary' onclick='history.back()'>Back</button>
        </div>
      <!--  <button class="pink-button">View More</button> -->
    </div>

    <%
            }
            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class='text-danger'>Error loading candidates.</p>");
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>

</body>
</html>
