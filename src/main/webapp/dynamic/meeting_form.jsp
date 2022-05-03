<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Meeting Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="sidebar.html"/>
		</div>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>
		<h1>Meetings</h1>
		<table class="form-table"> 
			<tr>
				<th>Class Title</th>
				<th>Qtr</th>
				<th>Year</th>
				<th>Section ID</th>
				<th>Room</th>
				<th>Cron Date</th>
				<th>Mandatory</th>
				<th>Meeting Type</th>
			</tr>
			
		<tr>
			<form action="meeting_form.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td><input type="text" value="" name="class_title"></td> 
					<td>
						<select value="" name="qtr">
						    <option value="Fall">Fall</option>
						  	<option value="Winter">Winter</option>
						  	<option value="Spring">Spring</option>
						</select>
					</td>
					<td><input type="number" value="" name="year"></td>
					<td><input type="text" value="" name="section_id"></td>
					<td><input type="text" value="" name="room"></td>
					<td><input type="text" value="" name="cron_date"></td>
					<td>
						<select value="" name="mandatory">
						    <option value="Yes">Yes</option>
						  	<option value="No">No</option>
						</select>
					</td>
					<td><input type="text" value="" name="meeting_type"></td>
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select * from section_meeting";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="meeting_form.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("class_title") %>" name="class_title"></td> 
					<td><input readonly type="text" value="<%= rs.getString("qtr") %>" name="qtr"></td>
					<td><input readonly type="text" value="<%= rs.getString("year") %>" name="year"></td>
					<td><input readonly type="text" value="<%= rs.getString("section_id") %>" name="section_id"></td>
					<td><input readonly type="text" value="<%= rs.getString("room") %>" name="room"></td>
					<td><input readonly type="text" value="<%= rs.getString("cron_date") %>" name="cron_date"></td>
					<td><input type="text" value="<%= rs.getString("mandatory") %>" name="mandatory"></td>
					<td><input type="text" value="<%= rs.getString("meeting_type") %>" name="meeting_type"></td>
				
				<td><input type="submit" value="Update"></td>
				</form>
				<form action="meeting_form.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("class_title") %>" name="class_title">
					<input type="hidden" value="<%= rs.getString("qtr") %>" name="qtr">
					<input type="hidden" value="<%= rs.getString("year") %>" name="year">
					<input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
					<input type="hidden" value="<%= rs.getString("room") %>" name="room">
					<input type="hidden" value="<%= rs.getString("cron_date") %>" name="cron_date">
					<input type="hidden" value="<%= rs.getString("mandatory") %>" name="mandatory">
					<input type="hidden" value="<%= rs.getString("meeting_type") %>" name="meeting_type">
				
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
							PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO section_meeting VALUES (?, ?, ?, ?, ?, ?, ?, ?)"));
							
							System.out.println(request.getParameter("class_title"));
							System.out.println(request.getParameter("date"));
							System.out.println(request.getParameter("time"));

							
							pstmt.setString(1,request.getParameter("class_title")); 
							pstmt.setString(2,request.getParameter("qtr")); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("year")));
							pstmt.setString(4,request.getParameter("section_id")); 
							pstmt.setString(5,request.getParameter("room"));					
							pstmt.setString(6, request.getParameter("cron_date"));
							pstmt.setString(7, request.getParameter("mandatory"));
							pstmt.setString(8, request.getParameter("meeting_type"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("meeting_form.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE section_meeting SET mandatory = ?, meeting_type = ? WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ? AND room = ? AND cron_date = ?");
							
							
							pstmt.setString(1,request.getParameter("mandatory"));
							pstmt.setString(2,request.getParameter("meeting_type"));
							pstmt.setString(3,request.getParameter("class_title")); 
							pstmt.setString(4,request.getParameter("qtr")); 
							pstmt.setInt(5,Integer.parseInt(request.getParameter("year")));
							pstmt.setString(6,request.getParameter("section_id")); 
							pstmt.setString(7,request.getParameter("room"));
							pstmt.setString(8, request.getParameter("cron_date"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("meeting_form.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM section_meeting WHERE class_title = ? AND qtr = ? AND year = ? AND section_id = ? AND room = ? AND cron_date = ?");
							
							
							pstmt.setString(1,request.getParameter("class_title")); 
							pstmt.setString(2,request.getParameter("qtr")); 
							pstmt.setInt(3,Integer.parseInt(request.getParameter("year")));
							pstmt.setString(4,request.getParameter("section_id")); 
							pstmt.setString(5,request.getParameter("room"));
							pstmt.setString(6, request.getParameter("cron_date"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("meeting_form.jsp"); 
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