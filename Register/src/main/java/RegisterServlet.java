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
@WebServlet(name = "RegistaServlet", urlPatterns = { "/RegistaServlet" })
public class RegisterServlet extends HttpServlet {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String hallid = request.getParameter("hallid");
        String zone = request.getParameter("zone");
        String section = request.getParameter("section");
        int rowno = Integer.parseInt(request.getParameter("rowno"));
        int seatnumber = Integer.parseInt(request.getParameter("seatnumber"));
        String seattype = request.getParameter("seattype");
        double price = Double.parseDouble(request.getParameter("price"));
        String status = request.getParameter("status");

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

            String insertQuery = "INSERT INTO SeatMap (HallID, Zone, Section, RowNo, SeatNumber, SeatType, Price, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(insertQuery);
            preparedStatement.setString(1, hallid);
            preparedStatement.setString(2, zone);
            preparedStatement.setString(3, section);
            preparedStatement.setInt(4, rowno);
            preparedStatement.setInt(5, seatnumber);
            preparedStatement.setString(6, seattype);
            preparedStatement.setDouble(7, price);
            preparedStatement.setString(8, status);

            int rowsInserted = preparedStatement.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("Hall_Seatmap.jsp?hallid=" + hallid);
            } else {
                out.println("Error adding new seat map record!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        } finally {
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
