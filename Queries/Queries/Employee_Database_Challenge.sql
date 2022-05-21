

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
	ORDER by emp.emp_no;
	
SELECT * FROM retiring_employees_titles;
	
	-- Use Dictinct with Orderby to remove duplicate rows


SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
	ret.first_name,
	ret.last_name,
	ret.title
	--ret.to_date
INTO unique_titles
FROM retiring_employees_titles as ret
WHERE ret.to_date = ('9999-01-01')
ORDER by ret.emp_no, ret.to_date DESC;

SELECT * FROM unique_titles;

--SELECT (ut.title),ut.title
SELECT count(ut.title),ut.title
	--INTO retiring_titles
    FROM unique_titles  as ut
    GROUP by  ut.title
    --ORDER by (ut.title) DESC;
    ORDER by COUNT(ut.title) DESC;

SELECT * FROM retiring_titles


SELECT DISTINCT ON (emp.emp_no) emp.emp_no, 
	emp.first_name, 
	emp.last_name, 
	emp.birth_date, 
	dep.from_date, 
	dep.to_date, 
	ti.title
INTO mentorship_eligibilty 
FROM employees AS emp
LEFT JOIN dept_emp AS dep
ON emp.emp_no = dep.emp_no
LEFT JOIN titles AS ti
ON emp.emp_no = ti.emp_no
WHERE (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (dep.to_date = '9999-01-01')
ORDER by emp.emp_no ASC;
