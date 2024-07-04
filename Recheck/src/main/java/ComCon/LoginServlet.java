package ComCon;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
    	response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.print("vhvjcc");
        
        /*
        String hallId = request.getParameter("hallId");
        String[] zoneNames = request.getParameterValues("zoneName");
        String[] sectionNames = request.getParameterValues("sectionName");
        String[] seatNumbers = request.getParameterValues("seatNumber");
        String[] zonePrices = request.getParameterValues("zonePrice");
        String[] statuses = request.getParameterValues("status");
        String[] rowNumbers = request.getParameterValues("rowNo");
        out.print(hallId);

        /* 
        String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "system";
        String password = "raHULj69a";

        // SQL query to insert into SeatMap
        String sql = "INSERT INTO SeatMap (HallID, Zone, Section, RowNo, SeatNumber, SeatType, Price, Status) " +
                     "VALUES (?, ?, ?, ?, ?, 'NA', ?, ?)";

        try (
            // Establish database connection
            Connection conn = DriverManager.getConnection(jdbcUrl, username, password);
            // Prepare the SQL statement for batch execution
            PreparedStatement statement = conn.prepareStatement(sql);
        ) {
            // Iterate over the received data arrays
            for (int i = 0; i < zoneNames.length; i++) {
                // Split zonePrice to separate price and number of seats
                String[] priceParts = zonePrices[i].split(",");
                double price = Double.parseDouble(priceParts[0].trim());
                @SuppressWarnings("unused")
				int numberOfSeats = Integer.parseInt(priceParts[1].trim());

                // Set parameters for the prepared statement
                statement.setString(1, hallId);
                statement.setString(2, zoneNames[i]);
                statement.setString(3, sectionNames[i]);
                statement.setInt(4, Integer.parseInt(rowNumbers[i]));
                statement.setInt(5, Integer.parseInt(seatNumbers[i]));
                statement.setDouble(6, price);
                statement.setString(7, statuses[i]);

                // Add statement to batch (for batch processing)
                statement.addBatch();
            }

            // Execute the batch insert
            @SuppressWarnings("unused")
			int[] insertCounts = statement.executeBatch();

            // Handle the results if needed
            // ...

            // Commit the transaction
            conn.commit();
        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
        }*/
    }

}
