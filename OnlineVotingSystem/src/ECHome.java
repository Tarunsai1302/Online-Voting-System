

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
import javax.servlet.http.HttpSession;


@WebServlet("/ECHome")
public class ECHome extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		String email=request.getParameter("un");
		String password=request.getParameter("pass");
		HttpSession hs=request.getSession();
		hs.setAttribute("username", email);
		hs.setAttribute("pass", password);
		try{
			Connection conn= dbconnect.GetConnection();
			PreparedStatement pst=conn.prepareStatement("select * from electioncommission where email='"+email+"' and password='"+password+"' ");
			ResultSet rs=pst.executeQuery();
			if(rs.next()){
				response.sendRedirect("NewFile.html");
			}
			else {
				out.println("<script>");
				out.println("alert('Invalid Credentials... Try with a valid Username and Password');");
				out.println("window.location.href='EClog.html';");
				out.println("</script>");

			}

			
		}
		catch(Exception e){
			e.printStackTrace();
		}
	
	}

}
