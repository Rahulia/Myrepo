<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Records with Update & Delete</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
<style>
*{
  margin:0px;
  padding:0px;
}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-Fyj4CNkQ8veWhs9amheHxEfP0qyvZ4atwjUlTvqQcwXVYO4mN9jLtA6MT0Jv9xr" crossorigin="anonymous"></script>
<script>
$(document).ready(function() {
  // Update button click handler
  $('.update-btn').click(function() {
    var email = $(this).data('email');
    var firstName = $(this).data('firstname');
    var lastName = $(this).data('lastname');
    var password = $(this).data('password');
    var gender = $(this).data('gender');

    // Populate update form with pre-filled data
    $('#updateEmail').val(email);
    $('#updateFirstName').val(firstName);
    $('#updateLastName').val(lastName);
    $('#updatePassword').val(password);
    $('#updateGender').val(gender);

    // Show update modal
    $('#updateModal').modal('show');
  });

  // Delete button click handler with confirmation
  $('.delete-btn').click(function() {
    var email = $(this).data('email');
    var confirmation = confirm("Are you sure you want to delete this student record (Email: " + email + ")?");

    if (confirmation) {
      // Send AJAX request to delete.java using email
      $.ajax({
        url: "delete.java",
        type: "GET",
        data: { email: email },
        success: function(response) {
          if (response.status === "success") {
            // Remove the deleted row using email
            var row = $(this).closest('tr').find('th:first-child'); // Find row based on email (first cell)
            if (row.text() === email) {
              row.closest('tr').remove();
            }
          } else {
            alert("Error deleting student record: " + response.message);
          }
        },
        error: function(jqXHR, textStatus, errorThrown) {
          console.error("AJAX Error:", textStatus, errorThrown);
          alert("An error occurred during deletion!");
        }
      });
    }
  });
});
</script>
</head>
<body>

<h2 align="center">Student Records</h2>
<table class="table table-hover text-center">
<thead>
<tr>
  <th scope="col">Email</th>
  <th scope="col">First Name</th>
  <th scope="col">Last Name</th>
  <th scope="col">Password</th>
  <th scope="col">Gender</th>
  <th scope="col">Actions</th>
</tr>
</thead>
<tbody>
<%
  Connection connection = null;
  Statement statement = null;
  ResultSet resultSet = null;

  try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a"); // Replace credentials
    System.out.println("Connected");
    statement = connection.createStatement();
    resultSet = statement.executeQuery
    	    ("select * from users");

    	    while (resultSet.next()) {
    	      String email = resultSet.getString("email");
    	      String firstName = resultSet.getString("first_name");
    	      String lastName = resultSet.getString("last_name");
    	      String password = resultSet.getString("password");
    	      String gender = resultSet.getString("gender");
    	%>
    	      <tr>
    	        <th scope="row"><%= email %></th>
    	        <td><b><%= firstName %></b></td>
    	        <td><b><%= lastName %></b></td>
    	        <td><b><%= password %></b></td>
    	        <td><b><%= gender %></b></td>
    	        <td>
    	          <button type="button" class="btn btn-primary btn-sm update-btn" data-email="<%= email %>" data-firstname="<%= firstName %>" data-lastname="<%= lastName %>" data-password="<%= password %>" data-gender="<%= gender %>">Update</button>
    	          <button type="button" class="btn btn-danger btn-sm delete-btn" data-email="<%= email %>">Delete</button>
    	        </td>
    	      </tr>
    	<%
    	    }
    	  } catch (Exception e) {
    	    e.printStackTrace();
    	  } finally {
    	    if (resultSet != null) resultSet.close();
    	    if (statement != null) statement.close();
    	    if (connection != null) connection.close();
    	  }
    	%>
    	</tbody>
    	</table>

    	<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel" aria-hidden="true">
    	  <div class="modal-dialog">
    	    <div class="modal-content">
    	      <div class="modal-header">
    	        <h5 class="modal-title" id="updateModalLabel">Update Student Record</h5>
    	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
    	          <span aria-hidden="true">&times;</span>
    	        </button>
    	      </div>
    	      <div class="modal-body">
    	        <form id="updateForm" method="post" action="update.java">
    	          <input type="hidden" name="email" id="updateEmail" value="">

    	          <div class="form-group">
    	            <label for="updateFirstName">First Name:</label>
    	            <input type="text" class="form-control" id="updateFirstName" name="firstName" placeholder="Enter First Name" required>
    	          </div>

    	          <div class="form-group">
    	            <label for="updateLastName">Last Name:</label>
    	            <input type="text" class="form-control" id="updateLastName" name="lastName" placeholder="Enter Last Name" required>
    	          </div>

    	          <div class="form-group">
    	            <label for="updatePassword">Password:</label>
    	            <input type="password" class="form-control" id="updatePassword" name="password" placeholder="Enter Password" required>
    	          </div>

    	          <div class="form-group">
    	            <label for="updateGender">Gender:</label>
    	            <select class="form-control" id="updateGender" name="gender" required>
    	              <option value="Male">Male</option>
    	              <option value="Female">Female</option>
    	              <option value="Other">Other</option>
    	            </select>
    	          </div>

    	          <button type="submit" class="btn btn-primary">Update</button>
    	        </form>
    	      </div>
    	    </div>
    	  </div>
    	</div>

    	</body>
    	</html>




                            