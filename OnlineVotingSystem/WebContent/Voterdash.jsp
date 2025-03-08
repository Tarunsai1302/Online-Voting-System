<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif;
            background: #f4f7fc;
            margin: 0;
            padding: 0;
        }

        /* Navbar Styling */
        .navbar {
            background: #fff;
            padding: 10px 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            height: 100vh;
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            padding-top: 20px;
            transition: all 0.3s ease;
        }

        .sidebar h3 {
            text-align: center;
            padding-bottom: 10px;
            font-weight: bold;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
        }

        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: white;
            text-decoration: none;
            font-size: 16px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .sidebar a:hover, .sidebar a.active {
            background: rgba(255, 255, 255, 0.2);
            border-left: 3px solid #fff;
            transform: scale(1.05);
        }

        /* Main Content */
        .content {
            margin-left: 250px;
            padding: 40px;
            min-height: 100vh;
            background: url('web/images/vbg.jpeg') no-repeat center center;
            background-size: cover;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .content::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
        }

        .content-container {
            position: relative;
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            width: 60%;
            max-width: 800px;
        }

        .content h2 {
            font-size: 32px;
            font-weight: bold;
            color: #0056b3;
        }

        .content p {
            font-size: 18px;
            color: #333;
        }

        /* Dashboard Cards */
        .dashboard-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .dashboard-card {
            width: 220px;
            height: 160px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            color: #0056b3;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.3);
        }

        .dashboard-card i {
            font-size: 40px;
            color: #007bff;
            margin-bottom: 10px;
        }

        /* Mobile Sidebar */
        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }
            .content {
                margin-left: 200px;
            }
            .dashboard-card {
                width: 180px;
                height: 140px;
            }
        }
    </style>

    <!-- Font Awesome for Icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
    <a href="index.html" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
        <img src="img/logo.png" alt="Election Commission Logo" width="50" height="50" class="me-2">
        <h2 class="m-0 text-primary">Online Voting System</h2>
    </a>
</nav>

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

<!-- Main Content -->
<div class="content">
    <div class="content-container">
        <h2>Welcome to the Voter Dashboard</h2>
        <p>Navigate using the sidebar or select an option below.</p>

       <!-- <div class="dashboard-container">
            <a href="Profile.jsp" class="dashboard-card"><i class="fas fa-user"></i> Profile</a>
            <a href="voterassembly.jsp" class="dashboard-card"><i class="fas fa-landmark"></i> Assembly Voting</a>
            <a href="voterparliment.jsp" class="dashboard-card"><i class="fas fa-university"></i> Parliament Voting</a>
            <a href="results.jsp" class="dashboard-card"><i class="fas fa-chart-bar"></i> View Results</a>
            <a href="votervrify.jsp" class="dashboard-card"><i class="fas fa-vote-yea"></i> Cast Your Vote</a>
        </div>  -->
    </div>
</div>

</body>
</html>
