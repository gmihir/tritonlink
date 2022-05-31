<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
	<head>		
	    <style type="text/css">
   		<%@include file="../css/results.css" %></style>
		
		<body>
		
		<table class="results-table">
			<tr>
				<div id="table-title">Student Info</div>
			</tr>
			<tr>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
			</tr>
		<%
		String sid = request.getParameter("sid");
		
		// Parse all the parameters
		if(sid != null){
			
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
			rs.next();
			
			%>
					<tr>
						<td><input readonly type="text" value="<%= rs.getString("ssn") %>" name="ssn"></td> 
						<td><input readonly type="text" value="<%= rs.getString("first_name") %>" name="first_name"></td>
						<td><input readonly type="text" value="<%= rs.getString("middle_name") %>" name="middle_name"></td>
						<td><input readonly type="text" value="<%= rs.getString("last_name") %>" name="last_name"></td>
					</tr>
				</table>
			<%
			
 			// Grab all courses of the student
			query = "SELECT cc.course_id " +
 					"FROM class_courses cc, section_enrollment se " +
 					"WHERE se.sid = ? AND cc.class_title = se.class_title AND cc.qtr = se.qtr AND cc.year = se.year";
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			ArrayList<String> studCourses = new ArrayList<String>();
			
			while(rs.next()){
				studCourses.add(rs.getString("course_id"));
			}
			
			// Query all the sections the student is taking
			// > Feed section attr. to grab the cron_dates
			// > Make a list([regular cron_dates])
			query = "SELECT sm.cron_date, sm.meeting_type " +
					"FROM section_enrollment se, section_meeting sm " + 
					"WHERE se.sid = ? AND sm.class_title = se.class_title AND sm.section_id = se.section_id AND sm.qtr = ? AND sm.year = ?";
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, sid);
			pstmt.setString(2, "SPRING");
			pstmt.setInt(3, 2018);
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			ArrayList<String> studCronDates = new ArrayList<String>();
			
			while(rs.next()){
				
				// If the meeting is regular, add it to the list
				if(rs.getString("meeting_type").equals("REGULAR") || 
					rs.getString("meeting_type").equals("DISCUSSION") ||
					rs.getString("meeting_type").equals("LECTURE") ||
					rs.getString("meeting_type").equals("LAB")){
					
					studCronDates.add(rs.getString("cron_date"));
				}
			}
			
			// Query all the classes that are in SPRING 2018
			// > Similarly, make a map(course_id, [regular cron_dates])
			query = "SELECT sm.cron_date, sm.class_title, sm.section_id, sm.meeting_type, cc.course_id " +
					"FROM section_meeting sm, class_courses cc " +
					"WHERE sm.class_title = cc.class_title AND sm.qtr = cc.qtr AND sm.year = cc.year " +
					"AND sm.qtr = ? AND sm.year = ?";
			
			pstmt = connection.prepareStatement(query);
			pstmt.setString(1, "SPRING");
			pstmt.setInt(2, 2018);
			
			// Execute query and show results
			rs = pstmt.executeQuery();
			HashMap<String, HashMap<String, ArrayList<String>>> courseMeetings = new HashMap<String, HashMap<String, ArrayList<String>>>();
			HashMap<String, String> courseTitle = new HashMap<String, String>();
			
			while(rs.next()){
				
				// If the student is taking the current course, continue
				if(studCourses.contains(rs.getString("course_id"))){
					continue;
				}
				
				String courseId = rs.getString("course_id");
				String sectionId = rs.getString("section_id");
				courseTitle.put(courseId, rs.getString("class_title"));
				
				// If the course has not been added to the map
				if(!courseMeetings.containsKey(courseId)){
					HashMap<String, ArrayList<String>> sectionMeeting = new HashMap<String, ArrayList<String>>();					
					courseMeetings.put(courseId, sectionMeeting);
					
					ArrayList<String> meetings = new ArrayList<String>();
					courseMeetings.get(courseId).put(sectionId, meetings);
				}
				
				// If the section has not been added to the map
				else if(!courseMeetings.get(courseId).containsKey(sectionId)){
					ArrayList<String> meetings = new ArrayList<String>();
					courseMeetings.get(courseId).put(sectionId, meetings);
				}
				
				// If the meeting is regular, add it to the list
				if(rs.getString("meeting_type").equals("REGULAR") || 
					rs.getString("meeting_type").equals("DISCUSSION") ||
					rs.getString("meeting_type").equals("LECTURE") ||
					rs.getString("meeting_type").equals("LAB")){
					
					courseMeetings.get(courseId).get(sectionId).add(rs.getString("cron_date"));
				}
			}
			
			// Go through all courses and see if their regular cron_dates
			// conflict with the students cron_dates
			// 120 0 13 ? ? MON,WED (duration start_min start_hour day_month month day_week)
			
			// DON'T FACTOR IN STUDENT'S OWN COURSES
			
			%>
			<table class="results-table">
			<tr>
				<div id="table-title">Conflicting Courses</div>
			</tr>
			<tr>
				<th>Course ID</th>
				<th>Class Title</th>
			</tr>
			<%
			
			// Loop through course by course
			for(String courseId : courseMeetings.keySet()){
				
				// keeps track of how many sections conflict with the student's schedule
				int sectionConflict = 0;
				
				// Loop through section by section
				for(String sectionId : courseMeetings.get(courseId).keySet()){
					
					// keeps track if there is a meeting conflict in the current section
					boolean meetingConflict = false;
					
					// Loop through section's regular-meeting by regular-meeting
					for(String meeting : courseMeetings.get(courseId).get(sectionId)){
						
						String[] date = meeting.split(" ");
						
						int duration = Integer.parseInt(date[0]);
						int startMin = Integer.parseInt(date[1]);
						int startHour = Integer.parseInt(date[2]);
/* 						String[] dayMonth = date[3].split(",");
						String[] month = date[4].split(","); */
						String[] daysOfWeek = date[5].split(",");
						
						// Loop through student's regular-meeting by regular-meeting
						for(String studentMeeting : studCronDates){
							String[] studDate = studentMeeting.split(" ");
							
							int studDuration = Integer.parseInt(studDate[0]);
							int studStartMin = Integer.parseInt(studDate[1]);
							int studStartHour = Integer.parseInt(studDate[2]);
/* 							String[] studDayMonth = studDate[3].split(",");
							String[] studMonth = studDate[4].split(","); */
							String[] studDaysOfWeek = studDate[5].split(",");
							
							// Are any of the meeting days conflicting with the student schedule
							for(String day : daysOfWeek){
								
								// Day is in student day of week
								if(Arrays.asList(studDaysOfWeek).contains(day)){
									
									// Convert hour to all minutes
									int startTime = (startHour * 60) + startMin;
									int endTime = startTime + duration;
									
									// Do the same conversion for student time
									int studStartTime = (studStartHour * 60) + studStartMin;
									int studEndTime = studStartTime + studDuration;
										
									// if the times line up, they conflict
									if((studStartTime >= startTime && studStartTime <= endTime) ||
										startTime >= studStartTime && startTime <= studEndTime){
										
										meetingConflict = true;
										break;
									}
								}
							} // (Looping through section's meeting's days of the week) daysOfWeek
							
							// meaning there is a conflict with the student schedule, so no need
							// to keep looping and move onto the next section/course
							if(meetingConflict){
								break;
							}
							
						} // (Looping through student schedule) studCronDates
						
						// meaning there is a conflict with the student schedule, so no need
						// to keep looping and move onto the next section/course
						if(meetingConflict){
							break;
						}
						
					} // (Looping through section's meetings) courseMeetings.get(courseId).get(sectionId)
					
					// meaning there is a conflict with the student schedule, so no need
					// to keep looping and move onto the next section/course
					if(meetingConflict){
						sectionConflict++;
					}
					
				} // (Looping through sections) courseMeetings.get(courseId).keySet()
				
				if(sectionConflict == courseMeetings.get(courseId).size()){
					%>
							<tr>
								<td><input readonly type="text" value="<%= courseId %>" name="course_id"></td> 
								<td><input readonly type="text" value="<%= courseTitle.get(courseId) %>" name="title"></td>
							</tr>
					<%
				}
				
			} // (Looping through courses) courseMeetings.keySet()
			
			// Close everything
			pstmt.close();
			rs.close();
			connection.close();
		}
		%>
			</table>
		</body>
	</head>
</html>
