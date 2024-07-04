<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
    <%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<style>
*{
margin:0px;
padding:0px;
}
</style>
</head>
<body>
<h2 align="center"> student records </h2>
<table class="table table-hover text-center">
<thead>
<tr>
<th scope="col">email</th>
<th scope="col">f name</th>
<th scope="col">l name</th>
<th scope="col">password</th>
<th scope="col">gender</th>
</tr>
</thead>
<tbody>
<% Connection connection=null;
Statement statement= null;
ResultSet resultset= null;

try{
	Class.forName("oracle.jdbc.driver.OracleDriver");
    connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
    System.out.println("Connected");
    statement = connection.createStatement();
    resultset = statement.executeQuery("select * from users");
    while(resultset.next()){
    	%>
    	<tr align="center">
    	<th scope="row"> <%out.println(resultset.getString("email"));%></th>
    	<td><b> <%out.println(resultset.getString("first_name"));%></b></td>
    	<td><b> <%out.println(resultset.getString("last_name"));%></b></td>
    	<td><b> <%out.println(resultset.getString("password"));%></b></td>
    	<td><b> <%out.println(resultset.getString("gender"));%></b></td>
    	</tr>
    	<% }
}catch(Exception e){
	e.printStackTrace();
}
    %>
</tbody>
</table>
          

</body>
</html>
