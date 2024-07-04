

import java.io.IOException;
import java.io.PrintWriter;
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
 * Servlet implementation class Add_MovieHalls
 */
@WebServlet("/Add_MovieHalls")
public class Add_MovieHalls extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        /*String hallid = request.getParameter("hallid");
        String zonee = request.getParameter("zone");
        String sectionn = request.getParameter("section");
        int rowno = Integer.parseInt(request.getParameter("rowno"));
        int seatnumber = Integer.parseInt(request.getParameter("seatnumber"));
        String seattype = request.getParameter("seattype");
        double price1 = Double.parseDouble(request.getParameter("price"));
        BigDecimal pricee = new BigDecimal(price1); 
        String statuss = request.getParameter("status");*/
        
        String hallName = request.getParameter("HallName");
        String location = request.getParameter("Location");
        int totalSeats = Integer.parseInt(request.getParameter("Capacity"));
        out.print("hbcjdsg"+hallName);
        
        //BigDecimal price = new BigDecimal(p); // Replace with actual price 
        //String status = request.getParameter("status"); // Replace with actual status 
        Connection connection = null; 
        PreparedStatement preparedStatement = null; 
        try { 
        	// Establish connection 
        	Class.forName("oracle.jdbc.driver.OracleDriver"); 
        	connection = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XE", "system", "raHULj69a");
        	//int i=1;
        	//for(i=1;i<seatNumber+1;i++) 
        	//{
        	// Prepare SQL statement 
        		String query = "INSERT INTO MovieHalls (Name, Location, Capacity) VALUES (?, ?, ?)";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setString(1, hallName);
                preparedStatement.setString(2, location);
                preparedStatement.setInt(3, totalSeats); 
        	// Execute insert 
        	
        	int rowsInserted = preparedStatement.executeUpdate(); 
        	
        	if (rowsInserted > 0) 
        	{ 
        		out.println("<h2>Seat inserted successfully!</h2>"); 
        		} 
        	else { 
        		out.println("<h2>Failed to insert seat.</h2>"); }//} 
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
