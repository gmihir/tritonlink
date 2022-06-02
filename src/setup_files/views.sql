CREATE MATERIALIZED VIEW CPQG AS (
	SELECT course_id, faculty_name, qtr, grade, COUNT(grade)
	FROM (SELECT cc.course_id, cs.faculty_name, sc.qtr, sc.grade
			FROM class_courses cc, class_section cs, student_classes sc
			WHERE cc.class_title = cs.class_title AND cc.qtr = cs.qtr AND cc.year = cs.year AND cs.qtr = sc.qtr AND cs.year = sc.year AND cs.class_title = sc.class_title AND cs.section_id = sc.section_id) AS bigboy
	GROUP BY (course_id, faculty_name, qtr, grade)
);

