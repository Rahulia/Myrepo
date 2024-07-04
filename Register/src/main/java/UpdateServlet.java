

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdateServlet
 */
@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	    /**
	 * 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    response.setContentType("text/html");
	    PrintWriter out = response.getWriter();

	    String hallId = request.getParameter("hallId");
	    if (hallId == null) {
	        hallId = "1";
	    }

	    PreparedStatement preparedStatement = null;
	    int totalInsertedSeats = 0;

	    try {
	        // Database connection and prepared statement setup (replace with your implementation)
	        // ...

	        Enumeration<String> parameterNames = request.getParameterNames();
	        while (parameterNames.hasMoreElements()) {
	            String paramName = parameterNames.nextElement();

	            // Process zone data
	            if (paramName.startsWith("zone") && !paramName.equals("zoneName")) { // Ignore single "zoneName" parameter
	                String zoneName = paramName.split("_")[1];
	                out.println("Processing Zone: " + zoneName);

	                // Process sections within the zone
	                String[] sectionNames = request.getParameterValues(zoneName + "_sectionName");
	                if (sectionNames != null) {
	                    for (String sectionName : sectionNames) {
	                        out.println("Processing Section: " + sectionName);

	                        String rowNoStr = request.getParameter(zoneName + "_" + sectionName + "_rowNo");
	                        String seatNumberStr = request.getParameter(zoneName + "_" + sectionName + "_seatNumber");
	                        String priceStr = request.getParameter(zoneName + "_" + sectionName + "_seatPrice");
	                        String status = request.getParameter(zoneName + "_" + sectionName + "_status");

	                        // Validate required data before insertion
	                        boolean validData = true;
	                        if (rowNoStr == null || rowNoStr.isEmpty()) {
	                            out.println("Error: Missing Row No for section " + zoneName + "_" + sectionName + "<br>");
	                            validData = false;
	                        }
	                        if (seatNumberStr == null || seatNumberStr.isEmpty()) {
	                            out.println("Error: Missing Number of Seats for section " + zoneName + "_" + sectionName + "<br>");
	                            validData = false;
	                        }
	                        if (priceStr == null || priceStr.isEmpty()) {
	                            out.println("Error: Missing Price for section " + zoneName + "_" + sectionName + "<br>");
	                            validData = false;
	                        }

	                        if (validData) {
	                            try {
	                                int rowNo = Integer.parseInt(rowNoStr);
	                                int seatNumber = Integer.parseInt(seatNumberStr);
	                                BigDecimal price = new BigDecimal(priceStr);

	                                // Prepare and execute insert
	                                preparedStatement.setInt(1, Integer.parseInt(hallId));
	                                preparedStatement.setString(2, zoneName);
	                                preparedStatement.setString(3, sectionName);
	                                preparedStatement.setInt(4, rowNo);
	                                preparedStatement.setInt(5, seatNumber);
	                                preparedStatement.setString(6, "Normal"); // Assuming seat type is fixed
	                                preparedStatement.setBigDecimal(7, price);
	                                preparedStatement.setString(8, status);
	                                int result = preparedStatement.executeUpdate();
	                                totalInsertedSeats += result;

	                                if (result > 0) {
	                                    out.println("Inserted Seat: " + seatNumber);
	                                } else {
	                                    out.println("Failed to insert Seat: " + seatNumber);
	                                }
	                            } catch (NumberFormatException e) {
	                                out.println("Error parsing data for section: " + zoneName + "_" + sectionName + ". Exception: " + e.getMessage() + "<br>");
	                            }
	                        }
	                    }
	                }
	            }
	        }

	        // Commit the transaction (replace with your implementation)
	        // ...

	        out.println("Successfully inserted " + totalInsertedSeats + " seats.");
	    } catch (SQLException e) {
	        out.println("Error occurred while inserting seats: " + e.getMessage());
	        // Implement error handling for SQLException (e.g., logging the error)
	    } finally {
	        // Close connections (replace with your implementation)
	        // ...
	    }
	}

	
}

	
