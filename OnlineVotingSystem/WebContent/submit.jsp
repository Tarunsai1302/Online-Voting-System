<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    HttpSession sessionObj = request.getSession();
    String voterId = request.getParameter("voterId");
    String electionType = request.getParameter("electionType");
    String candidateId = request.getParameter("candidate");

    Connection conn = null;
    boolean hasVotedMLA = false;
    boolean hasVotedMP = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

        // Step 1: Check if the voter has already voted
        PreparedStatement checkVote = conn.prepareStatement("SELECT mla_candidate_id, mp_candidate_id FROM votes WHERE voter_id = ?");
        checkVote.setString(1, voterId);
        ResultSet rs = checkVote.executeQuery();

        if (rs.next()) {
            hasVotedMLA = rs.getInt("mla_candidate_id") != 0;
            hasVotedMP = rs.getInt("mp_candidate_id") != 0;
        }
        rs.close();
        checkVote.close();

        // Step 2: Prevent voting again if both MLA & MP votes are already done
        if (hasVotedMLA && hasVotedMP) {
            response.sendRedirect("confirmation.jsp?voterId=" + voterId);
            return; // Stop execution
        }

        // Step 3: Update the existing vote record instead of inserting a new row
        if (electionType.equalsIgnoreCase("MLA") && !hasVotedMLA) {
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE votes SET mla_candidate_id = ? WHERE voter_id = ?"
            );
            pst.setInt(1, Integer.parseInt(candidateId));
            pst.setString(2, voterId);
            int rowsUpdated = pst.executeUpdate();
            pst.close();

            // If no rows were updated, it means the voter has no existing record, so insert
            if (rowsUpdated == 0) {
                PreparedStatement insertVote = conn.prepareStatement(
                    "INSERT INTO votes (voter_id, mla_candidate_id) VALUES (?, ?)"
                );
                insertVote.setString(1, voterId);
                insertVote.setInt(2, Integer.parseInt(candidateId));
                insertVote.executeUpdate();
                insertVote.close();
            }

            // Update MLA candidate vote count
            PreparedStatement updateVotes = conn.prepareStatement("UPDATE candidates SET vote_count = vote_count + 1 WHERE id = ?");
            updateVotes.setInt(1, Integer.parseInt(candidateId));
            updateVotes.executeUpdate();
            updateVotes.close();
        }

        if (electionType.equalsIgnoreCase("MP") && !hasVotedMP) {
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE votes SET mp_candidate_id = ? WHERE voter_id = ?"
            );
            pst.setInt(1, Integer.parseInt(candidateId));
            pst.setString(2, voterId);
            int rowsUpdated = pst.executeUpdate();
            pst.close();

            // If no rows were updated, insert a new row
            if (rowsUpdated == 0) {
                PreparedStatement insertVote = conn.prepareStatement(
                    "INSERT INTO votes (voter_id, mp_candidate_id) VALUES (?, ?)"
                );
                insertVote.setString(1, voterId);
                insertVote.setInt(2, Integer.parseInt(candidateId));
                insertVote.executeUpdate();
                insertVote.close();
            }

            // Update MP candidate vote count
            PreparedStatement updateVotes = conn.prepareStatement("UPDATE candidates SET vote_count = vote_count + 1 WHERE id = ?");
            updateVotes.setInt(1, Integer.parseInt(candidateId));
            updateVotes.executeUpdate();
            updateVotes.close();
        }

        // Step 4: Redirect based on voting status
        if (!hasVotedMLA) {
            response.sendRedirect("vote.jsp?electionType=MLA");
        } else if (!hasVotedMP) {
            response.sendRedirect("vote.jsp?electionType=MP");
        } else {
            response.sendRedirect("confirmation.jsp?voterId=" + voterId);
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
