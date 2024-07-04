import java.io.IOException;
import java.sql.Connection;
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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            
        	Connection con = CommonConnection.getConnection();

            // Prepare SQL statement for login validation
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // Assuming passwords are stored without hashing (not recommended)

            // Execute the statement
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email); // Store user email in session
                response.sendRedirect("GymHome.jsp"); // Redirect to home page
            } else {
                // Login failed
                response.sendRedirect("login.jsp"); // Redirect to failure page
            }

        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions properly in a production environment
        }
    }
}

