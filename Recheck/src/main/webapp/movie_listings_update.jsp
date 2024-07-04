<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String movieId = request.getParameter("movieId");
    String title = "", genre = "", director = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
    	Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
        pstmt = conn.prepareStatement("SELECT * FROM movies WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(movieId));
        rs = pstmt.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            genre = rs.getString("genre");
            director = rs.getString("director");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Movie</title>
</head>
<body>
    <h1>Edit Movie</h1>
    <form action="movie_listings_update.java" method="post">
        <input type="hidden" name="movieId" value="<%= movieId %>">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" value="<%= title %>" required>
        <br>
        <label for="genre">Genre:</label>
        <input type="text" id="genre" name="genre" value="<%= genre %>" required>
        <br>
        <label for="director">Director:</label>
        <input type="text" id="director" name="director" value="<%= director %>" required>
        <br>
        <button type="submit">Update</button>
    </form>
</body>
</html>

