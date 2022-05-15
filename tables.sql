CREATE TABLE CLUB(
	SID VARCHAR(255) NOT NULL REFERENCES student ON DELETE CASCADE,
	NAME VARCHAR(255) NOT NULL,
	ROLE VARCHAR(255) NOT NULL,
	foreign key (sid) references student(sid)
);

CREATE TABLE STUDENT (
	SSN int NOT NULL UNIQUE,
	sid VARCHAR(255) NOT NULL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	middle_name VARCHAR(255),
	last_name VARCHAR(255) NOT NULL,
	resident_status VARCHAR(255) NOT NULL,
	enrollment_status VARCHAR(255) NOT NULL
);

CREATE TABLE periods_attended (
	sid VARCHAR(255) NOT NULL references student on delete cascade,
	start_qtr VARCHAR(255) NOT NULL,
	start_year int NOT NULL,
	end_qtr VARCHAR(255),
	end_year int,
	PRIMARY KEY (sid, start_qtr, start_year)
);

CREATE TABLE previous_degrees(
	sid varchar(255) not null references student on delete cascade,
	institution varchar(255) not null,
	level varchar(255) not null,
	previous_degree_name varchar(255) not null,
	foreign key (sid) references student(sid),
	PRIMARY KEY (sid, institution, level, previous_degree_name)
);

CREATE TABLE probation(
	sid varchar(255) not null references student on delete cascade,
	reason varchar(255) not null,
	start_qtr varchar(255) not null,
	start_year int not null,
	end_qtr varchar(255) not null,
	end_year int not null,
	foreign key (sid) references student(sid),
	PRIMARY KEY (sid, reason, start_qtr, start_year)
);

CREATE TABLE class(
	class_title VARCHAR(255) NOT NULL,
	qtr VARCHAR(255) NOT NULL,
	year int NOT NULL,
	grade_option VARCHAR(255) NOT NULL,
	primary key (class_title, qtr, year)
);

CREATE TABLE class_section(
	class_title VARCHAR(255) NOT NULL,
	qtr VARCHAR(255) NOT NULL,
	year int NOT NULL,
	section_id VARCHAR(255) NOT NULL,
	enrollment_limit int NOT NULL,
	faculty_name VARCHAR(255) NOT NULL,
	foreign key (class_title, qtr, year) references class(class_title, qtr, year) on delete cascade on update cascade,
	foreign key (faculty_name) references faculty(faculty_name) on delete cascade on update cascade,
	primary key (class_title, qtr, year, section_id)
);

CREATE TABLE section_meeting(
	class_title VARCHAR(255) NOT NULL,
	qtr VARCHAR(255) NOT NULL,
	year int NOT NULL,
	section_id VARCHAR(255) NOT NULL,
	room VARCHAR(255) NOT NULL,
	cron_date VARCHAR(255) NOT NULL,
	mandatory VARCHAR(255) NOT NULL,
	meeting_type VARCHAR(255) NOT NULL,
	foreign key (class_title, qtr, year) references class(class_title, qtr, year) on delete cascade on update cascade, 
	primary key (class_title, qtr, year, section_id, room, cron_date)
);

CREATE TABLE class_courses(
	course_id VARCHAR(255) NOT NULL,
	class_title VARCHAR(255) NOT NULL,
	qtr VARCHAR(255) NOT NULL,
	year int NOT NULL,
	foreign key (class_title, qtr, year) references class(class_title, qtr, year) on delete cascade on update cascade,
	foreign key (course_id) references courses(course_id) on delete cascade on update cascade,
	primary key (course_id, class_title, qtr, year)
);

