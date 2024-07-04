<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seat Selection</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <style>
        .seat {
            width: 30px;
            height: 30px;
            margin: 5px;
            background-color: #b0c4de;
            cursor: pointer;
        }
        .available {
            background-color: #4CAF50;
        }
        .booked {
            background-color: #FF0000;
            cursor: not-allowed;
        }
        .selected {
            background-color: #FFD700;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card rounded-lg border border-danger mt-5">
                <div class="card-header text-center">
                    <h3>Seat Selection</h3>
                </div>
                <div class="card-body">
                    <%
                        String showtimeID = request.getParameter("sid");
                        String movieID = request.getParameter("mid");
                        String hallID = request.getParameter("hid");

                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

                        // Fetch seat layout
                        PreparedStatement seatStmt = connection.prepareStatement("SELECT * FROM SeatMap WHERE HallID = ?");
                        seatStmt.setString(1, hallID);
                        ResultSet seatRS = seatStmt.executeQuery();
                        Map<Integer, String> seatMap = new HashMap<>();
                        while (seatRS.next()) {
                            int seatID = seatRS.getInt("SeatID");
                            String status = seatRS.getString("Status");
                            seatMap.put(seatID, status);
                        }

                        // Fetch booked seats
                        PreparedStatement bookingStmt = connection.prepareStatement("SELECT * FROM BookingSeats WHERE ShowtimeID = ?");
                        bookingStmt.setString(1, showtimeID);
                        ResultSet bookingRS = bookingStmt.executeQuery();
                        while (bookingRS.next()) {
                            int seatID = bookingRS.getInt("SeatID");
                            seatMap.put(seatID, "Booked");
                        }
                    %>

                    <div id="seat-map" class="d-flex flex-wrap justify-content-center">
                        <% for (Map.Entry<Integer, String> entry : seatMap.entrySet()) { %>
                            <div class="seat <%= entry.getValue().toLowerCase() %>" data-seatid="<%= entry.getKey() %>"></div>
                        <% } %>
                    </div>

                    <div class="text-center mt-3">
                        <button id="book-btn" class="btn btn-primary">Book Selected Seats</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha384-KyZXEAg3QhqLMpG8r+Knujsl5+5hb7MD2iDdzXk5KPL5K5t+RiTAu6z/mn96iN0S" crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        $(".seat").click(function() {
            if (!$(this).hasClass("booked")) {
                $(this).toggleClass("selected");
            }
        });

        $("#book-btn").click(function() {
            let selectedSeats = [];
            $(".seat.selected").each(function() {
                selectedSeats.push($(this).data("seatid"));
            });

            if (selectedSeats.length > 0) {
                $.ajax({
                    url: "book_seats.jsp",
                    method: "POST",
                    data: {
                        seats: selectedSeats.join(","),
                        showtimeID: "<%= showtimeID %>"
                    },
                    success: function(response) {
                        alert(response);
                        location.reload();
                    }
                });
            } else {
                alert("Please select seats to book.");
            }
        });
    });
</script>
</body>
</html>

