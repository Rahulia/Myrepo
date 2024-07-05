

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CheckServlet
 */
@WebServlet("/CheckServlet")
public class CheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] seatIds = request.getParameterValues("seat");
        String userId = request.getParameter("user");
        String sid = request.getParameter("sid");
        String hid = request.getParameter("hid");
        String mid = request.getParameter("mid");
        //String userId = request.getParameter("user");

        // Debugging: Print parameter values to the server logs
        System.out.println("Received parameters:");
        System.out.println("sid: " + sid);
        System.out.println("hid: " + hid);
        System.out.println("mid: " + mid);
        System.out.println("userId: " + userId);

        // Print the selected seatIds
        if (seatIds != null) {
            System.out.println("Selected seat IDs:");
            for (String seatId : seatIds) {
                System.out.println("seatId: " + seatId);
            }
        } else {
            System.out.println("seatIds: null");
        }

        // Validate input parameters
        if (seatIds == null || sid == null || hid == null || mid == null || userId == null ||
            sid.isEmpty() || hid.isEmpty() || mid.isEmpty() || userId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Required parameters are missing or empty");
            return;
        }

        try {
            // Parse numeric parameters and handle potential NumberFormatException
            int showtimeId = Integer.parseInt(sid);
            int hallId = Integer.parseInt(hid);
            int movieId = Integer.parseInt(mid);
            int user_id = Integer.parseInt(userId);

            // Database operations
            Connection connection = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Load the Oracle JDBC driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // Establish the database connection
                connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

                // Insert into Bookings table
                String insertBookingSQL = "INSERT INTO Bookings (UserID, ShowtimeID, TotalPrice) VALUES (?, ?, ?)";
                ps = connection.prepareStatement(insertBookingSQL, new String[]{"BookingID"});
                ps.setInt(1, user_id);
                ps.setInt(2, showtimeId);
                ps.setDouble(3, 0.0); // TotalPrice should be calculated based on seat prices

                int rowsInserted = ps.executeUpdate();

                if (rowsInserted > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);

                        // Insert into BookingSeats table
                        String insertBookingSeatsSQL = "INSERT INTO BookingSeats (BookingID, SeatID, Status) VALUES (?, ?, ?)";
                        ps = connection.prepareStatement(insertBookingSeatsSQL);

                        for (String seatId : seatIds) {
                            if (seatId == null || seatId.isEmpty()) {
                                continue;
                            }
                            ps.setInt(1, bookingId);
                            ps.setInt(2, Integer.parseInt(seatId));
                            ps.setString(3, "Booked");
                            ps.addBatch();
                        }

                        ps.executeBatch();
                    }
                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
                }
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            // Only redirect if the response has not been committed due to an error
            if (!response.isCommitted()) {
                response.sendRedirect("display.jsp?sid=" + sid + "&mid=" + mid + "&hid=" + hid);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input for numerical parameters");
            }
        }
        
    }

}
