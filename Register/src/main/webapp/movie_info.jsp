<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movie Info</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card rounded-lg border border-danger mt-5">
                <div class="card-header text-center">
                    <h3>Showtime Listings</h3>
                </div>
                <div class="card-body">
                
                    <%
                        String movieid = request.getParameter("s");
                        String userID = request.getParameter("userid");
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                        PreparedStatement ps = connection.prepareStatement("SELECT * FROM Showtimes WHERE MovieID = ?");
                        ps.setString(1, movieid);
                        ResultSet rs = ps.executeQuery();
                    %>
                    <h2>User ID: <%= userID  %></h2>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Showtime ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                                    String showtimeid = rs.getString("ShowtimeID");
                                    String showDate = rs.getString("ShowDate");
                                    String showTime = rs.getString("ShowTime");
                                    String hallid = rs.getString("MovieID");
                                    String movid = rs.getString("MovieID");
                                    
                            %>
                            <tr>
                                <td><%= showtimeid %></td>
                                <td><%= showDate %></td>
                                <td><%= showTime %></td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#updateShowtimeModal" data-showtimeid="<%= showtimeid %>" data-showdate="<%= showDate %>" data-showtime="<%= showTime %>">Update</button>
                                    <a href="display.jsp?sid=<%= showtimeid %>&userID=<%= userID %>&mid=<%= movid %>&hid=<%= hallid %>&showtime=<%= showTime %>" class="btn btn-danger btn-sm">BOOK</a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    
                    
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

