<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Periods Attended Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/periods_attended.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="sidebar.html"/>
		</div>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>
		<h1>Periods Attended</h1>
		<table class="form-table"> 
			<tr>
				<th>SID</th>
				<th>Start QTR</th>
				<th>Start Year</th>
				<th>End QTR</th>
				<th>End Year</th>
			</tr>
			
		<tr>
			<form action="periods_attended.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td><input type="text" value="" name="sid"></td> 
					<td>
						<select value="" name="start_qtr">
						    <option value="Fall">Fall</option>
						  	<option value="Winter">Winter</option>
						  	<option value="Spring">Spring</option>
						</select>
					</td>
					<td><input type="number" value="" name="start_year"></td>
					<td>
						<select value="" name="end_qtr">
							<option disabled selected value>-- select an option --</option>
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
			String SELECT_QUERY = "select * from periods_attended";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="periods_attended.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input readonly type="text" value="<%= rs.getString("start_qtr") %>" name="start_qtr"></td>
					<td><input readonly type="text" value="<%= rs.getString("start_year") %>" name="start_year"></td>
					<td><input type="text" value="<%= rs.getString("end_qtr") %>" name="end_qtr"></td>
					<td><input type="text" value="<%= rs.getString("end_year") %>" name="end_year"></td>
				
				<td><input type="submit" value="Update"></td>
				</form>
				<form action="periods_attended.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("start_qtr") %>" name="start_qtr">
					<input type="hidden" value="<%= rs.getString("start_year") %>" name="start_year">
					<input type="hidden" value="<%= rs.getString("end_qtr") %>" name="end_qtr">
					<input type="hidden" value="<%= rs.getString("end_year") %>" name="end_year">
				
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO periods_attended VALUES (?, ?, ?, ?, NULL)"));
							
							if(request.getParameter("end_year") != ""){
								pstmt = conn.prepareStatement( ("INSERT INTO periods_attended VALUES (?, ?, ?, ?, ?)"));
								pstmt.setInt(5,Integer.parseInt(request.getParameter("end_year")));
							}
							
							pstmt.setString(1,request.getParameter("sid")); 
							pstmt.setString(2,request.getParameter("start_qtr")); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("start_year")));
							pstmt.setString(4,request.getParameter("end_qtr"));

							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("periods_attended.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE periods_attended SET end_qtr = ?, end_year = ? WHERE sid = ? AND start_qtr = ? AND start_year = ?");
							
							/* BOTH NULL */
							if(request.getParameter("end_qtr") == "null" && request.getParameter("end_year") == "null"){
								pstmt = conn.prepareStatement("UPDATE periods_attended SET end_qtr = NULL, end_year = NULL WHERE sid = ? AND start_qtr = ? AND start_year = ?");
								
								pstmt.setString(1,request.getParameter("sid")); 
								pstmt.setString(2,request.getParameter("start_qtr")); 
								pstmt.setInt(3,Integer.parseInt(request.getParameter("start_year")));
							}
							
							/* END QTR NULL */
							else if(request.getParameter("end_qtr") == "null"){
								pstmt = conn.prepareStatement("UPDATE periods_attended SET end_qtr = NULL, end_year = ? WHERE sid = ? AND start_qtr = ? AND start_year = ?");
								
								pstmt.setInt(1,Integer.parseInt(request.getParameter("end_year")));
								pstmt.setString(2,request.getParameter("sid")); 
								pstmt.setString(3,request.getParameter("start_qtr")); 
								pstmt.setInt(4,Integer.parseInt(request.getParameter("start_year")));
							}
							
							/* END YEAR NULL */
							else if(request.getParameter("end_year") == "null"){
								pstmt = conn.prepareStatement("UPDATE periods_attended SET end_qtr = ?, end_year = NULL WHERE sid = ? AND start_qtr = ? AND start_year = ?");
								
								pstmt.setString(1,request.getParameter("end_qtr")); 
								pstmt.setString(2,request.getParameter("sid")); 
								pstmt.setString(3,request.getParameter("start_qtr")); 
								pstmt.setInt(4,Integer.parseInt(request.getParameter("start_year")));
							}
							
							/* NIETHER NULL */
							else{
								pstmt.setString(1,request.getParameter("end_qtr")); 
								pstmt.setInt(2,Integer.parseInt(request.getParameter("end_year")));
								pstmt.setString(3,request.getParameter("sid")); 
								pstmt.setString(4,request.getParameter("start_qtr")); 
								pstmt.setInt(5,Integer.parseInt(request.getParameter("start_year")));
							}
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("periods_attended.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM periods_attended WHERE sid = ? AND start_qtr = ? AND start_year = ?");
							
							pstmt.setString(1,request.getParameter("sid")); 
							pstmt.setString(2,request.getParameter("start_qtr")); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("start_year")));

							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("periods_attended.jsp"); 
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