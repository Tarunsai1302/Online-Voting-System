<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Vote for Your Candidate</title>

    <!-- Bootstrap & jQuery -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(135deg, #74ebd5, #ACB6E5);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Arial', sans-serif;
        }
        .container {
            max-width: 600px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h2 {
            color: #007bff;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-custom {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 12px 20px;
            margin: 10px;
            font-size: 18px;
            border-radius: 8px;
            transition: 0.3s;
        }
        .btn-custom:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }
        #candidateList {
            margin-top: 20px;
        }
        .loading {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Select Your Election Type</h2>

        <!-- Buttons for MLA and MP -->
        <button class="btn btn-custom" onclick="loadCandidates('MLA')">Vote for MLA</button>
        <button class="btn btn-custom" onclick="loadCandidates('MP')">Vote for MP</button>

        <!-- Loading Indicator -->
        <div class="loading" id="loading">Loading candidates...</div>

        <!-- Candidate List (Loaded Dynamically) -->
        <div id="candidateList"></div>
        <button class='btn btn-secondary' onclick='history.back()'>Back</button>
    </div>

    <script>
        function loadCandidates(type) {
            $("#candidateList").html(""); // Clear previous content
            $("#loading").show(); // Show loading text

            $.ajax({
                url: "FetchCandidates.jsp",
                type: "GET",
                data: { electionType: type },
                success: function(response) {
                    $("#loading").hide(); // Hide loading text
                    $("#candidateList").html(response);
                },
                error: function() {
                    $("#loading").hide();
                    $("#candidateList").html("<p class='text-danger'>Error loading candidates. Please try again.</p>");
                }
            });
        }
    </script>
</body>
</html>
