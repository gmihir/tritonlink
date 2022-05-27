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
				<th>Course</th>
				<th>Class Title</th>
				<th>Qtr</th>
				<th>Year</th>
				<th>Min Units</th>
				<th>Max Units</th>
				<th>Grade Option</th>
			</tr>		
			<tr><div id="table-title">Classes</div></tr>
		<%
		String classTitle = request.getParameter("class_title");
		
		// Parse all the parameters
		if(classTitle != null){
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			String query = "SELECT qtr, year, grade_option FROM class WHERE class_title = ?;";
			PreparedStatement pstmt = connection.prepareStatement(query);
			pstmt.setString(1, classTitle);
			
			// Execute query and show results
			ResultSet rs = pstmt.executeQuery();
			
			// Loop through and create a key value mapping for all possible classes
			int index = 0;
			while(rs.next()) {
				
				String qtr = rs.getString("qtr");
				int year = rs.getInt("year");
				String gradeOption = rs.getString("grade_option");
				
				query = "SELECT course_id FROM class_courses WHERE class_title = ? AND qtr = ? AND year = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, classTitle);
				pstmt.setString(2, qtr);
				pstmt.setInt(3, year);
				
				// Execute query and show results
				ResultSet tempRs = pstmt.executeQuery();
				tempRs.next();
				
				String courseId = tempRs.getString("course_id");
				
				query = "SELECT min_units, max_units FROM courses WHERE course_id = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, courseId);
				
				// Execute query and show results
				tempRs = pstmt.executeQuery();
				tempRs.next();
				
				String minUnits = tempRs.getString("min_units");
				String maxUnits = tempRs.getString("max_units");
				
				%>
					<tr>
						<td><input readonly type="text" value="<%= courseId %>" name="course_id"></td>
						<td><input readonly type="text" value="<%= classTitle %>" name="class_title"></td>
						<td><input readonly type="text" value="<%= qtr %>" name="qtr"></td>
						<td><input readonly type="text" value="<%= year %>" name="year"></td>
						<td><input readonly type="text" value="<%= minUnits %>" name="min_units"></td>
						<td><input readonly type="text" value="<%= maxUnits %>" name="max_units"></td> 
						<td><input readonly type="text" value="<%= gradeOption %>" name="grade_option"></td>
						
					</tr>
				<%
				
				tempRs.close();
				// JUST LOOP THROUGH AND DO ALL THE QUERIES FOR EACH CLASS ONE BY ONE THEN ADD TO THE HTML IN THE LOOP
			}
			
			%>
				</table>
				<table class="results-table">
					<tr>
						<th>SSN</th>
						<th>SID</th>
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
						<th>Resident Status</th>
						<th>Enrollment Status</th>
					</tr>
						
					<tr><div id="table-title">Currently Enrolled Students</div></tr>
			<%
			
			query = "SELECT sid FROM section_enrollment WHERE class_title = ? AND qtr = ? AND year = ?";
			pstmt = connection.prepareStatement(query);
			
			pstmt.setString(1, classTitle);
			pstmt.setString(2, "SPRING");
			pstmt.setInt(3, 2018);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
				query = "SELECT * FROM student WHERE sid = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, rs.getString("sid"));
				
				// Execute query and show results
				ResultSet tempRs = pstmt.executeQuery();
				tempRs.next();
				
				%>
					<tr>
						<td><input readonly type="text" value="<%= tempRs.getString("ssn") %>" name="ssn"></td>
						<td><input readonly type="text" value="<%= tempRs.getString("sid") %>" name="sid"></td>
						<td><input readonly type="text" value="<%= tempRs.getString("first_name") %>" name="first_name"></td>
						<td><input readonly type="text" value="<%= tempRs.getString("middle_name") %>" name="middle_name"></td>
						<td><input readonly type="text" value="<%= tempRs.getString("last_name") %>" name="last_name"></td>
						<td><input readonly type="text" value="<%= tempRs.getString("resident_status") %>" name="resident_status"></td> 
						<td><input readonly type="text" value="<%= tempRs.getString("enrollment_status") %>" name="enrollment_status"></td>
						
					</tr>
				<%
				
				tempRs.close();
				// JUST LOOP THROUGH AND DO ALL THE QUERIES FOR EACH CLASS ONE BY ONE THEN ADD TO THE HTML IN THE LOOP
			}
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>