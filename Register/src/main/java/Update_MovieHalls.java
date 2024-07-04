

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
 * Servlet implementation class Update_MovieHalls
 */
@WebServlet("/Update_MovieHalls")
public class Update_MovieHalls extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the request
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        int hallId = Integer.parseInt(request.getParameter("hallid"));
        String hallName = request.getParameter("hallname");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String location = request.getParameter("location");
        out.print(hallId);
        

        // JDBC variables
        Connection conn = null;
        PreparedStatement stmt = null;

        /*try {
            // Establish JDBC connection
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

            // SQL query to update movie hall details
            String sql = "UPDATE MovieHalls SET HallName = ?, Capacity = ?, Location = ? WHERE HallID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, hallName);
            stmt.setInt(2, capacity);
            stmt.setString(3, location);
            stmt.setInt(4, hallId);

            // Execute the update
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Redirect back to a confirmation page or handle success
                response.sendRedirect("hall_updated.jsp");
            } else {
                // Handle update failure
                response.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            // Handle exceptions
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            // Close JDBC resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }*/
    }

}
