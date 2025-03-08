<%@page import="java.sql.ResultSet"%>
<%@page import="com.mysql.cj.xdevapi.Result"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page import="java.io.PrintWriter" %>
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
//String un1="tarun@gmail.com";
//String un2="dileep@gmail.com";
//String p1="tar123";
//String p2="dil123";
// PrintWriter out=response.getWriter();
String email=request.getParameter("un");
String password=request.getParameter("pass");
try{
	Connection conn= dbconnect.GetConnection();
	PreparedStatement pst=conn.prepareStatement("select * from electioncommission where email='"+email+"' and password='"+password+"' ");
	ResultSet rs=pst.executeQuery();
	if(rs.next()){
		response.sendRedirect("menu.html");
	}
	else {
		out.println("<script>");
		out.println("alert('Invalid Credentials... Try with a valid Username and Password');");
		out.println("window.location.href='EClog.html';");
		out.println("</script>");

	}

	
}
catch(Exception e){
	e.printStackTrace();
}




%>
</body>
</html>