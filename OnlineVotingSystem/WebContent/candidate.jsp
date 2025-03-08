<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate List</title>
    <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>
    <style>
        :root {
            --primary: #06BBCC;
            --light: #F0FBFC;
            --dark: #181d38;
        }
        body { 
            font-family: Arial, sans-serif; 
            background: linear-gradient(to right, #84fab0, #4FA3D1); 
            margin: 0; padding: 0; 
        }
        .container { 
            max-width: 95%; 
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
        .thead {
            background-color: var(--primary);
        }
        img { 
            width: 150px; 
            height: 150px; 
            border-radius: 5px; 
        }
    </style>
</head>
<body>

    <div class='container'>
        <h2>Registered Candidates</h2>
        <table class='table'>
            <thead class='thead'>
                <tr>
                    <th>Candidate ID</th><th>Election Year</th><th>Candidate Name</th><th>Date of Birth</th><th>Guardian Name</th>
                    <th>Cases (Civil/Criminal)</th><th>Annual Income</th><th>Party</th> <th>Position</th>
                    <th>State</th><th>Constituency</th><th>Profile Pic</th><th>Status</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");
                        PreparedStatement pst = conn.prepareStatement("SELECT * FROM candidates");
                        ResultSet rs = pst.executeQuery();
                        while (rs.next()) {
                            String imagePath = "uploads/" + rs.getString(6);  // Candidate picture
                            String status = rs.getString(14); // Status column
                %>
                <tr id="row-<%= rs.getInt(1) %>">
                    <td><%= rs.getInt(1) %></td>  <!-- Candidate ID -->
                    <td><%= rs.getString(2) %></td>  <!-- Election Year -->
                    <td><%= rs.getString(3) %></td>  <!-- Candidate Name -->
                    <td><%= rs.getString(4) %></td>  <!-- Date of Birth -->
                    <td><%= rs.getString(5) %></td>  <!-- Guardian Name -->
                    <td><%= rs.getString(7) %></td>  <!-- Cases -->
                    <td><%= rs.getDouble(8) %></td>  <!-- Annual Income -->
                    <td><%= rs.getString(9) %></td>
                    <td><%= rs.getString(10) %></td>  <!-- Position -->
                    <td><%= rs.getString(11) %></td> <!-- State -->
                    <td><%= rs.getString(12) %></td> <!-- Constituency -->
                    <td><img src='<%= request.getContextPath() + "/" + imagePath %>' class='img-thumbnail'></td>
                    <td id="status-<%= rs.getInt(1) %>"><%= status %></td> <!-- Status -->
                    <td>
                        <div class='btn-group'>
                            <button class='btn btn-success' onclick="updateCandidateStatus(<%= rs.getInt(1) %>, 'Approved')">Approve</button>
                            <button class='btn btn-danger' onclick="updateCandidateStatus(<%= rs.getInt(1) %>, 'Rejected')">Reject</button>
                        </div>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        pst.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                <tr><td colspan='13' class='alert alert-danger text-center'>Error fetching data. Please try again.</td></tr>
                <% } %>
            </tbody>
        </table>
        <div class='mt-4'>
            <button class='btn btn-secondary' onclick='history.back()'>Back</button>
        </div>
    </div>

<script>
function updateCandidateStatus(candidateId, status) {
    if (confirm("Are you sure you want to " + status.toLowerCase() + " this candidate?")) {
        fetch("updateCandidateStatus.jsp?candidateId=" + candidateId + "&status=" + status, {
            method: "GET"
        })
        .then(response => response.text())
        .then(data => {
            document.getElementById("status-" +candidateId).innerText = status;
        })
        .catch(error => console.error("Error updating status:", error));
    }
}
</script>

</body>
</html>
