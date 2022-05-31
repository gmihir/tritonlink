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
				<th>B. Class Section</th>
				<th>B. Start Date</th>
				<th>B. End Date</th>
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
						
						<td>
							<select value="" name="b-section-id">
								<option disabled selected>-- select an option --</option>
						
								<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			stmt = connection.createStatement();
			
			String sectionQuery = "select * from section_enrollment";
			rs = stmt.executeQuery(sectionQuery);
			
			HashSet<String> sections = new HashSet<String>();
			while(rs.next()) {	
				
				String classTitle = rs.getString("class_title");
				String sectionId = rs.getString("section_id");
				sections.add(classTitle + " --> " + sectionId);
			}
			
			for(String sectionString : sections) {
				%>
				<option value="<%= sectionString %>"><%= sectionString %></option>
				<%
			}
			rs.close();
			connection.close();
		%>
				</select>
				</td>
				
				<td>
					<input name="startDate" type="date" min="2018-04-02" max="2018-06-15"  />
				</td>
				
				<td>
					<input name="endDate" type="date" min="2018-04-02" max="2018-06-15"  />
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
							
							

 							else if( request.getParameter("b-section-id") != null && request.getParameter("startDate") != null
 									&& request.getParameter("endDate") != null) {
								String sectionString = request.getParameter("b-section-id");
								String startDate = request.getParameter("startDate");
								String endDate = request.getParameter("endDate");
								
								String[] startValues = startDate.split("-");
						        int startDay = Integer.parseInt(startValues[0]);
						        int startMonth = Integer.parseInt(startValues[1]);
						        int startYear = Integer.parseInt(startValues[2]);
						        
						        String[] endValues = endDate.split("-");
						        int endDay = Integer.parseInt(endValues[0]);
						        int endMonth = Integer.parseInt(endValues[1]);
						        int endYear = Integer.parseInt(endValues[2]);
							
								int arrowIndex = sectionString.indexOf(" --> ");
								String classTitle = sectionString.substring(0, arrowIndex);
								String sectionId = sectionString.substring(arrowIndex+5);
								
								%>
								
								<jsp:include page="report2_partB.jsp">
								    <jsp:param name="classTitle" value="<%= classTitle %>"/>
   								    <jsp:param name="sectionId" value="<%= sectionId %>"/>
   								    
								    <jsp:param name="startDate" value="<%= startDate %>" />
 								    <jsp:param name="endDate" value="<%= endDate %>" />
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