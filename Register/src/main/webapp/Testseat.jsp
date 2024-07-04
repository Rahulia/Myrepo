<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seat Map Listings</title>
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
                    <h3>Seat Map Listings</h3>
                </div>
                <div class="card-body">
                    <%
                        String hallid = request.getParameter("h");
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                        PreparedStatement ps = connection.prepareStatement("SELECT * FROM SeatMap");
                        //ps.setString(1, hallid);
                        ResultSet rs = ps.executeQuery();
                    %>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Seat ID</th>
                                <th>Zone</th>
                                <th>Section</th>
                                <th>Row No</th>
                                <th>Seat Number</th>
                                <th>Seat Type</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                                    String seatid = rs.getString("SeatID");
                                    String zone = rs.getString("Zone");
                                    String section = rs.getString("Section");
                                    int rowno = rs.getInt("RowNo");
                                    int seatNumber = rs.getInt("SeatNumber");
                                    String seatType = rs.getString("SeatType");
                                    BigDecimal price = rs.getBigDecimal("Price");
                                    String status = rs.getString("Status");
                            %>
                            <tr>
                                <td><%= seatid %></td>
                                <td><%= zone %></td>
                                <td><%= section %></td>
                                <td><%= rowno %></td>
                                <td><%= seatNumber %></td>
                                <td><%= seatType %></td>
                                <td><%= price %></td>
                                <td><%= status %></td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#updateSeatMapModal" data-seatid="<%= seatid %>" data-zone="<%= zone %>" data-section="<%= section %>" data-rowno="<%= rowno %>" data-seatnumber="<%= seatNumber %>" data-seattype="<%= seatType %>" data-price="<%= price %>" data-status="<%= status %>">Update</button>
                                    
                                    <form action="ChooseTrainerServlet?d=<%=rs.getInt("seatid") %>" method="post" style="display:inline;">
                                    <input type="hidden" name="movieid" value="<%=rs.getInt("seatid") %>">
                                    <input type="submit" class="btn btn-danger" value="Delete">
                                </form>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <div class="text-center">
                        <button class="btn btn-success" data-toggle="modal" data-target="#addSeatMapModal">Add Seat</button>
                    </div>
                    <%
                        rs.close();
                        ps.close();
                        connection.close();
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Seat Modal -->
<div class="modal fade" id="addSeatMapModal" tabindex="-1" role="dialog" aria-labelledby="addSeatMapModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form id="addSeatMapForm" action="SaveSubscriptionAndTrainerServlet" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSeatMapModalLabel">Add Seat</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="hallid" value="<%= hallid %>">
                    <div class="form-group">
                        <label for="zone">Zone</label>
                        <input type="text" class="form-control" id="zone" name="zone" required>
                    </div>
                    <div class="form-group">
                        <label for="section">Section</label>
                        <input type="text" class="form-control" id="section" name="section" required>
                    </div>
                    <div class="form-group">
                        <label for="rowno">Row No</label>
                        <input type="number" class="form-control" id="rowno" name="rowno" required>
                    </div>
                    <div class="form-group">
                        <label for="seatnumber">Seat Number</label>
                        <input type="number" class="form-control" id="seatnumber" name="seatnumber" required>
                    </div>
                    <div class="form-group">
                        <label for="seattype">Seat Type</label>
                        <input type="text" class="form-control" id="seattype" name="seattype" required>
                    </div>
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                    </div>
                    <div class="form-group">
                        <label for="status">Status</label>
                        <input type="text" class="form-control" id="status" name="status" value="Available" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Add Seat</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Update Seat Modal -->
<div class="modal fade" id="updateSeatMapModal" tabindex="-1" role="dialog" aria-labelledby="updateSeatMapModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="Update_SeatMap.java" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateSeatMapModalLabel">Update Seat</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="updateSeatID" name="seatid">
                    <input type="hidden" name="hallid" value="<%= hallid %>">
                    <div class="form-group">
                        <label for="updateZone">Zone</label>
                        <input type="text" class="form-control" id="updateZone" name="zone" required>
                    </div>
                    <div class="form-group">
                        <label for="updateSection">Section</label>
                        <input type="text" class="form-control" id="updateSection" name="section" required>
                    </div>
                    <div class="form-group">
                        <label for="updateRowNo">Row No</label>
                        <input type="number" class="form-control" id="updateRowNo" name="rowno" required>
                    </div>
                    <div class="form-group">
                        <label for="updateSeatNumber">Seat Number</label>
                        <input type="number" class="form-control" id="updateSeatNumber" name="seatnumber" required>
                    </div>
                    <div class="form-group">
                        <label for="updateSeatType">Seat Type</label>
                        <input type="text" class="form-control" id="updateSeatType" name="seattype" required>
                    </div>
                    <div class="form-group">
                        <label for="updatePrice">Price</label>
                        <input type="number" step="0.01" class="form-control" id="updatePrice" name="price" required>
                    </div>
                    <div class="form-group">
                        <label for="updateStatus">Status</label>
                        <input type="text" class="form-control" id="updateStatus" name="status" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Update Seat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#updateSeatMapModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget);
        var seatid = button.data('seatid');
        var zone = button.data('zone');
        var section = button.data('section');
        var rowno = button.data('rowno');
        var seatnumber = button.data('seatnumber');
        var seattype = button.data('seattype');
        var price = button.data('price');
        var status = button.data('status');
        
        var modal = $(this);
        modal.find('#updateSeatID').val(seatid);
        modal.find('#updateZone').val(zone);
        modal.find('#updateSection').val(section);
        modal.find('#updateRowNo').val(rowno);
        modal.find('#updateSeatNumber').val(seatnumber);
        modal.find('#updateSeatType').val(seattype);
        modal.find('#updatePrice').val(price);
        modal.find('#updateStatus').val(status);
    });
});
</script>
</body>
</html>
