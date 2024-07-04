package ComCon;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet(name = "RegistaServlet", urlPatterns = { "/RegistaServlet" })
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        try{
        	// Establish database connection
        	Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");

            // Prepare SQL statement for registration
            String sql = "INSERT INTO users (email, first_name, last_name, password, gender) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, firstName);
            ps.setString(3, lastName);
            ps.setString(4, password); // Storing password without hashing (not recommended for production)
            ps.setString(5, gender);

            // Execute the statement
            int result = ps.executeUpdate();

            if (result > 0) {
                // Registration successful
                response.sendRedirect("Login.jsp"); // Redirect to success page
            } else {
                // Registration failed
                response.sendRedirect("Register.jsp"); // Redirect to failure page
            }

        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions properly in a production environment
        }
}

}
