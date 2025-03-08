<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>
<%@page import="java.sql.Connection"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
    :root {
            --primary: #06BBCC;
            --light: #F0FBFC;
            --dark: #181d38;
        }
        /* Background */
        body {
          /*  background: linear-gradient(to right, #87CEEB, #00BFFF); */
          background-color:var(--light);
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
        }

        

        /* Sidebar */
        .sidebar {
            height: 100vh;
            width: 250px;
            position: fixed;
            background: linear-gradient(to bottom, #4682B4, #1E90FF); /* Darker Blue Gradient */
            backdrop-filter: blur(10px);
            padding-top: 80px;
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }

        .sidebar a {
            padding: 10px 15px;
            text-decoration: none;
            color: white;
            display: block;
        }

        .sidebar a:hover {
            background: #495057;
        }

        /* Content */
        .content {
            margin-left: 250px;
            padding: 20px;
            width: calc(100% - 250px);
        }

        /* Registration Form */
        .registration-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

      .custom-card {
  /*  background: linear-gradient(to bottom, #4682B4, #00BFFF);   */
  background-color:var(--primary);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 700px; /* Increased width */
}


        .btn-gradient {
            background: linear-gradient(to right, #00BFFF, #4682B4);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .btn-gradient:hover {
            background: linear-gradient(to right, #4682B4, #00BFFF);
        }
    </style>
</head>
<body>
<%
    // Get voterId from request
   // String voterId = request.getParameter("voterId");
HttpSession httpSession = request.getSession();
Object voterIdObj = httpSession.getAttribute("voterId");

if (voterIdObj == null) {
    out.println("<p class='text-danger text-center'>Error: User is not logged in!</p>");
    return;
}

String voterId = voterIdObj.toString();

    // Database connection
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Default values
    String name = "", fatherName = "", motherName = "", address = "", state = "", 
           parliament = "", assembly = "", gender = "", mobile = "", dob = "", profile = "default.png";

    try {
        // Load MySQL driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

        // Fetch voter details
        ps = con.prepareStatement("SELECT * FROM voter WHERE voterid=?");
        ps.setString(1, voterId);
        rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            fatherName = rs.getString("fathername");
            motherName = rs.getString("mothername");
            address = rs.getString("address");
            state = rs.getString("state");
            
            gender = rs.getString("gender");
            mobile = rs.getString("mobile");
            dob = rs.getString("dob");
            profile = rs.getString("profile");
            
            parliament = rs.getString("parlimentconstituency"); // Ensure correct column name
            assembly = rs.getString("assemblyconstituency");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
    
%>

    <div class="container mt-5">
        <h2 class="text-center">Update Profile</h2>
        <form id="updateProfileForm" action="updatedemo" method="post" enctype="multipart/form-data">
            <div class="mb-3">
            <input type="hidden"  name="voterId" class="form-control" value="<%=voterId %>" />
                <label class="form-label" for="fname">Voter Name</label>
                <input type="text" id="fname" name="fname" class="form-control" value="<%=name %>" required />
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label" for="lname">Father Name</label>
                    <input type="text" id="lname" name="lname" class="form-control" value="<%=fatherName %>" required />
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label" for="mname">Mother Name</label>
                    <input type="text" id="mname" name="mname" class="form-control" value="<%=motherName %>"required />
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label" for="address">Address</label>
                <textarea id="address" name="address" class="form-control" rows="3" required><%=address %></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label" for="state">State</label>
                <select id="stateDropdown" name="state" class="form-select" value="<%=state %>" required>
                    <option value="">Select State</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label" for="pconst">Parliament Constituency</label>
                <select id="parliamentDropdown" name="pconst" class="form-select" value="<%=parliament %>"required>
                    <option value="">Select Parliamentary Constituency</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label" for="aconst">Assembly Constituency</label>
                <select id="assemblyDropdown" name="aconst" class="form-select" value="<%=assembly %>"required>
                    <option value="">Select Assembly Constituency</option>
                </select>
            </div>
            <div class="mb-3">
    <label class="form-label" for="gender">Gender</label>
    <select id="gender" name="gender" class="form-select" required>
        <option value="">Select Gender</option>
        <option value="male" <%= "male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
        <option value="female" <%= "female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
        <option value="other" <%= "other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
    </select>
</div>


            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label" for="mobile">Mobile</label>
                    <input type="tel" id="mobile" name="mobile" class="form-control" value="<%=mobile %>"required />
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label" for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" class="form-control" value="<%=dob %>"required />
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label" for="pic">Profile Pic</label>
                <input type="file" id="pic" name="profile" accept="image/*" value="<%=profile %>"class="form-control" />
            </div>
            <div class="d-flex justify-content-center">
                <button type="submit" class="btn btn-primary">Update</button>
                <button type="button" class="btn btn-secondary ms-3" onclick="history.back()">Back</button>
            </div>
        </form>
    </div>

    <script>
    // These values should be set dynamically from the backend (JSP)
    let defaultState = "<%= state != null ? state : "" %>"; // Pre-selected State
    let defaultParliament = "<%= parliament != null ? parliament : "" %>"; // Pre-selected Parliament
    let defaultAssembly = "<%= assembly != null ? assembly : "" %>"; // Pre-selected Assembly

    function loadStates() {
        return new Promise((resolve, reject) => {
            fetch(`http://localhost:8085/OnlineVotingSystem/StateConstituencyServlet`)
                .then(response => response.json())
                .then(states => {
                    let dropdown = document.getElementById("stateDropdown");

                    // Reset dropdown
                    dropdown.innerHTML = '<option value="">Select State</option>';

                    // Populate states dynamically
                    states.forEach(state => {
                        let option = document.createElement("option");
                        option.value = state;
                        option.textContent = state;
                        dropdown.appendChild(option);
                    });

                    // Set default state
                    if (defaultState) {
                        dropdown.value = defaultState;
                    }

                    resolve(); // Notify that states are loaded
                })
                .catch(error => {
                    console.error("Error loading states:", error);
                    reject(error);
                });
        });
    }

    function loadParliamentaryConstituencies() {
        let selectedState = document.getElementById("stateDropdown").value;
        let parliamentDropdown = document.getElementById("parliamentDropdown");

        if (!selectedState) {
            parliamentDropdown.innerHTML = '<option value="">Select Parliamentary Constituency</option>';
            return;
        }

        let url = "http://localhost:8085/OnlineVotingSystem/StateConstituencyServlet?state=" + encodeURIComponent(selectedState);

        fetch(url)
            .then(response => response.json())
            .then(constituencies => {
                parliamentDropdown.innerHTML = '<option value="">Select Parliamentary Constituency</option>';

                if (!Array.isArray(constituencies)) {
                    console.error("Invalid data format received", constituencies);
                    return;
                }

                constituencies.forEach(constituency => {
                    let option = document.createElement("option");
                    option.value = constituency;
                    option.textContent = constituency;
                    parliamentDropdown.appendChild(option);
                });

                // Set default parliament if available
                if (defaultParliament) {
                    parliamentDropdown.value = defaultParliament;
                    loadAssemblyConstituencies(); // Load assemblies after parliament is set
                }
            })
            .catch(error => {
                console.error("Error loading parliamentary constituencies:", error);
                parliamentDropdown.innerHTML = '<option value="">Error loading parliamentary constituencies</option>';
            });
    }

    function loadAssemblyConstituencies() {
        let selectedParliament = document.getElementById("parliamentDropdown").value;
        let assemblyDropdown = document.getElementById("assemblyDropdown");

        if (!selectedParliament) {
            assemblyDropdown.innerHTML = '<option value="">Select Assembly Constituency</option>';
            return;
        }

        let url = "http://localhost:8085/OnlineVotingSystem/NewFile.jsp?parliament=" + encodeURIComponent(selectedParliament);

        fetch(url)
            .then(response => response.json())
            .then(assemblies => {
                assemblyDropdown.innerHTML = '<option value="">Select Assembly Constituency</option>';

                if (!Array.isArray(assemblies)) {
                    console.error("Invalid JSON format received:", assemblies);
                    return;
                }

                assemblies.forEach(assembly => {
                    let option = document.createElement("option");
                    option.value = assembly;
                    option.textContent = assembly;
                    assemblyDropdown.appendChild(option);
                });

                // Set default assembly if available
                if (defaultAssembly) {
                    assemblyDropdown.value = defaultAssembly;
                }
            })
            .catch(error => {
                console.error("Error loading assembly constituencies:", error);
                assemblyDropdown.innerHTML = '<option value="">Error loading assembly constituencies</option>';
            });
    }

    // Ensure the proper order of execution on page load
    window.onload = function () {
        loadStates().then(() => {
            if (defaultState) {
                loadParliamentaryConstituencies();
            }
        });
    };

    // Event Listeners
    document.getElementById("stateDropdown").addEventListener("change", loadParliamentaryConstituencies);
    document.getElementById("parliamentDropdown").addEventListener("change", loadAssemblyConstituencies);
</script>

</body>
</html>
