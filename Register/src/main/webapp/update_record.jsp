<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update User</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<style>
*{
    margin:0px;
    padding:0px;
}
</style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-6 offset-md-3">
            <div class="card rounded-lg border border-danger">
                <div class="card-header">
                    <h3 align="center">Update User</h3>
                </div>
                <%
                    String umail = request.getParameter("u");
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                    Statement statement = connection.createStatement();
                    ResultSet resultset = statement.executeQuery("select * from users where email='" + umail + "'");
                %>

                <div class="card-body rounded-lg">
                    <form action=UpdateServlet method="post">
                        <%
                            while(resultset.next()){
                        %>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="email" value="<%= resultset.getString("EMAIL") %>">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="fname" value="<%= resultset.getString("FIRST_NAME") %>">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="lname" value="<%= resultset.getString("LAST_NAME") %>">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="password" value="<%= resultset.getString("PASSWORD") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="gender" value="<%= resultset.getString("GENDER") %>">
                        </div>
                        <% } %>
                        <div class="card-footer text-center">
                            <input type="submit" name="submit" value="Update" id="update" class="btn btn-primary">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

