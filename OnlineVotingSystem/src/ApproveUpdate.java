import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ApproveUpdate")
public class ApproveUpdate extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String action = request.getParameter("action");

        try (Connection con = dbconnect.GetConnection()) {
            if ("approve".equals(action)) {
                // Fetch pending update details
                PreparedStatement fetchPs = con.prepareStatement("SELECT * FROM pending_updates WHERE id = ?");
                fetchPs.setString(1, id);
                ResultSet rs = fetchPs.executeQuery();

                if (rs.next()) {
                    // Update voter table
                    PreparedStatement updatePs = con.prepareStatement(
                        "UPDATE voter SET name=?, fathername=?, mothername=?, address=?, state=?, parlimentconstituency=?, assemblyconstituency=?, gender=?, mobile=?, dob=?, profile=? WHERE voterid=?"
                    );
                    updatePs.setString(1, rs.getString("name"));
                    updatePs.setString(2, rs.getString("fathername"));
                    updatePs.setString(3, rs.getString("mothername"));
                    updatePs.setString(4, rs.getString("address"));
                    updatePs.setString(5, rs.getString("state"));
                    updatePs.setString(6, rs.getString("parlimentconstituency"));
                    updatePs.setString(7, rs.getString("assemblyconstituency"));
                    updatePs.setString(8, rs.getString("gender"));
                    updatePs.setString(9, rs.getString("mobile"));
                    updatePs.setString(10, rs.getString("dob"));
                    updatePs.setString(11, rs.getString("profile"));
                    updatePs.setString(12, rs.getString("voterid"));
                    updatePs.executeUpdate();
                    
                    // Mark as approved
                    PreparedStatement approvePs = con.prepareStatement("UPDATE pending_updates SET status = 'approved' WHERE id = ?");
                    approvePs.setString(1, id);
                    approvePs.executeUpdate();
                }
            } else if ("reject".equals(action)) {
                // Mark as rejected
                PreparedStatement rejectPs = con.prepareStatement("UPDATE pending_updates SET status = 'rejected' WHERE id = ?");
                rejectPs.setString(1, id);
                rejectPs.executeUpdate();
            }

            response.sendRedirect("ecd.jsp?msg=Update Processed");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
