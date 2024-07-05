<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seat Selection</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        .seat {
            margin: 5px;
            font-size: 12px;
        }
        .seat-booked {
            background-color: red;
            cursor: not-allowed;
        }
        .seat-available {
            background-color: green;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center my-4">Select Your Seats</h2>
        <% 
            String showtimeID = request.getParameter("sid");
            Connection connection = null;
            PreparedStatement psSeats = null;
            PreparedStatement psBookingSeats = null;
            ResultSet rsSeats = null;
            ResultSet rsBookingSeats = null;
            
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                
                // Fetch the seat layout
                psSeats = connection.prepareStatement("SELECT * FROM SeatMap WHERE HallID = (SELECT HallID FROM Showtimes WHERE ShowtimeID = ?)");
                psSeats.setString(1, showtimeID);
                rsSeats = psSeats.executeQuery();
                
                // Fetch the booking status
                psBookingSeats = connection.prepareStatement("SELECT SeatID FROM BookingSeats WHERE BookingID IN (SELECT BookingID FROM Bookings WHERE ShowtimeID = ?)");
                psBookingSeats.setString(1, showtimeID);
                rsBookingSeats = psBookingSeats.executeQuery();
                
                // Store the booked seats in a set for quick lookup
                Set<Integer> bookedSeats = new HashSet<>();
                while (rsBookingSeats.next()) {
                    bookedSeats.add(rsBookingSeats.getInt("SeatID"));
                }
                
                // Display the seats
                Map<String, Map<Integer, List<Map<String, Object>>>> seatLayout = new HashMap<>();
                while (rsSeats.next()) {
                    String zone = rsSeats.getString("Zone");
                    int section = rsSeats.getInt("Section");
                    int rowNo = rsSeats.getInt("RowNo");
                    int seatID = rsSeats.getInt("SeatID");
                    int seatNumber = rsSeats.getInt("SeatNumber");
                    String seatType = rsSeats.getString("SeatType");
                    double price = rsSeats.getDouble("Price");
                    String status = rsSeats.getString("Status");

                    Map<String, Object> seatData = new HashMap<>();
                    seatData.put("SeatID", seatID);
                    seatData.put("SeatNumber", seatNumber);
                    seatData.put("SeatType", seatType);
                    seatData.put("Price", price);
                    seatData.put("Status", status);

                    seatLayout.computeIfAbsent(zone, k -> new HashMap<>())
                              .computeIfAbsent(section, k -> new ArrayList<>())
                              .add(seatData);
                }
                
                for (String zone : seatLayout.keySet()) {
                    out.println("<h3>Zone: " + zone + "</h3>");
                    for (int section : seatLayout.get(zone).keySet()) {
                        out.println("<h4>Section: " + section + "</h4>");
                        out.println("<div class='row'>");
                        for (Map<String, Object> seat : seatLayout.get(zone).get(section)) {
                            int seatID = (int) seat.get("SeatID");
                            int seatNumber = (int) seat.get("SeatNumber");
                            String seatStatus = bookedSeats.contains(seatID) ? "seat-booked" : "seat-available";
                            out.println("<div class='col seat " + seatStatus + "'>");
                            out.println("<input type='checkbox' name='seats' value='" + seatID + "' " + (bookedSeats.contains(seatID) ? "checked disabled" : "") + ">");
                            out.println("Seat " + seatNumber);
                            out.println("</div>");
                        }
                        out.println("</div>");
                    }
                }
            } catch(Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rsBookingSeats != null) rsBookingSeats.close();
                    if (rsSeats != null) rsSeats.close();
                    if (psBookingSeats != null) psBookingSeats.close();
                    if (psSeats != null) psSeats.close();
                    if (connection != null) connection.close();
                } catch(SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>


