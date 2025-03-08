import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

@WebServlet("/results")
public class results extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            String sql = "SELECT constituency, position, candidate_name, party, vote_count " +
                         "FROM candidates WHERE (constituency, vote_count) IN " +
                         "(SELECT constituency, MAX(vote_count) FROM candidates GROUP BY constituency, position)";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            // Start HTML
            out.println("<html><head><title>Election Results</title>");

            // CSS Styling
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; text-align: center; background-color: #f8f9fa; }");
            out.println("h2 { color: #007bff; }");
            out.println("table { width: 80%; margin: auto; border-collapse: collapse; background: #ffffff; }");
            out.println("th, td { border: 1px solid #ddd; padding: 12px; text-align: center; }");
            out.println("th { background-color: #007bff; color: white; }");
            out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
            out.println("</style>");

            // Google Charts Library
            out.println("<script type='text/javascript' src='https://www.gstatic.com/charts/loader.js'></script>");
            out.println("<script type='text/javascript'>");
            out.println("google.charts.load('current', {packages:['corechart']});");
            out.println("google.charts.setOnLoadCallback(drawChart);");

            // JavaScript for Google Charts
            out.println("function drawChart() {");
            out.println("var data = new google.visualization.DataTable();");
            out.println("data.addColumn('string', 'Candidate');");
            out.println("data.addColumn('number', 'Votes');");

            // Add Data to Chart
            out.println("data.addRows([");
            while (rs.next()) {
                String candidateName = rs.getString("candidate_name");
                int votes = rs.getInt("vote_count");
                out.println("['" + candidateName + "', " + votes + "],");
            }
            out.println("]);");

            out.println("var options = { title: 'Election Results', height: 400, legend: { position: 'none' }, bar: { groupWidth: '75%' }, colors: ['#007bff'] };");
            out.println("var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));");
            out.println("chart.draw(data, options); }");
            out.println("</script>");

            out.println("</head><body>");
            out.println("<h2>Election Winners by Constituency</h2>");
            out.println("<div id='chart_div' style='width: 80%; margin: auto;'></div>");

            // Winners Table
            rs.beforeFirst(); // Reset ResultSet for Table Display
            out.println("<table><tr><th>Constituency</th><th>Position</th><th>Candidate</th><th>Party</th><th>Votes</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("constituency") + "</td>");
                out.println("<td>" + rs.getString("position") + "</td>");
                out.println("<td>" + rs.getString("candidate_name") + "</td>");
                out.println("<td>" + rs.getString("party") + "</td>");
                out.println("<td>" + rs.getInt("vote_count") + "</td>");
                out.println("</tr>");
            }
            out.println("</table></body></html>");

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Error fetching results. Please try again later.</h3>");
        }
    }
}
