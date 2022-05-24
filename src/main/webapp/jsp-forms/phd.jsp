<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>PhD Entry Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>PhD Entry</h1>
		
		<div class="degree-form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>SSN</th>
				<th>Student ID</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>Resident Status</th>
				<th>Enrollment Status</th>
				<th>PhD Type</th>
				<th>Advisor</th>
				<th>Department</th>

			</tr>
			
		<tr>
			<form action="phd.jsp" method="post">
				<input type="hidden" value="insert" name="action"> 
					<td><input type="number" value="" name="ssn"></td>  				
					<td> <input type="text" value="" name="sid"></td> 
					<td><input type="text" value="" name="first_name"></td> 
					<td><input type="text" value="" name="middle_name"></td> 
					<td><input type="text" value="" name="last_name"></td> 
					<td><input type="text" value="" name="resident_status"></td> 
					<td><input type="text" value="" name="enrollment_status"></td> 
					<td><input type="text" value="" name="phd_type"></td> 
					<td><input type="text" value="" name="advisor"></td> 
					<td><input type="text" value="" name="dep_name"></td> 
					<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String GET_STUDENT_QUERY = 
					"select ssn, s.sid, first_name, middle_name, last_name, resident_status, enrollment_status, phd_type, advisor, dep_name from student s, phd p, candidate c where s.sid = c.sid and s.sid = p.sid UNION" 
					+ " select ssn, s.sid, first_name, middle_name, last_name, resident_status, enrollment_status, phd_type, '' as advisor, dep_name from student s, phd p where s.sid = p.sid and s.sid not in(select sid from candidate);";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(GET_STUDENT_QUERY);
			
			while(rs.next()) {
			%>
			
			<tr>
				<form action="phd.jsp" method="post">
				
				<input type="hidden" value="update" name="action"> 
					<td><input readonly type="text" value="<%= rs.getString("ssn") %>" name="ssn"></td> 
					<td><input readonly type="text" value="<%= rs.getString("sid") %>" name="sid"></td>
					<td><input type="text" value="<%= rs.getString("first_name") %>" name="first_name"></td>
					<td><input type="text" value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
					<td><input type="text" value="<%= rs.getString("last_name") %>" name="last_name"></td>
					<td><input type="text" value="<%= rs.getString("resident_status") %>" name="resident_status"></td>
					<td><input type="text" value="<%= rs.getString("enrollment_status") %>" name="enrollment_status"></td>
					<td><input type="text" value="<%= rs.getString("phd_type") %>" name="phd_type"></td>
					<td><input type="text" value="<%= rs.getString("advisor") %>" name="advisor"></td>
					<td><input type="text" value="<%= rs.getString("dep_name") %>" name="dep_name"></td>

					<td><input type="submit" value="Update"></td>
					
				</form>

				<form action="phd.jsp" method="post">
					<input type="hidden" value="delete" name="action">
					<input type="hidden" value="<%= rs.getString("ssn") %>" name="ssn">
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("first_name") %>" name="first_name">
					<input type="hidden" value="<%= rs.getString("middle_name") %>" name="middle_name">
					<input type="hidden" value="<%= rs.getString("last_name") %>" name="last_name">
					<input type="hidden" value="<%= rs.getString("resident_status") %>" name="resident_status">
					<input type="hidden" value="<%= rs.getString("enrollment_status") %>" name="enrollment_status">
					<input type="hidden" value="<%= rs.getString("phd_type") %>" name="phd_type">
					<input type="hidden" value="<%= rs.getString("advisor") %>" name="advisor">
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
							PreparedStatement pstmt = conn.prepareStatement("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?); " + 
							 	" INSERT INTO phd VALUES (?,?,?); INSERT INTO candidate VALUES (?,?);");
							
							pstmt.setInt(1,Integer.parseInt(request.getParameter("ssn"))); 
							pstmt.setString(2, request.getParameter("sid"));
							pstmt.setString(3,request.getParameter("first_name")); 
							pstmt.setString(4,request.getParameter("middle_name")); 
							pstmt.setString(5,request.getParameter("last_name")); 
							pstmt.setString(6,request.getParameter("resident_status")); 
							pstmt.setString(7,request.getParameter("enrollment_status")); 

							pstmt.setString(8, request.getParameter("sid"));
							pstmt.setString(9,request.getParameter("phd_type"));
							pstmt.setString(10,request.getParameter("dep_name"));

							
							pstmt.setString(11, request.getParameter("sid"));
							pstmt.setString(12,request.getParameter("advisor")); 
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("phd.jsp"); 
						}
						else if (action != null && action.equals("update")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstatement = conn.prepareStatement("UPDATE student SET first_name = ?, " 
							+ "middle_name = ?, last_name = ?, resident_status = ?, enrollment_status = ? WHERE sid = ?;"
							+ "UPDATE phd SET phd_type = ?, dep_name = ? WHERE sid = ?; UPDATE candidate SET advisor = ? WHERE sid = ?;");
							
							pstatement.setString(1, request.getParameter("first_name"));
							pstatement.setString(2, request.getParameter("middle_name"));
							pstatement.setString(3, request.getParameter("last_name")); 
							pstatement.setString(4, request.getParameter("resident_status")); 
							pstatement.setString(5, request.getParameter("enrollment_status")); 
							pstatement.setString(6, request.getParameter("sid")); 
							
							pstatement.setString(7, request.getParameter("phd_type")); 
							pstatement.setString(8, request.getParameter("dep_name"));
							pstatement.setString(9, request.getParameter("sid")); 
	
							pstatement.setString(10, request.getParameter("advisor")); 
							pstatement.setString(11, request.getParameter("sid")); 
							

							
							pstatement.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstatement.close();
							conn.close();
							
							response.sendRedirect("phd.jsp"); 
						}
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement( "DELETE FROM student WHERE sid = ?");
							
							pstmt.setString(1, request.getParameter("sid"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("phd.jsp"); 
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