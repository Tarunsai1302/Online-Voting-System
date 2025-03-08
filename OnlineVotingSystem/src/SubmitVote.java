import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SubmitVote")
public class SubmitVote extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        String voterId = (String) session.getAttribute("voterId");
        String electionType = request.getParameter("electionType");
        String candidateId = request.getParameter("candidate");

        if (voterId == null || electionType == null || candidateId == null) {
            response.sendRedirect("vote.jsp");
            return;
        }

        Connection conn = null;
        boolean hasMLA = false, hasMP = false;

        try {
            // Establish database connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            // Step 1: Check if voter has already voted
            PreparedStatement checkVote = conn.prepareStatement("SELECT mla_candidate_id, mp_candidate_id FROM votes WHERE voter_id = ?");
            checkVote.setString(1, voterId);
            ResultSet rs = checkVote.executeQuery();

            if (rs.next()) {
                hasMLA = rs.getInt("mla_candidate_id") != 0;
                hasMP = rs.getInt("mp_candidate_id") != 0;
            }
            rs.close();
            checkVote.close();

            // Step 2: Process the vote and update the candidate count
            if (!hasMLA && electionType.equalsIgnoreCase("MLA")) {
                // Update or insert MLA vote
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO votes (voter_id, mla_candidate_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE mla_candidate_id = ?"
                );
                pst.setString(1, voterId);
                pst.setInt(2, Integer.parseInt(candidateId));
                pst.setInt(3, Integer.parseInt(candidateId));
                pst.executeUpdate();
                pst.close();

                // Update vote count for MLA candidate
                PreparedStatement updateVotes = conn.prepareStatement(
                    "UPDATE candidates SET vote_count = COALESCE(vote_count, 0) + 1 WHERE id = ? AND position = 'MLA'"
                );
                updateVotes.setInt(1, Integer.parseInt(candidateId));
                updateVotes.executeUpdate();
                updateVotes.close();

                hasMLA = true;
            } 
            
            if (!hasMP && electionType.equalsIgnoreCase("MP")) {
                // Update or insert MP vote
                PreparedStatement pst = conn.prepareStatement(
                    "UPDATE votes SET mp_candidate_id = ? WHERE voter_id = ?"
                );
                pst.setInt(1, Integer.parseInt(candidateId));
                pst.setString(2, voterId);
                pst.executeUpdate();
                pst.close();

                // Update vote count for MP candidate
                PreparedStatement updateVotes = conn.prepareStatement(
                    "UPDATE candidates SET vote_count = COALESCE(vote_count, 0) + 1 WHERE id = ? AND position = 'MP'"
                );
                updateVotes.setInt(1, Integer.parseInt(candidateId));
                updateVotes.executeUpdate();
                updateVotes.close();

                hasMP = true;
            }

            // Step 3: Redirect to the correct page
            if (!hasMLA) {
                response.sendRedirect("vote.jsp?electionType=MLA");
            } else if (!hasMP) {
                response.sendRedirect("vote.jsp?electionType=MP");
            } else {
                // Display success message and redirect
                out.println("<script>");
                out.println("alert('Voted Successfully');");
                out.println("window.location.href='Voterdash.jsp';");
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
