<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Sections</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="sidebar.html"/>
		</div>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>
		<h1>Sections</h1>
		
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
			<form action="section.jsp" method="post">
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
			String SELECT_QUERY = "select * from thesis_committee";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="section.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("class_title") %>" name="class_title"></td> 
					<td><input readonly type="number" value="<%= rs.getString("qtr") %>" name="qtr"></td>
					<td><input readonly type="text" value="<%= rs.getString("year") %>" name="year"></td>
					<td><input type="text" value="<%= rs.getString("grade_option") %>" name="grade_option"></td> 
					<td><input readonly type="text" value="<%= rs.getString("section_id") %>" name="section_id"></td>
					<td><input type="number" value="<%= rs.getString("enrollment_limit") %>" name="enrollment_limit"></td> 
					<td><input type="text" value="<%= rs.getString("faculty_name") %>" name="faculty_name"></td>
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td>
				
<!-- 				<td><input type="submit" value="Update"></td> -->
				</form>
				<form action="section.jsp" method="post">
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
			<% }%>
		
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
							System.out.println("In Insert");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// INSERT the student attrs INTO the Student table.
							
							String stringStmt = "INSERT INTO class VALUES (?, ?, ?, ?); INSERT INTO class_courses VALUES (?, ?, ?, ?); ";
							String[] sections = request.getParameter("section_id").split("[,]", 0);
							
							for(int i = 0; i < sections.length; i++) {
								if(i == sections.length-1){
									stringStmt += "INSERT INTO class_section VALUES (?, ?, ?, ?, ?, ?)";
								}
								else{
									stringStmt += "INSERT INTO class_section VALUES (?, ?, ?, ?, ?, ?); ";
								}
					       	}
							
							PreparedStatement pstmt = conn.prepareStatement(stringStmt);
							
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
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("section.jsp"); 
						}
 						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET min_courses = ?, con_gpa = ? WHERE deg_name = ? AND deg_level = ? AND con_name = ?");
							
							pstmt.setDouble(1, Double.parseDouble(request.getParameter("min_courses"))); 
							pstmt.setDouble(2, Double.parseDouble(request.getParameter("con_gpa")));
							pstmt.setString(3, request.getParameter("deg_name")); 
							pstmt.setString(4, request.getParameter("deg_level")); 
							pstmt.setString(5, request.getParameter("con_name"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("section.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM thesis_committee WHERE sid = ? AND faculty_name = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("faculty_name"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("section.jsp"); 
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