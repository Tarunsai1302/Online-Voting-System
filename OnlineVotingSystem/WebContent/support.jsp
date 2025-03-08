<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Queries</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd, #b2ebf2);
            font-family: 'Poppins', sans-serif;
        }

        .container {
            max-width: 1000px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            margin-top: 30px;
        }

        h2 {
            text-align: center;
            font-weight: bold;
            color: #343a40;
        }

        .table {
            background: white;
        }

        .table th {
            background: #007bff;
            color: white;
            text-align: center;
        }

        .table td {
            text-align: center;
            vertical-align: middle;
        }

        .btn-primary {
            width: 100%;
            font-weight: bold;
        }

        .search-box {
            width: 100%;
            padding: 10px;
            border: 2px solid #007bff;
            border-radius: 5px;
            outline: none;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Support Queries</h2>
        <hr>

        <!-- Search Bar -->
        <input type="text" id="search" class="search-box mb-3" placeholder="Search queries...">

        <table class="table table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Query</th>
                    <th>Submitted At</th>
                </tr>
            </thead>
            <tbody id="queryTable">

                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM support_queries ORDER BY submitted_at DESC");

                        while (rs.next()) {
                %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("mobile") %></td>
                                <td><%= rs.getString("query") %></td>
                                <td><%= rs.getTimestamp("submitted_at").toString().replace("T", " ") %></td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' class='text-danger text-center'>Error fetching data: " + e.getMessage() + "</td></tr>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-danger text-center'>Error closing resources</td></tr>");
                        }
                    }
                %>

            </tbody>
        </table>

        <a href="index.html" class="btn btn-primary">Back to Home</a>
    </div>

    <script>
        document.getElementById('search').addEventListener('keyup', function() {
            let filter = this.value.toLowerCase();
            let rows = document.querySelectorAll("#queryTable tr");

            rows.forEach(row => {
                let queryText = row.innerText.toLowerCase();
                row.style.display = queryText.includes(filter) ? "" : "none";
            });
        });
    </script>

</body>
</html>
