<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.ArrayList"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Report 1 Part C Form</title>
		
	    <style type="text/css">
   		<%@include file="../css/results.css" %></style>
		
		<body>
		
		<table class="results-table">
			<tr>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
			</tr>
		<%
		String sid = request.getParameter("sid");
		
		// Parse all the parameters
		if(sid != null) {
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			String query = "SELECT ssn, first_name, middle_name, last_name FROM student WHERE sid = ?";
			PreparedStatement pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			
			// Execute query and show results
			ResultSet rs = pstmt.executeQuery();
			String ssn = "";
			String firstName = "";
			String middleName = "";
			String lastName = "";
			
			while(rs.next()) {
				ssn = rs.getString("ssn");
				firstName = rs.getString("first_name");
				middleName = rs.getString("middle_name");
				lastName = rs.getString("last_name");

		%>

		<%
		
			}
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
			
			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			query = "SELECT s.sid,s.class_title,s.qtr,s.year,s.section_id,s.units,g.grade FROM section_enrollment s, student_classes g WHERE s.sid = ? AND s.sid = g.sid AND s.class_title = g.class_title AND s.qtr = g.qtr AND s.year = g.year AND s.section_id = g.section_id ORDER BY s.qtr,s.year";
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			
			// map will contain (qtr,year) -> list of courses
			SortedMap<String, ArrayList<ArrayList<String>>> map = new TreeMap<String, ArrayList<ArrayList<String>>>();
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			while(rs.next()) {
			
				// Define section enrollment variables
				String qtr = rs.getString("qtr");
				String year = rs.getString("year");
				
				String key = qtr + " " + year;

				String sectionId = rs.getString("section_id");
				String units = rs.getString("units");
				String grade = rs.getString("grade");
				String classTitle = rs.getString("class_title");
				String querySid = rs.getString("sid");
				
				if(grade.equals("IN")) {
					continue;
				}
				
				if(map.containsKey(key)) {
					ArrayList<String> currentRecord = new ArrayList<String>();
					currentRecord.add(0,qtr);
					currentRecord.add(1,year);
					currentRecord.add(2,sectionId);
					currentRecord.add(3,units);
					currentRecord.add(4,grade);
					currentRecord.add(5,classTitle);
					currentRecord.add(6,querySid);
					
					map.get(key).add(currentRecord);
				}
				else {
					ArrayList<ArrayList<String>> add = new ArrayList<ArrayList<String>>();
					map.put(key,add);
					
					ArrayList<String> currentRecord = new ArrayList<String>();
					currentRecord.add(0,qtr);
					currentRecord.add(1,year);
					currentRecord.add(2,sectionId);
					currentRecord.add(3,units);
					currentRecord.add(4,grade);
					currentRecord.add(5,classTitle);
					currentRecord.add(6,querySid);
					
					map.get(key).add(currentRecord);
				}
			}
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
			
			// need to calculate gpa for every quarter and cumulative gpa
			double cGpa = 0;
			Map<String,Double> gpaMap = new HashMap<String, Double>();
					
			gpaMap.put("A+",4.3);
			gpaMap.put("A",4.0);
			gpaMap.put("A-",3.7);
			gpaMap.put("B+",3.4);
			gpaMap.put("B",3.1);
			gpaMap.put("B-",2.8);
			gpaMap.put("C+",2.5);
			gpaMap.put("C",2.2);
			gpaMap.put("C-",1.9);
			gpaMap.put("D",1.6);
			
			Map<String,Double> gpa = new HashMap<String,Double>();

			double credits = 0;
			int totalNumUnits = 0;
					
			for(Map.Entry<String, ArrayList<ArrayList<String>>> entry : map.entrySet()) {
				String qtrString = entry.getKey();
				ArrayList<ArrayList<String>> entries = entry.getValue();
				
				double currCredits = 0;
				int currUnits = 0;
				
				// calculate gpa for this specific quarter
				for(int i = 0 ; i < entries.size(); i++) {
					ArrayList<String> curr = entries.get(i);
					
					int units = Integer.parseInt(curr.get(3));
					String grade = curr.get(4);
					
					double lookup = gpaMap.get(grade);
					currUnits += units;
					currCredits += units * lookup;
					
				}
				
				gpa.put(qtrString,currCredits/currUnits);
				
				credits += currCredits;
				totalNumUnits += currUnits;
				
				// calculate gpa for entire thing
				
				
			}
			
			cGpa = credits/totalNumUnits;
						
			%>
			<tr>
					
					<tr><div id="table-title">Student, Overall GPA: <%= cGpa %></div></tr>
					<td><input readonly type="text" value="<%= ssn %>" name="ssn"></td> 
					<td><input readonly type="text" value="<%= firstName%>" name="first_name"></td>
					<td><input readonly type="text" value="<%= middleName %>" name="middle_name"></td>
					<td><input readonly type="text" value="<%= lastName %>" name="last_name"></td>
					
				</tr>
			</table>
			<% 
			
			
			for(Map.Entry<String, ArrayList<ArrayList<String>>> entry : map.entrySet()) {
				String qtrString = entry.getKey();
				ArrayList<ArrayList<String>> entries = entry.getValue();
				
				for(int i = 0; i < entries.size(); i++) {
					ArrayList<String> curr = entries.get(i);
					
					String displayQtr = curr.get(0);
					String displayYr = curr.get(1);
					String displaySectionId = curr.get(2);
					String displayUnits = curr.get(3);
					String displayGrade = curr.get(4);
					String displayTitle = curr.get(5);
					
			%>
			
				<table class="results-table">
					<tr>
						<th>Class Title</th>
						<th>Qtr</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Units</th>
						<th>Grade</th>
					</tr>
					
					<tr>
						
						<tr><div id="table-title"><%= qtrString %>, GPA: <%= gpa.get(qtrString) %></div></tr>
						<td><input readonly type="text" value="<%= displayTitle %>" name="class_title"></td> 
						<td><input readonly type="text" value="<%= displayQtr %>" name="qtr"></td>
						<td><input readonly type="text" value="<%= displayYr %>" name="year"></td>
						<td><input readonly type="text" value="<%= displaySectionId %>" name="section_id"></td>
						<td><input readonly type="text" value="<%= displayUnits %>" name="units"></td> 
						<td><input readonly type="text" value="<%= displayGrade %>" name="grade"></td>
						
					</tr>
				</table>
			<%
				}
			}
			
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>