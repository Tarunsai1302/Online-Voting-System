

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/verify")
public class verify extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String otp=  request.getParameter("number");
		PrintWriter out=response.getWriter();
	    
		 try{
			 Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
				Connection conn=	DriverManager.getConnection("jdbc:mysql://localhost:3306/scet","root","manager");
			PreparedStatement pst=	conn.prepareStatement("select *from voter where otp='"+otp+"'");	
				 
		 ResultSet rs=	pst.executeQuery();
			 
		      if(rs.next()){
		    	  out.println("<script>");
		 			out.println("alert('OTP verified sucessfully');");
		 			out.println("window.location.href='Voterdash.jsp';");
		 			out.println("</script>");
		    	 // response.sendRedirect("parentpane.html");
		      }
		      else{
		    	  out.println("<script>");
		 			out.println("alert('Invalid OTP');");
		 			out.println("window.location.href='Voterlog.html';");
		 			out.println("</script>");
		      }
		 
		 
		 }
		 catch(Exception e)
		 {
			 e.printStackTrace();
		 }
		 
		 


	}

}
