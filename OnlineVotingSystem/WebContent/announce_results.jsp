<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Election Announcement</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <nav class="navbar navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">Election Commission Panel</a>
        </div>
    </nav>

    <div class="container mt-5 text-center">
        <h2>Announce Election Results</h2>
        
        <form method="post">
            <button type="submit" name="announce" class="btn btn-success">Announce Results</button>
            <button class="btn btn-secondary" onclick="history.back()">Back</button>
        </form>

        <br>
        <%
            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("announce") != null) {
                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

                    String sql = "UPDATE election_status SET results_announced = 1 WHERE election_type = 'General'";
                    stmt = conn.prepareStatement(sql);
                    int rowsUpdated = stmt.executeUpdate();

                    if (rowsUpdated > 0) {
        %>
                        <div class="alert alert-success mt-3" role="alert">
                            Election results have been announced successfully!
                        </div>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
        %>
                    <div class="alert alert-danger mt-3" role="alert">
                        Error updating the announcement. Please try again.
                    </div>
        <%
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>

</body>
</html>
