<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student home page</title>
</head>
<body>

	<%@ page language="java" import="java.sql.*" %>
	
	<%
		DriverManager.registerDriver(new org.postgresql.Driver());
		String GET_STUDENT_QUERY = "select * from student";
		
		Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlinkdb?user=username&password=password");
		
		Statement stmt = connection.createStatement();
		
		ResultSet rs = stmt.executeQuery(GET_STUDENT_QUERY);
		
		while(rs.next()) {
			
		%>
		
		<span> Student id is <%= rs.getInt(1) %></span> <br />
		<span> Age is <%= rs.getInt(2)%></span><br/>
		<span> Email is <%= rs.getString(3) %></span> <br/>
		<span> Name is <%= rs.getString(4) %></span><br/>
		<br/> <br/> <br/>
			
		<% }%>
	
</body>
</html>