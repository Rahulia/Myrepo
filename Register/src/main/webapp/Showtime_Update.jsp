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
                    ResultSet resultset = statement.executeQuery("select * from movies where movieid='" + umail + "'");
                %>

                <div class="card-body rounded-lg">
                    <form action=Movie_Listings_Update method="post">
                        <%
                            while(resultset.next()){
                        %>
                        <div class="form-group">
                        <label for="movieid">Title:</label>
                        <input type="hidden" class="form-control" name="movieid" value="<%= resultset.getString("movieid") %>"> 
                        </div>
                       
                        <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" class="form-control" name="title" value="<%= resultset.getString("title") %>"> 
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="genre" value="<%= resultset.getString("genre") %>">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="description" value="<%= resultset.getString("description") %>">
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" name="duration" value="<%= resultset.getString("duration") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="releaseDate" value="<%= resultset.getString("releaseDate") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="posterURL" value="<%= resultset.getString("posterURL") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="trailerURL" value="<%= resultset.getString("trailerURL") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="synopsis" value="<%= resultset.getString("synopsis") %>">
                        </div>
                        <div class="form-group">
                            <input type="hidden" class="form-control" name="castCrew" value="<%= resultset.getString("castCrew") %>">
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