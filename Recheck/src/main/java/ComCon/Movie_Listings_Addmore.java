package ComCon;

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
 * Servlet implementation class Movie_Listings_Addmore
 */
@WebServlet("/Movie_Listings_Addmore")
public class Movie_Listings_Addmore extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String description = request.getParameter("description"); // Get description
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

         // Update insert query to include all movie table columns
            String insertQuery = "INSERT INTO Moviesx (Title, Genre, Description, Duration, releaseDate, PosterURL, TrailerURL, Synopsis, CastCrew) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(insertQuery);
            preparedStatement.setString(1, title);
            preparedStatement.setString(2, genre);
            preparedStatement.setString(3, description);
            preparedStatement.setInt(4, duration);         
            preparedStatement.setString(5, releaseDate); // Convert releaseDate to java.sql.Date
            preparedStatement.setString(6, posterURL);
            preparedStatement.setString(7, trailerURL);
            preparedStatement.setString(8, synopsis); // Update variable name to match table column (Synopsis)
            preparedStatement.setString(9, castCrew);

            int rowsInserted = preparedStatement.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("view.jsp");
            } else {
                out.println("Error adding new movie record!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage()+releaseDate);
        } finally {
            // Close resources
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }


}
