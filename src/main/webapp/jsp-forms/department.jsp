<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Department Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Department Entry Form</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Department Name</th>
			</tr>
			
		<tr>
			<form action="department.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="dep_name"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_FACULTY_QUERY = "select * from department";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_FACULTY_QUERY);
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="department.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input type="text" value="<%= rs.getString("dep_name") %>" name="dep_name"></td> 
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="department.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("dep_name") %>" name="dep_name">
					<td><input type="submit" value="Delete"></td> 
				</form>
			</tr>
			<% 
			}
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
							pstmt = conn.prepareStatement("INSERT INTO department VALUES (?); ");
														
							pstmt.setString(1,request.getParameter("dep_name")); 
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							%>
								<script>
									window.location.href = 'department.jsp';
								</script>
							<%  
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
/* 							PreparedStatement pstatement = conn.prepareStatement("UPDATE faculty SET faculty_title = ?, dep_name = ? WHERE faculty_name =  ?");
							
							pstatement.setString(1, request.getParameter("faculty_title"));
							pstatement.setString(2, request.getParameter("dep_name"));
							pstatement.setString(3, request.getParameter("faculty_name")); 
									
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("faculty_entry.jsp");  */
						}
						else if (action != null && action.equals("delete")) {
							System.out.println("in delete");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							pstmt = conn.prepareStatement( "DELETE FROM department WHERE dep_name = ?");
							
							pstmt.setString(1, request.getParameter("dep_name"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							%>
								<script>
									window.location.href = 'department.jsp';
								</script>
							<%  
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
				    
				}
				%>
			
		</body>
	</head>
</html>