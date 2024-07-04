

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
 * Servlet implementation class Add_Show
 */
@WebServlet("/AddShow")
public class Add_Show extends HttpServlet {
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
        
        int MovieID=Integer.parseInt(request.getParameter("movieid"));
        int HallID=Integer.parseInt(request.getParameter("hallid"));
        String ShowDate = request.getParameter("showdate");
        String ShowTime = request.getParameter("showtime");
        String dipsplayformat = request.getParameter("format");
        out.print("ttttttttt"+HallID);
        out.print("ttttttttt       "+MovieID);
        out.print("tttttt       "+ShowDate);
        out.print("ttttttt       "+ShowTime);
        out.print("       "+dipsplayformat);
        
        
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
        		String query = "INSERT INTO Showtimes (MovieID, HallID, ShowDate, ShowTime, MovieType)VALUES (1, 1, '2024-07-05', '18:00:00', '3D')";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, MovieID);
                preparedStatement.setInt(2, HallID);
                preparedStatement.setString(3, ShowDate);
                preparedStatement.setString(4, ShowTime);
                preparedStatement.setString(5, "3D");
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
