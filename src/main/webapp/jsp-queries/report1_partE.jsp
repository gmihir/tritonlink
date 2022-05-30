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
			Map<String, List> map = new HashMap();
			List<String> coursesTaken = new ArrayList<String>();
					
			query = "SELECT * FROM student_classes WHERE sid = ?";
			pstmt = connection.prepareStatement(query);
			
			pstmt.setString(1, sid);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				
				// Set up query to get the course the student has taken
				query = "SELECT course_id FROM class_courses WHERE class_title = ? AND qtr = ? AND year = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, rs.getString("class_title"));
				pstmt.setString(2, rs.getString("qtr"));
				pstmt.setInt(3, rs.getInt("year"));
				ResultSet tempRs = pstmt.executeQuery();
				tempRs.next();
				
				List values = new ArrayList(); // define list to store units and grade the student took/got
				String courseId = tempRs.getString("course_id");
				
				// Set up query to get the grade the student got in the current class
				query = "SELECT number_grade FROM grade_conversion WHERE letter_grade = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, rs.getString("grade"));
				tempRs = pstmt.executeQuery();
				tempRs.next();
				
				// Add in the grade and the units the student got/took
				values.add(tempRs.getFloat("number_grade"));
				values.add(rs.getInt("units"));

				coursesTaken.add(courseId);
				map.put(courseId, values);
				
				tempRs.close();
			}
			
			// While loop to go through all concentrations student completed
			// Have to calculate GPA and units taken during this and store courses not yet taken.
			// Check if the student has taken min. units (by checking units taken for taken courses)
			// then check if they make the min gpa. If they do, then they completed and add to html.
			
			query = "SELECT * FROM concentration WHERE deg_name = ? AND deg_level = ?";
			pstmt = connection.prepareStatement(query);
			
			pstmt.setString(1, degName);
			pstmt.setString(2, "MS");
			rs = pstmt.executeQuery();
			
			// Define concentration and course completion lists
			List<String> completedCon = new ArrayList<String>();
			List<String> courseToComplete = new ArrayList<String>();
			
			// Loop through each concentration
			while(rs.next()){
				int sumUnits = 0;
				double gpa = 0;
				
				query = "SELECT course_id FROM concentration_courses WHERE con_name = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, rs.getString("con_name"));
				ResultSet tempRs = pstmt.executeQuery();
				
				// Loop through all the courses in the concentration
				while(tempRs.next()){
					
					String courseId = tempRs.getString("course_id");
					
					// Student has taken the course
					if(coursesTaken.contains(courseId)){
						
						float grade = (float) map.get(courseId).get(0);
						int unit = (Integer) map.get(courseId).get(1);
						
 						// Student took the course for a letter grade
						if(grade > 0){
							
							// Add the units to sumUnits and change gpa
							sumUnits += unit;
							gpa += unit * grade;
						}
 						
 						// Student took the course pass/no pass
						else if(grade == 0 || grade == -1){
							
							// Add the units to sumUnits
							sumUnits += unit;
						}
 						
 						// Student had incomplete grade
						else{
							courseToComplete.add(courseId);
						}
					}
					
					// Student did not take the course, yet to complete
					else{
						courseToComplete.add(courseId);
					}
				}
				
				gpa /= sumUnits;
				
				// Student has not taken enough units for the concentration or gotten the gpa
				if(sumUnits >= rs.getInt("min_courses") && gpa >= rs.getInt("con_gpa")){
					completedCon.add(rs.getString("con_name"));
				}
				
				tempRs.close();
			}
			
			%>
			<table class="results-table">
				<tr>
					<div id="table-title">Concentrations Completed</div>
				</tr>
				<tr>
					<th>Concentration Name</th>
				</tr>
			<%
			
			for(String concentration : completedCon){
				%>
					<tr>
						<td><input readonly type="text" value="<%= concentration %>" name="con_name"></td> 
					</tr>
				<%
			}
			
			%>
			</table>
			<table class="results-table">
				<tr>
					<div id="table-title">Courses to Complete/Pass</div>
				</tr>
				<tr>
					<th>Course ID</th>
					<th>Earliest Availability</th>
				</tr>
			<%
			
			// Another while loop that will take the courses not yet taken from every concentration
			// and give the earliest date its offered after SPRING 2020
			for(String courseId : courseToComplete){
				query = "SELECT * FROM class_courses WHERE course_id = ?";
				pstmt = connection.prepareStatement(query);
				
				pstmt.setString(1, courseId);
				ResultSet tempRs = pstmt.executeQuery();
				
				
				int year = -1;
				String qtr = "";
				
				// Loop through and grab the next earliest time (after SPRING 2018) for the course
				while(tempRs.next()){
					
					if(tempRs.getInt("year") == 2018){
						if(tempRs.getString("qtr") == "FALL"){ // Earliest available
							year = 2018;
							qtr = "FALL";
							break;
						}
						
						continue; // Cause qtr would be either SPRING or WINTER
					}
					
					// Year is less than 2018
					else if(tempRs.getInt("year") < 2018){
						continue;
					}
					
					// If year is the less than current year
					else if(year == -1 || tempRs.getInt("year") < year){
						year = tempRs.getInt("year");
						qtr = tempRs.getString("qtr");
					}
					
					// If year is the same
					else if(tempRs.getInt("year") == year){
						if(tempRs.getString("qtr") == "WINTER" ||
							(tempRs.getString("qtr") == "SPRING" && qtr == "FALL")){
							year = tempRs.getInt("year");
							qtr = tempRs.getString("qtr");
						}
					}
				}
				
				String availability = year + " " + qtr;
				
				// If there is a course available
				if(year == -1){
					availability = "No Offering";
				}
				
				%>
					<tr>
						<td><input readonly type="text" value="<%= courseId %>" name="course_id"></td>
						<td><input readonly type="text" value="<%= availability %>" name="availability"></td>
					</tr>
				<%
				
				tempRs.close();
			}
			
			%>
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