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
