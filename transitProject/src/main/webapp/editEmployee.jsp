<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="model.Employee" %>
<%@ page import="dao.EmployeeDAO" %>
<%
    // Check if user is logged in as a manager
    String role = (String) session.getAttribute("role");
    if (role == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    int employeeID = Integer.parseInt(request.getParameter("employeeID"));
    EmployeeDAO employeeDAO = new EmployeeDAO();
    Employee employee = employeeDAO.getEmployeeById(employeeID); // Add this method in EmployeeDAO

    if ("update".equals(request.getParameter("action"))) {
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String ssn = request.getParameter("ssn");

        employee.setFirstName(fname);
        employee.setLastName(lname);
        employee.setUsername(username);
        employee.setPassword(password);
        employee.setSsn(ssn);

        if (employeeDAO.updateCustomerRep(employee)) {
            response.sendRedirect("manageEmployees.jsp?message=Employee updated successfully.");
            return;
        } else {
            request.setAttribute("error", "Failed to update employee.");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Employee</title>
    <link rel="stylesheet" href="styles.css">
    <script>
        // Display the toaster
        function showToaster(message, type) {
            const toaster = document.createElement('div');
            toaster.className = `toaster ${type}`;
            toaster.textContent = message;
            document.body.appendChild(toaster);
            toaster.style.display = "block";

        }

        // Client-side validation for SSN
        function validateSSN() {
            const ssnInput = document.getElementById("ssn");
            const ssnValue = ssnInput.value;
            const ssnPattern = /^\d{3}-\d{2}-\d{4}$/; // SSN pattern XXX-XX-XXXX

            if (!ssnPattern.test(ssnValue)) {
                showToaster("Invalid SSN format. Please use XXX-XX-XXXX.", "error");
                ssnInput.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="edit-employee-container">
        <!-- Navigation Bar -->
        <div class="navbar">
            <a href="managerDashboard.jsp">Back to Dashboard</a>
            <%
                String referer = request.getHeader("referer");
                if (referer != null && !referer.isEmpty()) {
            %>
                <a href="<%= referer %>" class="back-to-schedule">Back to Employees</a>
            <%
                }
            %>
        </div>

        <!-- Page Title -->
        <h2>Edit Employee</h2>

        <!-- Display Toaster for Errors -->
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) { 
        %>
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    showToaster("<%= error %>", "error");
                });
            </script>
        <% } %>

        <!-- Edit Employee Form -->
        <form action="editEmployee.jsp" method="post" onsubmit="return validateSSN()">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">

            <div class="form-group">
                <label for="fname">First Name:</label>
                <input type="text" id="fname" name="fname" value="<%= employee.getFirstName() %>" required>
            </div>

            <div class="form-group">
                <label for="lname">Last Name:</label>
                <input type="text" id="lname" name="lname" value="<%= employee.getLastName() %>" required>
            </div>

            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" value="<%= employee.getUsername() %>" required>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" value="<%= employee.getPassword() %>" required>
            </div>

            <div class="form-group">
                <label for="ssn">SSN:</label>
                <input type="text" id="ssn" name="ssn" value="<%= employee.getSsn() %>" placeholder="XXX-XX-XXXX" required>
            </div>

            <div class="form-buttons">
                <button type="submit" class="update-button">Update Employee</button>
            </div>
        </form>
    </div>

    <!-- Toaster for Success -->
    <%
        String successMessage = request.getParameter("successMessage");
        if (successMessage != null) {
    %>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                showToaster("<%= successMessage %>", "success");
            });
        </script>
    <% } %>
</body>
</html>
