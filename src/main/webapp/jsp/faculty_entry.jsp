<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Faculty Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Faculty Entry</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Name</th>
				<th>Title</th>
				<th>Department</th>
			</tr>
			
		<tr>
			<form action="faculty_entry.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="faculty_name"></td> 
					<td><input type="text" value="" name="faculty_title"></td> 
					<td><input type="text" value="" name="dep_name"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_FACULTY_QUERY = "select * from faculty";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_FACULTY_QUERY);
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="faculty_entry.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("faculty_name") %>" name="faculty_name"></td> 
					<td><input type="text" value="<%= rs.getString("faculty_title") %>" name="faculty_title"></td>
					<td><input type="text" value="<%= rs.getString("dep_name") %>" name="dep_name"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="faculty_entry.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="faculty_name">
					<input type="hidden" value="<%= rs.getString("faculty_title") %>" name="faculty_title">
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
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO faculty VALUES (?, ?, ?); ");
														
							
							pstmt.setString(1, request.getParameter("faculty_name"));
							pstmt.setString(2,request.getParameter("faculty_title")); 
							pstmt.setString(3,request.getParameter("dep_name")); 
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("faculty_entry.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE faculty SET faculty_title = ?, dep_name = ? WHERE faculty_name =  ?");
							
							pstatement.setString(1, request.getParameter("faculty_title"));
							pstatement.setString(2, request.getParameter("dep_name"));
							pstatement.setString(3, request.getParameter("faculty_name")); 
									
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("faculty_entry.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							System.out.println("in delete");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM faculty WHERE faculty_name = ?");
							
							pstmt.setString(1, request.getParameter("faculty_name"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("faculty_entry.jsp"); 
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