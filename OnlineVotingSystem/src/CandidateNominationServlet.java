import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
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

import com.mysql.cj.xdevapi.Statement;

@WebServlet("/CandidateNominationServlet")
@MultipartConfig(fileSizeThreshold = 2 * 1024 * 1024, 
                 maxFileSize = 10 * 1024 * 1024,       
                 maxRequestSize = 50 * 1024 * 1024)   
public class CandidateNominationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/scet";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "manager";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            int electionYear = Integer.parseInt(request.getParameter("electionYear"));
            String candidateName = request.getParameter("candidateName");
            String dob = request.getParameter("dob");
            String guardianName = request.getParameter("guardianName");
            Part filePart = request.getPart("candidatePicture");
            String cases = request.getParameter("cases");
            double income = Double.parseDouble(request.getParameter("income"));
            String party=request.getParameter("party");
            String position = request.getParameter("position");
            String state = request.getParameter("states");
            String constituency = request.getParameter("constituency");
            boolean declaration = request.getParameter("declaration") != null;

            // Validate File Type
            String fileName = filePart.getSubmittedFileName();
            if (!fileName.endsWith(".jpg") && !fileName.endsWith(".png")) {
                out.println("<h3>Invalid file type. Only JPG and PNG are allowed.</h3>");
                return;
            }

            // Dynamic Upload Path
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            // Save Data to Database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "INSERT INTO candidates (election_year,candidate_name, dob, guardian_name, candidate_picture, cases, income,party, position, state, constituency, declaration,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pst = conn.prepareStatement(sql);

            // Set values
            pst.setInt(1,electionYear);
            pst.setString(2, candidateName);
            pst.setString(3, dob); // Assuming dob is in "yyyy-MM-dd" format
            pst.setString(4, guardianName);
            pst.setString(5, fileName); // Assuming image is uploaded as InputStream
            pst.setString(6, cases);
            pst.setDouble(7, income);
            pst.setString(8, party);
            pst.setString(9, position);
            pst.setString(10, state);
            pst.setString(11, constituency);
            pst.setBoolean(12, declaration);
            pst.setString(13, "waiting");
            int i=pst.executeUpdate();

            if(i>0) {
            	out.println("<script>");
	 			out.println("alert('Candidate Nomination Successful');");
	 			out.println("window.location.href='index.html';");
	 			out.println("</script>");
            }
            else {
            	out.println("<script>");
	 			out.println("alert('Nomination Failed');");
	 			out.println("window.location.href='index.html';");
	 			out.println("</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