CREATE TABLE courses(
	course_id varchar(255) primary key,
	min_units int not null,
	max_units int not null,
	grade_type varchar(255) not null,
	requires_lab varchar(255) not null,
	dep_name varchar(255) not null,
	foreign key (dep_name) references department(dep_name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE department(
	dep_name varchar(255) primary key
);

CREATE TABLE degree(
	deg_name varchar(255) not null,
	deg_level varchar(255) not null,
	min_units int not null,
	dep_name varchar(255) not null references department ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (dep_name) references department(dep_name),
	primary key (deg_name, deg_level)
);

CREATE TABLE concentration(
	deg_name varchar(255) not null,
	deg_level varchar(255) not null,
	con_name varchar(255) primary key,
	min_courses int not null,
	con_gpa real not null,
	foreign key (deg_name, deg_level) references degree(deg_name, deg_level) ON DELETE CASCADE
);

CREATE TABLE concentration_courses(
	con_name varchar(255),
	course_id varchar(255),
	foreign key (con_name) references concentration(con_name) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (course_id) references courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key (con_name, course_id)
);

CREATE TABLE categories(
	deg_name varchar(255) not null,
	deg_level varchar(255) not null,
	cat_name varchar(255) not null,
	min_units int not null,
	cat_gpa real not null,
	course_id varchar(255) not null,
	foreign key (course_id) references courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (deg_name, deg_level) references degree(deg_name, deg_level) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key (deg_name, deg_level, cat_name, course_id)
);

CREATE TABLE thesis_committee(
	sid varchar(255),
	faculty_name varchar(255),
	foreign key (sid) references student(sid) ON DELETE CASCADE ON UPDATE CASCADE,
	foreign key (faculty_name) references faculty(faculty_name) ON DELETE CASCADE ON UPDATE CASCADE,
	primary key (sid, faculty_name)
);

CREATE TABLE major (
	sid varchar(255) primary key references student on delete cascade,
	major varchar(255) not null,
	foreign key (sid) references student(sid)
);

CREATE TABLE minor (sid varchar(255) primary key references student on delete cascade,
	minor varchar(255) not null,
	foreign key (sid) references student(sid)
);

CREATE TABLE college (sid varchar(255) primary key references student on delete cascade,
	college varchar(255) not null,
	foreign key (sid) references student(sid)
);

CREATE TABLE phd (sid varchar(255) primary key references student on delete cascade,
	phd_type varchar(255) not null,
	dep_name varchar(255) not null references department on delete cascade,
	foreign key (dep_name) references department(dep_name)
);

CREATE TABLE faculty (faculty_name varchar(255) primary key,
	faculty_title varchar(255) not null,
	dep_name varchar(255) references department on delete cascade,
	foreign key (dep_name) references department(dep_name)
);

CREATE TABLE candidate (
	sid varchar(255) primary key references student on delete cascade,
	advisor varchar(255) references faculty on delete cascade,
	foreign key (advisor) references faculty(faculty_name)
); 

CREATE TABLE grad (
	sid varchar(255) primary key references student on delete cascade,
	grad_type varchar(255) not null,
	dep_name varchar(255) not null references department on delete cascade,
	foreign key (dep_name) references department(dep_name)
);

create table prerequisite(
	course_id varchar(255) not null,
	pre_course_id varchar(255),
	instructor_consent varchar(255),
	foreign key (course_id) references courses(course_id) on delete cascade on update cascade,
	foreign key (pre_course_id) references courses(course_id) on delete cascade on update cascade
);

Create table student_classes(
	sid varchar(255) not null,
	grade varchar(255) not null,
	class_title varchar(255) not null,
	qtr varchar(255) not null,
	year int not null,
	section_id varchar(255) not null,
	foreign key (sid) references student(sid) on delete cascade on update cascade,
	foreign key(class_title, qtr, year) references class(class_title, qtr, year) on delete cascade on update cascade,
	foreign key (class_title, qtr, year, section_id) references class_section(class_title, qtr, year, section_id) on delete cascade on update cascade
);

create table section_enrollment(
	class_title varchar(255) not null,
	qtr varchar(255) not null,
	year int not null,
	section_id varchar(255) not null,
	sid varchar(255) not null,
	units int not null,
	grade varchar(255) not null,
	foreign key (class_title, qtr, year, section_id) references class_section(class_title,qtr,year, section_id) on delete cascade on update cascade,
	foreign key (sid) references student(sid) on delete cascade on update cascade
);

create table section_waitlist (
	class_title varchar(255) not null,
	qtr varchar(255) not null,
	year int not null,
	section_id varchar(255) not null,
	sid varchar(255) not null,
	units int not null,
	grade varchar(255) not null,
	foreign key (class_title, qtr, year, section_id) references class_section(class_title, qtr, year, section_id) on delete cascade on update cascade,
	foreign key (sid) references student(sid) on delete cascade on update cascade
);
