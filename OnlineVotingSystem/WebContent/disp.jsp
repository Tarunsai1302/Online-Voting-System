<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>State Constituencies</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            height: 100vh;
        }

        .states-container {
            flex: 1;
            padding: 20px;
        }

        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            max-width: 800px;
            margin: auto;
            gap: 30px;
        }

        .state {
            position: relative;
            width: 200px;
            padding: 15px;
            border: 1px solid #000;
            cursor: pointer;
            background: #fff;
        }

        .state:hover::after, .state.active::after {
            content: " ▼";
            position: absolute;
            right: 10px;
        }

        .constituencies {
            max-height: 200px;
            overflow-y: auto;
            display: none;
            position: absolute;
            left: 100%;
            background: white;
            border: 1px solid #000;
            width: 200px;
            z-index: 1;
        }

        .constituencies div {
            padding: 5px;
            border-bottom: 1px solid #ddd;
        }

        .constituencies div:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>

<!-- States container -->
<div class="states-container">
    <div class="container">
        <% 
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            String[] states = {"AndhraPradesh", "Telangana"};

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "root");

                for (String state : states) {
                    pst = conn.prepareStatement("SELECT * FROM assemblyconstituencies WHERE state=?");
                    pst.setString(1, state);
                    rs = pst.executeQuery();
        %>

        <div class="state" onclick="toggleDropdown(event, this)">
            <%= state.replace("AndhraPradesh", "Andhra Pradesh") %>
            <div class="constituencies">
                <% int i = 1; while(rs.next()) { %>
                    <div><%= i + ". " + rs.getString(1) %></div>
                <% i++; } %>
            </div>
        </div>

        <% 
                rs.close();
                pst.close();
                } 
            } catch (Exception e) { 
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</div>

<script>
function toggleDropdown(event, element) {
    event.stopPropagation();
    let dropdown = element.querySelector(".constituencies");

    
    document.querySelectorAll(".state").forEach(state => {
        if (state !== element) {
            state.classList.remove("active");
            state.querySelector(".constituencies").style.display = "none";
        }
    });

    if (dropdown.style.display === "block") {
        dropdown.style.display = "none";
        element.classList.remove("active");
    } else {
        dropdown.style.display = "block";
        element.classList.add("active");
        
        dropdown.scrollTop = 0;
    }
}

document.addEventListener("click", function () {
    document.querySelectorAll(".constituencies").forEach(dropdown => {
        dropdown.style.display = "none";
    });

    document.querySelectorAll(".state").forEach(state => {
        state.classList.remove("active");
    });
});

</script>

</body>
</html>