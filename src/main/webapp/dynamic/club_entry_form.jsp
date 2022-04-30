<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<body>
		<table>
			<tr>
				<td>
					<%-- import the java.sql package --%>
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
								if (action != null && action.equals("insert")) {
									conn.setAutoCommit(false);
									// Create the prepared statement and use it to
									// INSERT the student attrs INTO the Student table. 
									PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO club VALUES (?, ?, ?)"));
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
					
						<table> 
							<tr>
								<th>Student ID</th>
								<th>Club Name</th>
								<th>Student Role</th>
							</tr>
						
					<tr>
						
						<form action="club_entry_form.jsp" method="post">
							<input type="hidden" value="insert" name="action"> 
								<th><input value="" name="sid" size="10"></th> 
								<th><input value="" name="name" size="10"></th> 
								<th><input value="" name="role" size="15"></th> 
								<th><input type="submit" value="Insert"></th>
					   </form>
					</tr>
 				</table>
				</td>
			</tr>
		</table>
	</body>
</html>