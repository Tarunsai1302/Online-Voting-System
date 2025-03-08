<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.servlet.annotation.MultipartConfig"%>
<%@page import="java.io.File"%>
<%@page import="java.nio.file.Paths"%>
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

String fname=request.getParameter("fname");
String lname=request.getParameter("lname");
String username=request.getParameter("un");
String email=request.getParameter("email");
String gender=request.getParameter("gender");
String emobile=request.getParameter("mobile");
long mobile=Long.parseLong(emobile);
String dob=request.getParameter("dob");
String address=request.getParameter("address");
String pincode=request.getParameter("pincode");
int pin=Integer.parseInt(pincode);
Part filepart=request.getPart("profile");
String fileName=      Paths.get(filepart.getSubmittedFileName()).getFileName().toString();

String uploadpath=   getServletContext().getRealPath("") + File.separator + "images";
  
    File file=new File(uploadpath);
      if(!file.exists()) 
   	   file.mkdir();
   	   String filepath=uploadpath + file.separator + fileName;
   	   filepart.write(filepath);
   	   try{
   		   Class.forName("com.mysql.cj.jdbc.Driver");
   		   Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/scet","root","manager");
   		   PreparedStatement pst=conn.prepareStatement("insert into voter values(?,?,?,?,?,?,?,?,?,?,?)");
   		pst.setString(1, fname);
   		pst.setString(2, lname);
   		pst.setString(3, username);
   		pst.setString(4, email);
   		pst.setString(5, gender);
   		pst.setLong(6, mobile);
   		pst.setString(7, dob);
   		pst.setString(8, address);
   		pst.setInt(9, pin);
   		pst.setString(10, fileName);
   		pst.setString(11,"Waiting");
   		
   		   int i=pst.executeUpdate();
   		   if(i==1){
   			   out.println("Login SuccessFulllll....");
   		   }else{
   			out.println("<script>");
   			out.println("alert('Issue in the registration');");
   			out.println("window.location.href='Voterlog.html';");
   			out.println("</script>");
   		   }
   	   }
   	catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}

%>
</body>
</html>