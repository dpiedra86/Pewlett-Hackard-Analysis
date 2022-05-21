-- Create table departments
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT null,
	dept_name VARCHAR(40) NOT null,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
	
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);


CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(6) NOT NULL,
	from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

DROP TABLE titles CASCADE;

--an asterisk to indicate that we want all of the records 
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM titles;
SELECT * FROM dept_emp;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

--SELECT first_name, last_name, title
--FROM employees as e
--LEFT JOIN titles as t ON e.emp_no = t.emp_no

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_managerON retirement_info.emp_no = dept_emp.emp_no;
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
	FROM retirement_info LEFT JOIN dept_emp
	ON retirement_info.emp_no = dept_emp.emp_no;
	
	-- Joining retirement_info and dept_emp tables
	SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
	FROM retirement_info as ri LEFT JOIN dept_emp as de
	ON ri.emp_no = de.emp_no;
	
	-- Joining departments and dept_manager tables
SELECT dep.dept_name,
     dem.emp_no,
     dem.from_date,
     dem.to_date
FROM departments as dep
INNER JOIN dept_manager as dem
ON dep.dept_no = dem.dept_no;
	
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');


SELECT * FROM current_emp

SELECT COUNT(ce.emp_no), de.dept_no
INTO department_count
From current_emp as ce LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM department_count

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name, last_name 
INTO retirement_info 
FROM employees as em
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT emp_no, first_name, last_name, gender
INTO emp_info 
FROM employees as em
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * from retirement_info;

--DROP TABLE retirement_info CASCADE;

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT * from manager_info;
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name		
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);



SELECT emp.emp_no, 
        emp.first_name, 
        emp.last_name,
	    ti.title, 
        ti.from_date, 
        ti.to_date
	INTO retiring_employees_titles
	FROM employees AS emp
	LEFT JOIN titles as ti
	ON (emp.emp_no = ti.emp_no)
	WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY emp.emp_no;
	
	-- Use Dictinct with Orderby to remove duplicate rows
	
	
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
		ret.first_name, 
        ret.last_name,
	    ret.title,
		
	INTO my_new_table
	FROM retiring_employees_titles as ret
	WHERE tet.to_date = ('9999-01-01')
	ORDER BY ret.emp_no,  ret.to_date DESC;
	
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
	ret.first_name,
	ret.last_name,
	ret.title,
	ret.from_date
--INTO my_new_table
FROM retiring_employees_titles as ret
WHERE ret.to_date = ('9999-01-01')
ORDER BY ret.emp_no ASC, ret.from_date DESC;

select * FROM my_new_table;