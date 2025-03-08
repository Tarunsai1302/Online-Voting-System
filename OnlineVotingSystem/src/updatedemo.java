import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.util.UUID;

@WebServlet("/updatedemo")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class updatedemo extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	PrintWriter out=response.getWriter();
        HttpSession httpSession = request.getSession();
        String voterId = (String) httpSession.getAttribute("voterId");

        // Fetch form data
        String name = request.getParameter("fname");
        String fatherName = request.getParameter("lname");
        String motherName = request.getParameter("mname");
        String address = request.getParameter("address");
        String state = request.getParameter("state");
        String parliament = request.getParameter("pconst");
        String assembly = request.getParameter("aconst");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String dob = request.getParameter("dob");

        // Handle file upload
        Part filePart = request.getPart("profile");
        String fileName = (filePart != null && filePart.getSize() > 0) ? UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;

        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        new File(uploadPath).mkdirs();
        
        if (fileName != null) {
            filePart.write(uploadPath + File.separator + fileName);
        }

        // Insert into pending_updates table
        try (Connection con = dbconnect.GetConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO pending_updates (voterid, name, fathername, mothername, address, state, parlimentconstituency, assemblyconstituency, gender, mobile, dob, profile, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')")) {
             
            ps.setString(1, voterId);
            ps.setString(2, name);
            ps.setString(3, fatherName);
            ps.setString(4, motherName);
            ps.setString(5, address);
            ps.setString(6, state);
            ps.setString(7, parliament);
            ps.setString(8, assembly);
            ps.setString(9, gender);
            ps.setString(10, mobile);
            ps.setString(11, dob);
            ps.setString(12, (fileName != null) ? fileName : null);

            ps.executeUpdate();
            //response.sendRedirect("Profile.jsp?msg=Request Sent for Approval");
            out.println("<script>");
 			out.println("alert('Update Request Sent');");
 			out.println("window.location.href='Profile.jsp';");
 			out.println("</script>");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
