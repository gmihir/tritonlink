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
			
			// first need to get all category names
			ArrayList<String> categories = new ArrayList<String>();
			
			String categoryQuery = "SELECT cat_name FROM categories WHERE deg_name = ? AND deg_level = 'BS' GROUP BY cat_name";
			pstmt = connection.prepareStatement(categoryQuery);
			
			pstmt.setString(1, degree);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				categories.add(rs.getString("cat_name"));
			}
			rs.close();
			pstmt.close();
			
			HashMap<String, Integer> categoryToUnits = new HashMap<String, Integer>();
			
			
			for(int i = 0 ; i < categories.size() ; i++) {
				String unitsQuery = "select min_units from categories where deg_name = ? and deg_level = 'BS' and cat_name = ? group by min_units";
				pstmt = connection.prepareStatement(unitsQuery);
				pstmt.setString(1, degree);
				pstmt.setString(2, categories.get(i));
				
				// get units, add to map
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					categoryToUnits.put(categories.get(i), rs.getInt("min_units"));
				}
				pstmt.close();
				rs.close();
			}
			
			HashMap<String, ArrayList<String>> categoryToCourses = new HashMap<String, ArrayList<String>>();
			
			for(int i = 0; i < categories.size(); i++) {
				String catCourseQuery = "select course_id from categories where deg_name = ? and deg_level = 'BS' and cat_name = ?";
				pstmt = connection.prepareStatement(catCourseQuery);
				pstmt.setString(1, degree);
				pstmt.setString(2, categories.get(i));
				
				rs = pstmt.executeQuery();
				
				ArrayList<String> courses = new ArrayList<String>();
				
				while(rs.next()) {
					courses.add(rs.getString("course_id"));
				}
				
				categoryToCourses.put(categories.get(i), courses);
				pstmt.close();
				rs.close();
			}
						
			// now get all courses the student has taken
			HashMap<String, Integer> coursesTakenToUnits = new HashMap<String, Integer>();
			
			String courseQuery = "select c.course_id, s.units from class_courses c, student_classes s where s.sid = ? and c.class_title = s.class_title and c.qtr = s.qtr and c.year = s.year";
			pstmt = connection.prepareStatement(courseQuery);
			pstmt.setString(1, sid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				coursesTakenToUnits.put(rs.getString("course_id"), rs.getInt("units"));
			}
						
			// now, we need to calculate remaining requirements for the student
			
			HashMap<String, Integer> categoryToUnitsTaken = new HashMap<String, Integer>();
					
					
			for(int i = 0 ; i < categories.size(); i++) {
				
				String currCat = categories.get(i);
				
				// find which courses the student has taken that correspond to this category
				ArrayList<String> courses = categoryToCourses.get(currCat);
				categoryToUnitsTaken.put(currCat,0);
				
				
				for(String course : courses) {
					// if the student has taken the course in the category, add the units
					if(coursesTakenToUnits.containsKey(course)) {
						int currUnitCount = categoryToUnitsTaken.get(currCat);
						categoryToUnitsTaken.put(currCat, currUnitCount + coursesTakenToUnits.get(course));
					}
				}
				
			}
			
			int totalUnits = 0;
			
			for(String cat : categoryToUnits.keySet()) {
				totalUnits += categoryToUnits.get(cat);
			}
			
			int takenUnits = 0;
			for(String cat : categoryToUnitsTaken.keySet()) {
				takenUnits += categoryToUnitsTaken.get(cat);
			}
			
			%>
			
			<h3>
				In order to graduate with a BS degree in <%= degree %>, you need to take a total of <%= totalUnits %> units, broken down into these categories.
			</h3>
			
			<br>
			
			<%
				for(String cat : categoryToUnits.keySet()) {
					%>
					<%=cat %> : <%= categoryToUnits.get(cat) %> units 
					<br />
					<br />
					<% 
				}
			%>
			
			<h3>
				You still have to take at least <%= totalUnits - takenUnits %> units, broken down into the following categories.
				<br/>
			</h3>
				<%
					for(String cat : categoryToUnitsTaken.keySet()) {
					%>
						<%=cat %> : <%= Math.max(0, categoryToUnits.get(cat) - categoryToUnitsTaken.get(cat)) %> units 
						<br />
						<br />
						<% 
					}
				%>
			
			
			
			<% 
			
			
		
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>