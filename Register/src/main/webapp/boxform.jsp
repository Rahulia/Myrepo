<!DOCTYPE html>
<html>
<head>
    <title>Box Form</title>
</head>
<body>
    <h2>Enter Number of Boxes and Row Number</h2>
    <form action="AddServlet" method="post">
        <label for="rowno">Row Number:</label>
        <input type="number" id="rowno" name="rowno" min="1" required><br>
        <label for="boxno">Total Number of Boxes:</label>
        <input type="number" id="boxno" name="boxno" min="1" required><br>
        <button type="submit">Submit</button>
    </form>
</body>
</html>

