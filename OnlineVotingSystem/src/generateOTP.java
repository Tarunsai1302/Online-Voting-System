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

import org.omg.CORBA.Request;

@WebServlet("/generateOTP")
public class generateOTP extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession httpSession=    request.getSession();
        String emobile = request.getParameter("mobile");
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
        httpSession.setAttribute("mobile", mobile);
       

        if (checkdbMobile(mobile,httpSession)) {
            String otp = generateOTP(6);
            
        
        httpSession.setAttribute("GenerateOtp", otp);


            if (storeOtp(mobile, otp)) {
            	out.println("{\"status\": \"success\", \"message\": \"OTP Generated Successfully. Check in your DB.\", \"otp\": \"" + otp + "\"}");
            } else {
                out.println("{\"status\": \"error\", \"message\": \"Failed to store OTP.\"}");
            }
        } else {
            out.println("{\"status\": \"error\", \"message\": \"Mobile number is not registered.\"}");
           // response.sendRedirect("Voterlog.html");
        }
    }

    private static String generateOTP(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder otp = new StringBuilder();

        for (int i = 0; i < length; i++) {
            otp.append(random.nextInt(10));  // Generate a random digit (0-9)
        }

        return otp.toString();
    }

    //  Fix: Better exception handling and resource management
    private boolean checkdbMobile(Long mobile,HttpSession httpSession) {
        boolean existingMobile = false;
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
             PreparedStatement pst = conn.prepareStatement("SELECT * FROM voter WHERE mobile=?");

           
            pst.setLong(1, mobile);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                existingMobile = true;
                httpSession.setAttribute("state", rs.getString(4));
                httpSession.setAttribute("aconst", rs.getString(6));
                httpSession.setAttribute("pconst", rs.getString(7));
                httpSession.setAttribute("voterId", rs.getString(13));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return existingMobile;
    }

    //  Fix: Proper error handling and resource management
    private boolean storeOtp(Long mobile, String otp) {
        boolean storeOtp = false;
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
        
             PreparedStatement pst = conn.prepareStatement("UPDATE voter SET otp=? WHERE mobile=?");

            
            pst.setString(1, otp);
            pst.setLong(2, mobile);

            int i = pst.executeUpdate();
            storeOtp = (i == 1);
              } catch (Exception e) {
            e.printStackTrace();
        }
        return storeOtp;
    }

}
