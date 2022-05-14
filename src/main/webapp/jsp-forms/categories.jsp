<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Categories Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Categories Form</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table">
			<tr>
				<th>Degree Name<sup>*</sup> </th>
				<th>Degree Level<sup>*</sup></th>
				<th>Category Name<sup>*</sup></th>
				<th>Minimum Number of Units<sup>*</sup></th>
				<th>Minimum GPA<sup>*</sup></th>
				<th>Course IDs<sup>*</sup>
				<br>(csv while inserting)</br></th>
			</tr>
			
		<tr>
			<form action="categories.jsp" method="post">
				<input type="hidden" value="insert" name="action">
				
					<td><input type="text" value="" name="deg_name"></td> 
					<td><input type="text" value="" name="deg_level"></td>
					<td><input type="text" value="" name="cat_name"></td>
					<td><input type="number" value="" name="min_units"></td>
					<td><input step="0.01" type="number" value="" name="cat_gpa"></td>
					<td><input type="text" value="" name="course_id"></td>
					
				<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select * from categories";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			Connection conn = null;
			
			PreparedStatement pstmt = null;
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="categories.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("deg_name") %>" name="deg_name"></td> 
					<td><input readonly type="text" value="<%= rs.getString("deg_level") %>" name="deg_level"></td>
					<td><input readonly type="text" value="<%= rs.getString("cat_name") %>" name="cat_name"></td>
					<td><input type="number" value="<%= rs.getString("min_units") %>" name="min_units"></td>
					<td><input step="0.01" type="number" value="<%= rs.getString("cat_gpa") %>" name="cat_gpa"></td>
					<td><input readonly type="text" value="<%= rs.getString("course_id") %>" name="course_id"></td>
				
				<td><input type="submit" value="Update"></td>
				</form>
				<form action="categories.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("deg_name") %>" name="deg_name">
					<input type="hidden" value="<%= rs.getString("deg_level") %>" name="deg_level">
					<input type="hidden" value="<%= rs.getString("cat_name") %>" name="cat_name">
					<input type="hidden" value="<%= rs.getString("min_units") %>" name="min_units">
					<input type="hidden" value="<%= rs.getString("cat_gpa") %>" name="cat_gpa">
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
						conn = DriverManager.getConnection
								("jdbc:postgresql:tritonlinkdb?user=username&password=password");
						
						// Check if an insertion is requested
						String action = request.getParameter("action"); 
					%>
					<%
						if (action != null && action.equals("insert")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// INSERT the student attrs INTO the Student table.
							// Insert the class_section
							String statement = "";
							String[] courses = request.getParameter("course_id").split("[,]", 0);
							
							for(int i = 0; i < courses.length; i++) {
								if(i == courses.length-1){
									statement += "INSERT INTO categories VALUES (?, ?, ?, ?, ?, ?)";
								}
								else{
									statement += "INSERT INTO categories VALUES (?, ?, ?, ?, ?, ?); ";
								}
					       	}
							
							pstmt = conn.prepareStatement(statement);
							
							int pstmtIndex = 1;
							for(int i = 0; i < courses.length; i++) {
								System.out.println(courses[i]);
								
								pstmt.setString(pstmtIndex, request.getParameter("deg_name")); 
								pstmt.setString(pstmtIndex+1, request.getParameter("deg_level")); 
								pstmt.setString(pstmtIndex+2, request.getParameter("cat_name"));
								pstmt.setInt(pstmtIndex+3, Integer.parseInt(request.getParameter("min_units"))); 
								pstmt.setDouble(pstmtIndex+4, Double.parseDouble(request.getParameter("cat_gpa")));
								pstmt.setString(pstmtIndex+5, courses[i]);
								
								pstmtIndex += 6;
					       	}
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("categories.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							pstmt = conn.prepareStatement("UPDATE categories SET min_units = ?, cat_gpa = ? WHERE course_id = ? AND deg_name = ? AND deg_level = ? AND cat_name = ?");
							
							pstmt.setInt(1, Integer.parseInt(request.getParameter("min_units"))); 
							pstmt.setDouble(2, Double.parseDouble(request.getParameter("cat_gpa")));
							pstmt.setString(3, request.getParameter("course_id"));
							pstmt.setString(4, request.getParameter("deg_name")); 
							pstmt.setString(5, request.getParameter("deg_level")); 
							pstmt.setString(6, request.getParameter("cat_name"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							response.sendRedirect("categories.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							pstmt = conn.prepareStatement("DELETE FROM categories WHERE deg_name = ? AND deg_level = ? AND cat_name = ? AND course_id = ?");
							
							pstmt.setString(1, request.getParameter("deg_name")); 
							pstmt.setString(2, request.getParameter("deg_level")); 
							pstmt.setString(3, request.getParameter("cat_name"));
							pstmt.setString(4, request.getParameter("course_id"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("categories.jsp"); 
						}
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				finally {
					try { rs.close(); } catch (Exception e) { /* Ignored */ }
					try { stmt.close(); } catch (Exception e) { /* Ignored */ }
				    try { pstmt.close(); } catch (Exception e) { /* Ignored */ }
				    try { conn.close(); } catch (Exception e) { /* Ignored */ }
				    try { connection.close(); } catch (Exception e) { /* Ignored */ }
				}
				%>
			
		</body>
	</head>
</html>