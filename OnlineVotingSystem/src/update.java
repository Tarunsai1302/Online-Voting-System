import java.io.File;
import java.io.IOException;
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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.util.UUID;

@WebServlet("/update")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class update extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String voterId = request.getParameter("voterId");
        if (voterId == null || voterId.isEmpty()) {
            System.out.println("Voter ID is missing!");
            response.sendRedirect("error.jsp"); // Redirect if voterId is missing
            return;
        }
        
        // Fetch form data
        String name = request.getParameter("fname");
        String fatherName = request.getParameter("lname");
        String motherName = request.getParameter("mname");
        String state = request.getParameter("state");
        String parliament = request.getParameter("pconst");
        String assembly = request.getParameter("aconst");
        String gender = request.getParameter("gender");
        String mobile = request.getParameter("mobile");
        String dob = request.getParameter("dob");

        // Handle file upload
        Part filePart = request.getPart("profile");
        String fileName = (filePart != null && filePart.getSize() > 0) 
            ? UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString() 
            : null;

        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        new File(uploadPath).mkdirs();

        if (fileName != null) {
            filePart.write(uploadPath + File.separator + fileName);
        }

        // Debugging Output
        System.out.println("Updating Voter ID: " + voterId);
        System.out.println("Name: " + name + ", Father: " + fatherName + ", Mother: " + motherName);
        System.out.println("State: " + state + ", Parliament: " + parliament + ", Assembly: " + assembly);
        System.out.println("Gender: " + gender + ", Mobile: " + mobile + ", DOB: " + dob);
        System.out.println("Profile Image: " + ((fileName != null) ? fileName : "default.png"));

        // Update database
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            String sql = "UPDATE voter SET name=?, fathername=?, mothername=?, state=?, "
                    + "parlimentconstituency=?, assemblyconstituency=?, gender=?, mobile=?, dob=?, profile=? "
                    + "WHERE voterid=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, fatherName);
            ps.setString(3, motherName);
            ps.setString(4, state);
            ps.setString(5, parliament);
            ps.setString(6, assembly);
            ps.setString(7, gender);
            ps.setString(8, mobile);
            ps.setString(9, dob);
            ps.setString(10, (fileName != null) ? fileName : "default.png");
            ps.setString(11, voterId);

            int rowsUpdated = ps.executeUpdate();
            System.out.println("Rows Updated: " + rowsUpdated);

            if (rowsUpdated > 0) {
                response.sendRedirect("Profile.jsp?update=success");
            } else {
                response.sendRedirect("Profile.jsp?update=failure");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp"); // Redirect to error page if exception occurs
        }
    }
}
