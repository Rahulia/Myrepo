<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movie Listings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    
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
            
            color: white;
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

        .movie-poster {
            width: 100%;
            height: auto; /* Maintain aspect ratio */
            transition: transform 0.3s;
            object-fit: cover; /* Ensure image fills container */
        }

        .movie-info {
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

        .movie-info p {
            margin-bottom: 5px;
        }

        .card:hover .movie-info {
            opacity: 0;
        }

        .movie-trailer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: none;
        }

        .card:hover .movie-trailer {
            display: block;
        }

        .card-actions {
            position: absolute;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1;
        }
        .card-actions-bot {
            position: absolute center;
            buttom: 10px;
            
            z-index: 1;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="center">
            <h2>MOVIES LIST</h2>
        </div>
        <div class="center">
            <a href="movie_listings_addmore.jsp" class="add-button"><b>ADD MORE</b></a>
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
                    resultset = statement.executeQuery("select * from movies");
                    while(resultset.next()) {
                        String posterUrl = resultset.getString("posterurl");
                        String trailerUrl = resultset.getString("trailerurl");
                        // Extract video ID from YouTube URL
                        String videoId = trailerUrl.substring(trailerUrl.indexOf("v=") + 2);
            %>
            <div class="col-md-4">
                <div class="card" onmouseover="playVideo('<%= videoId %>')" onmouseout="pauseVideo('<%= videoId %>')">
                    <div class="card-actions">
                        <a href="Movie_Listings_update.jsp?u=<%= resultset.getInt("movieid") %>" class="btn btn-primary">Edit</a>
                        <form action="Movie_Listings_Delete?d=<%=resultset.getInt("movieid") %>" method="post" style="display:inline;">
                            <input type="hidden" name="movieid" value="<%= resultset.getInt("movieid") %>">
                            <input type="submit" class="btn btn-danger" value="Delete">
                        </form>
                        
                    </div>
                    <div class="card-body p-0">
                        <img src="<%= posterUrl %>" class="movie-poster img-fluid" alt="Movie Poster">
                        <div class="movie-info">
                            <p><strong></strong> <%= resultset.getString("title") %></p>
                        </div>
                        <iframe id="video_<%= videoId %>" class="movie-trailer" src="https://www.youtube.com/embed/<%= videoId %>?enablejsapi=1" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div class="card-footer text-center card-actions-bot">
                        <a href="Showtime.jsp?s=<%= resultset.getInt("movieid") %>" class="btn btn-primary">SHOWTIME</a>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha384-KyZXEAg3QhqLMpG8r+Knujsl5+5hb7MD2iDdzXk5KPL5K5t+RiTAu6z/mn96iN0S" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-MtVR7E1EdGbu1a4eMb9zJ0bWmAlpUItF+Fs3N8MKwi+HZ/2Sxbi74SrDLMzNx7Ok" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-7z6IdlASG7zK5NxubT60nynQ8BXIbrE1lWPIBNo6lCaSWF5xEgMQV2pQNnfn5xT" crossorigin="anonymous"></script>
    <script>
        function playVideo(videoId) {
            const player = document.getElementById(`video_${videoId}`);
            if (player) {
                player.style.display = "block";
                player.src = `https://www.youtube.com/embed/${videoId}?autoplay=1`;
            }
        }

        function pauseVideo(videoId) {
            const player = document.getElementById(`video_${videoId}`);
            if (player) {
                player.style.display = "none";
                player.src = "";
            }
        }
    </script>
</body>
</html>



