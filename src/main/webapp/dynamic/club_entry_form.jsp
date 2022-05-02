<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Club Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/club_entry.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="sidebar.html"/>
		</div>
		
		<div class="club-form">
				<%@ page language="java" import="java.sql.*" %>
		<h1>Clubs</h1>
		<table class="form-table"> 
			<tr>
				<th>Student ID</th>
				<th>Club Name</th>
				<th>Role</th>
			</tr>
			
		<tr>
			<form action="club_entry_form.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="sid"></td> 
					<td><input type="text" value="" name="name"></td> 
					<td><input type="text" value="" name="role"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_STUDENT_QUERY = "select * from club";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_STUDENT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="club_entry_form.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input type="text" value="<%= rs.getString("name") %>" name="name"></td>
					<td><input type="text" value="<%= rs.getString("role") %>" name="role"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>
				
				<form action="club_entry_form.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("name") %>" name="name">
					<input type="hidden" value="<%= rs.getString("role") %>" name="role">
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
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// INSERT the student attrs INTO the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO club VALUES (?, ?, ?)"));
							
							System.out.println(request.getParameter("sid"));
							System.out.println(request.getParameter("name"));
							System.out.println(request.getParameter("role"));

							
							pstmt.setString(1,request.getParameter("sid")); 
							pstmt.setString(2,request.getParameter("name")); 
							pstmt.setString(3,request.getParameter("role")); 

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("club_entry_form.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE club SET name = ?, " + "role = ? WHERE sid = ?");
							
							pstatement.setString(1, request.getParameter("name"));
							pstatement.setString(2, request.getParameter("role"));
							pstatement.setString(3, request.getParameter("sid")); 

							
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("club_entry_form.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM club WHERE sid = ? AND name = ? AND role = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("name"));
							pstmt.setString(3, request.getParameter("role"));


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("club_entry_form.jsp"); 
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