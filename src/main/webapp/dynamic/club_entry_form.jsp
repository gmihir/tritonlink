<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Club Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/club_entry.css" %></style>
		
		<body>
		
		<div class="club-form">
			<a href="../index.html" class="home">&#8249; Home</a>
			<h1>Club Entry Form</h1>
			
			<br>
			<br>
			
			<table>
			    <form action="club_entry_form.jsp" method="get">
			    		<input type="hidden" value="insert" name="action">
					  <label for="sid">Student ID</label>
					  <br>
					  <input type="text" id="student-id" name="sid" placeholder="Student ID">
					
					  <br>
					  <label for="name">Club Name</label>
					  <br>
					  <input type="text" id="club-name" name="name" placeholder="Club Name">
					
					  <label for="role">Role in Club</label>
					  <br>
					  <input type="text" id="club-role" name="role" placeholder="Role in Club">
					  
					  <input type="submit" value="Submit">
				</form>
			</table>
		</div>
			
			<%@ page language="java" import="java.sql.*" %>
			
				<%
					boolean successful = false;
					try {
						// Load Postgres Driver class file 
						DriverManager.registerDriver(new org.postgresql.Driver());
						
						// Make a connection to the postgres datasource 
						Connection conn = DriverManager.getConnection
								("jdbc:postgresql:tritonlinkdb?user=username&password=password");
						
						// Check if an insertion is requested
						String action = request.getParameter("action"); 
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
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				
				%>
			
		</body>
	</head>
</html>