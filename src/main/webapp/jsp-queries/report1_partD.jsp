<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Report 1 Part D Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/results.css" %></style>
		
		<body>
		
		<table class="results-table">
			<tr>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
			</tr>
		<%
		String sid = request.getParameter("sid");
		String degree = request.getParameter("degree");
		
		// Parse all the parameters
		if(sid != null && degree != null) {
			
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
			String ssn = "";
			String firstName = "";
			String middleName = "";
			String lastName = "";
			
			while(rs.next()) {
				ssn = rs.getString("ssn");
				firstName = rs.getString("first_name");
				middleName = rs.getString("middle_name");
				lastName = rs.getString("last_name");

		%>

		<%
		
			}
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");

						
			%>
			<tr>
					
					<tr><div id="table-title">Student</div></tr>
					<td><input readonly type="text" value="<%= ssn %>" name="ssn"></td> 
					<td><input readonly type="text" value="<%= firstName%>" name="first_name"></td>
					<td><input readonly type="text" value="<%= middleName %>" name="middle_name"></td>
					<td><input readonly type="text" value="<%= lastName %>" name="last_name"></td>
					
				</tr>
			</table>
			
			<table class="results-table">
			<tr>
				<th>Degree Name</th>
				<th>Degree Level</th>
			</tr>
						<tr>
					
					<tr><div id="table-title">Degree</div></tr>
					<td><input readonly type="text" value="<%= degree %>" name="ssn"></td> 
					<td><input readonly type="text" value="BS" name="first_name"></td>
				</tr>
			</table>
			
			
			<% 
		
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>