<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.List" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Periods Attended Form</title>
		
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
			
			while(rs.next()) {

		%>
				<tr>
					
					<tr><div id="table-title">Student</div></tr>
					<td><input readonly type="text" value="<%= rs.getString("ssn") %>" name="ssn"></td> 
					<td><input readonly type="text" value="<%= rs.getString("first_name") %>" name="first_name"></td>
					<td><input readonly type="text" value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
					<td><input readonly type="text" value="<%= rs.getString("last_name") %>" name="last_name"></td>
					
				</tr>
			</table>
			
			<table class="results-table">
				<tr>
					<th>Class Title</th>
					<th>Qtr</th>
					<th>Year</th>
					<th>Section ID</th>
					<th>Units</th>
					<th>Grade Choice</th>
					<th>Grade Option</th>
				</tr>
				
				<tr><div id="table-title">Class</div></tr>							
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
			
			// Query setup
			query = "SELECT * FROM section_enrollment WHERE sid = ? AND qtr = ? AND year = ?";
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			pstmt.setString(2, "SPRING");
			pstmt.setInt(3, 2018);
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				
				// Define section enrollment variables
				String qtr = rs.getString("qtr");
				String year = rs.getString("year");
				String sectionId = rs.getString("section_id");
				String units = rs.getString("units");
				String grade = rs.getString("grade");
				String classTitle = rs.getString("class_title");
				
				// Postgres setup
				DriverManager.registerDriver(new org.postgresql.Driver());
				connection = DriverManager.getConnection
						("jdbc:postgresql:tritonlinkdb?user=username&password=password");
				
				// Query setup
				query = "SELECT grade_option FROM class WHERE class_title = ? AND qtr = ? AND year = ?";
				pstmt = connection.prepareStatement(query);
				pstmt.setString(1, classTitle);
				pstmt.setString(2, "SPRING");
				pstmt.setInt(3, 2018);
				
				// Execute query and show results
				ResultSet tempRs = pstmt.executeQuery();
				tempRs.next();
				
				// Define class variables
				String gradeOption = tempRs.getString("grade_option");
				
				%>
					<tr>
						<td><input readonly type="text" value="<%= classTitle %>" name="class_title"></td> 
						<td><input readonly type="text" value="<%= qtr %>" name="qtr"></td>
						<td><input readonly type="text" value="<%= year %>" name="year"></td>
						<td><input readonly type="text" value="<%= sectionId %>" name="section_id"></td>
						<td><input readonly type="text" value="<%= units %>" name="units"></td> 
						<td><input readonly type="text" value="<%= grade %>" name="grade"></td>
						<td><input readonly type="text" value="<%= gradeOption %>" name="grade_option"></td>
					</tr>
				<%
				
				tempRs.close();
			}
			
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
			</table>
		</body>
	</head>
</html>