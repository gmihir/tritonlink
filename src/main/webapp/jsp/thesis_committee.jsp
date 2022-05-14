<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Thesis Committee</title>
		
	    <style type="text/css">
   		<%@include file="../css/forms.css" %></style>
		
		<body>
		
		<div class="sidebar-insert">
			<jsp:include page="../html/sidebar.html"/>
		</div>
		
		<h1>Thesis Committee</h1>
		
		<div class="form">
				<%@ page language="java" import="java.sql.*" %>
		
<!-- 		<div class="form-popup" id="myForm">
		  <form action="thesis_committee.jsp" method="post" class="form-container">
		    <h1 id='pop-up-header'>Add Faulty (comma separated)</h1>
		    
				<input type="text" id="faculty-text-box" value="" name="faculty">
			
		    <button type="button" class="btn cancel" onclick="closeForm()">Close</button>
		  </form>
		</div> -->
		
		<table class="form-table"> 
			<tr>
				<th>SID<sup>*</sup> </th>
				<th>Faculty Name<sup>*</sup>
				<br>(csv while inserting)</br>
				</th>
			</tr>
			
		<tr>
			<form action="thesis_committee.jsp" method="post">
				<input type="hidden" value="insert" name="action">
				
					<td><input type="text" value="" name="sid"></td>
					<td><input type="text" value="" name="faculty_name"></td>
					<!-- <td><button type="button" class="open-button" onclick="openForm()">Add Faculty</button></td> -->
					
				<td><input type="submit" value="Insert"></td>
  			</form>
		</tr>

		<%
			DriverManager.registerDriver(new org.postgresql.Driver());
			String SELECT_QUERY = "select * from thesis_committee";
			
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			Statement stmt = connection.createStatement();
			
			ResultSet rs = stmt.executeQuery(SELECT_QUERY);
			
			while(rs.next()) {
				
			%>
			
			<tr>
				<form action="thesis_committee.jsp" method="post">
				<input type="hidden" value="update" name="action">
				
					<td><input readonly type="text" value="<%= rs.getString("sid") %>" name="sid"></td> 
					<td><input readonly type="text" value="<%= rs.getString("faculty_name") %>" name="faculty_name"></td>
				
<!-- 				<td><input type="submit" value="Update"></td> -->
				</form>
				<form action="thesis_committee.jsp" method="post">
				<input type="hidden" value="delete" name="action">
				
					<input type="hidden" value="<%= rs.getString("sid") %>" name="sid">
					<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="faculty_name">
				
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
							System.out.println("In Insert");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// INSERT the student attrs INTO the Student table.
							
							String stringStmt = "";
							String[] faculty = request.getParameter("faculty_name").split("[,]", 0);
							String sid = request.getParameter("sid");
							
							for(int i = 0; i < faculty.length; i++) {
								if(i == faculty.length-1){
									stringStmt += "INSERT INTO thesis_committee VALUES (?, ?)";
								}
								else{
									stringStmt += "INSERT INTO thesis_committee VALUES (?, ?); ";
								}
					       	}
							
							PreparedStatement pstmt = conn.prepareStatement(stringStmt);
							
							int sidIndex = 1;
							int facultyIndex = 2;
							for(int i = 0; i < faculty.length; i++) {
								System.out.println(faculty[i]);
								
								pstmt.setString(sidIndex, sid);
								pstmt.setString(facultyIndex, faculty[i]);
								
								sidIndex += 2;
								facultyIndex += 2;
					       	}
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("thesis_committee.jsp"); 
						}
/* 						else if (action != null && action.equals("update")) {
							System.out.println("in update");
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to
							// UPDATE the student attributes in the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET min_courses = ?, con_gpa = ? WHERE deg_name = ? AND deg_level = ? AND con_name = ?");
							
							pstmt.setDouble(1, Double.parseDouble(request.getParameter("min_courses"))); 
							pstmt.setDouble(2, Double.parseDouble(request.getParameter("con_gpa")));
							pstmt.setString(3, request.getParameter("deg_name")); 
							pstmt.setString(4, request.getParameter("deg_level")); 
							pstmt.setString(5, request.getParameter("con_name"));
							
							System.out.println(pstmt.toString());
							
							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);
							
							pstmt.close();
							conn.close();
							
							response.sendRedirect("thesis_committee.jsp"); 
						} */
						else if (action != null && action.equals("delete")) {
							conn.setAutoCommit(false);
							// Create the prepared statement and use it to 
							// DELETE the student FROM the Student table. 
							PreparedStatement pstmt = conn.prepareStatement("DELETE FROM thesis_committee WHERE sid = ? AND faculty_name = ?");
							
							pstmt.setString(1, request.getParameter("sid"));
							pstmt.setString(2, request.getParameter("faculty_name"));

							pstmt.executeUpdate();
							conn.commit();
							conn.setAutoCommit(true);

							pstmt.close();
							conn.close();

							/* FIX THIS TO RESOLVE DUPLICATE BUG*/
							response.sendRedirect("thesis_committee.jsp"); 
						}
					}
				catch(Exception e) {
					System.out.println("error:");
					System.out.println(e.toString());
				}
				
				%>
<!-- 		<script>
				function openForm() {
				  document.getElementById("myForm").style.display = "block";
				}
	
				function closeForm() {
				  document.getElementById("myForm").style.display = "none";
				}
		</script> -->
		</body>
	</head>
</html>