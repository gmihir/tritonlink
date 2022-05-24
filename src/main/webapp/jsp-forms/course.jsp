<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Course Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Course Entry</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Course ID</th>
				<th>Min Units</th>
				<th>Max Units</th>
				<th>Requires Lab?</th>
				<th>Grade Type</th>
				<th>Department</th>
			</tr>
			
		<tr>
			<form action="course.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="course_id"></td> 
					<td><input type="number" value="" name="min_units"></td>
					<td><input type="number" value="" name="max_units"></td>  
					<td><input type="text" value="" name="requires_lab"></td> 
					<td><input type="text" value="" name="grade_type"></td> 
					<td><input type="text" value="" name="dep_name"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_COURSE_QUERY = "select * from courses";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_COURSE_QUERY);
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="course.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td> 
					<td><input type="number" value="<%= rs.getString("min_units") %>" name="min_units"></td>
					<td><input type="number" value="<%= rs.getString("max_units") %>" name="max_units"></td>
					<td><input type="text" value="<%= rs.getString("requires_lab") %>" name="requires_lab"></td>
					<td><input type="text" value="<%= rs.getString("grade_type") %>" name="grade_type"></td>
					<td><input type="text" value="<%= rs.getString("dep_name") %>" name="dep_name"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="course.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("course_id") %>" name="course_id">
					<input type="hidden" value="<%= rs.getString("min_units") %>" name="min_units">
					<input type="hidden" value="<%= rs.getString("max_units") %>" name="max_units">
					<input type="hidden" value="<%= rs.getString("requires_lab") %>" name="requires_lab">
					<input type="hidden" value="<%= rs.getString("grade_type") %>" name="grade_type">
					<input type="hidden" value="<%= rs.getString("dep_name") %>" name="dep_name">
					
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
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO courses VALUES (?,?, ?, ?,?,?); ");
														
							
							pstmt.setString(1, request.getParameter("course_id"));
							pstmt.setInt(2,Integer.parseInt(request.getParameter("min_units"))); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("max_units"))); 
							pstmt.setString(4,request.getParameter("grade_type")); 
							pstmt.setString(5,request.getParameter("requires_lab")); 
							pstmt.setString(6,request.getParameter("dep_name")); 


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("course.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE courses SET min_units = ?, max_units = ?, requires_lab = ?, grade_type = ?, dep_name = ? WHERE course_id = ?");
							
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
							
							response.sendRedirect("course.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM courses WHERE course_id = ?");
							
							pstmt.setString(1, request.getParameter("course_id"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("course.jsp"); 
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