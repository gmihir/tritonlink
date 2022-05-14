<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Concetration Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Concetration Courses</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Concentration Name<sup>*</sup></th>
				<th>Course ID<sup>*</sup></th>
			</tr>
			
		<tr>
			<form action="concentration_courses_form.jsp" method="post">
				<input type="hidden" value="insert" name="action">
				
					<td><input type="text" value="" name="con_name"></td>
					<td><input type="text" value="" name="course_id"></td>
					
				<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select * from concentration_courses";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="concentration_courses_form.jsp" method="post">
				<input type="hidden" value="update" name="action">
				 
					<td><input readonly type="text" value="<%= rs.getString("con_name") %>" name="con_name"></td>
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td>
				
<!-- 				<td><input type="submit" value="Update"></td> -->
				</form>
				<form action="concentration_courses_form.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("con_name") %>" name="con_name">
					<input type="hidden" value="<%= rs.getString("course_id") %>" name="course_id">
				
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO concentration_courses VALUES (?, ?)"));
							
							pstmt.setString(1, request.getParameter("con_name"));
							pstmt.setString(2, request.getParameter("course_id"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("concentration_courses_form.jsp"); 
						}
/* 						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration_courses SET min_courses = ?, con_gpa = ? WHERE deg_name = ? AND deg_level = ? AND con_name = ?");
							
							pstmt.setString(1, request.getParameter("con_name"));
							pstmt.setString(2, request.getParameter("course_id"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("concentration_courses_form.jsp"); 
						} */
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM concentration_courses WHERE con_name = ? AND course_id = ?");
							
							pstmt.setString(1, request.getParameter("con_name"));
							pstmt.setString(2, request.getParameter("course_id"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("concentration_courses_form.jsp"); 
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