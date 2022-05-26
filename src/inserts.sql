-- 1
--INSERT INTO DEGREE VALUES ('COMPUTER SCIENCE','BS',32, 'JACOBS SCHOOL OF ENGINEERING');
--INSERT INTO CATEGORIES ('COMPUTER SCIENCE', 'BS', 'UPPER DIVISION', 12, -1, )



-- 35-37
INSERT INTO DEPARTMENT VALUES ('JSOE');
INSERT INTO FACULTY VALUES ('FACULTY1', 'PROFESSOR', 'JSOE');
INSERT INTO FACULTY VALUES ('FACULTY2', 'PROFESSOR', 'JSOE');
INSERT INTO FACULTY VALUES ('FACULTY3', 'PROFESSOR', 'JSOE');

-- 8
INSERT INTO COURSES VALUES ('CSE132A', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('DATABASE SYSTEM PRINCIPLES', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE132A', 'DATABASE SYSTEM PRINCIPLES', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM PRINCIPLES', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2015, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE132A', 'DATABASE SYSTEM PRINCIPLES', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2015, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE132A', 'DATABASE SYSTEM PRINCIPLES', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2017, 'A00', 100, 'FACULTY1');

-- 9
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'SPRING', 2018, 'A00', 'WH100', '120 0 13 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'SPRING', 2018, 'A00', 'WH100', '50 0 13 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2017, 'A00', 'WH100', '120 0 13 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2017, 'A00', 'WH100', '50 0 13 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2015, 'A00', 'WH100', '120 0 13 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM PRINCIPLES', 'FALL', 2015, 'A00', 'WH100', '50 0 13 ? 1 FRI', 'NO', 'DISCUSSION');
-- 10
INSERT INTO COURSES VALUES ('CSE150A', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE150A', 'INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'SPRING', 2018, 'A00', 100, 'FACULTY2');

INSERT INTO CLASS VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE150A', 'INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2017, 'A00', 100, 'FACULTY2');

INSERT INTO CLASS VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2015, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE150A', 'INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2015, 'A00', 100, 'FACULTY2');

-- 11
INSERT INTO SECTION_MEETING VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'SPRING', 2018, 'A00', 'WH100', '120 0 14 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2017, 'A00', 'WH100', '120 0 14 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('INTRODUCTION TO ARTIFICIAL INTELLIGENCE', 'FALL', 2015, 'A00', 'WH100', '120 0 14 ? 1 MON,WED', 'NO', 'REGULAR');


