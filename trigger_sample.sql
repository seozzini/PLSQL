-- 1) 테이블 준비
DROP TABLE employee;
CREATE TABLE employee
AS
    SELECT *
    FROM employees;
    
CREATE TABLE t_job_history
AS
    SELECT *
    FROM job_history;

-- 2) 사원의 업무나 부서가 변경될 경우 t_job_history 테이블에 이전내역 입력
CREATE PROCEDURE add_job_history 
(p_eid IN employees.employee_id%TYPE,
 p_pre_hdate IN employees.hire_date%TYPE,
 p_new_hdate IN employees.hire_date%TYPE,
 p_job_id IN jobs.job_id%TYPE,
 p_dept_id IN departments.department_id%TYPE)
IS

BEGIN
    INSERT INTO t_job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_eid, p_pre_hdate, p_new_hdate, p_job_id, p_dept_id);
END;
/

-- 3) employee 테이블이 변경될 경우 자동으로 진행될 작업을 트리거로 생성
CREATE OR REPLACE TRIGGER update_t_job_history
  AFTER UPDATE OF job_id, department_id ON employee
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


SELECT *
FROM t_job_history
ORDER BY end_date;


UPDATE employee
SET job_id = 'IT_PROG'
WHERE employee_id = 100;