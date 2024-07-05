<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seat Selection</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card rounded-lg border border-danger mt-5">
                <div class="card-header text-center">
                    <h3>Select Seats</h3>
                </div>
                <div class="card-body">
                    <form action="CheckServlet" method="post">
                    <%
                            String sid = request.getParameter("sid");
                            String hid = request.getParameter("hid");
                            String user = request.getParameter("userID");
                            
                          %>
                          <%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("userID") == null) {
        response.sendRedirect("login.jsp"); // Redirect to login page if session is null or userID is not set
        return;
    }

    int userID = (Integer) session.getAttribute("userID");
    
    
%>
<h2>User ID: <%= userID  %></h2>
                        <input type="hidden" name="sid" value="<%= request.getParameter("sid") %>">
                        <input type="hidden" name="mid" value="<%= request.getParameter("mid") %>">
                        <input type="hidden" name="hid" value="<%= request.getParameter("hid") %>">
                        <input type="hidden" name="user" value="<%= user %>"> <!-- Assuming userId is stored in session -->

                          
                            <!-- Add the User ID check here -->
                            <h2>User ID: <%= user %></h2>

                           <% Class.forName("oracle.jdbc.driver.OracleDriver");
                            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                            PreparedStatement ps = connection.prepareStatement("SELECT * FROM SeatMap WHERE HallID = ?");
                            ps.setString(1, hid);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                int seatId = rs.getInt("SeatID");
                                int rowNo = rs.getInt("RowNo");
                                int seatNumber = rs.getInt("SeatNumber");
                                String status = rs.getString("Status");

                                // Check if the seat is booked
                                PreparedStatement checkBookingPs = connection.prepareStatement("SELECT * FROM BookingSeats WHERE SeatID = ? AND BookingID IN (SELECT BookingID FROM Bookings WHERE ShowtimeID = ?)");
                                checkBookingPs.setInt(1, seatId);
                                checkBookingPs.setString(2, sid);
                                ResultSet checkBookingRs = checkBookingPs.executeQuery();

                                boolean isBooked = false;
                                if (checkBookingRs.next()) {
                                    isBooked = true;
                                }

                                checkBookingRs.close();
                                checkBookingPs.close();

                                String checked = isBooked ? "checked disabled" : "";
                                %>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="seat" value="<%= seatId %>" <%= checked %> >
                                    <label class="form-check-label">
                                        Row <%= rowNo %> Seat <%= seatNumber %>
                                    </label>
                                </div>
                                <%
                            }
                            rs.close();
                            ps.close();
                            connection.close();
                        %>

                        <button type="submit" class="btn btn-primary">Book Selected Seats</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>




