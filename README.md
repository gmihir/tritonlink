# TritonLink

## Useful Commands
psql postgres -U username\
DROP DATABASE TRITONLINKDB;\
CREATE DATABASE TRITONLINKDB;\
\c tritonlinkdb\
\i file-path

## How to build project

First, you will need to install Eclipse and create a new dynamic web project. Then, get the files we have created and import them into your project. Next, you should install PostgreSQL locally, as well as Apache Tomcat v.9.0. Then, just navigate to home.jsp click run in Eclipse!

## The Forms

### Home Page

This isn't a form but it is a static home page.

### Categories Form

This form is used to create categories for a degree and can add courses to the category.

### Classes Form

This form is used to create a class, which is an instance of a course. When creating the classes, a user can also create sections simultaneously.


### Thesis Committee Form

This form is used to create and assign a thesis committee to a graduate student. 

### Concentration Courses

This form is used to load courses into a specific concentration.

### Clubs

This form is used to store which clubs a student is in as well as their position in the club.

### Course Enrollment

This form is used to enroll students in a course. 

### Previous Degrees Form

This form is used to store a student's previous degrees. 

### Probation

This form is used to store a student's probation period(s). A student can have any number of probation periods.

### Undergrad Form 

This form is used to create an undergraduate student.

### Graduate Form

This form is used to create a graduate student.

### PhD Form

This form is used to create a PhD student.

### Meetings Form

This form is used to create a meeting for a specific section of a class.

### Periods Attended 

This form is used to enter a student's periods of attendance.

### Faculty Form

This form is used to create a faculty and assign them a department.

### Department

This form is used to create a department.

### Degree Requirements Form

This form is used to enter the requirements for a degree that a student can obtain.

### Concentration

This form is used to create a concentration for a specific degree.

### Course Entry

This form is used to create a course. This course can then be taken by a student once it is a class.

### Prerequisites

This form is used to designate a prerequisite for a specific course.

### Classes Previously Taken

This form is used to store the classes a student has taken and the grades they have received.

### Waitlist Enrollment

This form is used to enroll students in a waitlist for a class if all sections of the class are at their enrollment limit.

## Entity &#8594; JSP Mapping
previous_degree &#8594; previous_degree.jsp\
student &#8594; undergrad_entry.jsp, grad_entry.jsp, phd_entry.jsp\
club &#8594; club_entry_form.jsp\
periods_of_attendance &#8594; periods_attended.jsp\
probation &#8594; probation_entry_form.jsp\
graduate &#8594; grad_entry.jsp\
undergraduate &#8594; undergrad_entry.jsp\
phd &#8594; phd_entry.jsp\
thesis_committee &#8594; thesis_committee.jsp\
candidate &#8594; phd_entry.jsp\
department &#8594; department.jsp\
degree &#8594; degree_entry.jsp\
concentration &#8594; concentration_form.jsp, concentration_courses.jsp\
category &#8594; categories.jsp\
courses &#8594; course_entry_form.jsp, course_enrollment.jsp, concentration_courses.jsp\
pre_req &#8594; prereq_entry.jsp\
class &#8594; classes.jsp, past_classes.jsp\
section &#8594; course_enrollment.jsp, classes.jsp\
meetings &#8594; meeting_form.jsp\
enrolled_students &#8594; course_enrollment.jsp\
waitlisted_students &#8594; waitlist_enrollment.jsp\
faculty &#8594; faculty_entry.jsp
