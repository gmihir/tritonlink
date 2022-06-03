<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Club Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Previous Degrees</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Student ID</th>
				<th>Institution</th>
				<th>Level</th>
				<th>Degree Name</th>
			</tr>
			
		<tr>
			<form action="previous_degree.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="sid"></td> 
					<td><input type="text" value="" name="institution"></td> 
					<td><input type="text" value="" name="level"></td>
					<td><input type="text" value="" name="previous_degree_name"></td>  
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_DEGREE_QUERY = "select * from previous_degrees";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_DEGREE_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="previous_degree.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input type="text" value="<%= rs.getString("institution") %>" name="institution"></td>
					<td><input type="text" value="<%= rs.getString("level") %>" name="level"></td>
					<td><input type="text" value="<%= rs.getString("previous_degree_name") %>" name="previous_degree_name"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>
				
				<form action="previous_degree.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("institution") %>" name="institution">
					<input type="hidden" value="<%= rs.getString("level") %>" name="level">
					<input type="hidden" value="<%= rs.getString("previous_degree_name") %>" name="previous_degree_name">
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO previous_degrees VALUES (?, ?, ?, ?)"));
							
							
							pstmt.setString(1,request.getParameter("sid")); 
							pstmt.setString(2,request.getParameter("institution")); 
							pstmt.setString(3,request.getParameter("level")); 
							pstmt.setString(4,request.getParameter("previous_degree_name")); 


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'previous_degree.jsp';
								</script>
							<%   
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE previous_degrees SET institution = ?, " 
							+ "level = ?, previous_degree_name = ? WHERE sid = ?");
							
							pstatement.setString(1, request.getParameter("institution"));
							pstatement.setString(2, request.getParameter("level"));
							pstatement.setString(3, request.getParameter("previous_degree_name")); 
							pstatement.setString(4, request.getParameter("sid")); 

							
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							%>
								<script>
									window.location.href = 'previous_degree.jsp';
								</script>
							<%  
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM previous_degrees WHERE sid = ? AND institution = ?" + 
									" AND level = ? AND previous_degree_name = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("institution"));
							pstmt.setString(3, request.getParameter("level"));
							pstmt.setString(4, request.getParameter("previous_degree_name"));


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'previous_degree.jsp';
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