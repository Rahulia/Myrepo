
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import ComonCon.CommonConnection;
@WebServlet("/ChooseSubscriptionServlet")
public class ChooseSubscriptionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subscriptionModel = request.getParameter("subscriptionModel");
        String trainer = request.getParameter("trainer");
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        try {
        	Connection con = CommonConnection.getConnection();
            // Prepare SQL statement to update user choices
            String sql = "UPDATE users SET subscription_model = ?, trainer = ? WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, subscriptionModel);
            ps.setString(2, trainer);
            ps.setString(3, userEmail);

            // Execute the statement
            int result = ps.executeUpdate();

            if (result > 0) {
                // Update successful
                response.sendRedirect("gymhome.jsp"); // Redirect to refresh data
            } else {
                // Update failed
                response.sendRedirect("error.jsp"); // Handle errors appropriately
            }

        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions properly in a production environment
        }
    }
}
