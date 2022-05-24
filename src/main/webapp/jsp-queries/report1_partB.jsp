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
				<th>Qtr</th>
				<th>Year</th>
				<th>Min Units</th>
				<th>Max Units</th>
				<th>Grade Option</th>
			</tr>
		<%
		String class_title = request.getParameter("class_title");
		Map map = new HashMap();
		
		// Parse all the parameters
		if(class_title != null){
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			String query = "SELECT qtr, year, grade_option FROM class WHERE class_title = ?";
			PreparedStatement pstmt = connection.prepareStatement(query);
			pstmt.setString(1, class_title);
			
			// Execute query and show results
			ResultSet rs = pstmt.executeQuery();
			
			// Loop through and create a key value mapping for all possible classes
			while(rs.next()) {
				String key = classTitle + "," + rs.getString("qtr") + "," +  rs.getString("year");
				String[] temp = new String[4];
				temp[0] = rs.getString("grade_option");
				
				map.put(key, temp);
				
				// JUST LOOP THROUGH AND DO ALL THE QUERIES FOR EACH CLASS ONE BY ONE THEN ADD TO THE HTML IN THE LOOP
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
			query = "SELECT course_id FROM courses WHERE ";
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			pstmt.setString(2, "SPRING");
			pstmt.setInt(3, 2018);
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			rs.next();
			
			// Define section enrollment variables
			String qtr = rs.getString("qtr");
			String year = rs.getString("year");
			String sectionId = rs.getString("section_id");
			String units = rs.getString("units");
			String grade = rs.getString("grade");
			String classTitle = rs.getString("class_title");
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
			
			
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
			rs = pstmt.executeQuery();
			rs.next();
			
			// Define class variables
			String gradeOption = rs.getString("grade_option");
			
			%>
				<table class="results-table">
					<tr>
						<th>Class Title</th>
						<th>Qtr</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Units</th>
						<th>Grade</th>
						<th>Grade Option</th>
					</tr>
					
					<tr>
						
						<tr><div id="table-title">Class</div></tr>
						<td><input readonly type="text" value="<%= classTitle %>" name="class_title"></td> 
						<td><input readonly type="text" value="<%= qtr %>" name="qtr"></td>
						<td><input readonly type="text" value="<%= year %>" name="year"></td>
						<td><input readonly type="text" value="<%= sectionId %>" name="section_id"></td>
						<td><input readonly type="text" value="<%= units %>" name="units"></td> 
						<td><input readonly type="text" value="<%= grade %>" name="grade"></td>
						<td><input readonly type="text" value="<%= gradeOption %>" name="grade_option"></td>
						
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