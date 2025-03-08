<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Voter ID</title>
        
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --primary: #06BBCC;
            --light: #F0FBFC;
            --dark: #181d38;
        }
        body {
            background: var(--light);
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            background: linear-gradient(to bottom, #4682B4, #1E90FF);
            backdrop-filter: blur(10px);
            padding-top: 20px;
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            color: white;
            display: block;
        }
        .sidebar a:hover {
            background: #495057;
        }
        .content {
            margin-left: 350px;
            padding: 50px;
        }
   /*     .state {
            cursor: pointer;
            font-weight: bold;
            margin-top: 20px;
        }
        .table-container {
            display: none;
            margin-top: 10px;
        }*/
         .states-container {
            width: 80%;
            max-width: 800px;
        }

        /* Flexbox for side-by-side buttons */
        .states-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .state {
            width: 200px;
            padding: 15px;
            border: 1px solid #000;
            cursor: pointer;
            background: #fff;
            text-align: center;
            font-weight: bold;
            transition: 0.3s;
        }

        .state:hover, .state.active {
            background-color: #007bff;
            color: white;
        }

        .table-container {
            display: none;
            margin-top: 10px;
            background: white;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
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
        
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
        <a href="index.html" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
            <img src="img/logo.png" alt="Election Commission Logo" width="50" height="50" class="me-2">
            <h2 class="m-0 text-primary">Online Voting System</h2>
            <div class="collapse navbar-collapse" id="navbarCollapse">
        <div class="navbar-nav ms-auto p-4 p-lg-0">
            <a href="index.html" class="nav-item nav-link active">Home</a>
        </a>
    </nav>
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
    <div class="content">
<div class="container mt-5">
        <h2 class="text-center">Voter Verification</h2>
        <form action="VerifyVoter" method="post">
            <div class="mb-3">
                <label for="voterId" class="form-label">Enter Your Voter ID:</label>
                <input type="text" class="form-control" id="voterId" name="voterId" required>
            </div>
            <button type="submit" class="btn btn-primary">Verify & Proceed</button>
        </form>

        <%-- Display error message if invalid voter ID --%>
        <% String error = request.getParameter("error"); 
           if (error != null) { %>
            <div class="alert alert-danger mt-3"><%= error %></div>
        <% } %>
    </div>
</body>
</html>
