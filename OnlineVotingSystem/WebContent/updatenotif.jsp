<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Notification Update</title>
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
            margin-left: 250px;
            padding: 20px;
        }
        .container {
            width: 50%;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        }
        h2 {
            text-align: center;
            color: #007bff;
        }
        input, button {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
        <a href="index.html" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
          <!--   <h2 class="m-0 text-primary"><i class="fa fa-book me-3"></i>Online Voting System</h2> -->
            <img src="img/logo.png" alt="Election Commission Logo" width="50" height="50" class="me-2">
    <h2 class="m-0 text-primary">Online Voting System</h2>
        </a>
        <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="index.html" class="nav-item nav-link active">Home</a>
                <a href="#ab" class="nav-item nav-link">About</a>
                <a href="Voterlog.html" class="nav-item nav-link">Voter</a>
              <!--  <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Login As</a>
                    <div class="dropdown-menu fade-down m-0">
                        <a href="adminlog.html" class="dropdown-item">Admin</a>
                        <a href="Voterlog.html" class="dropdown-item">Voter</a>
                        
                    </div>
                </div>  -->
                <a href="EClog.html" class="nav-item nav-link">ElectionCommission</a>
               
                <a href="contact.html" class="nav-item nav-link">Contact</a>
            </div>
           <!-- <a href="" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Register Now<i class="fa fa-arrow-right ms-3"></i></a>
-->      </div>
    </nav>
    <!-- Navbar End -->
    <!-- Sidebar Start -->
    <div class="sidebar">
    <a href="NewFile.html">DashBoard</a>
        <a href="Assembly.jsp">Assembly Constituencies</a>
        <a href="constituency.jsp">Parliament Constituencies</a>
        <a href="PartyReg.html">Party Registration</a>
        <a href="partyview.jsp">View All Parties</a>
        <a href="candidate.jsp">View Candidates List</a>
        <a href="voterreg.html">Add Voter</a>
        <a href="Display.jsp">View All Voters</a>
        <a href="updatenotif.jsp">Election Notification</a>
        <a href="ecd.jsp">View Request</a>
        <a href="announce_results.jsp">Announce Results</a>
        <a href="EClog.html">Logout</a>
    </div>
    <!-- Sidebar End -->

    <!-- Content Area -->
    <%
    String currentNotification = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

        PreparedStatement stmt = conn.prepareStatement("SELECT notification FROM enotif LIMIT 1");
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            currentNotification = rs.getString("notification");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
    <div class="content">
        <div class="container">
            <h2>Update Election Notification</h2>

            <form action="updatenotif.jsp" method="post">
                <label for="electionNotif">Election Notification:</label>
                <input type="text" id="electionNotif" name="electionNotif" required>
                <button type="submit">Update Notification</button>
            </form>
            <h3>Existing Notification:</h3>
    <p style="color: green; font-weight: bold;">
        <%= currentNotification.isEmpty() ? "No notification available." : currentNotification %>
    </p>

            <%
                // Database update logic (only runs when form is submitted)
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    String electionNotif = request.getParameter("electionNotif");
                    
                    if (electionNotif != null && !electionNotif.trim().isEmpty()) {
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

                            // Ensure at least one record exists before updating
                            PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM enotif");
                            ResultSet rs = checkStmt.executeQuery();
                            rs.next();
                            int count = rs.getInt(1);
                            rs.close();
                            checkStmt.close();

                            int result = 0;
                            if (count > 0) {
                                PreparedStatement pst = conn.prepareStatement("UPDATE enotif SET notification = ? ");
                                pst.setString(1, electionNotif);
                                result = pst.executeUpdate();
                                pst.close();
                            } else {
                                PreparedStatement pst = conn.prepareStatement("INSERT INTO enotif (notification) VALUES (?)");
                                pst.setString(1, electionNotif);
                                result = pst.executeUpdate();
                                pst.close();
                            }

                            conn.close();

                            if (result > 0) {
            %>
                                <p class="text-success">Notification Updated Successfully.</p>
                                <script>
                                    alert('Notification Updated Successfully');
                                    window.location.href = 'NewFile.html';
                                </script>
            <%
                            } else {
            %>
                                <p class="text-danger">Failed to Update Notification.</p>
            <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
            %>
                            <p class="text-danger">Database Error.</p>
            <%
                        }
                    } else {
            %>
                        <p class="text-danger">Please enter a valid notification.</p>
            <%
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
