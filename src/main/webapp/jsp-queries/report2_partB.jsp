<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
	<head>		
	    <style type="text/css">
   		<%@include file="../css/results.css" %></style>
		
		<body>
		

		<%
		String classTitle = request.getParameter("classTitle");
		String sectionId = request.getParameter("sectionId");

		
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		

		
		// Parse all the parameters
		if(classTitle != null && sectionId != null && startDate != null && endDate != null) {

			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			Calendar startCalendar = Calendar.getInstance();
			Calendar endCalendar = Calendar.getInstance();
			
			java.util.Date start = df.parse(startDate);
			java.util.Date end = df.parse(endDate);
			
			startCalendar.setTime(start);
			endCalendar.setTime(end);
			
			HashMap<Integer,String> dayOfWeek = new HashMap<Integer, String>();
			dayOfWeek.put(1, "SUN");
			dayOfWeek.put(2, "MON");
			dayOfWeek.put(3, "TUE");
			dayOfWeek.put(4, "WED");
			dayOfWeek.put(5, "THU");
			dayOfWeek.put(6, "FRI");
			dayOfWeek.put(7, "SAT");
			
			String startDay = dayOfWeek.get(startCalendar.get(Calendar.DAY_OF_WEEK));
			String endDay = dayOfWeek.get(endCalendar.get(Calendar.DAY_OF_WEEK));
			
			// set start time and end time to 8 am and 8 pm respectively
			startCalendar.set(Calendar.HOUR_OF_DAY, 8);
			endCalendar.set(Calendar.HOUR_OF_DAY, 20);
			
			// now, need to get all times that are "occupied" by enrolled student(s)
			HashSet<String> enrolledStudents = new HashSet<String>();
			
			
			

			// Postgres setup
			DriverManager.registerDriver(new org.postgresql.Driver());
			Connection connection = DriverManager.getConnection
					("jdbc:postgresql:tritonlinkdb?user=username&password=password");
			
			// Query setup
			String enrolledQuery = "select sid from section_enrollment where class_title = ? and section_id = ?";
			PreparedStatement pstmt = connection.prepareStatement(enrolledQuery);
 			pstmt.setString(1, classTitle);
			pstmt.setString(2, sectionId);
			
 			
			// Execute query and show results
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()) {
				enrolledStudents.add(rs.getString("sid"));
			}
			
			rs.close();
			

			// get all meetings the students are in
			
			// first, get all classes the students are currently enrolled in
			StringBuilder builder = new StringBuilder();

			for(String student : enrolledStudents) {
				builder.append("?,");
			}
			
			String placeHolders =  builder.deleteCharAt( builder.length() -1 ).toString();
			String cronQuery = "select distinct cron_date from section_meeting where qtr = 'SPRING' and year = 2018 and class_title IN (select distinct class_title from section_enrollment where sid IN (" + placeHolders + "))";
			pstmt = connection.prepareStatement(cronQuery);
			
			int index = 1;
			
			for( String student: enrolledStudents ) {
			  pstmt.setString(  index++, student ); // or whatever it applies 
			}
			rs = pstmt.executeQuery();
			
			HashSet<String> conflictCronDates = new HashSet<String>();
			
			while(rs.next()) {
				conflictCronDates.add(rs.getString("cron_date"));
			}
			rs.close();
			
			//now, we need to get all possible dates for review sessions
			HashSet<Calendar> allPossibleDates = new HashSet<Calendar>();
			Calendar currentTime = startCalendar;
			long endTimeMs = endCalendar.getTimeInMillis();
			long currMs = currentTime.getTimeInMillis();
					
			
			while(currMs < endTimeMs) {
				// increment by an hour and add
				allPossibleDates.add(currentTime);
				
				// add 1 hour
				currentTime.add(Calendar.HOUR_OF_DAY,1);
				
				if(currentTime.get(Calendar.HOUR_OF_DAY) > 19) {
					currentTime.add(Calendar.DATE, 1);
					currentTime.set(Calendar.HOUR_OF_DAY, 8);
				}

				currMs = currentTime.getTimeInMillis();
			}
			
			HashSet<Calendar> solution = new HashSet<Calendar>(allPossibleDates);
			
			//now, we need to check and remove all possible dates for review sessions that are in conflict with cronDates
			for(Calendar c : allPossibleDates) {
				for(String conflictingDate : conflictCronDates) {
					String[] date = conflictingDate.split(" ");
					
					int duration = Integer.parseInt(date[0]);
					int startMin = Integer.parseInt(date[1]);
					int startHour = Integer.parseInt(date[2]);
					
					int conflictTimeInMinutes = startHour * 60 + startMin;
					int endConflictTimeInMinutes = conflictTimeInMinutes + duration;
					
					String[] daysOfWeek = date[5].split(",");
					
					//System.out.println("----------------");
					
					int startTime = c.get(Calendar.HOUR_OF_DAY) * 60 + c.get(Calendar.MINUTE);
					int endTime = startTime +  60;
					
					if((startTime >= conflictTimeInMinutes && startTime <= endConflictTimeInMinutes) || 
							(conflictTimeInMinutes >= startTime && conflictTimeInMinutes <= endConflictTimeInMinutes)) {
						System.out.println("removing possibility");
						solution.remove(c);
					}
/* 					System.out.println(c.get(Calendar.HOUR_OF_DAY));
					System.out.println(c.get(Calendar.MINUTE));
					System.out.println(dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK)));

					System.out.println(Arrays.toString(date));
					System.out.println("----------------"); */
				}
			}
			
			
			// Close everything
			pstmt.close();
			//rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>