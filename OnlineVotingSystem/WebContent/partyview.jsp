<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Political Parties</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #84fab0, #4FA3D1);
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 30px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
            overflow-x: auto; 
        }
        h2 {
            color: #007bff;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        img {
            width: 150px;
            height: 150px;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>List of Registered Political Parties</h2>

    <table>
        <tr>
        <th>Party Id</th>
            <th>Party Name</th>
            <th>President</th>
            <th>Secretary</th>
            <th>State</th>
            <th>Party Symbol</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

                PreparedStatement ps = con.prepareStatement("SELECT * FROM party");
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                	String partyid=rs.getString("partyid");
                    String partyName = rs.getString("partyname");
                    String president = rs.getString("partypresident");
                    String secretary = rs.getString("secretary");
                    String state = rs.getString("state");
                    String imagePath = rs.getString("partyimage"); 
        %>

        <tr>
        <td><%= partyid %></td>
            <td><%= partyName %></td>
            <td><%= president %></td>
            <td><%= secretary %></td>
            <td><%= state %></td>
<td><img src='images/<%= imagePath %>' width="100" height="100" class="img-thumbnail"></td>
<td>
                        <div class='btn-group'>
                            <button class='btn btn-danger' onclick="deleteCourse('<%= rs.getString(1) %>')">Delete</button>
                        </div>
                    </td>
</tr>




                
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<tr><td colspan='5' style='color: red;'>Database Error!</td></tr>");
            }
        %>
    </table>
    <div class='mt-4'>
            <button class='btn btn-secondary' onclick='history.back()'>Back</button>
        </div>
</div>
<script>
function deleteCourse(partyId) {
    if (confirm("Are you sure you want to delete this Party?")) {
        window.location.href = "delparty?partyid=" + partyId;
        }
    }
</script>
</body>
</html>