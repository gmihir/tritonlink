<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Probation Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Probation Entry</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Student ID</th>
				<th>Reason</th>
				<th>Start Quarter</th>
				<th>Start Year</th>
				<th>End Quarter</th>
				<th>End Year</th>
			</tr>
			
		<tr>
			<form action="probation_entry_form.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="sid"></td> 
					<td><input type="text" value="" name="reason"></td> 
					
					<td>
						<select type="text" value="" name="start_qtr">
							<option value="Fall">Fall</option>
							<option value="Winter">Winter</option>
							<option value="Spring">Spring</option>
					</td>
					<td><input type="number" value="" name="start_year"></td>  				
					<td>
						<select type="text" value="" name="end_qtr">
							<option value="Fall">Fall</option>
							<option value="Winter">Winter</option>
							<option value="Spring">Spring</option>
						</select>
					</td>
					<td><input type="number" value="" name="end_year"></td>  				
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_DEGREE_QUERY = "select * from probation";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_DEGREE_QUERY);
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="probation_entry_form.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input type="text" value="<%= rs.getString("reason") %>" name="reason"></td>
					<td><input type="text" value="<%= rs.getString("start_qtr") %>" name="start_qtr"></td>
					<td><input type="text" value="<%= rs.getInt("start_year") %>" name="start_year"></td>
					<td><input type="text" value="<%= rs.getString("end_qtr") %>" name="end_qtr"></td>
					<td><input type="text" value="<%= rs.getInt("end_year") %>" name="end_year"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>
				
				<script>
					
					let startQtr = <% rs.getString("start_qtr"); %>
					let endQtr = <% rs.getString("end_qtr"); %>
					
					
				</script>
				
				<form action="probation_entry_form.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("reason") %>" name="reason">
					<input type="hidden" value="<%= rs.getString("start_qtr") %>" name="start_qtr">
					<input type="hidden" value="<%= rs.getInt("start_year") %>" name="start_year">
					<input type="hidden" value="<%= rs.getString("end_qtr") %>" name="end_qtr">
					<input type="hidden" value="<%= rs.getInt("end_year") %>" name="end_year">
					
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO probation VALUES (?, ?, ?, ?, ?, ?)"));
							
							
							pstmt.setString(1,request.getParameter("sid")); 
							pstmt.setString(2,request.getParameter("reason")); 
							pstmt.setString(3,request.getParameter("start_qtr")); 
							pstmt.setInt(4,Integer.parseInt(request.getParameter("start_year"))); 
							pstmt.setString(5,request.getParameter("end_qtr")); 
							pstmt.setInt(6,Integer.parseInt(request.getParameter("end_year"))); 


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("probation_entry_form.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE probation SET reason = ?, " 
							+ "start_qtr = ?, start_year = ?, end_qtr = ?, end_year = ? WHERE sid = ?");
							
							pstatement.setString(1, request.getParameter("reason"));
							pstatement.setString(2, request.getParameter("start_qtr"));
							pstatement.setInt(3, Integer.parseInt(request.getParameter("start_year"))); 
							pstatement.setString(4, request.getParameter("end_qtr")); 
							pstatement.setInt(5, Integer.parseInt(request.getParameter("end_year"))); 
							pstatement.setString(6, request.getParameter("sid")); 

							
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("probation_entry_form.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							System.out.println("in delete");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM probation WHERE sid = ? AND reason = ?" + 
									" AND start_qtr = ? AND start_year = ? AND end_qtr = ? AND end_year = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("reason"));
							pstmt.setString(3, request.getParameter("start_qtr"));
							pstmt.setInt(4, Integer.parseInt(request.getParameter("start_year")));
							pstmt.setString(5, request.getParameter("end_qtr"));
							pstmt.setInt(6, Integer.parseInt(request.getParameter("end_year")));


							System.out.println(pstmt.toString());
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("probation_entry_form.jsp"); 
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