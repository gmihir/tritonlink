<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Concentration Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Concentrations</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Degree Name<sup>*</sup> </th>
				<th>Degree Level<sup>*</sup></th>
				<th>Concentration Name<sup>*</sup></th>
				<th>Minimum Number of Courses<sup>*</sup></th>
				<th>Minimum GPA<sup>*</sup></th>
			</tr>
			
		<tr>
			<form action="concentration.jsp" method="post">
				<input type="hidden" value="insert" name="action">
				
					<td><input type="text" value="" name="deg_name"></td> 
					<td><input type="text" value="" name="deg_level"></td>
					<td><input type="text" value="" name="con_name"></td>
					<td><input type="number" value="" name="min_courses"></td>
					<td><input step="0.01" type="number" value="" name="con_gpa"></td>
					
				<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select * from concentration";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="concentration.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("deg_name") %>" name="deg_name"></td> 
					<td><input readonly type="text" value="<%= rs.getString("deg_level") %>" name="deg_level"></td>
					<td><input readonly type="text" value="<%= rs.getString("con_name") %>" name="con_name"></td>
					<td><input type="number" value="<%= rs.getString("min_courses") %>" name="min_courses"></td>
					<td><input type="number" value="<%= rs.getString("con_gpa") %>" name="con_gpa"></td>
				
				<td><input type="submit" value="Update"></td>
				</form>
				<form action="concentration.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("deg_name") %>" name="deg_name">
					<input type="hidden" value="<%= rs.getString("deg_level") %>" name="deg_level">
					<input type="hidden" value="<%= rs.getString("con_name") %>" name="con_name">
					<input type="hidden" value="<%= rs.getString("min_courses") %>" name="min_courses">
					<input type="hidden" value="<%= rs.getString("con_gpa") %>" name="con_gpa">
				
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO concentration VALUES (?, ?, ?, ?, ?)"));
							
							pstmt.setString(1, request.getParameter("deg_name")); 
							pstmt.setString(2, request.getParameter("deg_level")); 
							pstmt.setString(3, request.getParameter("con_name"));
							pstmt.setInt(4, Integer.parseInt(request.getParameter("min_courses"))); 
							pstmt.setDouble(5, Double.parseDouble(request.getParameter("con_gpa")));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'concentration.jsp';
								</script>
							<%  
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET min_courses = ?, con_gpa = ? WHERE deg_name = ? AND deg_level = ? AND con_name = ?");
							
							pstmt.setInt(1, Integer.parseInt(request.getParameter("min_courses"))); 
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
							
							%>
								<script>
									window.location.href = 'concentration.jsp';
								</script>
							<%  
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM concentration WHERE deg_name = ? AND deg_level = ? AND con_name = ?");
							
							pstmt.setString(1, request.getParameter("deg_name")); 
							pstmt.setString(2, request.getParameter("deg_level")); 
							pstmt.setString(3, request.getParameter("con_name"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'concentration.jsp';
								</script>
							<%  
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