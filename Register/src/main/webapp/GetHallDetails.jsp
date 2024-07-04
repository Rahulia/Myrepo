<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*, org.json.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
    String hallId = request.getParameter("hallid");
    JSONObject hallDetails = new JSONObject();

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "raHULj69a");
        String sql = "SELECT * FROM MovieHalls WHERE HallID = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(hallId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            hallDetails.put("hallName", rs.getString("HallName"));
            hallDetails.put("capacity", rs.getInt("Capacity"));
            hallDetails.put("location", rs.getString("Location"));
        }

        response.setContentType("application/json");
        response.getWriter().write(hallDetails.toString());
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

</body>
</html>