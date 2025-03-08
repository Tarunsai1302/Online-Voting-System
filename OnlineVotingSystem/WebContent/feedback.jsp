<%@page import="java.sql.ResultSet"%>
<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page import="com.mysql.cj.xdevapi.Result"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
String name=request.getParameter("name");
String email=request.getParameter("email");
String subject=request.getParameter("subject");
String message =request.getParameter("message");
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/scet","root","manager");
	PreparedStatement pst=conn.prepareStatement("insert into feedback values(?,?,?,?)");
	pst.setString(1, name);
	pst.setString(2, email);
	pst.setString(3, subject);
	pst.setString(4,message);
	int  i=pst.executeUpdate();
	if(i>0){
		out.println("<script>");
			out.println("alert('Feedback sent Successfull');");
			out.println("window.location.href='index.html';");
			out.println("</script>");
	}
	else{
		out.println("<script>");
			out.println("alert('Added Successfull');");
			out.println("window.location.href='index.html';");
			out.println("</script>");
	}
}
catch(Exception e){
	e.printStackTrace();
}




%>
</body>
</html>
