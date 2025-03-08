import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchVoter")
public class SearchVoter extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String voterId = request.getParameter("voterId");
        String mobileNumber = request.getParameter("mobileNumber");
        String state = request.getParameter("state"); // Fixed incorrect argument

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Validate input
        if ((voterId == null || voterId.trim().isEmpty()) && 
            (mobileNumber == null || mobileNumber.trim().isEmpty())) {
            out.println("<div class='alert alert-danger'>Please enter a Voter ID or Mobile Number.</div>");
            return;
        }
//        System.out.println(voterId);
//        System.out.println(mobileNumber);
//        System.out.println(state);
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish Connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Determine search query
            String query;
            if (voterId != null && !voterId.trim().isEmpty()) {
                query = "SELECT * FROM voter WHERE voterid = ? AND state = ?";
                pst = conn.prepareStatement(query);
                pst.setString(1, voterId);
                pst.setString(2, state);
            } else {
                query = "SELECT * FROM voter WHERE mobile= ? AND state = ?";
                pst = conn.prepareStatement(query);
                pst.setString(1, mobileNumber);
                pst.setString(2, state);
            }

            rs = pst.executeQuery();

            if (rs.next()) {
                out.println("<div class='alert alert-success'>");
                out.println("<p><strong>Name:</strong> " + rs.getString("name") + "</p>");
                out.println("<p><strong>State:</strong> " + rs.getString("state") + "</p>");
                out.println("<p><strong>Assembly Constituency:</strong> " + rs.getString("assemblyconstituency") + "</p>");
                out.println("<p><strong>Parliament Constituency:</strong> " + rs.getString("parlimentconstituency") + "</p>");
                out.println("</div>");
            } else {
                out.println("<div class='alert alert-warning'>No record found.</div>");
            }

        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Close all resources properly
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("<div class='alert alert-danger'>Error closing resources: " + e.getMessage() + "</div>");
            }
        }
    }
}
