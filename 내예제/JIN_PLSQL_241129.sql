--2024.11.29
--Ʈ����(������ ����)
-- 1) ���̺� �غ�
DROP TABLE employee;
CREATE TABLE employee
AS
    SELECT *
    FROM employees;
    
CREATE TABLE job_history
AS
    SELECT *
    FROM job_history;

-- 2) ����� ������ �μ��� ����� ��� job_history ���̺� �������� �Է�
CREATE PROCEDURE add_job_history 
(p_eid IN employees.employee_id%TYPE,
 p_pre_hdate IN employees.hire_date%TYPE,
 p_new_hdate IN employees.hire_date%TYPE,
 p_job_id IN jobs.job_id%TYPE,
 p_dept_id IN departments.department_id%TYPE)
IS

BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_eid, p_pre_hdate, p_new_hdate, p_job_id, p_dept_id);
END;
/

-- 3) employee ���̺��� ����� ��� �ڵ����� ����� �۾��� Ʈ���ŷ� ����  --UPDATE OF: ������� 
CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


--����
SELECT *
FROM job_history
ORDER BY end_date;

--����
SELECT *
FROM employees e
    JOIN departments d
    ON (e.department_id = d.department_id);


UPDATE employees
SET job_id = 'IT_PROG'
WHERE employee_id = 100;

rollback;

---------------------------------------------------------------------------------------------
--sql Ʃ��(������ ����)

-- 1) �����غ�
-- 1-1) �����͸� ������ ���̺� ����
DROP TABLE t_emps;
CREATE TABLE t_emps
AS 
    SELECT *
    FROM employees;

ALTER TABLE t_emps
ADD CONSTRAINT t_emps_pk PRIMARY KEY (employee_id);

ALTER TABLE t_emps
MODIFY employee_id NUMBER(38,0);

ALTER TABLE t_emps
MODIFY last_name VARCHAR2(1000);

-- 1-2) PRIMARY KEY�� ����� ������ �÷��� �� ������ ��ü ����
DROP SEQUENCE t_emps_empid_seq;
CREATE SEQUENCE t_emps_empid_seq
    START WITH 1000;
 
-- 1-3) ���� ������ ����  -- �ι��� ������ �����ϱ�. UNDO SPACE OVER��(�ӽ��������)
BEGIN
    FOR count IN 1 .. 10 LOOP
        INSERT INTO t_emps(employee_id, last_name, email, hire_date, job_id)
        SELECT t_emps_empid_seq.NEXTVAL, last_name || count, email, hire_date, job_id
        FROM t_emps;
    END LOOP;
END;
/


SELECT COUNT(*)
FROM t_emps;

-- 1) �ε����� Ȱ���� �˻� ����

-- ���� 1 : �ε����� ������� ���� �÷�
SELECT *
FROM t_emps
WHERE last_name = 'King15';


-- ���� 2 : �ε����� ����� �÷�
SELECT *
FROM t_emps
WHERE employee_id = 100000;



-- 2) ORDER BY vs INDEX
-- ���� 1 : �ε����� ���� �÷��� �������� ������ ���
SELECT *
FROM t_emps
ORDER BY last_name;

-- ���� 2 :  �ε����� �ִ� �÷��� �������� ������ ���
SELECT *
FROM t_emps
ORDER BY employee_id;

-- 3) HINT ���
-- 3-1) FULL
SELECT /*+ FULL (t_emps) */ *
FROM t_emps;

-- 3-2) INDEX_ASC
SELECT /*+ INDEX_ASC(t_emps t_emps_pk) */ *
FROM t_emps;

-- 3-3) INDEX_DESC
SELECT /*+ INDEX_DESC(t_emps t_emps_pk) */ *
FROM t_emps;


DROP TRIGGER update_job_history;

rollback;
