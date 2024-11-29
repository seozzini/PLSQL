--2024.11.29
--트리거(배포한 파일)
-- 1) 테이블 준비
DROP TABLE employee;
CREATE TABLE employee
AS
    SELECT *
    FROM employees;
    
CREATE TABLE job_history
AS
    SELECT *
    FROM job_history;

-- 2) 사원의 업무나 부서가 변경될 경우 job_history 테이블에 이전내역 입력
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

-- 3) employee 테이블이 변경될 경우 자동으로 진행될 작업을 트리거로 생성  --UPDATE OF: 행단위라서 
CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


--기존
SELECT *
FROM job_history
ORDER BY end_date;

--복잡
SELECT *
FROM employees e
    JOIN departments d
    ON (e.department_id = d.department_id);


UPDATE employees
SET job_id = 'IT_PROG'
WHERE employee_id = 100;

rollback;

---------------------------------------------------------------------------------------------
--sql 튜닝(배포한 파일)

-- 1) 사전준비
-- 1-1) 데이터를 저장할 테이블 생성
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

-- 1-2) PRIMARY KEY로 사용할 예정인 컬럼에 들어갈 시퀀스 객체 생성
DROP SEQUENCE t_emps_empid_seq;
CREATE SEQUENCE t_emps_empid_seq
    START WITH 1000;
 
-- 1-3) 임의 데이터 생성  -- 두번에 나눠서 실행하기. UNDO SPACE OVER됨(임시저장공간)
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

-- 1) 인덱스를 활용한 검색 유무

-- 예시 1 : 인덱스가 적용되지 않은 컬럼
SELECT *
FROM t_emps
WHERE last_name = 'King15';


-- 예시 2 : 인덱스가 적용된 컬럼
SELECT *
FROM t_emps
WHERE employee_id = 100000;



-- 2) ORDER BY vs INDEX
-- 예시 1 : 인덱스가 없는 컬럼을 기준으로 정렬한 경우
SELECT *
FROM t_emps
ORDER BY last_name;

-- 예시 2 :  인덱스가 있는 컬럼을 기준으로 정렬한 경우
SELECT *
FROM t_emps
ORDER BY employee_id;

-- 3) HINT 사용
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
