

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Create_Seatmap
 */
@WebServlet("/Create_Seatmap")
public class Create_Seatmap extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	 private static final String DB_URL = "jdbc:mysql://localhost:3306/your_database";
	    private static final String DB_USER = "your_username";
	    private static final String DB_PASSWORD = "your_password";

	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        int hallId = Integer.parseInt(request.getParameter("hallId"));
	        
	        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
	            String[] zoneNames = request.getParameterValues("zoneName");
	            
	            if (zoneNames != null) {
	                for (String zoneName : zoneNames) {
	                    int zoneIndex = Integer.parseInt(zoneName.replaceAll("[^0-9]", ""));
	                    String[] sectionNames = request.getParameterValues("sectionName" + zoneIndex);
	                    
	                    if (sectionNames != null) {
	                        for (String sectionName : sectionNames) {
	                            int sectionIndex = Integer.parseInt(sectionName.replaceAll("[^0-9]", ""));
	                            String seatNumberParam = request.getParameter("seatNumber" + zoneIndex + "_" + sectionIndex);
	                            int seatCount = Integer.parseInt(seatNumberParam);
	                            String zonePriceParam = request.getParameter("zonePrice" + zoneIndex + "_" + sectionIndex);
	                            String[] priceAndSeats = zonePriceParam.split(",");
	                            double price = Double.parseDouble(priceAndSeats[0]);
	                            int totalSeats = Integer.parseInt(priceAndSeats[1]);
	                            String status = request.getParameter("status" + zoneIndex + "_" + sectionIndex);

	                            for (int seatNumber = 1; seatNumber <= totalSeats; seatNumber++) {
	                                insertSeatMap(connection, hallId, zoneName, sectionName, 1, seatNumber, "NA", price, status, price + ":" + seatCount);
	                            }
	                        }
	                    }
	                }
	            }

	            response.sendRedirect("seatmap_success.jsp");
	        } catch (SQLException e) {
	            e.printStackTrace();
	            response.sendRedirect("seatmap_error.jsp");
	        }
	    }

	    private void insertSeatMap(Connection connection, int hallId, String zone, String section, int row, int seatNumber, String seatType, double price, String status, String zonePriceDefinition) throws SQLException {
	        String sql = "INSERT INTO SeatMap (HallID, Zone, Section, Row, SeatNumber, SeatType, Price, Status, ZonePriceDefinition) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        try (PreparedStatement statement = connection.prepareStatement(sql)) {
	            statement.setInt(1, hallId);
	            statement.setString(2, zone);
	            statement.setString(3, section);
	            statement.setInt(4, row);
	            statement.setInt(5, seatNumber);
	            statement.setString(6, seatType);
	            statement.setDouble(7, price);
	            statement.setString(8, status);
	            statement.setString(9, zonePriceDefinition);
	            statement.executeUpdate();
	        }
	    }

}
