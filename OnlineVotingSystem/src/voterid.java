

import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;
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


@WebServlet("/voterid")
public class voterid extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();

        //String emobile = request.getParameter("mobile");
		HttpSession hs = request.getSession();
		String emobile = (String) hs.getAttribute("Mobile"); // Use correct key

//		if (emobile != null) {
//		    long mobile = Long.parseLong(emobile);
//		    // Now you can use mobile safely
//		}


        if (emobile == null || emobile.trim().isEmpty()) {
            out.println("{\"status\": \"error\", \"message\": \"Mobile number is missing or invalid.\"}");
            return;
        }

        Long mobile;
        try {
            mobile = Long.parseLong(emobile);
        } catch (NumberFormatException e) {
            out.println("{\"status\": \"error\", \"message\": \"Invalid mobile number format.\"}");
            return;
        }
        
        
        if (checkdbMobile(mobile)) {
            String vid = generateId(10);
            
//        HttpSession httpSession=    request.getSession();
//        httpSession.setAttribute("GenerateOtp", vid);
            

            if (storeId(mobile, vid)) {
            	out.println("<script>");
            	out.println("alert('Voter Added Successfully!');");
            	out.println("window.location.href='NewFile.html';");
            	out.println("</script>");


            } else {
                out.println("{\"status\": \"error\", \"message\": \"Failed to store OTP.\"}");
            }
        } else {
            out.println("{\"status\": \"error\", \"message\": \"Mobile number is not registered.\"}");
        }
        
	}
	
	 private boolean checkdbMobile(Long mobile) {
	        boolean existingMobile = false;
	        try {
	        	Class.forName("com.mysql.cj.jdbc.Driver");
	        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
	             PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter WHERE mobile=?");

	           
	            pst.setLong(1, mobile);
	            ResultSet rs = pst.executeQuery();

	            if (rs.next()) {
	                existingMobile = true;
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return existingMobile;
	    }
	 
	 private static String generateId(int length) {
	        SecureRandom random = new SecureRandom();
	        StringBuilder voterId = new StringBuilder();

	        for (int i = 0; i < length; i++) {
	            voterId.append(random.nextInt(10));  // Generate a random digit (0-9)
	        }

	        return voterId.toString();
	    }
	 
	 private boolean storeId(Long mobile, String vid) {
	        boolean storeid = false;
	        try {
	        	Class.forName("com.mysql.cj.jdbc.Driver");
	        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
	        
	             PreparedStatement pst = conn.prepareStatement("UPDATE voter SET voterid=? WHERE mobile=?");

	            
	            pst.setString(1, vid);
	            pst.setLong(2, mobile);

	            int i = pst.executeUpdate();
	            storeid = (i == 1);
	              } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return storeid;
	    }

}
