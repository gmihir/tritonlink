<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Classes Previously Taken Entry</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Classes Previously Taken</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>Student ID</th>
				<th>Units</th>
				<th>Class Title</th>
				<th>Quarter</th>
				<th>Year</th>
				<th>Section ID</th>
				<th>Grade</th>
			</tr>
			
		<tr>
			<form action="past_classes.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td> <input type="text" value="" name="sid"></td> 
					<td><input type="number" value="" name="units"></td> 
					<td><input type="text" value="" name="class_title"></td> 
					<td><input type="text" value="" name="qtr"></td> 
					<td><input type="number" value="" name="year"></td> 
					<td><input type="text" value="" name="section_id"></td> 
					<td><input type="text" value="" name="grade"></td> 

					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_COURSE_QUERY = "select * from student_classes";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_COURSE_QUERY);
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="past_classes.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input type="number" value="<%= rs.getString("units") %>" name="units"></td>
					<td><input readonly type="text" value="<%= rs.getString("class_title") %>" name="class_title"></td>
					<td><input readonly type="text" value="<%= rs.getString("qtr") %>" name="qtr"></td>
					<td><input readonly type="number" value="<%= rs.getString("year") %>" name="year"></td>
					<td><input readonly type="text" value="<%= rs.getString("section_id") %>" name="section_id"></td>
					<td><input type="text" value="<%= rs.getString("grade") %>" name="grade"></td>
					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="past_classes.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("units") %>" name="units">
					<input type="hidden" value="<%= rs.getString("class_title") %>" name="class_title">
					<input type="hidden" value="<%= rs.getString("qtr") %>" name="qtr">
					<input type="hidden" value="<%= rs.getString("year") %>" name="year">
					<input type="hidden" value="<%= rs.getString("section_id") %>" name="section_id">
					<input type="hidden" value="<%= rs.getString("grade") %>" name="grade">
					
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
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO student_classes VALUES (?,?,?, ?, ?,?,?); ");
														
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setInt(2,Integer.parseInt(request.getParameter("units"))); 
							pstmt.setString(3,request.getParameter("grade")); 
							pstmt.setString(4,request.getParameter("class_title")); 
							pstmt.setString(5,request.getParameter("qtr")); 
							pstmt.setInt(6,Integer.parseInt(request.getParameter("year"))); 
							pstmt.setString(7,request.getParameter("section_id")); 


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'past_classes.jsp';
								</script>
							<%   
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE student_classes SET grade = ?, units = ? WHERE sid = ? AND class_title = ? AND qtr = ? AND year = ? AND section_id = ?");
							
							pstatement.setString(1, request.getParameter("grade"));
							pstatement.setInt(2, Integer.parseInt(request.getParameter("units"))); 
							pstatement.setString(3, request.getParameter("sid"));
							pstatement.setString(4, request.getParameter("class_title")); 
							pstatement.setString(5, request.getParameter("qtr")); 
							pstatement.setInt(6, Integer.parseInt(request.getParameter("year"))); 
							pstatement.setString(7, request.getParameter("section_id")); 

							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							%>
								<script>
									window.location.href = 'past_classes.jsp';
								</script>
							<%    
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM student_classes WHERE sid = ? AND class_title = ? AND qtr = ? AND year = ? AND section_id = ? AND grade = ? AND units = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("class_title"));
							pstmt.setString(3, request.getParameter("qtr"));
							pstmt.setInt(4, Integer.parseInt(request.getParameter("year")));
							pstmt.setString(5, request.getParameter("section_id"));
							pstmt.setString(6, request.getParameter("grade"));
							pstmt.setInt(7, Integer.parseInt(request.getParameter("units")));


							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							%>
								<script>
									window.location.href = 'past_classes.jsp';
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