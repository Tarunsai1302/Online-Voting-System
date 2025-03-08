import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
@MultipartConfig
@WebServlet("/Partyreg")
public class Partyreg extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		String partyid = request.getParameter("partyid");
		String partyName = request.getParameter("partyname");
        String partyPresident = request.getParameter("partypresident");
        String partySecretary = request.getParameter("secretary");
        String state = request.getParameter("state");
        Part filepart=request.getPart("partyimage");
		String fileName=      Paths.get(filepart.getSubmittedFileName()).getFileName().toString();

		String uploadpath=   getServletContext().getRealPath("") + File.separator + "images";
		  
		    File file=new File(uploadpath);
		      if(!file.exists()) 
		   	   file.mkdir();
		   	   String filepath=uploadpath + file.separator + fileName;
		   	   filepart.write(filepath);
		   	 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            
                PreparedStatement ps = con.prepareStatement("INSERT INTO party VALUES (?, ?, ?, ?,?,?)");
                ps.setString(1, partyid);
                ps.setString(2, partyName);
                ps.setString(3, partyPresident);
                ps.setString(4, partySecretary);
                ps.setString(5, state);
                ps.setString(6, fileName);

                int result = ps.executeUpdate();
                if (result > 0) {
                    //out.println("<div class='message' style='color: green;'>Party Registered Successfully!</div>");
                	out.println("<script>");
		   			out.println("alert('Party Registered Successfullyy');");
		   			out.println("window.location.href='NewFile.html';");
		   			out.println("</script>");
                	//response.sendRedirect("NewFile.html");
                } else {
                    out.println("<div class='message' style='color: red;'>Registration Failed!</div>");
                }
            }
         catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='message' style='color: red;'>Database Error!</div>");
        }
	}

}