-- 12
INSERT INTO COURSES VALUES ('CSE124A', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('NETWORKED SYSTEMS', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE124A', 'NETWORKED SYSTEMS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('NETWORKED SYSTEMS', 'SPRING', 2018, 'A00', 100, 'FACULTY2');

INSERT INTO CLASS VALUES ('NETWORKED SYSTEMS', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE124A', 'NETWORKED SYSTEMS', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('NETWORKED SYSTEMS', 'FALL', 2017, 'A00', 100, 'FACULTY2');

INSERT INTO CLASS VALUES ('NETWORKED SYSTEMS', 'FALL', 2015, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE124A', 'NETWORKED SYSTEMS', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('NETWORKED SYSTEMS', 'FALL', 2015, 'A00', 100, 'FACULTY2');

-- 13
INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'SPRING', 2018, 'A00', 'WH100', '80 0 20 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'SPRING', 2018, 'A00', 'WH100', '50 0 12 ? 1 MON', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'FALL', 2017, 'A00', 'WH100', '80 0 20 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'FALL', 2017, 'A00', 'WH100', '50 0 12 ? 1 MON', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'FALL', 2015, 'A00', 'WH100', '80 0 20 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('NETWORKED SYSTEMS', 'FALL', 2015, 'A00', 'WH100', '50 0 12 ? 1 MON', 'NO', 'DISCUSSION');

-- 14
INSERT INTO COURSES VALUES ('CSE132B', 4, 4, 'BOTH', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('DATABASE SYSTEM APPLICATIONS', 'SPRING', 2018, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM APPLICATIONS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM APPLICATIONS', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2017, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM APPLICATIONS', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2017, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2015, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM APPLICATIONS', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2015, 'A00', 100, 'FACULTY1');

-- 15
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM APPLICATIONS', 'SPRING', 2018, 'A00', 'WH100', '120 0 15 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2017, 'A00', 'WH100', '120 0 15 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('DATABASE SYSTEM APPLICATIONS', 'FALL', 2015, 'A00', 'WH100', '120 0 15 ? 1 TUE,THU', 'NO', 'REGULAR');

-- 16
INSERT INTO COURSES VALUES ('CSE132C', 4, 4, 'BOTH', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'SPRING', 2018, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM IMPLEMENTATION', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2017, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2017, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2015, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('CSE132B', 'DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('DATABASE SYSTEM IMPLEMENTATION', 'FALL', 2015, 'A00', 100, 'FACULTY1');

-- 17
INSERT INTO COURSES VALUES ('CSE130', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('PROGRAMMING LANGUAGES', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE130', 'PROGRAMMING LANGUAGES', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('PROGRAMMING LANGUAGES', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE130', 'PROGRAMMING LANGUAGES', 'FALL', 2017);
INSERT INTO CLASS_SECTION VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2017, 'A00', 100, 'FACULTY1');

INSERT INTO CLASS VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2015, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('CSE130', 'PROGRAMMING LANGUAGES', 'FALL', 2015);
INSERT INTO CLASS_SECTION VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2015, 'A00', 100, 'FACULTY1');

-- 18
INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'SPRING', 2018, 'A00', 'WH100', '180 0 10 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'SPRING', 2018, 'A00', 'WH100', '60 0 9 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2017, 'A00', 'WH100', '180 0 10 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2017, 'A00', 'WH100', '60 0 9 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2015, 'A00', 'WH100', '180 0 10 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('PROGRAMMING LANGUAGES', 'FALL', 2015, 'A00', 'WH100', '60 0 9 ? 1 FRI', 'NO', 'DISCUSSION');

-- 19
INSERT INTO COURSES VALUES ('CSE005', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROGRAMMING', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROGRAMMING', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROGRAMMING', 'FALL', 2015, 'LETTER');


INSERT INTO CLASS_COURSES VALUES ('CSE005', 'INTRODUCTION TO PROGRAMMING', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('CSE005', 'INTRODUCTION TO PROGRAMMING', 'FALL', 2017);
INSERT INTO CLASS_COURSES VALUES ('CSE005', 'INTRODUCTION TO PROGRAMMING', 'FALL', 2015);


INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROGRAMMING', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROGRAMMING', 'FALL', 2017, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROGRAMMING', 'FALL', 2015, 'A00', 100, 'FACULTY3');


-- 20
INSERT INTO COURSES VALUES ('CSE000', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2015, 'LETTER');


INSERT INTO CLASS_COURSES VALUES ('CSE000', 'INTRODUCTION TO COMPUTER SCIENCE', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('CSE000', 'INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2017);
INSERT INTO CLASS_COURSES VALUES ('CSE000', 'INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2015);


INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2017, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO COMPUTER SCIENCE', 'FALL', 2015, 'A00', 100, 'FACULTY3');

-- 21
INSERT INTO COURSES VALUES ('CSE007', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('PROGRAMMING WITH MATLAB', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('PROGRAMMING WITH MATLAB', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS VALUES ('PROGRAMMING WITH MATLAB', 'FALL', 2015, 'LETTER');


INSERT INTO CLASS_COURSES VALUES ('CSE007', 'PROGRAMMING WITH MATLAB', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('CSE007', 'PROGRAMMING WITH MATLAB', 'FALL', 2017);
INSERT INTO CLASS VALUES ('PROGRAMMING WITH MATLAB', 'FALL', 2015, 'LETTER');


INSERT INTO CLASS_SECTION VALUES ('PROGRAMMING WITH MATLAB', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('PROGRAMMING WITH MATLAB', 'FALL', 2017, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS VALUES ('PROGRAMMING WITH MATLAB', 'FALL', 2015, 'LETTER');


-- 22
INSERT INTO COURSES VALUES ('CSE008', 4, 4, 'LETTER', 'NO', 'JSOE');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2017, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2015, 'LETTER');


INSERT INTO CLASS_COURSES VALUES ('CSE008', 'INTRODUCTION TO PROBLEM SOLVING', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('CSE008', 'INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2017);
INSERT INTO CLASS_COURSES VALUES ('CSE008', 'INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2015);


INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2017, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO PROBLEM SOLVING', 'FALL', 2015, 'A00', 100, 'FACULTY3');


-- 23
INSERT INTO DEPARTMENT VALUES ('MATHEMATICS');

INSERT INTO COURSES VALUES ('MATH132A', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('PARTIAL DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('MATH132A', 'PARTIAL DIFFERENTIAL EQUATIONS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('PARTIAL DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO SECTION_MEETING VALUES ('PARTIAL DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'A00', 'WH100', '120 0 13 ? 1 MON,WED', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('PARTIAL DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'A00', 'WH100', '50 0 13 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO COURSES VALUES ('MATH150A', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('DIFFERENTIAL GEOMETRY', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('MATH150A', 'DIFFERENTIAL GEOMETRY', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('DIFFERENTIAL GEOMETRY', 'SPRING', 2018, 'A00', 100, 'FACULTY2');

INSERT INTO SECTION_MEETING VALUES ('DIFFERENTIAL GEOMETRY', 'SPRING', 2018, 'A00', 'WH100', '120 0 14 ? 1 MON,WED', 'NO', 'REGULAR');

INSERT INTO COURSES VALUES ('MATH124A', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('LEARNING MATH I', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('MATH124A', 'LEARNING MATH I', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('LEARNING MATH I', 'SPRING', 2018, 'A00', 100, 'FACULTY2');

INSERT INTO SECTION_MEETING VALUES ('LEARNING MATH I', 'SPRING', 2018, 'A00', 'WH100', '80 0 20 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('LEARNING MATH I', 'SPRING', 2018, 'A00', 'WH100', '50 0 12 ? 1 MON', 'NO', 'DISCUSSION');

INSERT INTO COURSES VALUES ('MATH132B', 4, 4, 'BOTH', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('INTEGRAL EQUATIONS', 'SPRING', 2018, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('MATH132B', 'INTEGRAL EQUATIONS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('INTEGRAL EQUATIONS', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO SECTION_MEETING VALUES ('INTEGRAL EQUATIONS', 'SPRING', 2018, 'A00', 'WH100', '120 0 15 ? 1 TUE,THU', 'NO', 'REGULAR');

INSERT INTO COURSES VALUES ('MATH132C', 4, 4, 'BOTH', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'BOTH');
INSERT INTO CLASS_COURSES VALUES ('MATH132B', 'DIFFERENTIAL EQUATIONS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('DIFFERENTIAL EQUATIONS', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO COURSES VALUES ('MATH130', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('FOUNDATIONS OF REAL ANALYSIS', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS_COURSES VALUES ('MATH130', 'FOUNDATIONS OF REAL ANALYSIS', 'SPRING', 2018);
INSERT INTO CLASS_SECTION VALUES ('FOUNDATIONS OF REAL ANALYSIS', 'SPRING', 2018, 'A00', 100, 'FACULTY1');

INSERT INTO SECTION_MEETING VALUES ('FOUNDATIONS OF REAL ANALYSIS', 'SPRING', 2018, 'A00', 'WH100', '180 0 10 ? 1 TUE,THU', 'NO', 'REGULAR');
INSERT INTO SECTION_MEETING VALUES ('FOUNDATIONS OF REAL ANALYSIS', 'SPRING', 2018, 'A00', 'WH100', '60 0 9 ? 1 FRI', 'NO', 'DISCUSSION');

INSERT INTO COURSES VALUES ('MATH005', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('PRECALC', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('PRECALC', 'FALL', 2017, 'LETTER');

INSERT INTO CLASS_COURSES VALUES ('MATH005', 'PRECALC', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('MATH005', 'PRECALC', 'FALL', 2017);

INSERT INTO CLASS_SECTION VALUES ('PRECALC', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('PRECALC', 'FALL', 2017, 'A00', 100, 'FACULTY3');

INSERT INTO COURSES VALUES ('MATH000', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('INTRODUCTION TO MATH', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('INTRODUCTION TO MATH', 'FALL', 2017, 'LETTER');

INSERT INTO CLASS_COURSES VALUES ('MATH000', 'INTRODUCTION TO MATH', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('MATH000', 'INTRODUCTION TO MATH', 'FALL', 2017);

INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO MATH', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('INTRODUCTION TO MATH', 'FALL', 2017, 'A00', 100, 'FACULTY3');

INSERT INTO COURSES VALUES ('MATH007', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('CALCULUS I', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('CALCULUS I', 'FALL', 2017, 'LETTER');

INSERT INTO CLASS_COURSES VALUES ('MATH007', 'CALCULUS I', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('MATH007', 'CALCULUS I', 'FALL', 2017);

INSERT INTO CLASS_SECTION VALUES ('CALCULUS I', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('CALCULUS I', 'FALL', 2017, 'A00', 100, 'FACULTY3');

INSERT INTO COURSES VALUES ('MATH008', 4, 4, 'LETTER', 'NO', 'MATHEMATICS');
INSERT INTO CLASS VALUES ('CALCULUS II', 'SPRING', 2018, 'LETTER');
INSERT INTO CLASS VALUES ('CALCULUS II', 'FALL', 2017, 'LETTER');

INSERT INTO CLASS_COURSES VALUES ('MATH008', 'CALCULUS II', 'SPRING', 2018);
INSERT INTO CLASS_COURSES VALUES ('MATH008', 'CALCULUS II', 'FALL', 2017);

INSERT INTO CLASS_SECTION VALUES ('CALCULUS II', 'SPRING', 2018, 'A00', 100, 'FACULTY3');
INSERT INTO CLASS_SECTION VALUES ('CALCULUS II', 'FALL', 2017, 'A00', 100, 'FACULTY3');

-- 24


