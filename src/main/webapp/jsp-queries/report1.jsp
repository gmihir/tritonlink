<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.*"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Report 1</title>
		
	    <style type="text/css">
   		<%@include file="../css/queries.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Report 1</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>

		<table class="form-table"> 
			<tr>
				<th>A. SID</th>
				<th>B. Class Title</th>
				<th>C. SID</th>
				<th>D. Student Name</th>
				<th>D. Degree</th>
				<th>E. Student Name</th>
				<th>E. Degree</th>
			</tr>
			
			<tr>
				<form method="post">
					<input type="hidden" value="search" name="action">
					
						<td>
							<select value="" name="a-sid">
								<option disabled selected>-- select an option --</option>
							    
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String selectQuery = "select sid from student";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(selectQuery);
			
			while(rs.next()) {
				
		%>
			
								<option value="<%= rs.getString("sid") %>"><%= rs.getString("sid") %></option>
			
		<%	}
			rs.close();
			connection.close();
		%>
			
							</select>
						</td>
						<td>
							<select value="" name="b-class">
								<option disabled selected>-- select an option --</option>
								
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select class_title from class GROUP BY class_title";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			stmt = connection.createStatement();
			
			rs = stmt.executeQuery(selectQuery);
			
			while(rs.next()) {
				
		%>
			
								<option value="<%= rs.getString("class_title") %>"><%= rs.getString("class_title") %></option>
			
		<%	}
			rs.close();
			connection.close();
		%>
								
							</select>
						</td>
						<td>
							<select name="c-sid">
								<option disabled selected>-- select an option --</option>
								
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select * from student";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			stmt = connection.createStatement();
			
			rs = stmt.executeQuery(selectQuery);
			
			while(rs.next()) {
				
		%>
			
								<option value="<%= rs.getString("sid") %>"><%= rs.getString("sid") %></option>
			
		<%	}
			rs.close();
			connection.close();
		%>
		
							</select>
						</td>
						<td>
							<select value="" name="d-name">
								<option disabled selected>-- select an option --</option>
		
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select * from student where sid not in (select sid from grad)";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			stmt = connection.createStatement();
			rs = stmt.executeQuery(selectQuery);
			
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
			
		<%	}
			rs.close();
			connection.close();
		%>
		
							</select>
						</td>
						<td>
							<select value="" name="d-degree">
								<option disabled selected>-- select an option --</option>
		
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select deg_name from degree where deg_level = ?";
			String whereClause = "BS";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			PreparedStatement pstmt = connection.prepareStatement(selectQuery);
			pstmt.setString(1, whereClause);

			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
		%>
			
								<option value="<%= rs.getString("deg_name") %>"><%= rs.getString("deg_name") %></option>
			
		<%	}
			pstmt.close();
			rs.close();
			connection.close();
		%>
		
							</select>
						</td>
						<td>
							<select value="" name="e-name">
								<option disabled selected>-- select an option --</option>

		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select * from student where sid in (select sid from grad)";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			stmt = connection.createStatement();
			rs = stmt.executeQuery(selectQuery);
			
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
			
		<%	}
			rs.close();
			connection.close();
		%>

							</select>
						</td>
						<td>
							<select value="" name="e-degree">
								<option disabled selected>-- select an option --</option>
								
		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			selectQuery = "select deg_name from degree where deg_level = ?";
			whereClause = "MS";
			
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			pstmt = connection.prepareStatement(selectQuery);
			pstmt.setString(1, whereClause);

			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				
		%>
			
								<option value="<%= rs.getString("deg_name") %>"><%= rs.getString("deg_name") %></option>
			
		<%	}
			pstmt.close();
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
					%>
					<%
						if (action != null && action.equals("search")) {
							
							// define usert input parameters
							String aSid = request.getParameter("a-sid");
							String bClass = request.getParameter("b-class");
							String cSid = request.getParameter("c-sid");
							String dSid = nameSid.get(request.getParameter("d-name"));
							String dDegree = request.getParameter("d-degree");
							String eSid = nameSid.get(request.getParameter("e-name"));
							String eDegree = request.getParameter("e-degree");
							
							// go through all possible cases and route page based on user input
							if(aSid != null){
								%>
								
								<jsp:include page="report1_partA.jsp">
								    <jsp:param name="sid" value="<%= aSid %>"/>
								</jsp:include>
								
								<%
							}
							
							else if(bClass != null){
								%>
								
								<jsp:include page="report1_partB.jsp">
								    <jsp:param name="class_title" value="<%= bClass %>"/>
								</jsp:include>
								
								<%
							}
							
							else if(cSid != null){
								%>
								<jsp:include page="report1_partC.jsp">
							    	<jsp:param name="sid" value="<%= cSid %>"/>
								</jsp:include>								
								<%
							}
							
							else if(dSid != null && dDegree != null){
								%>
									<jsp:include page="report1_partD.jsp">
								    	<jsp:param name="sid" value="<%= dSid %>"/>
								    	<jsp:param name="degree" value="<%= dDegree %>"/>
									</jsp:include>
								<% 
							}
							
							else if(eSid != null && eDegree != null){
								%>
								<jsp:include page="report1_partE.jsp">
							    	<jsp:param name="sid" value="<%= eSid %>"/>
							    	<jsp:param name="deg_name" value="<%= eDegree %>"/>
								</jsp:include>								
								<%
							}
							
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