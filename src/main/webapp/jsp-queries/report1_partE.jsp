<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
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
		String degName = request.getParameter("deg_name");
		
		// Parse all the parameters
		if(sid != null && degName != null){
			
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
			
			query = "SELECT deg_level FROM degree WHERE deg_name = ? AND deg_level = ?";
			pstmt = connection.prepareStatement(query);
			
			pstmt.setString(1, degName);
			pstmt.setString(2, "MS");
			
			rs = pstmt.executeQuery();
			rs.next();
			
			%>
				<table class="results-table">
					<tr>
						<div id="table-title">Degree</div>
					</tr>
					<tr>
						<th>Degree Name</th>
						<th>Degree Type</th>
					</tr>
					<tr>
						<td><input readonly type="text" value="<%= degName %>" name="deg_name"></td> 
						<td><input readonly type="text" value="<%= rs.getString("deg_level") %>" name="deg_level"></td>
					</tr>
				</table>
			<%
			
			// Grab all the courses the student had taken and the units they took it for
			// and the grade they got from the course
			
			// While loop to go through all concentrations student completed
			// Have to calculate GPA and units taken during this and store courses not yet taken.
			// Check if the student has taken min. units (by checking units taken for taken courses)
			// then check if they make the min gpa. If they do, then they completed and add to html.
			
			// Another while loop that will take the courses not yet taken from every concentration
			// and give the earliest date its offered after SPRING 2020
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>