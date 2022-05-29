<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>		
	    <style type="text/css">
   		<%@include file="../css/results.css" %></style>
		
		<body>
		
		<table class="results-table">
			<tr>
				<div id="table-title">Student Info</div>
			</tr>
			<tr>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
			</tr>
		<%
		String sid = request.getParameter("sid");
		
		// Parse all the parameters
		if(sid != null){
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			String query = "SELECT ssn, first_name, middle_name, last_name FROM student WHERE sid = ?";
			PreparedStatement pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			
			// Execute query and show results
			ResultSet rs = pstmt.executeQuery();
			rs.next();
			
			%>
					<tr>
						<td><input readonly type="text" value="<%= rs.getString("ssn") %>" name="ssn"></td> 
						<td><input readonly type="text" value="<%= rs.getString("first_name") %>" name="first_name"></td>
						<td><input readonly type="text" value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
						<td><input readonly type="text" value="<%= rs.getString("last_name") %>" name="last_name"></td>
					</tr>
				</table>
			<%
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>