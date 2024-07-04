package ComCon;

import javax.servlet.annotation.WebServlet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Servlet implementation class CommonConnection
 */
@WebServlet("/CommonConnection")


public class CommonConnection {
    public static Connection getConnection() {
        Connection connection = null;
        
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
            System.out.println("Connected");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // Better to log the exception
        }
        
        return connection;
    }
}
