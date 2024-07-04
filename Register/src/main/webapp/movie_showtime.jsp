<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Showtimes</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <header>
        <h1>Showtimes</h1>
    </header>

    <div id="showtime-list">
        <% 
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        Connection connection = null;
        Statement statement = null;
        ResultSet resultset = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviereservationsystem", "root", "password");
            statement = connection.createStatement();
            resultset = statement.executeQuery("SELECT * FROM Showtimes WHERE movieId=" + movieId);
            while(resultset.next()) {
        %>
        <div class="showtime-item">
            <h3><%= resultset.getString("hallName") %></h3>
            <p><%= resultset.getString("date") %></p>
            <% 
            String[] times = resultset.getString("times").split(",");
            for(String time : times) {
            %>
            <button onclick="location.href='seat_selection.jsp?showtimeId=<%= resultset.getInt("id") %>&time=<%= time %>'"><%= time %></button>
            <% } %>
        </div>
        <% 
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (resultset != null) try { resultset.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
        %>
    </div>
    
    <footer>
        <p>&copy; 2024 Movie Reservation System</p>
    </footer>
</body>
</html>
