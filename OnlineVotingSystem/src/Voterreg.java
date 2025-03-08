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

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
@WebServlet("/Voterreg")
public class Voterreg extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads"; // Save images in /uploads

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        // Get form parameters
        String name = request.getParameter("fname");
        String fname = request.getParameter("lname");
        String mname = request.getParameter("un");
        String address=request.getParameter("address");
        String state = request.getParameter("state");
        String aconstituency = request.getParameter("aconst");
        String pconstituency = request.getParameter("pconst");
        String gender = request.getParameter("gender");
        String emobile = request.getParameter("mobile");
        long mobile = Long.parseLong(emobile);
        String dob = request.getParameter("dob");
        String eaadhar = request.getParameter("aadhar");
        long aadhar = Long.parseLong(eaadhar);

        // Store mobile in session
        HttpSession hs = request.getSession();
        hs.setAttribute("Mobile", emobile);

        // Handle File Upload
        Part filePart = request.getPart("profile"); // File input name="profile"
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Define upload path (outside the project in Tomcat webapps/uploads)
        String uploadPath = getServletContext().getRealPath("/") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        
        // Create directory if it doesn't exist
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Creates parent directories if necessary
        }

        // Full file path
        String filePath = uploadPath + File.separator + fileName;
        
        // Save the file
        filePart.write(filePath);

        try {
            // Database connection
            Connection conn = dbconnect.GetConnection();
            PreparedStatement pst = conn.prepareStatement("INSERT INTO voter VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

            pst.setString(1, name);
            pst.setString(2, fname);
            pst.setString(3, mname);
            pst.setString(4, state);
            pst.setString(5, address);
            pst.setString(6, aconstituency);
            pst.setString(7, pconstituency);
            pst.setString(8, gender);
            pst.setLong(9,mobile);
            pst.setString(10, dob);
            pst.setLong(11, aadhar);
            pst.setString(12, fileName);  // Store filename (not path)
            pst.setString(13, "");  // Unused field
            pst.setString(14, "");  // Unused field

            // Execute query
            int i = pst.executeUpdate();
            if (i == 1) {
                out.println("<script>");
                out.println("alert('VoterID generation in Process');");
                out.println("window.location.href='voterid';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('Issue in the registration');");
                out.println("window.location.href='voterreg.html';");
                out.println("</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
