CREATE TABLE CPQG AS (
SELECT course_id, faculty_name, qtr, grade, COUNT(grade)
FROM (SELECT cc.course_id, cs.faculty_name, sc.qtr, sc.grade
		FROM class_courses cc, class_section cs, student_classes sc
		WHERE cc.class_title = cs.class_title AND cc.qtr = cs.qtr AND cc.year = cs.year AND cs.qtr = sc.qtr AND cs.year = sc.year AND cs.class_title = sc.class_title AND cs.section_id = sc.section_id) AS bigboy
GROUP BY (course_id, faculty_name, qtr, grade)
);

CREATE TABLE CPG AS (
SELECT course_id, faculty_name, grade, COUNT(grade)
FROM (SELECT cc.course_id, cs.faculty_name, sc.grade
		FROM class_courses cc, class_section cs, student_classes sc
		WHERE cc.class_title = cs.class_title AND cc.qtr = cs.qtr AND cc.year = cs.year AND cs.qtr = sc.qtr AND cs.year = sc.year AND cs.class_title = sc.class_title AND cs.section_id = sc.section_id) AS bigboy
GROUP BY (course_id, faculty_name, grade)
);

CREATE FUNCTION cpqg_update() RETURNS trigger AS $cpqg_update$
	DECLARE 
		exists int;
		facultyName varchar;
		courseId varchar;
	BEGIN


	select course_id into courseId from class_courses where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year;

	select faculty_name into facultyName from class_section where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year and section_id = NEW.section_id;


	SELECT COUNT(*) INTO exists FROM CPQG WHERE course_id = courseId AND faculty_name = facultyName AND qtr = NEW.qtr AND grade = NEW.grade;

	IF (exists > 0) THEN
		-- update case

		UPDATE CPQG SET count = (select count from CPQG where course_id = courseId AND faculty_name = facultyName AND qtr = NEW.qtr AND grade = NEW.grade) + 1 WHERE course_id = courseId AND faculty_name = facultyName AND qtr = NEW.qtr AND grade = NEW.grade;

	ELSIF (exists = 0) THEN 
		-- insert row case
		INSERT INTO CPQG VALUES (courseId, facultyName, NEW.qtr, NEW.grade, 1);

	END IF;

	RETURN NULL;

	END;
$cpqg_update$ LANGUAGE plpgsql;

CREATE TRIGGER update_cpqg 
AFTER INSERT OR UPDATE
ON student_classes
FOR EACH ROW
EXECUTE FUNCTION cpqg_update();


CREATE FUNCTION cpg_update() RETURNS trigger AS $cpg_update$
	DECLARE 
		exists int;
		facultyName varchar;
		courseId varchar;
	BEGIN


	select course_id into courseId from class_courses where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year;

	select faculty_name into facultyName from class_section where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year and section_id = NEW.section_id;


	SELECT COUNT(*) INTO exists FROM CPG WHERE course_id = courseId AND faculty_name = facultyName AND grade = NEW.grade;

	IF (exists > 0) THEN
		-- update case

		UPDATE CPG SET count = (select count from CPG where course_id = courseId AND faculty_name = facultyName AND grade = NEW.grade) + 1 WHERE course_id = courseId AND faculty_name = facultyName AND grade = NEW.grade;

	ELSIF (exists = 0) THEN 
		-- insert row case
		INSERT INTO CPG VALUES (courseId, facultyName, NEW.grade, 1);

	END IF;

	RETURN NULL;

	END;
$cpg_update$ LANGUAGE plpgsql;

CREATE TRIGGER cpg 
AFTER INSERT OR UPDATE
ON student_classes
FOR EACH ROW
EXECUTE FUNCTION cpg_update();

CREATE FUNCTION enrollment_check() RETURNS trigger AS $enrollment_check$
DECLARE
	enrollmentLimit int;
	currentEnrollment int;
BEGIN

SELECT ENROLLMENT_LIMIT INTO enrollmentLimit FROM CLASS_SECTION WHERE SECTION_ID = NEW.SECTION_ID AND QTR = NEW.QTR AND YEAR = NEW.YEAR AND CLASS_TITLE = NEW.CLASS_TITLE;

SELECT COUNT(SID) INTO currentEnrollment FROM SECTION_ENROLLMENT WHERE SECTION_ID = NEW.SECTION_ID AND QTR = NEW.QTR AND YEAR = NEW.YEAR AND CLASS_TITLE = NEW.CLASS_TITLE;

