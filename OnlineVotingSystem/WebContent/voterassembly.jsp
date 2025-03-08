<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .sidebar {
            width: 250px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: #007bff;
            color: white;
            padding-top: 20px;
        }
        .sidebar a {
            display: block;
            padding: 15px;
            color: white;
            text-decoration: none;
        }
        .sidebar a:hover {
            background: #0056b3;
        }
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        .states-container {
            width: 80%;
            max-width: 800px;
            margin: auto;
        }
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
            %>
            <div class="state" onclick="toggleTable(event, '<%= state %>')">
                <%= state.replace("AndhraPradesh", "Andhra Pradesh") %>
            </div>
            <% 
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
                        pst = conn.prepareStatement("SELECT * FROM assemblyconstituencies WHERE state=?");
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
                    %>
                </tbody>
            </table>
        </div>
        <% } 
                conn.close();
            } catch (Exception e) { 
                e.printStackTrace();
            } 
        %>
    </div>
</div>

<script>
let activeTable = null;

function toggleTable(event, stateId) {
    event.stopPropagation(); // Prevent event from bubbling up

    // Hide currently active table
    if (activeTable && activeTable.id !== stateId) {
        activeTable.style.display = "none";
        document.querySelectorAll(".state.active").forEach(el => el.classList.remove("active"));
    }

    // Show or hide the clicked state's table
    let table = document.getElementById(stateId);
    let stateElement = document.querySelector(`.state[onclick*='${stateId}']`);

    if (table.style.display === "block") {
        table.style.display = "none";
        stateElement?.classList.remove("active");
        activeTable = null;
    } else {
        table.style.display = "block";
        stateElement?.classList.add("active");
        activeTable = table;
    }
}

// Hide the table when clicking outside
document.addEventListener("click", function () {
    if (activeTable) {
        activeTable.style.display = "none";
        document.querySelectorAll(".state.active").forEach(el => el.classList.remove("active"));
        activeTable = null;
    }
});


</script>

</body>
</html>

