<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Prerequisite Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Prerequisite Entry</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Course ID</th>
				<th>Prerequisite Course ID</th>
				<th>Instructor Consent?</th>
			</tr>
			
		<tr>
			<form action="prereq.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="course_id"></td> 
					<td><input type="text" value="" name="pre_course_id"></td> 
					<td><input type="text" value="" name="instructor_consent"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_COURSE_QUERY = "select * from prerequisite";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_COURSE_QUERY);
			
			while(rs.next()) {
				String preCourseId;
				
				if(rs.getString("pre_course_id") == null) {
					preCourseId = "";
				}
				else {
					preCourseId = rs.getString("pre_course_id");
				}
				
				String instructorConsent;
				
				if(rs.getString("instructor_consent") == null) {
					instructorConsent = "";
				}
				else {
					instructorConsent = rs.getString("instructor_consent");
				}
				
			%>
			
			<tr>
				<form action="prereq.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td> 
					<td><input type="text" value="<%= preCourseId %>" name="pre_course_id"></td>
					<td><input type="text" value="<%= instructorConsent %>" name="instructor_consent"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="prereq.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("course_id") %>" name="course_id">
					<input type="hidden" value="<%= preCourseId %>" name="pre_course_id">
					<input type="hidden" value="<%= instructorConsent %>" name="instructor_consent">
					<td><input type="submit" value="Delete"></td> 
				</form>
			</tr>
			<% }
			rs.close();
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
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// INSERT the student attrs INTO the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO prerequisite VALUES (?,?, ?); ");
														
							
							pstmt.setString(1, request.getParameter("course_id"));
							
							if(request.getParameter("pre_course_id") == null || request.getParameter("pre_course_id").equals("")) {
								pstmt.setNull(2, Types.VARCHAR);
							}
							else {
								pstmt.setString(2,request.getParameter("pre_course_id")); 
							}
							
							if(request.getParameter("instructor_consent") == null || request.getParameter("instructor_consent").equals("")) {
								pstmt.setNull(3, Types.VARCHAR);
							}
							else {
								pstmt.setString(3,request.getParameter("instructor_consent")); 								
							}


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("prereq.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
/* 							PreparedStatement pstatement = conn.prepareStatement("UPDATE prereq_entry SET min_units = ?, max_units = ?, requires_lab = ?, grade_type = ?, dep_name = ? WHERE course_id = ?");
							
							pstatement.setInt(1, Integer.parseInt(request.getParameter("min_units")));
							pstatement.setInt(2, Integer.parseInt(request.getParameter("max_units")));
							pstatement.setString(3, request.getParameter("requires_lab")); 
							pstatement.setString(4, request.getParameter("grade_type")); 
							pstatement.setString(5, request.getParameter("dep_name")); 
							pstatement.setString(6, request.getParameter("course_id")); 

							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("course_entry.jsp");  */
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM prerequisite WHERE course_id = ? AND pre_course_id = ? AND instructor_consent = ?");
							
							pstmt.setString(1, request.getParameter("course_id"));
							pstmt.setString(2, request.getParameter("pre_course_id"));
							pstmt.setString(3, request.getParameter("instructor_consent"));


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("prereq.jsp"); 
						}
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				
				%>
			
		</body>
	</head>
</html>