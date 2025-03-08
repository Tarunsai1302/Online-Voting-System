<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Election Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; padding-top: 60px; }
        h2 { color: #007bff; text-align: center; margin-top: 20px; }
        .chart-container { width: 80%; margin: auto; }
        .back-btn { display: block; width: 150px; margin: 20px auto; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">Election Portal</a>
        </div>
    </nav>

    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean resultsAnnounced = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Check if EC has announced results
            stmt = conn.prepareStatement("SELECT results_announced FROM election_status WHERE election_type = 'General'");
            rs = stmt.executeQuery();
            if (rs.next()) {
                resultsAnnounced = rs.getBoolean("results_announced");
            }

            if (resultsAnnounced) {
    %>
                <script type="text/javascript">
    google.charts.load('current', {packages:['corechart']});
    google.charts.setOnLoadCallback(drawCharts);

    function drawCharts() {
        var mlaData = [
            ['Candidate', 'Votes'], // Column headers
            <% 
                stmt = conn.prepareStatement("SELECT candidate_name, vote_count FROM candidates WHERE position = 'MLA' ORDER BY vote_count DESC");
                rs = stmt.executeQuery();
                while (rs.next()) { 
            %>
                ['<%= rs.getString("candidate_name") %>', <%= rs.getInt("vote_count") %>],
            <% } %>
        ];
        
        var mpData = [
            ['Candidate', 'Votes'], // Column headers
            <% 
                stmt = conn.prepareStatement("SELECT candidate_name, vote_count FROM candidates WHERE position = 'MP' ORDER BY vote_count DESC");
                rs = stmt.executeQuery();
                while (rs.next()) { 
            %>
                ['<%= rs.getString("candidate_name") %>', <%= rs.getInt("vote_count") %>],
            <% } %>
        ];

        drawChart('MLA', 'mla_chart_div', mlaData);
        drawChart('MP', 'mp_chart_div', mpData);
    }

    function drawChart(position, elementId, dataRows) {
        var data = google.visualization.arrayToDataTable(dataRows);

        var options = { 
            title: 'Election Results - ' + position, 
            height: 400, 
            legend: { position: 'none' }, 
            bar: { groupWidth: '75%' }, 
            colors: ['#007bff']
        };

        var chart = new google.visualization.ColumnChart(document.getElementById(elementId));
        chart.draw(data, options);
    }
</script>


                <h2>MLA Election Results</h2>
                <div class="chart-container">
                    <div id="mla_chart_div"></div>
                </div>

                <table class="table table-bordered table-hover mt-4">
                    <thead class="table-primary">
                        <tr>
                            <th>Candidate</th>
                            <th>Party</th>
                            <th>Votes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            stmt = conn.prepareStatement("SELECT candidate_name, party, vote_count FROM candidates WHERE position = 'MLA' ORDER BY vote_count DESC");
                            rs = stmt.executeQuery();
                            while (rs.next()) { 
                        %>
                            <tr>
                                <td><%= rs.getString("candidate_name") %></td>
                                <td><%= rs.getString("party") %></td>
                                <td><%= rs.getInt("vote_count") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

                <h2>MP Election Results</h2>
                <div class="chart-container">
                    <div id="mp_chart_div"></div>
                </div>

                <table class="table table-bordered table-hover mt-4">
                    <thead class="table-primary">
                        <tr>
                            <th>Candidate</th>
                            <th>Party</th>
                            <th>Votes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            stmt = conn.prepareStatement("SELECT candidate_name, party, vote_count FROM candidates WHERE position = 'MP' ORDER BY vote_count DESC");
                            rs = stmt.executeQuery();
                            while (rs.next()) { 
                        %>
                            <tr>
                                <td><%= rs.getString("candidate_name") %></td>
                                <td><%= rs.getString("party") %></td>
                                <td><%= rs.getInt("vote_count") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>

    <% 
            } else { 
    %>
                <h2 style="text-align:center; color:red;">Election results are not yet announced by the Election Commission.</h2>
    <% 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>

    <button class="btn btn-secondary back-btn" onclick="window.history.back();">Back</button>

</body>
</html>
