import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Display")
public class Display extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Connection conn = dbconnect.GetConnection();
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter");
            ResultSet rs = pst.executeQuery();

            // HTML with Applied CSS
            out.println("<html><head><title>Voter List</title>");
            out.println("<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; background: linear-gradient(to right, #84fab0, #4FA3D1); margin: 0; padding: 0; }");
            out.println(".container { width: 80%; margin: 30px auto; padding: 20px; background: white; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2); text-align: center; }");
            out.println("h2 { color: #007bff; text-align: center; }");
            out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
            out.println("th, td { padding: 12px; border: 1px solid #ddd; text-align: center; }");
            out.println("th { background-color: #007bff; color: white; }");
            out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
            out.println("img { width: 80px; height: 80px; border-radius: 5px; }");
            out.println("</style>");
            out.println("</head><body>");

            out.println("<div class='container'>");
            out.println("<h2>Registered Voters</h2>");
            out.println("<table class='table'>");
            out.println("<thead><tr>");
            out.println("<th>Voter Name</th><th>Father Name</th><th>Mother Name</th><th>State</th>");
            out.println("<th>AssemblyConstituency</th><th>ParlimentConstituency</th><th>Gender</th><th>Mobile</th>");
            out.println("<th>Date Of Birth</th><th>Aadhar</th><th>Profile Pic</th><th>Status</th>");
            out.println("</tr></thead><tbody>");

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString(1) + "</td>");
                out.println("<td>" + rs.getString(2) + "</td>");
                out.println("<td>" + rs.getString(3) + "</td>");
                out.println("<td>" + rs.getString(4) + "</td>");
                out.println("<td>" + rs.getString(5) + "</td>");
                out.println("<td>" + rs.getString(6) + "</td>");
                out.println("<td>" + rs.getString(7) + "</td>");
                out.println("<td>" + rs.getLong(8) + "</td>");
                out.println("<td>" + rs.getString(9) + "</td>");
                out.println("<td>" + rs.getLong(10) + "</td>");

                // Profile Picture with Image Display
                String profilePic = rs.getString(11);
                out.println("<td><img src='images/" + profilePic + "' class='img-thumbnail'></td>");

                // Status Column
                out.println("<td>" + rs.getString(12) + "</td>");
                out.println("</tr>");
            }

            out.println("</tbody></table>");

            // Back Button
            out.println("<div class='mt-4'>");
            out.println("<button class='btn btn-secondary' onclick='history.back()'>Back</button>");
            out.println("</div>");

            out.println("</div>");
            out.println("</body></html>");

            // Closing resources
            rs.close();
            pst.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger text-center mt-4'>Error fetching data. Please try again.</div>");
        }
    }
}
