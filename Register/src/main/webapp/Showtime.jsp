<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Showtime Listings</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="card rounded-lg border border-danger mt-5">
                <div class="card-header text-center">
                    <h3>Showtime Listings</h3>
                </div>
                <div class="card-body">
                    <%
                        String movieid = request.getParameter("s");
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                        PreparedStatement ps = connection.prepareStatement("SELECT * FROM Showtimes WHERE MovieID = ?");
                        ps.setString(1, movieid);
                        ResultSet rs = ps.executeQuery();
                    %>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Showtime ID</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                                    String showtimeid = rs.getString("ShowtimeID");
                                    String showDate = rs.getString("ShowDate");
                                    String showTime = rs.getString("ShowTime");
                            %>
                            <tr>
                                <td><%= showtimeid %></td>
                                <td><%= showDate %></td>
                                <td><%= showTime %></td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#updateShowtimeModal" data-showtimeid="<%= showtimeid %>" data-showdate="<%= showDate %>" data-showtime="<%= showTime %>">Update</button>
                                    <a href="Delete_Showtime.java?showtimeid=<%= showtimeid %>" class="btn btn-danger btn-sm">Delete</a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <button class="btn btn-success" data-toggle="modal" data-target="#addShowtimeModal">Add Showtime</button>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Showtime Modal -->
<div class="modal fade" id="addShowtimeModal" tabindex="-1" role="dialog" aria-labelledby="addShowtimeModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form id="addShowtimeForm" action="AddShow" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="addShowtimeModalLabel">Add Showtime</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="movieid" value="<%= movieid %>">
                    <div class="form-group">
                        <label for="selectHall">Select Hall</label>
                        <select class="form-control" id="selectHall" name="hallid">
                            <% 
                                Class.forName("oracle.jdbc.driver.OracleDriver");
                                connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                                Statement statement = connection.createStatement();
                                rs = statement.executeQuery("SELECT HallID, Name FROM MovieHalls");
                                boolean hasData = false; // Flag to check if there's any data
                                while (rs.next()) {
                                    hasData = true; // Set flag to true if there's data
                                    int hallid = rs.getInt("HallID");
                                    String hallName = rs.getString("Name");
                            %>
                            <option value="<%= hallid %>"><%= hallName %></option>
                            <% } 
                                rs.close();
                                statement.close();
                                connection.close();
                                
                                if (!hasData) {
                            %>
                            <option value="" disabled selected>No halls available</option>
                            <% } else { %>
                            <option value="" disabled selected>Please select a hall</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="addShowDate">Date</label>
                        <input type="text" class="form-control" id="addShowDate" name="showdate" placeholder="YYYY-MM-DD" required>
                    </div>
                    <div class="form-group">
                        <label for="addShowTime">Time</label>
                        <input type="text" class="form-control" id="addShowTime" name="showtime" placeholder="HH:MM:SS" required>
                    </div>
                    <div class="form-group">
                        <label for="addFormat">Format</label>
                        <input type="text" class="form-control" id="addFormat" name="format" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <% if (!hasData) { %>
                    <button type="button" class="btn btn-info" onclick="location.href='Hall_Seatmap.jsp'">New Hall</button>
                    <% } else { %>
                    <button type="button" class="btn btn-info" onclick="location.href='Hall_Seatmap.jsp'">New Hall</button>
                    <button type="submit" class="btn btn-primary" onclick="return validateForm()">Add Showtime</button>
                    <% } %>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        var hallSelect = document.getElementById('selectHall');
        var selectedHall = hallSelect.value;
        if (selectedHall === '') {
            alert('Please select a hall to continue.');
            return false;
        }
        return true;
    }
</script>





<!-- Update Showtime Modal -->
<div class="modal fade" id="updateShowtimeModal" tabindex="-1" role="dialog" aria-labelledby="updateShowtimeModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="Update_Showtime.java" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateShowtimeModalLabel">Update Showtime</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="updateShowtimeID" name="showtimeid">
                    <input type="hidden" name="movieid" value="<%= movieid %>">
                    <div class="form-group">
                        <label for="updateSelectHall">Select Hall</label>
                        <select class="form-control" id="updateSelectHall" name="hallid">
                            <% 
                                Class.forName("oracle.jdbc.driver.OracleDriver");
                                connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                                statement = connection.createStatement();
                                rs = statement.executeQuery("SELECT HallID, Name FROM MovieHalls");
                                hasData = false; // Flag to check if there's any data
                                while (rs.next()) {
                                    hasData = true; // Set flag to true if there's data
                                    int hallid = rs.getInt("HallID");
                                    String hallName = rs.getString("Name");
                            %>
                            <option value="<%= hallid %>"><%= hallName %></option>
                            <% } 
                                rs.close();
                                statement.close();
                                connection.close();
                                
                                if (!hasData) {
                            %>
                            <option value="" disabled selected>No halls available</option>
                            <% } else { %>
                            <option value="" disabled selected>Please select a hall</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="updateShowDate">Date</label>
                        <input type="text" class="form-control" id="updateShowDate" name="showdate" placeholder="YYYY-MM-DD" required>
                    </div>
                    <div class="form-group">
                        <label for="updateShowTime">Time</label>
                        <input type="text" class="form-control" id="updateShowTime" name="showtime" placeholder="HH:MM:SS" required>
                    </div>
                    <div class="form-group">
                        <label for="updateFormat">Format</label>
                        <input type="text" class="form-control" id="updateFormat" name="format" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Update Showtime</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $('#updateShowtimeModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var showtimeid = button.data('showtimeid');
        var hallid = button.data('hallid');
        var showdate = button.data('showdate');
        var showtime = button.data('showtime');
        var format = button.data('format');
        
        var modal = $(this);
        modal.find('#updateShowtimeID').val(showtimeid);
        modal.find('#updateSelectHall').val(hallid);
        modal.find('#updateShowDate').val(showdate);
        modal.find('#updateShowTime').val(showtime);
        modal.find('#updateFormat').val(format);
    });
</script>

</body>
</html>

