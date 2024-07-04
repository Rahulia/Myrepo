import java.io.*;
import java.math.BigDecimal;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/SaveSubscriptionAndTrainerServlet")
public class SaveSubscriptionAndTrainerServlet extends HttpServlet {
  
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        
        
        int hallId = Integer.parseInt(request.getParameter("hallid")); 
        String zone = request.getParameter("zone"); 
        String section = request.getParameter("section"); 
        int rowNo = Integer.parseInt(request.getParameter("rowno"));
        int seatNumber = Integer.parseInt(request.getParameter("seatnumber"));
        String seatType = request.getParameter("seattype");
        String p = request.getParameter("price");
        out.print(hallId);
        
        BigDecimal price = new BigDecimal(p); // Replace with actual price 
        String status = request.getParameter("status"); // Replace with actual status 
        Connection connection = null; 
        PreparedStatement preparedStatement = null; 
        try { 
        	// Establish connection 
        	Class.forName("oracle.jdbc.driver.OracleDriver"); 
        	connection = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XE", "system", "raHULj69a");
        	int i=1;
        	for(i=1;i<seatNumber+1;i++) 
        	{
        	// Prepare SQL statement 
        	String sql = "INSERT INTO SeatMap (HallID, Zone, Section, RowNo, SeatNumber, SeatType, Price, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"; 
        	preparedStatement = connection.prepareStatement(sql); 
        	// Set parameters 
        	preparedStatement.setInt(1, hallId); 
        	preparedStatement.setString(2, zone); 
        	preparedStatement.setString(3, section); 
        	preparedStatement.setInt(4, rowNo); 
        	preparedStatement.setInt(5, i); 
        	preparedStatement.setString(6, seatType); 
        	preparedStatement.setBigDecimal(7, price); 
        	preparedStatement.setString(8, status); 
        	// Execute insert 
        	
        	int rowsInserted = preparedStatement.executeUpdate(); 
        	
        	if (rowsInserted > 0) 
        	{ 
        		out.println("<h2>Seat inserted successfully!</h2>"); 
        		} 
        	else { 
        		out.println("<h2>Failed to insert seat.</h2>"); }} 
        	} catch (ClassNotFoundException | SQLException e) 
        { 
        		e.printStackTrace(); 
        		out.println("<h2>Error: " + e.getMessage() + "</h2>"); 
        		} 
        	
        finally 
        { 
        			// Close resources try 
        }
        			{ 
        				if (preparedStatement != null) 
        			{ 
        					try {
								preparedStatement.close();
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} } 
        			if (connection != null) 
        			{ 
        				try {
							connection.close();
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} 
        			}
        			} 
        
        			} 
          
}