IF (currentEnrollment >= enrollmentLimit) THEN
	-- insert not allowed
	RAISE EXCEPTION 'Enrollment Limit Reached.';
END IF;

RETURN NEW;
END;
$enrollment_check$ LANGUAGE plpgsql;

CREATE TRIGGER check_enrollment_limit 
BEFORE INSERT OR UPDATE
ON section_enrollment
FOR EACH ROW
EXECUTE FUNCTION enrollment_check();

-- Part 4 Section 1

CREATE FUNCTION meeting_check() RETURNS trigger AS $meeting_check$
DECLARE
	startTimeMinutes int;
	endTimeMinutes int;
	duration int;
	startMin int;
	startHour int;
	dayOfWeekString varchar;
	existsStartTimeMinutes int;
	existsEndTimeMinutes int;
	existsDuration int;
	existsStartMin int;
	existsStartHour int;
	existsDayOfWeek varchar;
	isConflict int;
	sameDay int;
	currentDay varchar;
	temprow RECORD;
	cronDay varchar;
BEGIN

select into duration CAST( (select (string_to_array(NEW.cron_date, ' '))[1]) as int);
select into startMin CAST( (select (string_to_array(NEW.cron_date, ' '))[2]) as int);
select into startHour CAST( (select (string_to_array(NEW.cron_date, ' '))[3]) as int);
select into dayOfWeekString (string_to_array(NEW.cron_date, ' '))[6];

IF (NEW.meeting_type NOT IN ('REGULAR', 'LECTURE', 'DISCUSSION', 'LAB')) THEN
	RETURN NEW;
END IF;

isConflict = 0;
startTimeMinutes = startHour*60 + startMin;
endTimeMinutes = startTimeMinutes + duration;

-- need to get all conflicts
FOR temprow IN select cron_date from section_meeting where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year AND section_id = NEW.section_id AND meeting_type IN ('REGULAR', 'LECTURE', 'DISCUSSION', 'LAB')
    LOOP
	    -- put in here
		select into existsDuration CAST( (select (string_to_array(temprow.cron_date, ' '))[1]) as int);
		select into existsStartMin CAST( (select (string_to_array(temprow.cron_date, ' '))[2]) as int);
		select into existsStartHour CAST( (select (string_to_array(temprow.cron_date, ' '))[3]) as int);
		select into existsDayOfWeek (string_to_array(temprow.cron_date, ' '))[6];
	    
	    -- check if current cron meeting is in conflict

	    existsStartTimeMinutes = existsStartHour*60 + existsStartMin;
	    existsEndTimeMinutes = existsStartTimeMinutes + existsDuration;

	    -- check if the crontabs contain the same day(s)

	    sameDay = 0;


	    FOR cronDay IN select (string_to_array(existsDayOfWeek, ','))
		LOOP 
			select into sameDay (select 1 as col where cronDay LIKE '%' || dayOfWeekString || '%');

			EXIT WHEN sameDay = 1;
		END LOOP;	


	    IF (sameDay = 1 AND ( (startTimeMinutes >= existsStartTimeMinutes AND startTimeMinutes < existsEndTimeMinutes) OR (existsStartTimeMinutes >= startTimeMinutes AND existsStartTimeMinutes < endTimeMinutes) )) THEN 
		    isConflict = 1;
		    RAISE EXCEPTION 'THIS MEETING TIME CONFLICTS WITH ANOTHER TIME IN THE SECTION.';
		    END IF;
	    END LOOP;

	    RETURN NEW;
END;
$meeting_check$ LANGUAGE plpgsql;

CREATE TRIGGER check_meeting 
BEFORE INSERT OR UPDATE
ON section_meeting
FOR EACH ROW
EXECUTE FUNCTION meeting_check();



-- Part 4 Section 2.1

CREATE FUNCTION check_faculty_sections() RETURNS trigger AS $check_faculty_sections$
DECLARE
	startTimeMinutes int;
	endTimeMinutes int;
	duration int;
	startMin int;
	startHour int;
	dayOfWeekString varchar;
	existsStartTimeMinutes int;
	existsEndTimeMinutes int;
	existsDuration int;
	existsStartMin int;
	existsStartHour int;
	existsDayOfWeek varchar;
	isConflict int;
	sameDay int;
	currentDay varchar;
	temprow RECORD;
	cronDay varchar;

	-- New Variables
	meeting_type varchar;
	all_section_meetings RECORD;
