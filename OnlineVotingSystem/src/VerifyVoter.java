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
import javax.servlet.http.HttpSession;

@WebServlet("/VerifyVoter")
public class VerifyVoter extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String voterId = request.getParameter("voterId");
        HttpSession httpSession=request.getSession();
        long mobile=(long)httpSession.getAttribute("mobile");
       // long mobile=Long.parseLong(emobile);
        PrintWriter out=response.getWriter();
        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Query to check if voter ID exists
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter WHERE voterid = ? and mobile=?");
            pst.setString(1, voterId);
            pst.setLong(2, mobile);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Voter ID is valid, store in session and redirect to candidate list
                HttpSession session = request.getSession();
                session.setAttribute("voterId", voterId);
                out.println("<script>");
	   			out.println("alert('Voter Verified Successfullyy');");
	   			out.println("window.location.href='vote.jsp';");
	   			out.println("</script>");
               // response.sendRedirect("candidates.jsp");
            } else {
                // Voter ID not found, redirect back with error
               // response.sendRedirect("vote.jsp?error=Invalid Voter ID");
            	out.println("<script>");
	   			out.println("alert('Enter Valid VoterId');");
	   			out.println("window.location.href='votervrify.jsp';");
	   			out.println("</script>");
            	
            }

            // Close connections
            rs.close();
            pst.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("vote.jsp?error=Something went wrong!");
        }
    }
}
