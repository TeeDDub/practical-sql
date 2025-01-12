---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------


-- 코드 7-1: departments 테이블과 employees 테이블 만들기

CREATE TABLE departments (
    dept_id integer,
    dept text,
    city text,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10,2),
    dept_id integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

INSERT INTO departments
VALUES
    (1, 'Tax', 'Atlanta'),
    (2, 'IT', 'Boston');

INSERT INTO employees
VALUES
    (1, 'Julia', 'Reyes', 115300, 1),
    (2, 'Janet', 'King', 98000, 1),
    (3, 'Arthur', 'Pappas', 72700, 2),
    (4, 'Michael', 'Taylor', 89500, 2);

-- 코드 7-2: employees 테이블과 departments 테이블 조인하기

SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id
ORDER BY employees.dept_id;

-- 코드 7-3: JOIN을 살펴보기 위한 두 테이블 생성하기

CREATE TABLE district_2020 (
    id integer CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 text
);

CREATE TABLE district_2035 (
    id integer CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 text
);

INSERT INTO district_2020 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Dover Middle School'),
    (6, 'Webutuck High School');

INSERT INTO district_2035 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Webutuck High School');

-- 코드 7-4: JOIN 사용하기

SELECT *
FROM district_2020 JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- INNER JOIN을 사용할 수도 있습니다.
SELECT *
FROM district_2020 INNER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 코드 7-5: USING을 사용한 JOIN

SELECT *
FROM district_2020 JOIN district_2035
USING (id)
ORDER BY district_2020.id;

-- 코드 7-6: LEFT JOIN 사용

SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 코드 7-7: RIGHT JOIN 사용

SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2035.id;

-- 코드 7-8: FULL OUTER JOIN 사용

SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 코드 7-9: CROSS JOIN 사용

SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;

-- CROSS JOIN은 쉼표(,)로 대체할 수 있습니다.
SELECT *
FROM district_2020, district_2035
ORDER BY district_2020.id, district_2035.id;

-- 또한 JOIN ... ON true로도 대체할 수 있습니다.
SELECT *
FROM district_2020 JOIN district_2035 ON true
ORDER BY district_2020.id, district_2035.id;

-- 코드 7-10: IS NULL로 결측값을 표시하도록 필터링하기

SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
WHERE district_2035.id IS NULL;

-- RIGHT JOIN을 사용한 방법
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
WHERE district_2020.id IS NULL;

-- 코드 7-11: 조인의 특정 열 쿼리하기

SELECT district_2020.id,
       district_2020.school_2020,
       district_2035.school_2035
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 코드 7-12: 테이블 별칭으로 코드 단순화하기

SELECT d20.id,
       d20.school_2020,
       d35.school_2035
FROM district_2020 AS d20 LEFT JOIN district_2035 AS d35
ON d20.id = d35.id
ORDER BY d20.id;

-- 코드 7-13: 여러 테이블 조인하기

CREATE TABLE district_2020_enrollment (
    id integer,
    enrollment integer
);

CREATE TABLE district_2020_grades (
    id integer,
    grades varchar(10)
);

INSERT INTO district_2020_enrollment
VALUES
    (1, 360),
    (2, 1001),
    (5, 450),
    (6, 927);

INSERT INTO district_2020_grades
VALUES
    (1, 'K-3'),
    (2, '9-12'),
    (5, '6-8'),
    (6, '9-12');

SELECT d20.id,
       d20.school_2020,
       en.enrollment,
       gr.grades
FROM district_2020 AS d20 JOIN district_2020_enrollment AS en
    ON d20.id = en.id
JOIN district_2020_grades AS gr
    ON d20.id = gr.id
ORDER BY d20.id;

-- 코드 7-14: UNION을 이용한 쿼리 결합

SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;

-- 코드 7-15: UNION ALL을 이용한 쿼리 결합

SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;

-- 코드 7-16: UNION 쿼리 커스터마이징

SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020

UNION ALL

SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;

-- 코드 7-17: INTERSECT와 EXCEPT를 사용한 쿼리 결합

SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;

-- 코드 7-18: 조인된 인구조사 테이블에서 수학 연산 수행하기

CREATE TABLE us_counties_pop_est_2010 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name
    county_name text,                        -- County name
    estimates_base_2010 integer,             -- 4/1/2010 resident total population estimates base
    CONSTRAINT counties_2010_key PRIMARY KEY (state_fips, county_fips)
);

COPY us_counties_pop_est_2010
FROM 'C:\YourDirectory\us_counties_pop_est_2010.csv'
WITH (FORMAT CSV, HEADER);

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
       round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_change
FROM us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
ON c2019.state_fips = c2010.state_fips
    AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change DESC;
