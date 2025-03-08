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

@WebServlet("/Updatestatus")
public class Updatestatus extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String emobile = request.getParameter("mobile");
        Long mobile=Long.parseLong(emobile);
        String stat="";
          
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
            PreparedStatement ps = conn.prepareStatement("SELECT status FROM voter WHERE mobile='"+mobile+"'");
           
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String cstat = rs.getString("status");
                if ("authenticated".equals(cstat)) {
                    stat = "waiting";
                } else {
                    stat = "authenticated";
                }
            }
            PreparedStatement ps1 = conn.prepareStatement("UPDATE voter SET status=? WHERE mobile=?");
            ps1.setString(1, stat);
            ps1.setLong(2, mobile);
            int rs1 = ps1.executeUpdate();

            if (rs1 == 1) {
                out.println("<html><body><center>");
                out.println("<h3>Status updated successfully</h3>");
                out.println("<form><input type='submit' value='Back' formaction='Display'></form>");
                out.println("</center></body></html>");
            } else {
                out.println("<h3>Error updating status</h3>");
            }
        
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
