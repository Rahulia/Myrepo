

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
 * Servlet implementation class Movie_Listings_Update
 */
@WebServlet("/Movie_Listings_Update")
public class Movie_Listings_Update extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    response.setContentType("text/html");
	    PrintWriter out = response.getWriter();
	    String movieid = request.getParameter("movieid");
	    String title = request.getParameter("title");
	    String genre = request.getParameter("genre");
	    String description = request.getParameter("description");
	    int duration = Integer.parseInt(request.getParameter("duration")); // Parse duration to int
	    String releaseDate = request.getParameter("releaseDate");
	    String posterURL = request.getParameter("posterURL");
	    String trailerURL = request.getParameter("trailerURL");
	    String synopsis = request.getParameter("synopsis");
	    String castCrew = request.getParameter("castCrew");

	    Connection connection = null;
	    PreparedStatement preparedStatement = null;

	    try {
	        Class.forName("oracle.jdbc.driver.OracleDriver");
	        connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

	        String updateQuery = "UPDATE Movies SET Title=?, Genre=?, Description=?, Duration=?, ReleaseDate=?, PosterURL=?, TrailerURL=?, Synopsis=?, CastCrew=? WHERE MovieID=?";
	        preparedStatement = connection.prepareStatement(updateQuery);

	        preparedStatement.setString(1, title);
	        preparedStatement.setString(2, genre);
	        preparedStatement.setString(3, description);
	        preparedStatement.setInt(4, duration);

	        // Convert releaseDate to java.sql.Date (assuming valid format from form)
	        preparedStatement.setString(5, releaseDate);

	        preparedStatement.setString(6, posterURL);
	        preparedStatement.setString(7, trailerURL);
	        preparedStatement.setString(8, synopsis);
	        preparedStatement.setString(9, castCrew);
	        preparedStatement.setString(10, movieid);

	        int rowsUpdated = preparedStatement.executeUpdate();

	        if (rowsUpdated > 0) {
	            response.sendRedirect("Movie_Listings.jsp"); // Redirect to success page
	        } else {
	            out.println("No movie found with ID " + movieid + " or update failed.");
	        }
	    } catch (NumberFormatException e) {
	        // Handle potential parsing error for duration (if form data is incorrect)
	        out.println("Error: Invalid duration format. Please enter a number.");
	    } catch (Exception e) {
	        // Catch other exceptions (e.g., database connection issues)
	        e.printStackTrace(out); // Print stack trace for debugging (consider logging instead in production)
	    } finally {
	        // Close resources
	        if (preparedStatement != null) {
	            try {
	                preparedStatement.close();
	            } catch (SQLException e) {
	                e.printStackTrace(out); // Consider logging instead
	            }
	        }
	        if (connection != null) {
	            try {
	                connection.close();
	            } catch (SQLException e) {
	                e.printStackTrace(out); // Consider logging instead
	            }
	        }
	    }
	}

}
