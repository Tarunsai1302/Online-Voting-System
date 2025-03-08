

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/deletevoter")
public class deletevoter extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mobile = request.getParameter("mobile");
        PrintWriter out = response.getWriter();

        try {
            Connection conn = dbconnect.GetConnection();
            PreparedStatement ps = conn.prepareStatement("delete from voter where mobile=? ");
            ps.setString(1, mobile);
            int r = ps.executeUpdate();
            
            if (r > 0) {
                out.println("<script type='text/javascript'>");
                out.println("alert('voter deleted successfully!');");
                out.println("window.location.href = 'Display.jsp';");
                out.println("</script>");
            } else {
                out.println("<script type='text/javascript'>");
                out.println("alert('Error deleting material. Please try again.');");
                out.println("window.location.href = 'Display.jsp';");
                out.println("</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('An error occurred. Please contact support.');");
            out.println("window.location.href = 'Display.jsp';");
            out.println("</script>");
        }
    }
}