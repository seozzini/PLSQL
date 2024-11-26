-- PAGING
SELECT d.*
FROM (SELECT ROWNUM rn, e.*
      FROM( SELECT *
            FROM employees 
            ORDER BY first_name
            ) e
     )d
WHERE rn BETWEEN 1 AND 10;

SET SERVEROUTPUT ON    

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!!');
END;
/

DECLARE
-- 선언부 : 변수 등 선언
BEGIN
-- 실행부 : 실제 프로세스 수행
EXCEPTION
-- 예외처리 : 예외 발생시 처리하는 작업
END;
/

DECLARE
    v_str VARCHAR2(100); -- 기본
    v_num CONSTANT NUMBER(2,0) := 10; -- 상수
    v_count NUMBER(2,0) NOT NULL DEFAULT 5; -- NOT NULL 조건의 변수
    v_sum NUMBER(3,0) := v_num + v_count; -- 표현식(계산식)을 기반으로 초기화
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_str : ' || v_str);
    DBMS_OUTPUT.PUT_LINE('v_num : ' || v_num);
    -- v_num := 100;
    DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
END;
/

-- %TYPE 속성
DECLARE
    v_eid employees.employee_id%TYPE; -- NUMBER(6,0)
    v_ename employees.last_name%TYPE; -- VARCHAR2(25 BYTE) <=> VARCHAR2(25 char)
    v_new v_ename%TYPE;        -- VARCHAR2(25 BYTE)
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    FROM employees
    WHERE employee_id = 100;
    -- v_eid := 'eid : 100';
    v_new := v_eid || ' ' || v_ename;
    DBMS_OUTPUT.PUT_LINE(v_new);
END;
/
-- PL/SQL에서 단독 사용가능한 SQL함수 => 단일행 함수들 (DECODE, 그룹함수 제외)
DECLARE
    v_date DATE;
BEGIN
    v_date := sysdate + 7;
    DBMS_OUTPUT.PUT_LINE(v_date);
END;
/

-- PL/SQL의 SELECT문
-- 1) INTO절 : 조회한 컬럼의 값을 담는 변수 선언 => 반드시 데이터는 하나의 행만 반환
DECLARE
    v_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 2) 결과 값은 무조건 하나의 행
DECLARE
    v_name employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE department_id = &부서번호;
    -- 부서번호 0 : "no data found"
    -- 부서번호 50 : "exact fetch returns more than requested number of rows"
    -- 부서번호 10 : 정상실행
    DBMS_OUTPUT.PUT_LINE(v_name);
END;
/
-- 3) SELECT절의 컬럼 갯수 = INTO절의 변수 갯수
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    -- SELECT > INTO : not enough values
    -- SELECT < INTO : too many values
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/

/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.

=> SELECT문
-- 입력 : 사원번호                    / employees 테이블
-- 출력 : 사원번호, 사원이름, 부서이름  / employees 테이블(사원번호, 사원이름) + departments 테이블(부서이름)
                                        => JOIN | 서브쿼리

*/
-- 1) 필요한 SQL문 확인
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e 
     JOIN departments d
     ON (e.department_id = d.department_id)
WHERE e.employee_id = &사원번호;

-- 2) PL/SQL 블록 작성
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;.
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_eid, v_ename, v_deptname
    FROM employees e 
        JOIN departments d
        ON (e.department_id = d.department_id)
    WHERE e.employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/

-- 서브쿼리 사용
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, 
           e.last_name, 
           (SELECT department_name FROM departments WHERE department_id = e.department_id)
    INTO v_eid, 
         v_ename, 
         v_deptname
    FROM employees e       
    WHERE e.employee_id = &사원번호;

    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/
-- SELECT 문
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dept_id departments.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, e.department_id
    INTO v_eid, v_ename, v_dept_id
    FROM employees e         
    WHERE e.employee_id = &사원번호;
    
    SELECT department_name
    INTO v_deptname
    FROM departments d
    WHERE  department_id = v_dept_id;

    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/







/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 
급여, 
연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.

=> SELECT문
-- 입력 : 사원번호      => employees 테이블
-- 출력 : 사원이름, 급여, 연봉 / 연봉 = (급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12)) => employees 테이블

*/

-- 1) 필요한 SQL문 확인
SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
FROM employees
WHERE employee_id = &사원번호;

-- 2) PL/SQL 블록 작성
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_year NUMBER(20);
BEGIN
    SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
    INTO v_ename, v_sal, v_year
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_year);
END;
/

-- 추가문제 : SELECT절에서 연봉 계산 분리
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_year NUMBER(20);
BEGIN
    SELECT last_name, salary, commission_pct 
    INTO v_ename, v_sal, v_comm
    FROM employees
    WHERE employee_id = &사원번호;
    
    v_year := (v_sal*12+(nvl(v_sal,0)*nvl(v_comm,0)*12));
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_year);
END;
/

-- PL/SQL 안에서 DML
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees
                (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno); 
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    COMMIT; -- 블록 =/= 트랜잭션, 반드시 필요하다면 명시적으로 COMMIT/ROLLBACK 작성
END;
/

SELECT *
FROM employees
WHERE employee_id IN (200,1000);

ROLLBACK;

BEGIN
    DELETE FROM employees
    WHERE employee_id = 1000;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다.');
    END IF;
END;
/




