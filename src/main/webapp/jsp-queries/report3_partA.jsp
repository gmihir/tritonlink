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

			// The user can only select a faculty next
			if(facultyName != null){
				
				// Course, faculty, and qtr query
				if(qtr != null){
					
					%>
						<tr>
							<th>Grade</th>
							<th>Count</th>
						</tr>
					<%
					
					// Postgres setup
					DriverManager.registerDriver(new org.postgresql.Driver());
					Connection connection = DriverManager.getConnection
							("jdbc:postgresql:tritonlinkdb?user=username&password=password");
					
					// Query setup
					String query = "SELECT cs.class_title, cs.qtr, cs.year, cs.section_id " +
									"FROM class_courses cc, class_section cs " +
									"WHERE cs.faculty_name = ? AND cc.course_id = ? AND cc.qtr = ? " +
									"AND cs.qtr = cc.qtr AND cs.year = cc.year " +
									"AND cs.class_title = cc.class_title";
					PreparedStatement pstmt = connection.prepareStatement(query);
					pstmt.setString(1, facultyName);
					pstmt.setString(2, courseId);
					pstmt.setString(3, qtr);
					
					System.out.println(pstmt);
					// Execute query and show results
					ResultSet rs = pstmt.executeQuery();
					
					while(rs.next()){
						query = "SELECT grade FROM student_classes WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ?";
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
							
							// Check if the grade exists
							if(!gradeCount.containsKey(grade)){
								gradeCount.put(grade, 0);
							}
							
							gradeCount.put(grade, gradeCount.get(grade) + 1);
						}
						
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
				}
				
				// Course and faculty query
				else{

				}
			}
			
			// Course query
			else{

			}
		}
		%>
			</table>
		</body>
	</head>
</html>