BEGIN

	-- If the faculty is staff, its a placeholder so exit
	IF (NEW.faculty_name = 'STAFF') THEN
		RETURN NEW;
	END IF;

	-- Loop through all meetings for the section the faculty enrolled in
	FOR temprow IN select * from section_meeting where class_title = NEW.class_title AND qtr = NEW.qtr AND year = NEW.year AND section_id = NEW.section_id
	    LOOP

    	-- Define the faculty's section meeting variables
    	select into duration CAST( (select (string_to_array(temprow.cron_date, ' '))[1]) as int);
		select into startMin CAST( (select (string_to_array(temprow.cron_date, ' '))[2]) as int);
		select into startHour CAST( (select (string_to_array(temprow.cron_date, ' '))[3]) as int);
		select into dayOfWeekString (string_to_array(temprow.cron_date, ' '))[6];

		-- The meeting is not a regular type, so continue the loop
		IF (temprow.meeting_type NOT IN ('REGULAR', 'LECTURE', 'DISCUSSION', 'LAB')) THEN
			CONTINUE;
		END IF;

		-- Convert the faculty's time to minutes
		isConflict = 0;
		startTimeMinutes = startHour * 60 + startMin;
		endTimeMinutes = startTimeMinutes + duration;

		-- For all the other section's meetings the faculty is signed up for
		FOR all_section_meetings IN select sm.* from class_section cs, section_meeting sm where cs.faculty_name = NEW.faculty_name AND cs.class_title = sm.class_title AND cs.qtr = sm.qtr AND cs.year = sm.year
			LOOP

			    -- Define the faculty's other section meeting variables
				select into existsDuration CAST( (select (string_to_array(all_section_meetings.cron_date, ' '))[1]) as int);
				select into existsStartMin CAST( (select (string_to_array(all_section_meetings.cron_date, ' '))[2]) as int);
				select into existsStartHour CAST( (select (string_to_array(all_section_meetings.cron_date, ' '))[3]) as int);
				select into existsDayOfWeek (string_to_array(all_section_meetings.cron_date, ' '))[6];
			    
			    -- Convert the meeting time to minutes
			    existsStartTimeMinutes = existsStartHour * 60 + existsStartMin;
			    existsEndTimeMinutes = existsStartTimeMinutes + existsDuration;

			    sameDay = 0; -- check if the crontabs contain the same day(s)

			    -- For all the cron days in the OTHER section meeting
			    FOR cronDay IN select (string_to_array(existsDayOfWeek, ','))
				LOOP 
					select into sameDay (select 1 as col where cronDay LIKE '%' || dayOfWeekString || '%');

					EXIT WHEN sameDay = 1;
				END LOOP;

				-- THERE IS A CONFLICT, ABORT MISSION
			    IF (sameDay = 1 AND ( (startTimeMinutes >= existsStartTimeMinutes AND startTimeMinutes < existsEndTimeMinutes) OR (existsStartTimeMinutes >= startTimeMinutes AND existsStartTimeMinutes < endTimeMinutes) )) THEN 
				    isConflict = 1;
				    RAISE EXCEPTION 'CONFLICTING MEETING TIMES.';
				    END IF;
		END LOOP;

    END LOOP;

    RETURN NEW;
END;
$check_faculty_sections$ LANGUAGE plpgsql;


CREATE TRIGGER faculty_section_update 
BEFORE INSERT OR UPDATE
ON class_section
FOR EACH ROW
EXECUTE FUNCTION check_faculty_sections();



-- Part 4 Section 2.1

CREATE FUNCTION check_meeting_section() RETURNS trigger AS $check_meeting_section$
DECLARE
	facultyName varchar;
BEGIN

	-- Get the faculty name from the inserted/updated section_meeting
	select faculty_name into facultyName from class_section where NEW.class_title = class_title AND NEW.qtr = qtr AND NEW.year = year AND NEW.section_id = section_id;

	-- If the faculty is staff, its a placeholder so exit
	IF (facultyName <> 'STAFF') THEN
		RAISE EXCEPTION 'CANNOT CREATE MEETING AFTER ASSIGNING TO A FACULTY.';
	END IF;

	RETURN NEW;
END;
$check_meeting_section$ LANGUAGE plpgsql;


CREATE TRIGGER meeting_section_update 
BEFORE INSERT OR UPDATE
ON section_meeting
FOR EACH ROW
EXECUTE FUNCTION check_meeting_section();
