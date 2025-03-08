<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Commission Dashboard</title>
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
        </a>
    </nav>
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
    <div class="content">
    <div class="states-container">
    <div class="states-row">
        <% 
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            String[] states = {"AndhraPradesh", "Telangana"};

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

                for (String state : states) {
                    pst = conn.prepareStatement("SELECT * FROM assemblyconstituencies WHERE state=?");
                    pst.setString(1, state);
                    rs = pst.executeQuery();
        %>

        <div class="state" onclick="toggleTable(event, '<%= state %>')">
            <%= state.replace("AndhraPradesh", "Andhra Pradesh") %>
        </div>

        <% 
                rs.close();
                pst.close();
                } 
            } catch (Exception e) { 
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <% for (String state : states) { %>
        <div id="<%= state %>" class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Constituency Name</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
                        pst = conn.prepareStatement("SELECT * FROM parlimentaryconstituencies WHERE state=?");
                        pst.setString(1, state);
                        rs = pst.executeQuery();
                        int i = 1;
                        while(rs.next()) { 
                    %>
                        <tr>
                            <td><%= i %></td>
                            <td><%= rs.getString(1) %></td>
                        </tr>
                    <% 
                        i++; 
                        }
                        rs.close();
                        pst.close();
                        conn.close();
                    %>
                </tbody>
            </table>
        </div>
    <% } %>
</div></div>

    <script>
let activeTable = null;

function toggleTable(event, stateId) {
    event.stopPropagation(); // Prevent event from bubbling up

    // Hide currently active table
    if (activeTable && activeTable.id !== stateId) {
        activeTable.style.display = "none";
        document.querySelector(".state.active")?.classList.remove("active");
    }

    // Show or hide the clicked state's table
    let table = document.getElementById(stateId);
    if (table.style.display === "block") {
        table.style.display = "none";
        document.querySelector(`.state[onclick*='${stateId}']`).classList.remove("active");
        activeTable = null;
    } else {
        table.style.display = "block";
        document.querySelector(`.state[onclick*='${stateId}']`).classList.add("active");
        activeTable = table;
    }
}

// Hide the table when clicking outside
document.addEventListener("click", function () {
    if (activeTable) {
        activeTable.style.display = "none";
        document.querySelector(".state.active")?.classList.remove("active");
        activeTable = null;
    }
});
</script>

</body>
</html>
