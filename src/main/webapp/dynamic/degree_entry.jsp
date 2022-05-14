<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Degree Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/degree_entry.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="sidebar.html"/>
		</div>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>
		<h1>Degree Entry</h1>
		<table class="form-table"> 
			<tr>
				<th>Name</th>
				<th>Level</th>
				<th>Min Units</th>
				<th>Department</th>
			</tr>
			
		<tr>
			<form action="degree_entry.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="deg_name"></td> 
					<td><input type="text" value="" name="deg_level"></td> 
					<td><input type="number" value="" name="min_units"></td> 
					<td><input type="text" value="" name="dep_name"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_DEGREE_QUERY = "select * from degree";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_DEGREE_QUERY);
			
			while(rs.next()) {
				System.out.println("deg_levl:");
				System.out.println(rs.getString("deg_level"));
			%>
			
			<tr>
				<form action="degree_entry.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("deg_name") %>" name="deg_name"></td> 
					<td><input readonly type="text" value="<%= rs.getString("deg_level") %>" name="deg_level"></td>
					<td><input type="number" value="<%= rs.getString("min_units") %>" name="min_units"></td>
					<td><input type="text" value="<%= rs.getString("dep_name") %>" name="dep_name"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="degree_entry.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("deg_name") %>" name="deg_name">
					<input type="hidden" value="<%= rs.getString("deg_level") %>" name="deg_level">
					<input type="hidden" value="<%= rs.getString("min_units") %>" name="min_units">
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
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO degree VALUES (?,?, ?, ?); ");
														
							
							pstmt.setString(1, request.getParameter("deg_name"));
							pstmt.setString(2,request.getParameter("deg_level")); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("min_units"))); 
							pstmt.setString(4,request.getParameter("dep_name")); 

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("degree_entry.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE degree SET min_units = ?, dep_name = ? WHERE deg_name =  ? AND deg_level = ?");
							
							pstatement.setInt(1, Integer.parseInt(request.getParameter("min_units")));
							pstatement.setString(2, request.getParameter("dep_name"));
							pstatement.setString(3, request.getParameter("deg_name")); 
							pstatement.setString(4, request.getParameter("deg_level")); 

							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("degree_entry.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM degree WHERE deg_name = ? AND deg_level = ?");
							
							pstmt.setString(1, request.getParameter("deg_name"));
							pstmt.setString(2, request.getParameter("deg_level"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("degree_entry.jsp"); 
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