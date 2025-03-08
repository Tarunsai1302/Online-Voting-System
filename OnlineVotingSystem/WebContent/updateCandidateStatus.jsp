<%@ page import="java.sql.*" %>

<%
    String candidateId = request.getParameter("candidateId");
    String status = request.getParameter("status");

    if (candidateId != null && status != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
            PreparedStatement pst = conn.prepareStatement("UPDATE candidates SET status=? WHERE id=?");
            pst.setString(1, status);
            pst.setInt(2, Integer.parseInt(candidateId));
            int rowsUpdated = pst.executeUpdate();
            pst.close();
            conn.close();
            
            if (rowsUpdated > 0) {
                out.print("Success");
            } else {
                out.print("Error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("Error");
        }
    } else {
        out.print("Invalid Request");
    }
%>
