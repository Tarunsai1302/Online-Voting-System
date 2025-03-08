import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MarqueeServlet")
public class MarqueeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        String marqueeText = "";

        try {
            // Database Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Fetching data from database
            PreparedStatement pst = conn.prepareStatement("SELECT notification FROM enotif");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                marqueeText += rs.getString("notification") + " | ";  // Concatenating with separator
            }

            // Closing resources
            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            marqueeText = "Error loading announcements!";
        }

        out.write(marqueeText);  // Send response to HTML page
    }
}