

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Delete_Moviehalls
 */
@WebServlet("/Delete_Moviehalls")
public class Delete_Moviehalls extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        int hallID = Integer.parseInt(request.getParameter("d"));
        out.print(hallID);
        
        try {
            // Database connection
        	Class.forName("oracle.jdbc.driver.OracleDriver"); 
        	Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XE", "system", "raHULj69a");
            
            // Delete movie hall data from MovieHalls table
            String query = "BEGIN\n"
                    + "    DELETE FROM BookingSeats \n"
                    + "    WHERE SeatID IN (\n"
                    + "        SELECT SeatID \n"
                    + "        FROM SeatMap \n"
                    + "        WHERE HallID = ?\n"
                    + "    );\n"
                    + "\n"
                    + "    DELETE FROM Bookings \n"
                    + "    WHERE ShowtimeID IN (\n"
                    + "        SELECT ShowtimeID \n"
                    + "        FROM Showtimes \n"
                    + "        WHERE HallID = ?\n"
                    + "    );\n"
                    + "\n"
                    + "    DELETE FROM Showtimes \n"
                    + "    WHERE HallID = ?;\n"
                    + "\n"
                    + "    DELETE FROM SeatMap \n"
                    + "    WHERE HallID = ?;\n"
                    + "\n"
                    + "    DELETE FROM MovieHalls \n"
                    + "    WHERE HallID = ?;\n"
                    + "END;";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, hallID);
            pstmt.setInt(2, hallID);
            pstmt.setInt(3, hallID);
            pstmt.setInt(4, hallID);
            pstmt.setInt(5, hallID);
            
            int i = pstmt.executeUpdate();
            
            if(i > 0) {
                out.print("<p>Hall successfully deleted!</p>");
            }
            
            // Redirect back to the Hall_Seatmap.jsp page
            response.sendRedirect("Testseat.jsp");
            
            pstmt.close();
            conn.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

}
