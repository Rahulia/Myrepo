<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seat Selection</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        .container {
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        .zone-container {
            margin-bottom: 20px;
        }
        .row-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-bottom: 10px;
            transition: all 0.3s ease-in-out;
        }
        .row-container:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .seat {
            width: 40px;
            height: 40px;
            background-image: url('seat-available.png');
            background-size: cover;
            margin: 5px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .seat.selected {
            background-image: url('seat-selected.png');
        }
        .seat.sold {
            background-image: url('seat-sold.png');
            cursor: not-allowed;
        }
        .zone-title {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 18px;
            color: #333;
        }
        .price {
            margin-left: 20px;
            font-weight: bold;
            color: #555;
        }
        .btn {
            display: inline-block;
            font-weight: 400;
            color: #212529;
            text-align: center;
            vertical-align: middle;
            user-select: none;
            background-color: #007bff;
            border: 1px solid transparent;
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: 0.25rem;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        .btn-primary {
            color: #fff;
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            color: #fff;
            background-color: #0056b3;
            border-color: #004085;
        }
        .card {
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.5s ease-in-out;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #ddd;
            padding: 0.75rem 1.25rem;
            font-size: 1.25rem;
            text-align: center;
        }
        .card-body {
            padding: 1.25rem;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                    <h2>User ID: <%= user %></h2>
                    <input type="hidden" name="sid" value="<%= request.getParameter("sid") %>">
                    <input type="hidden" name="mid" value="<%= request.getParameter("mid") %>">
                    <input type="hidden" name="hid" value="<%= request.getParameter("hid") %>">
                    <input type="hidden" name="user" value="<%= user %>">

                    <% 
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

                        // Retrieve unique zones and their prices
                        PreparedStatement zonePs = connection.prepareStatement("SELECT DISTINCT Zone, Price FROM SeatMap WHERE HallID = ? ORDER BY Zone");
                        zonePs.setString(1, hid);
                        ResultSet zoneRs = zonePs.executeQuery();

                        while (zoneRs.next()) {
                            String zone = zoneRs.getString("Zone");
                            int price = zoneRs.getInt("Price");

                            // Select seats based on zone and order by row and seat number
                            PreparedStatement ps = connection.prepareStatement("SELECT * FROM SeatMap WHERE HallID = ? AND Zone = ? ORDER BY RowNo, SeatNumber");
                            ps.setString(1, hid);
                            ps.setString(2, zone);
                            ResultSet rs = ps.executeQuery();
                    %>
                    <div class="zone-container">
                        <div class="zone-title"><%= zone %> - ₹<%= price %></div>
                        <%
                            int currentRow = -1;
                            while (rs.next()) {
                                int seatId = rs.getInt("SeatID");
                                int rowNo = rs.getInt("RowNo");
                                int seatNumber = rs.getInt("SeatNumber");

                                if (rowNo != currentRow) {
                                    if (currentRow != -1) {
                                        // Close the previous row container
                                        %>
                                        <span class="price">₹<%= price %></span></div>
                                        <%
                                    }
                                    currentRow = rowNo;
                                    %>
                                    <div class="row-container">
                                    <%
                                }

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

                                String checked = isBooked ? "sold" : "";
                        %>
                        <div class="seat <%= checked %>" data-seat-id="<%= seatId %>"></div>
                        <%
                            }
                            if (currentRow != -1) {
                                // Close the last row container
                                %>
                                <span class="price">₹<%= price %></span></div>
                                <%
                            }
                            rs.close();
                            ps.close();
                        %>
                    </div>
                    <%
                        }
                        zoneRs.close();
                        zonePs.close();
                        connection.close();
                    %>

                    <button type="submit" class="btn btn-primary">Book Selected Seats</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('.seat').not('.sold').on('click', function() {
            $(this).toggleClass('selected');
        });

        $('form').on('submit', function() {
            let selectedSeats = [];
            $('.seat.selected').each(function() {
                selectedSeats.push($(this).data('seat-id'));
            });
            $('<input>').attr({
                type: 'hidden',
                name: 'selectedSeats',
                value: selectedSeats.join(',')
            }).appendTo('form');
        });
    });
</script>
</body>
</html>







