<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Classes</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Classes</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		
<!-- 		<div class="form-popup" id="myForm">
		  <form action="thesis_committee.jsp" method="post" class="form-container">
		    <h1 id='pop-up-header'>Add Faulty (comma separated)</h1>
		    
				<input type="text" id="faculty-text-box" value="" name="faculty">
			
		    <button type="button" class="btn cancel" onclick="closeForm()">Close</button>
		  </form>
		</div> -->
		
		<table class="form-table"> 
			<tr>
				<th>Class Title<sup>*</sup> </th>
				<th>QTR<sup>*</sup></th>
				<th>Year<sup>*</sup></th>
				<th>Grade Option<sup>*</sup></th>
				<th>Section ID<sup>*</sup>
				<br>(csv while inserting)</br>
				</th>
				<th>Enrollment Limit<sup>*</sup></th>
				<th>Faculty Name<sup>*</sup></th>
				<th>Course ID<sup>*</sup></th>
			</tr>
			
		<tr>
			<form action="classes.jsp" method="post">
				<input type="hidden" value="insert" name="action">
				
					<td><input type="text" value="" name="class_title"></td>
					<td>
						<select value="" name="qtr">
						    <option value="Fall">Fall</option>
						  	<option value="Winter">Winter</option>
						  	<option value="Spring">Spring</option>
						</select>
					</td>
					<td><input type="number" value="" name="year"></td>
					<td>
						<select value="" name="grade_option">
						    <option value="Letter Grade">Letter Grade</option>
						  	<option value="P/NP">P/NP</option>
						</select>
					</td>
					<td><input type="text" value="" name="section_id"></td>
					<td><input type="number" value="" name="enrollment_limit"></td>
					<td><input type="text" value="" name="faculty_name"></td>
					<td><input type="text" value="" name="course_id"></td>
					<!-- <td><button type="button" class="open-button" onclick="openForm()">Add Faculty</button></td> -->
					
				<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>

		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select c.class_title, c.qtr, c.year, c.grade_option, cs.section_id, cs.section_id, cs.enrollment_limit, cs.faculty_name, cc.course_id "
					+ "FROM class c, class_section cs, class_courses cc "
					+ "WHERE c.class_title = cs.class_title AND cs.class_title = cc.class_title AND "
					+ "c.qtr = cs.qtr AND cs.qtr = cc.qtr AND "
					+ "c.year = cs.year AND cs.year = cc.year;";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="classes.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("class_title") %>" name="class_title"></td> 
					<td><input readonly type="text" value="<%= rs.getString("qtr") %>" name="qtr"></td>
					<td><input readonly type="text" value="<%= rs.getString("year") %>" name="year"></td>
					<td><input type="text" value="<%= rs.getString("grade_option") %>" name="grade_option"></td> 
					<td><input readonly type="text" value="<%= rs.getString("section_id") %>" name="section_id"></td>
					<td><input type="number" value="<%= rs.getString("enrollment_limit") %>" name="enrollment_limit"></td> 
					<td><input type="text" value="<%= rs.getString("faculty_name") %>" name="faculty_name"></td>
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td>
				
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="classes.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("class_title") %>" name=class_title>
					<input type="hidden" value="<%= rs.getString("qtr") %>" name="qtr">
					<input type="hidden" value="<%= rs.getString("year") %>" name="year">
					<input type="hidden" value="<%= rs.getString("grade_option") %>" name="grade_option">
					<input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
					<input type="hidden" value="<%= rs.getString("enrollment_limit") %>" name="enrollment_limit">
					<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="faculty_name">
					<input type="hidden" value="<%= rs.getString("course_id") %>" name="course_id">
				
				<td><input type="submit" value="Delete"></td> 
				</form>
			</tr>
			<% }
				connection.close();
			%>
		
			</table>
		</div>
			
			<%@ page language="java" import="java.sql.*" %>
			
				<%
					try {
						// Load Postgres Driver class file 
						DriverManager.registerDriver(new org.postgresql.Driver());
						
						// Make a connection to the postgres datasource 
						Connection conn = DriverManager.getConnection
								("jdbc:postgresql:tritonlinkdb?user=username&password=password");
						
						// Check if an insertion is requested
						String action = request.getParameter("action"); 
					%>
					<%
						if (action != null && action.equals("insert")) {
							System.out.println("--- In Insert ---");
							conn.setAutoCommit(false);
							
							// Check to see if the class already exists
							String selectQuery = "SELECT COUNT(*) as count FROM class WHERE class_title = '"
							+ request.getParameter("class_title")
							+ "' AND qtr = '"
							+ request.getParameter("qtr")
							+ "' AND year = "
							+ Integer.parseInt(request.getParameter("year"))
							+ ";";
							
							System.out.println(selectQuery);
							
							Statement checkStatement = connection.createStatement();
							ResultSet resultSet = checkStatement.executeQuery(selectQuery);
							
							while(resultSet.next()){
								
								// Insert the class and class_courses as seperate statements in case they already exist
								String classInsert = "INSERT INTO class VALUES (?, ?, ?, ?);";
								String classCoursesInsert = "INSERT INTO class_courses VALUES (?, ?, ?, ?);";
								
								String statement = classInsert + classCoursesInsert;
								PreparedStatement pstmt = conn.prepareStatement(statement);
								
								if(resultSet.getString("count").equals("0")){
									
									// Class
									pstmt.setString(1, request.getParameter("class_title"));
									pstmt.setString(2, request.getParameter("qtr"));
									pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
									pstmt.setString(4, request.getParameter("grade_option"));
									
									// Class_Courses
									pstmt.setString(5, request.getParameter("course_id"));
									pstmt.setString(6, request.getParameter("class_title"));
									pstmt.setString(7, request.getParameter("qtr"));
									pstmt.setInt(8, Integer.parseInt(request.getParameter("year")));
									
									System.out.println(pstmt.toString());
									pstmt.executeUpdate();
								}
								
								// Insert the class_section
								statement = "";
								String[] sections = request.getParameter("section_id").split("[,]", 0);
								
								for(int i = 0; i < sections.length; i++) {
									if(i == sections.length-1){
										statement += "INSERT INTO class_section VALUES (?, ?, ?, ?, ?, ?)";
									}
									else{
										statement += "INSERT INTO class_section VALUES (?, ?, ?, ?, ?, ?); ";
									}
						       	}
								
								pstmt = conn.prepareStatement(statement);
								
								int pstmtIndex = 1;
								for(int i = 0; i < sections.length; i++) {
									System.out.println(sections[i]);
									
									pstmt.setString(pstmtIndex, request.getParameter("class_title"));
									pstmt.setString(pstmtIndex+1, request.getParameter("qtr"));
									pstmt.setInt(pstmtIndex+2, Integer.parseInt(request.getParameter("year")));
									pstmt.setString(pstmtIndex+3, sections[i]);
									pstmt.setInt(pstmtIndex+4, Integer.parseInt(request.getParameter("enrollment_limit")));
									pstmt.setString(pstmtIndex+5, request.getParameter("faculty_name"));
									
									pstmtIndex += 6;
						       	}
								
								System.out.println(pstmt.toString());
								
								pstmt.executeUpdate();
								conn.commit();
								conn.setAutoCommit(true);

								pstmt.close();
								conn.close();
							}
							
							resultSet.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("classes.jsp"); 
						}
 						else if (action != null && action.equals("update")) {
							System.out.println("--- IN UPDATE ---");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table.
							String classUpdate = "UPDATE class SET grade_option = ? WHERE class_title = ? AND qtr = ? AND year = ?;";
/* 							String classCoursesUpdate = "UPDATE class_courses SET grade_option = ? WHERE class_title = ? AND qtr = ? AND year = ?"; */
							String classSectionUpdate = "UPDATE class_section SET enrollment_limit = ?, faculty_name = ? WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ?;";
							
							String statement = classUpdate + classSectionUpdate;
							PreparedStatement pstmt = conn.prepareStatement(statement);
							
							// Class
							pstmt.setString(1, request.getParameter("grade_option")); 
							pstmt.setString(2, request.getParameter("class_title")); 
							pstmt.setString(3, request.getParameter("qtr"));
							pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));
							
							// Class_Section
							pstmt.setInt(5, Integer.parseInt(request.getParameter("enrollment_limit")));
							pstmt.setString(6, request.getParameter("faculty_name")); 
							pstmt.setString(7, request.getParameter("class_title"));
							pstmt.setString(8, request.getParameter("qtr"));
							pstmt.setInt(9, Integer.parseInt(request.getParameter("year")));
							pstmt.setString(10, request.getParameter("section_id"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("classes.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							System.out.println("--- IN DELETE ---");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table.
/* 							String classUpdate = "DELETE FROM class WHERE class_title = ? AND qtr = ? AND year = ?;"; */
/*  						String classCoursesUpdate = "DELETE FROM class_courses WHERE class_title = ? AND qtr = ? AND year = ?;"; */
							String classSectionUpdate = "DELETE FROM class_section WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ?;";
							
							String statement = classSectionUpdate;
							PreparedStatement pstmt = conn.prepareStatement(statement);
							
/* 							// Class 
							pstmt.setString(1, request.getParameter("class_title")); 
							pstmt.setString(2, request.getParameter("qtr"));
							pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
							
							// Class 
							pstmt.setString(4, request.getParameter("class_title")); 
							pstmt.setString(5, request.getParameter("qtr"));
							pstmt.setInt(6, Integer.parseInt(request.getParameter("year"))); */
							
							// Class_Section
							pstmt.setString(1, request.getParameter("class_title")); 
							pstmt.setString(2, request.getParameter("qtr"));
							pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
							pstmt.setString(4, request.getParameter("section_id"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("classes.jsp"); 
						}
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				
				%>
<!-- 		<script>
				function openForm() {
				  document.getElementById("myForm").style.display = "block";
				}
	
				function closeForm() {
				  document.getElementById("myForm").style.display = "none";
				}
		</script> -->
		</body>
	</head>
</html>