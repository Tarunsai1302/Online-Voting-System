<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Get election type (MLA or MP) from request
    String electionType = request.getParameter("electionType");

    // Get session attributes
    HttpSession httpSession = request.getSession();
    String voterId = (String) httpSession.getAttribute("voterId");
    String state = (String) httpSession.getAttribute("state");
    String aconst = (String) httpSession.getAttribute("aconst");
    String pconst = (String) httpSession.getAttribute("pconst");

    // Validate session attributes
    if (electionType == null || voterId == null || state == null || aconst == null || pconst == null) {
        out.println("<div class='alert alert-danger text-center'>Invalid request. Please log in again.</div>");
        return;
    }

    // Determine constituency based on election type
    String constituency = electionType.equals("MLA") ? aconst : pconst;

    Connection conn = null;

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

        // Check if the voter has already voted
        PreparedStatement checkVote = conn.prepareStatement(
            "SELECT mla_candidate_id, mp_candidate_id FROM votes WHERE voter_id = ?"
        );
        checkVote.setString(1, voterId);
        ResultSet voteResult = checkVote.executeQuery();

        boolean hasVotedMLA = false, hasVotedMP = false;
        if (voteResult.next()) {
            hasVotedMLA = voteResult.getInt("mla_candidate_id") != 0;
            hasVotedMP = voteResult.getInt("mp_candidate_id") != 0;
        }
        voteResult.close();
        checkVote.close();

        // Redirect if already voted for both
        if (hasVotedMLA && hasVotedMP) {
        	out.println("<script>");
            out.println("alert('Already Voted');");
            out.println("window.location.href='Voterdash.jsp';");
            out.println("</script>");
            return;
        }
        if (electionType.equals("MLA") && hasVotedMLA) {
            response.sendRedirect("vote.jsp?electionType=MP");
            return;
        } else if (electionType.equals("MP") && hasVotedMP) {
            response.sendRedirect("vote.jsp?electionType=MLA");
            return;
        }

        // Fetch candidates
        PreparedStatement pst = conn.prepareStatement(
            "SELECT id, candidate_name, party FROM candidates WHERE state = ? AND constituency = ? AND position = ? AND status = 'Approved'"
        );
        pst.setString(1, state);
        pst.setString(2, constituency);
        pst.setString(3, electionType);
        ResultSet rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote for <%= electionType %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="text-center">Vote for <%= electionType %></h2>

        <%
            if (!rs.isBeforeFirst()) { // No candidates found
        %>
            <div class="alert alert-warning text-center">No candidates found for <%= electionType %> in your constituency.</div>
        <%
            } else {
        %>
            <table class="table table-bordered table-hover">
                <thead class="table-primary">
                    <tr>
                        <th>Candidate Name</th>
                        <th>Party</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>

                    <%
                        while (rs.next()) {
                    %>
                        <tr>
                            <td><%= rs.getString("candidate_name") %></td>
                            <td><%= rs.getString("party") %></td>
                            <td class="text-center">
                                <form action="SubmitVote" method="post">
                                    <input type="hidden" name="electionType" value="<%= electionType %>">
                                    <input type="hidden" name="candidate" value="<%= rs.getInt("id") %>">
                                    <button type="submit" class="btn btn-success">Vote</button>
                                </form>
                            </td>
                        </tr>
                    <%
                        }
                    %>

                </tbody>
            </table>
            
        <%
            }
        %>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
        rs.close();
        pst.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger text-center'>An error occurred. Please try again later.</div>");
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
