<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movie Halls</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@core@2.10.2/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
        }

        .center {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 10vh; /* Fills entire viewport height */
        }
        
        .add-button {
            background-color: #4CAF50; /* Green */
            border: none;
            color: white;
            padding: 5px 8px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: 0.3s; /* Smooth hover effect */
        }
        
        .add-button:hover {
            background-color: #45A049; /* Green shade on hover */
        }

        .card {
            margin: 20px 0;
            transition: transform 0.3s;
            position: relative;
            overflow: hidden;
            border: none; /* Remove default border */
            height: 375px; /* Fixed height */
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card-header, .card-footer {
            
            color: white;p
            border: none; /* Remove default border */
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .btn-primary {
            background-color: green;
            border: none;
            margin-right: 10px;
        }

        .btn-primary:hover {
            background-color: grey;
        }

        .btn-danger {
            border: none;
            transition: background-color 0.3s;
        }

        .btn-danger:hover {
            background-color: darkred;
        }

        .hall-poster {
            width: 100%;
            height: auto; /* Maintain aspect ratio */
            transition: transform 0.3s;
            object-fit: cover; /* Ensure image fills container */
        }

        .hall-info {
            position: absolute;
            top: 280px;
            left: 0;
            width: 100%;
            height: 100%;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            align-items: center;
            display: flex;
            flex-direction: column;
            justify-content: flex-center;
            opacity: 1;
            transition: opacity 0.3s;
        }

        .hall-info p {
            margin-bottom: 5px;
        }

        .card:hover .hall-info {
            opacity: 0;
        }

        .card-actions {
            position: absolute;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1;
        }

        .card-actions-bot {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="center">
            <h2>MOVIE HALLS</h2>
        </div>
        
        
        <div class="text-center">
                        <button class="btn btn-success" data-toggle="modal" data-target="#addHallModal">NEW HALL</button>
                    </div>

        <div class="row">
            <% 
                Connection connection = null;
                Statement statement = null;
                ResultSet resultset = null;
                
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
                    statement = connection.createStatement();
                    resultset = statement.executeQuery("select * from moviehalls");
                    while(resultset.next()) {
                        String hallName = resultset.getString("name");
                        int hallId = resultset.getInt("hallid");
            %>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-actions">
                        <a href="#" class="btn btn-primary" data-toggle="modal" data-target="#updateHallModal" data-hallid="<%= hallId %>">Edit</a>
                        <form action="Delete_Moviehalls?d=<%= hallId %>" method="post" style="display:inline;">
                            <input type="hidden" name="hallid" value="<%= hallId %>">
                            <input type="submit" class="btn btn-danger" value="Delete">
                        </form>
                    </div>
                    <div class="card-body p-0">
                        <img src="default-hall-poster.jpg" class="hall-poster img-fluid" alt="Hall Poster">
                        <div class="hall-info">
                            <p><strong></strong> <%= hallName %></p>
                        </div>
                    </div>
                    <div class="card-footer text-center card-actions-bot">
                        <a href="Testseat.jsp?h=<%= hallId %>" class="btn btn-primary">SEATMAP</a>
                    </div>
                </div>
            </div>
            <% 
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if(resultset != null) resultset.close();
                        if(statement != null) statement.close();
                        if(connection != null) connection.close();
                    } catch(SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>
    <div class="modal fade" id="addHallModal" tabindex="-1" role="dialog" aria-labelledby="addHallModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="addHallForm" action="Add_MovieHalls" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="addHallModalLabel">Add Hall</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for="HallName">Hall Name</label>
            <input type="text" class="form-control" id="HallName" name="HallName" required>
            <label for="Capacity">Capacity</label>
            <input type="text" class="form-control" id="Capacity" name="Capacity" required>
            <label for="Location">Location</label>
            <input type="text" class="form-control" id="Location" name="Location" required>
          </div>
          </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Add Hall</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="updateHallModal" tabindex="-1" role="dialog" aria-labelledby="updateHallModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <form id="updateHallForm" action="Update_MovieHalls" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="updateHallModalLabel">Update Hall</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="updateHallId" name="hallid">
          <div class="form-group">
            <label for="HallName">Hall Name</label>
            <input type="text" class="form-control" id="HallName" name="Hallname" required>
            <label for="Capacity">Capacity</label>
            <input type="text" class="form-control" id="Capacity" name="Capacity" required>
            <label for="Location">Location</label>
            <input type="text" class="form-control" id="Location" name="Location" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Update Hall</button>
        </div>
      </form>
    </div>
  </div>
</div>





    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha384-KyZXEAg3QhqLMpG8r+Knujsl5+5hb7MD2iDdzXk5KPL5K5t+RiTAu6z/mn96iN0S" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-MtVR7E1EdGbu1a4eMb9zJ0bWmAlpUItF+Fs3N8MKwi+HZ/2Sxbi74SrDLMzNx7Ok" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-7z6IdlASG7zK5NxubT60nynQ8BXIbrE1lWPIBNo6lCaSWF5xEgMQV2pQNnfn5xT" crossorigin="anonymous"></script>
</body>
</html>


