<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
PrintWriter ou = response.getWriter();
ArrayList<String> list = new ArrayList<>();

String parliament = request.getParameter("parliament");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

    if (parliament != null) {
        PreparedStatement pst = conn.prepareStatement(
            "SELECT assembly_constituency FROM assemblyconstituencies WHERE parliamentary_constituency=?"
        );
        pst.setString(1, parliament);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            list.add(rs.getString(1));
        }

        rs.close();
        pst.close();
        conn.close();
    }

    // Convert to JSON and return response
    out.write("[\"" + String.join("\",\"", list) + "\"]");
} catch (Exception e) {
    e.printStackTrace();
} %>