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
			LinkedHashSet<Calendar> allPossibleDates = new LinkedHashSet<Calendar>();
			Calendar currentTime = (Calendar) startCalendar.clone();
			long endTimeMs = endCalendar.getTimeInMillis();
			long currMs = currentTime.getTimeInMillis();
			
			System.out.println("currMs: " + currMs);
			System.out.println("endTimeMs: " + endTimeMs);

			
			while(currMs < endTimeMs) {
				// increment by an hour and add
				Calendar toAdd = (Calendar) currentTime.clone();
				allPossibleDates.add(toAdd);
				System.out.println("adding possibility: " + currentTime.getTimeInMillis());
				
				// add 1 hour
				currentTime.add(Calendar.HOUR_OF_DAY,1);
				
				if(currentTime.get(Calendar.HOUR_OF_DAY) > 19) {
					currentTime.add(Calendar.DATE, 1);
					currentTime.set(Calendar.HOUR_OF_DAY, 8);
				}

				currMs = currentTime.getTimeInMillis();
			}
			
			LinkedHashSet<Calendar> solution = new LinkedHashSet<Calendar>(allPossibleDates);
			System.out.println("before: " + solution.size());
			
			HashMap<String, HashSet<String>> dayToConflictingCron = new HashMap<String, HashSet<String>>();
			
			for(String conflictingDate : conflictCronDates) {
				String[] date = conflictingDate.split(" ");
				
				HashSet<String> conflictingDayArray = new HashSet<String>(Arrays.asList(date[5].split(",")));
				
				for(String day : conflictingDayArray) {
					if(dayToConflictingCron.containsKey(day)) {
						HashSet<String> crons = dayToConflictingCron.get(day);
						crons.add(conflictingDate);
						dayToConflictingCron.put(day,crons);
					}
					else {
						HashSet<String> crons = new HashSet<String>();
						crons.add(conflictingDate);
						dayToConflictingCron.put(day,crons);
					}
				}
			}
			
			System.out.println("Conflicts: ");
			System.out.println(dayToConflictingCron);
			
			//now, we need to check and remove all possible dates for review sessions that are in conflict with cronDates
			for(Calendar c : allPossibleDates) {
				System.out.println("current:");
				System.out.println(dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK)) + " " + c.get(Calendar.HOUR_OF_DAY));
				System.out.println(c.getTimeInMillis());
				System.out.println("--------");
				
				String currentDayOfWeek = dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK));
				
				if(!dayToConflictingCron.containsKey(currentDayOfWeek)) {
					continue;
				}
				for(String conflictingDate : dayToConflictingCron.get(currentDayOfWeek)) {
					String[] date = conflictingDate.split(" ");
					
					int duration = Integer.parseInt(date[0]);
					int startMin = Integer.parseInt(date[1]);
					int startHour = Integer.parseInt(date[2]);
					
					int conflictTimeInMinutes = startHour * 60 + startMin;
					int endConflictTimeInMinutes = conflictTimeInMinutes + duration;
					
					String[] conflictingDayArray = date[5].split(",");
					
					HashSet<String> conflictDays = new HashSet<String>(Arrays.asList(conflictingDayArray));
					String calendarDay = dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK));
					System.out.println(conflictDays);
					System.out.println(calendarDay);
					boolean sameDay = conflictDays.contains(calendarDay);
					//System.out.println("----------------");
					
					int startTime = c.get(Calendar.HOUR_OF_DAY) * 60 + c.get(Calendar.MINUTE);
					int endTime = startTime +  60;
					
					System.out.println("startTime: " + startTime);
					System.out.println("endTime: " + endTime);
					System.out.println("conflictTimeInMinutes: " + conflictTimeInMinutes);
					System.out.println("endConflictTimeInMinutes: " + endConflictTimeInMinutes);

					
					if((startTime >= conflictTimeInMinutes && startTime < endConflictTimeInMinutes) || 
							(conflictTimeInMinutes >= startTime && conflictTimeInMinutes < endTime)) {
						System.out.println("removing possibility: " + conflictingDate);
						System.out.println(dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK)) + " " + c.get(Calendar.HOUR_OF_DAY));
						solution.remove(c);
						break;
					}
				}
			}
			
			HashMap<Integer, String> monthLookup = new HashMap<Integer, String>();
			monthLookup.put(0, "January");
			monthLookup.put(1, "February");
			monthLookup.put(2, "March");
			monthLookup.put(3, "April");
			monthLookup.put(4, "May");
			monthLookup.put(5, "June");
			monthLookup.put(6, "July");
			monthLookup.put(7, "August");
			monthLookup.put(8, "September");
			monthLookup.put(9, "October");
			monthLookup.put(10, "November");
			monthLookup.put(11, "December");


			%>
			
			<table class="results-table">
			<tr>
				<div id="table-title">Available Review Session Times</div>
			</tr>
			<tr>
				<th>Month</th>
				<th>Date</th>
				<th>Day</th>
				<th>Time</th>
				
			</tr>
				 <%
				 	for(Calendar c : solution) {
				 		String month = monthLookup.get(c.get(Calendar.MONTH));
				 		int date = c.get(Calendar.DATE);
				 		String day = dayOfWeek.get(c.get(Calendar.DAY_OF_WEEK));
				 		int startTime = c.get(Calendar.HOUR_OF_DAY);
				 		int endTime = startTime + 1;
				 		
				 		%>
							<tr>
								<td><input readonly type="text" value="<%= month %>" name="month"></td> 
								<td><input readonly type="text" value="<%= date %>" name="date"></td>
								<td><input readonly type="text" value="<%= day %>" name="day"></td>
								<td><input readonly type="text" value="<%= startTime %>:00 - <%= endTime %>:00" name="time"></td>
								
							</tr>
 				 		<%
				 	}
				 %>
				</ul>
			
			<% 
			
			// Close everything
			pstmt.close();
			//rs.close();
			connection.close();
		}
		%>
		
		</body>
	</head>
</html>