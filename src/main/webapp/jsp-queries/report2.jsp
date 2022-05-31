<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.*"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Report 2</title>
		
	    <style type="text/css">
   		<%@include file="../css/queries.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Report 2</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>A. Student Name</th>
			</tr>
			
			<tr>
				<form method="post">
					<input type="hidden" value="search" name="action">
					
						<td>
							<select value="" name="a-student-name">
								<option disabled selected>-- select an option --</option>
							    
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			Statement stmt = connection.createStatement();
			
			String selectQuery = "select * from student";
			ResultSet rs = stmt.executeQuery(selectQuery);
			
			Map<String, String> nameSid = new HashMap<String, String>();
			int index = 0;
			while(rs.next()) {
				
				String middleName = "";
				
				if(rs.getString("middle_name") != null){
					middleName = rs.getString("middle_name");
				}
				
				String valueName = index + rs.getString("first_name") + middleName + rs.getString("last_name");
				String displayName = rs.getString("first_name") + " " + middleName + " " + rs.getString("last_name");
				
				nameSid.put(valueName, rs.getString("sid"));
		%>
			
								<option value="<%= valueName %>"><%= displayName %></option>
			
		<%
			}
			rs.close();
			connection.close();
		%>
								
							</select>
						</td>
						
					<td><input type="submit" value="Search"></td>
	  			</form>
			</tr>
			
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
					if (action != null && action.equals("search")) {
						
						// define usert input parameters
						String aSid = nameSid.get(request.getParameter("a-student-name"));
						
						// go through all possible cases and route page based on user input
						if(aSid != null){
							%>
							<jsp:include page="report2_partA.jsp">
							    <jsp:param name="sid" value="<%= aSid %>"/>
							</jsp:include>
							<%
							}
							
/* 							else if(bClass != null){

							} */
						}
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				
				%>
				
				</table>
			</div>
		</body>
	</head>
</html>