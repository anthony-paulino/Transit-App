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
</head>
<body>
    <h2>Edit Employee</h2>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p style="color:red;"><%= error %></p>
    <%
        }
    %>
    <form action="editEmployee.jsp" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
        First Name: <input type="text" name="fname" value="<%= employee.getFirstName() %>" required><br>
        Last Name: <input type="text" name="lname" value="<%= employee.getLastName() %>" required><br>
        Username: <input type="text" name="username" value="<%= employee.getUsername() %>" required><br>
        Password: <input type="password" name="password" value="<%= employee.getPassword() %>" required><br>
        SSN: <input type="text" name="ssn" value="<%= employee.getSsn() %>" required><br>
        <button type="submit">Update Employee</button>
    </form>

    <!-- Return to Manage Employees -->
    <form action="manageEmployees.jsp" method="get" style="margin-top:20px;">
        <button type="submit">Back to Manage Employees</button>
    </form>
</body>
</html>