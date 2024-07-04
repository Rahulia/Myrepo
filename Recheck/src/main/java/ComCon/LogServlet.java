package ComCon;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class LogServlet
 */
@WebServlet("/LogServlet")
public class LogServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LogServlet() {
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
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String hallId = request.getParameter("hallId");
        if (hallId == null) hallId = "1";
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        out.print("hallId: " + hallId);
        String[] zones = request.getParameterValues("zoneName");
        out.print("zones: " + Arrays.toString(zones));

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XE", "system", "raHULj69a");
            connection.setAutoCommit(false); // Ensure autocommit is disabled

            Enumeration<String> parameterNames = request.getParameterNames();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                String[] paramValues = request.getParameterValues(paramName);
                out.println(paramName + ": " + String.join(", ", paramValues));
            }

            if (zones != null) {
                for (String zone : zones) {
                    out.print("zone: " + zone);
                    String[] sections = request.getParameterValues(zone + "_sectionName");
                    out.print("sections: " + Arrays.toString(sections));

                    if (sections != null) {
                        for (String section : sections) {
                            out.print("section: " + section);
                            String rowNoStr = request.getParameter(zone + "_" + section + "_rowNo");
                            String seatNumberStr = request.getParameter(zone + "_" + section + "_seatNumber");
                            String priceStr = request.getParameter(zone + "_" + section + "_zonePrice");
                            String status = request.getParameter(zone + "_" + section + "_status");

                            out.print("rowNoStr: " + rowNoStr);
                            out.print("seatNumberStr: " + seatNumberStr);
                            out.print("priceStr: " + priceStr);
                            out.print("status: " + status);

                            if (rowNoStr == null || seatNumberStr == null || priceStr == null || status == null) {
                                out.print("One of the required parameters is null");
                                continue;
                            }

                            int rowNo = Integer.parseInt(rowNoStr);
                            int seatNumber = Integer.parseInt(seatNumberStr);
                      
                            BigDecimal price = BigDecimal.valueOf(Double.parseDouble(priceStr));
                            String seatType = "Normal";
                          

                            for (int i = 1; i <= seatNumber; i++) {
                                String sql = "INSERT INTO SeatMap (HallID, Zone, Section, RowNo, SeatNumber, SeatType, Price, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                                out.print("SQL Query: " + sql);

                                preparedStatement = connection.prepareStatement(sql);
                                preparedStatement.setInt(1, Integer.parseInt(hallId));
                                preparedStatement.setString(2, zone);
                                preparedStatement.setString(3, section);
                                preparedStatement.setInt(4, rowNo);
                                preparedStatement.setInt(5, i);
                                preparedStatement.setString(6, seatType);
                                preparedStatement.setBigDecimal(7, price);
                                preparedStatement.setString(8, status);

                                out.print("Preparing to execute insert with values: HallID=" + hallId + ", Zone=" + zone + ", Section=" + section + ", RowNo=" + rowNo + ", SeatNumber=" + i + ", SeatType=" + seatType + ", Price=" + price + ", Status=" + status);

                                try {
                                    int result = preparedStatement.executeUpdate();
                                    if (result > 0) {
                                        out.print("Insert result: Success for SeatNumber=" + i);
                                    } else {
                                        out.print("Insert result: Failed for SeatNumber=" + i);
                                    }
                                } catch (SQLException e) {
                                    out.print("Error executing insert: " + e.getMessage());
                                    e.printStackTrace(out);
                                    out.print("Insert result: Not inserted for SeatNumber=" + i);
                                }
                            }
                        }
                    }
                }
            }

            connection.commit(); // Commit the transaction
            out.print("Data successfully inserted and committed.");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(out);
            out.print("Exception: " + e.getMessage());
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback the transaction on error
                } catch (SQLException ex) {
                    ex.printStackTrace(out);
                    out.print("Rollback Exception: " + ex.getMessage());
                }
            }
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace(out);
                out.print("Close Connection Exception: " + e.getMessage());
            }
        }
    }

}
