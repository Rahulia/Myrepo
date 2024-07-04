<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Movie</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
  <style>
    body {
      background-color: #f8f9fa;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .card {
      margin-top: 20px;
      width: 100%;
      max-width: 600px;
    }

    .card-header h3 {
      margin-bottom: 0;
    }

    .form-group label {
      font-weight: bold;
    }

    .form-control {
      border-radius: 0.25rem;
      margin-bottom: 10px;
    }

    textarea.form-control {
      resize: none;
      height: 100px;
    }

    button.btn-primary {
      background-color: green;
      border: none;
      transition: background-color 0.3s ease;
    }

    button.btn-primary:hover {
      background-color: grey;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="col-md-6 offset-md-3">
        <div class="card rounded-lg border border-danger">
          <div class="card-header text-center">
            <h3>Add New Movie</h3>
          </div>
          <div class="card-body rounded-lg">
            <form action="Movie_Listings_Addmore" method="post">
              <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" class="form-control" id="title" name="title" required>
              </div>
              <div class="form-group">
                <label for="genre">Genre:</label>
                <input type="text" class="form-control" id="genre" name="genre" required>
              </div>
              <div class="form-group">
                <label for="description">Description:</label>
                <textarea class="form-control" id="description" name="description" required></textarea>
              </div>
              <div class="form-group">
                <label for="duration">Duration (minutes):</label>
                <input type="number" class="form-control" id="duration" name="duration" min="1">
              </div>
              <div class="form-group">
                <label for="releaseDate">Release Date (YYYY-MM-DD):</label>
                <input type="date" class="form-control" id="releaseDate" name="releaseDate" required>
              </div>
              <div class="form-group">
                <label for="posterURL">Poster URL:</label>
                <input type="text" class="form-control" id="posterURL" name="posterURL" required>
              </div>
              <div class="form-group">
                <label for="trailerURL">Trailer URL:</label>
                <input type="text" class="form-control" id="trailerURL" name="trailerURL" required>
              </div>
              <div class="form-group">
                <label for="synopsis">Synopsis:</label>
                <textarea class="form-control" id="synopsis" name="synopsis" required></textarea>
              </div>
              <div class="form-group">
                <label for="castCrew">Cast & Crew (comma separated):</label>
                <input type="text" class="form-control" id="castCrew" name="castCrew">
              </div>
              <div class="card-footer text-center">
                <button type="submit" class="btn btn-primary">Add</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha384-KyZXEAg3QhqLMpG8r+Knujsl5+5hb7MD2iDdzXk5KPL5K5t+RiTAu6z/mn96iN0S" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-MtVR7E1EdGbu1a4eMb9zJ0bWmAlpUItF+Fs3N8MKwi+HZ/2Sxbi74SrDLMzNx7Ok" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-7z6IdlASG7zK5NxubT60nynQ8BXIbrE1lWPIBNo6lCaSWF5xEgMQV2pQNnfn5xT" crossorigin="anonymous"></script>
</body>
</html>

