


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

import ComonCon.CommonConnection;

/**
 * Servlet implementation class delete
*/
@WebServlet("/delete")
public class delete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public delete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json"); // Set JSON content type
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email"); // Get email from request parameter

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            
            connection = CommonConnection.getConnection();

            String deleteQuery = "DELETE FROM users WHERE email = ?";
            preparedStatement = connection.prepareStatement(deleteQuery);

            preparedStatement.setString(1, email);

            int rowsDeleted = preparedStatement.executeUpdate();

            if (rowsDeleted > 0) {
                out.println("{\"status\": \"success\", \"message\": \"Student record deleted successfully!\"}");
            } else {
                out.println("{\"status\": \"error\", \"message\": \"Student record not found!\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"status\": \"error\", \"message\": \"Error deleting student record: " + e.getMessage() + "\"}");
        } finally {
            if (preparedStatement != null)
				try {
					preparedStatement.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            if (connection != null)
				try {
					connection.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
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
    
       
         

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
            System.out.println("Connected");
         // Update insert query to include all movie table columns
            String insertQuery = "INSERT INTO Movies (Title, Genre, Description, Duration, releaseDate, PosterURL, TrailerURL, Synopsis, CastCrew) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);
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
        } 
    }

}
