<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Check if user is logged in as an EC official
    HttpSession sessionEC = request.getSession(false);
    if (sessionEC == null || sessionEC.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login page if not logged in
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EC Dashboard - Approve Voter Updates</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <style>
        :root {
            --primary: #007bff;
            --light: #f8f9fa;
            --dark: #343a40;
            --success: #28a745;
            --danger: #dc3545;
        }

        body {
            background: linear-gradient(135deg, #e3f2fd, #b2ebf2);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            padding-bottom: 50px;
        }

        .container {
            max-width: 1200px;
            margin-top: 30px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
        }

        h2 {
            text-align: center;
            color: var(--dark);
            font-weight: bold;
            text-transform: uppercase;
        }

        table {
            background: var(--light);
        }

        th {
            background: var(--primary);
            color: white;
            text-align: center;
        }

        td {
            text-align: center;
            vertical-align: middle;
        }

        .btn-approve {
            background: var(--success);
            color: white;
            font-weight: bold;
        }

        .btn-reject {
            background: var(--danger);
            color: white;
            font-weight: bold;
        }

        .btn-approve:hover {
            background: #218838;
        }

        .btn-reject:hover {
            background: #c82333;
        }

        .badge-warning {
            background: #ffc107;
            color: black;
        }

        .profile-img {
            border-radius: 5px;
            border: 2px solid var(--dark);
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Voter Profile Update Request</h2>
        <hr>

        <div class="table-responsive">
    <table class="table table-striped table-hover table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Voter ID</th>
                <th>Name</th>
                <th>Father's Name</th>
                <th>Mother's Name</th>
                <th>Address</th>
                <th>State</th>
                <th>Parliament Constituency</th>
                <th>Assembly Constituency</th>
                <th>Gender</th>
                <th>Mobile</th>
                <th>Date of Birth</th>
                <th>Profile Picture</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet","root","manager");
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM pending_updates WHERE status='pending'")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("voterid") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("fathername") %></td>
                        <td><%= rs.getString("mothername") %></td>
                        <td class="text-truncate" style="max-width: 150px;"><%= rs.getString("address") %></td>
                        <td><%= rs.getString("state") %></td>
                        <td><%= rs.getString("parlimentconstituency") %></td>
                        <td><%= rs.getString("assemblyconstituency") %></td>
                        <td><%= rs.getString("gender") %></td>
                        <td><%= rs.getString("mobile") %></td>
                        <td><%= rs.getString("dob") %></td>
                        <td>
                            <% if (rs.getString("profile") != null) { %>
                                <img src="uploads/<%= rs.getString("profile") %>" alt="Profile" width="50" class="profile-img">
                            <% } else { %>
                                No Image
                            <% } %>
                        </td>
                        <td><span class="badge badge-warning">Pending</span></td>
                        <td>
                            <form method="post" action="ApproveUpdate">
                                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                <button type="submit" name="action" value="approve" class="btn btn-sm btn-approve">Approve</button>
                                <button type="submit" name="action" value="reject" class="btn btn-sm btn-reject">Reject</button>
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
            <tr><td colspan="15" class="text-danger text-center">Error fetching data!</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
    <button class="btn btn-secondary" onclick="history.back()">Back</button>
</div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
