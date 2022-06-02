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
					<div id="table-title">Grades Given</div>
				</tr>
		<%
		String courseId = request.getParameter("course_id");
		String facultyName = request.getParameter("faculty_name");
		String qtr = request.getParameter("qtr");
		
		// at minimum, the user has to select courseId
		if(courseId != null){
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");

			// The user can only select a faculty next
			if(facultyName != null) {
				
				// Course, faculty, and qtr query
				if(qtr != null) {
					
					%>
						<tr>
							<th>Grade</th>
							<th>Count</th>
						</tr>
					<%
					

					
					// Query setup
					String query = "SELECT * FROM CPQG WHERE COURSE_ID = ? AND FACULTY_NAME = ? AND QTR = ?";
					PreparedStatement pstmt = connection.prepareStatement(query);
					pstmt.setString(1, courseId);
					pstmt.setString(2, facultyName);
					pstmt.setString(3, qtr);
					// Execute query and show results
					ResultSet rs = pstmt.executeQuery();
					
					while(rs.next()){
						String grade = rs.getString("grade");
						String count = rs.getString("count");
							%>
								<tr>
									<td><input readonly type="text" value="<%= grade %>" name="grade"></td> 
									<td><input readonly type="text" value="<%= count %>" name="count"></td>
								</tr>
							<%
						
					}
					rs.close();
					pstmt.close();
				}
				
				// Course and faculty query
				else{
					%>
						<tr>
							<th>Grade</th>
							<th>Count</th>
						</tr>
					<%
					
					// Query setup
					String query = "SELECT cs.class_title, cs.qtr, cs.year, cs.section_id " +
									"FROM class_courses cc, class_section cs " +
									"WHERE cs.faculty_name = ? AND cc.course_id = ? " +
									"AND cs.qtr = cc.qtr AND cs.year = cc.year " +
									"AND cs.class_title = cc.class_title";
					PreparedStatement pstmt = connection.prepareStatement(query);
					pstmt.setString(1, facultyName);
					pstmt.setString(2, courseId);
					
					System.out.println(pstmt);
					// Execute query and show results
					ResultSet rs = pstmt.executeQuery();
					
					double gpa = 0;
					
					double totalCredits = 0;
					double totalUnits = 0;
					
					Map<String,Double> gpaMap = new HashMap<String, Double>();
					
					gpaMap.put("A+",4.3);
					gpaMap.put("A",4.0);
					gpaMap.put("A-",3.7);
					gpaMap.put("B+",3.4);
					gpaMap.put("B",3.1);
					gpaMap.put("B-",2.8);
					gpaMap.put("C+",2.5);
					gpaMap.put("C",2.2);
					gpaMap.put("C-",1.9);
					gpaMap.put("D",1.6);
					
					while(rs.next()){
						query = "SELECT units,grade FROM student_classes WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ?";
						pstmt = connection.prepareStatement(query);
						pstmt.setString(1, rs.getString("class_title"));
						pstmt.setString(2, rs.getString("qtr"));
						pstmt.setInt(3, rs.getInt("year"));
						pstmt.setString(4, rs.getString("section_id"));
						System.out.println(pstmt);
						ResultSet tempRs = pstmt.executeQuery();
						HashMap<String, Integer> gradeCount = new HashMap<String, Integer>();
						
						// Loop through all the grades
						while(tempRs.next()){
							String grade = tempRs.getString("grade");
							int units = tempRs.getInt("units");
							
							if(gpaMap.containsKey(grade)) {
								totalCredits += units * gpaMap.get(grade);
								totalUnits += units;		
							}

							
							// Check if the grade exists
							if(!gradeCount.containsKey(grade)){
								gradeCount.put(grade, 0);
							}
							
							gradeCount.put(grade, gradeCount.get(grade) + 1);
							
							
						}
						gpa = totalCredits/totalUnits;
						gpa = ((double)((int)(gpa *100.0)))/100.0;

						// Loop through and add the html
						for(String grade : gradeCount.keySet()){
							%>
								<tr>
									<td><input readonly type="text" value="<%= grade %>" name="grade"></td> 
									<td><input readonly type="text" value="<%= gradeCount.get(grade) %>" name="count"></td>
								</tr>
							<%
						}
						tempRs.close();
					}
					rs.close();
					pstmt.close();
					
					%>
					
							<h1>GPA: <%= gpa %></h1>
					<% 
					
				}
				
			}
			
			// Course query
			else{
				%>
				<tr>
					<th>Grade</th>
					<th>Count</th>
				</tr>
				<%
				
				String courseQuery = "select grade, count(grade) from student_classes where class_title IN (select distinct class_title from class_courses where course_id = ?) group by grade";
				PreparedStatement pstmt = connection.prepareStatement(courseQuery);
				pstmt.setString(1, courseId);
				
				ResultSet rs = pstmt.executeQuery();

				while(rs.next()) {
					%>
						<tr>
							<td><input readonly type="text" value="<%= rs.getString("grade") %>" name="grade"></td> 
							<td><input readonly type="text" value="<%= rs.getString("count") %>" name="count"></td>
						</tr>
					<% 
				}
			}
			connection.close();
		}
		%>
			</table>
		</body>
	</head>
</html>
