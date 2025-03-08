<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.ArrayList" %>

<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String state = request.getParameter("states");
    String position = request.getParameter("position");

    System.out.println("Received State: " + state);
    System.out.println("Received Position: " + position);

    if (state == null || position == null) {
        out.print("{\"error\": \"Invalid request parameters\"}");
        return;
    }

    ArrayList<String> list = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

        String query;
        if (position.equalsIgnoreCase("mla")) {
            query = "SELECT DISTINCT assembly_constituency FROM assemblyconstituencies WHERE state = ?";
        } else if (position.equalsIgnoreCase("mp")) {
            query = "SELECT DISTINCT parliamentary_constituency FROM assemblyconstituencies WHERE state = ?";
        } else {
            out.print("{\"error\": \"Invalid position\"}");
            conn.close();
            return;
        }

        pst = conn.prepareStatement(query);
        pst.setString(1, state);
        ResultSet rs = pst.executeQuery();

        // Ensure Proper JSON Formatting
        StringBuilder jsonOutput = new StringBuilder();
        jsonOutput.append("{\"constituencies\": [");

        boolean first = true;
        while (rs.next()) {
            if (!first) jsonOutput.append(",");
            jsonOutput.append("\"").append(rs.getString(1)).append("\""); // Add quotes around values
            first = false;
        }

        jsonOutput.append("]}");
        System.out.println("Response Sent: " + jsonOutput.toString());
        out.print(jsonOutput.toString());

    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"error\": \"Database error occurred\"}");
    } finally {
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
