<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.*"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Report 3</title>
		
	    <style type="text/css">
   		<%@include file="../css/queries.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Report 3</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>		 
			<table class="form-table"> 
				<tr>
					<th>Course ID</th>
					<th>Faculty</th>
					<th>QTR</th>
				</tr>
				
				<tr>
					<form method="post">
						<input type="hidden" value="search" name="action">
						
							<td>
								<select value="" name="course_id">
									<option disabled selected>-- select an option --</option>
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			Statement stmt = connection.createStatement();
			
			String selectQuery = "select course_id from courses";
			ResultSet rs = stmt.executeQuery(selectQuery);
			
			while(rs.next()) {
				%>
					<option value="<%= rs.getString("course_id") %>"><%= rs.getString("course_id") %></option>
				<%
			}
			
			%>
							</select>
						</td>
						<td>
							<select value="" name="faculty_name">
								<option disabled selected>-- select an option --</option>
			<%
			
			selectQuery = "select faculty_name from faculty";
			rs = stmt.executeQuery(selectQuery);
			
			while(rs.next()){
				%>
					<option value="<%= rs.getString("faculty_name") %>"><%= rs.getString("faculty_name") %></option>
				<%
			}
			
			rs.close();
			connection.close();
		
			%>
						</select>
					</td>
					<td>
						<select value="" name="qtr">
							<option disabled selected>-- select an option --</option>
						    <option value="FALL">FALL</option>
						  	<option value="WINTER">WINTER</option>
						  	<option value="SPRING">SPRING</option>
						</select>
					</td>
					<td><input type="submit" value="Search"></td>
	  			</form>
			</tr>
			
			<%@ page language="java" import="java.sql.*" %>
			
				<%
				try {
					// Postgres set up
					DriverManager.registerDriver(new org.postgresql.Driver());
					connection = DriverManager.getConnection
							("jdbc:postgresql:tritonlinkdb?user=username&password=password");
					
					// Check if an insertion is requested
					String action = request.getParameter("action"); 
					if (action != null && action.equals("search")) {
						
						// define usert input parameters
						String courseId = request.getParameter("course_id");
						String facultyName = request.getParameter("faculty_name");
						String qtr = request.getParameter("qtr");
						
						// at minimum, the user has to select courseId
						if(courseId != null) {
							// The user can only select a faculty next
							if(facultyName != null) {
								// Course, faculty, and qtr will be put through
								if(qtr != null){
									%>
									<jsp:include page="report3_partA.jsp">
									    <jsp:param name="course_id" value="<%= courseId %>"/>
									    <jsp:param name="faculty_name" value="<%= facultyName %>"/>
									    <jsp:param name="qtr" value="<%= qtr %>"/>
									</jsp:include>
									<%
								}
								
								// Course and faculty will be put through
								else{
									%>
									<jsp:include page="report3_partA.jsp">
									    <jsp:param name="course_id" value="<%= courseId %>"/>
									    <jsp:param name="faculty_name" value="<%= facultyName %>"/>
									</jsp:include>
									<%
								}
							}
							
							// Just the course id is put through
							else{
								%>
								<jsp:include page="report3_partA.jsp">
								    <jsp:param name="course_id" value="<%= courseId %>"/>
								</jsp:include>
								<%
							}
						}
					}
				}
				
				catch(Exception e) {
					System.out.println("Error:");
					System.out.println(e.toString());
				}
				%>
				
				</table>
			</div>
		</body>
	</head>
</html>