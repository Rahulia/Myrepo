import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import ComonCon.CommonConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

            // Check Uusers table
            ps = connection.prepareStatement("SELECT * FROM Uusers WHERE Email = ? AND Password = ?");
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // User found in Uusers table
                int userID = rs.getInt("UserID");
          
                response.sendRedirect("user_homepage.jsp?userid="+userID);
            } else {
                // Check Admins table
                ps = connection.prepareStatement("SELECT * FROM Admins WHERE Email = ? AND Password = ?");
                ps.setString(1, email);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    // User found in Admins table
                    response.sendRedirect("admin_homepage.jsp?sid=<%= showtimeid %>");
                } else {
                    // User not found in either table
                    response.sendRedirect("register.jsp");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}

