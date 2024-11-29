--2024.11.28 EXAM
/*
2.사원번호 입력받아 부서이름, job_id, 급여, 연간 총수입 출력.
급여나 커미션이 NULL일 경우라도 값이 출력되도록
*/
SELECT department_name ,job_id, salary, ((NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12) as year   --salary도 nvl처리해주기~~
FROM employees e join departments d
                on e.department_id = d.department_id
WHERE employee_id = &사원번호;


DECLARE
  v_dname employees.last_name%TYPE;
  v_jid employees.job_id%TYPE;
  v_sal employees.salary%TYPE;
  v_year NUMBER(20,2);
BEGIN
    SELECT department_name ,job_id, salary , ((NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12)   --salary도 nvl처리해주기~~
    INTO v_dname,v_jid, v_sal, v_year
    FROM employees e join departments d
                on e.department_id = d.department_id
    WHERE e.employee_id = &사원번호;
  
  DBMS_OUTPUT.PUT_LINE('부서이름 : '|| v_dname);
  DBMS_OUTPUT.PUT_LINE('job_id : '|| v_jid);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
  DBMS_OUTPUT.PUT_LINE('연간 총수입 : ' || v_year);

END;
/


/*
3. 사원번호를 입력받아 Employees 테이블을 참조해서 사원의 입사년도가 2015년 이후(2015년 제외)에 입사면
'New employee', 아니면 'Career employee'라고 출력
*/
SELECT employee_id, hire_date
    FROM employees
    WHERE employee_id = &사원번호;

DECLARE
    v_hdate employees.hire_date%type;
    v_msg VARCHAR2(100);

BEGIN

    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF TO_CHAR(v_hdate, 'yyyy') > '2015' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);

END;
/



/*
4. 구구단 1단 ~ 9단을 출력하는 PL/SQL 블록 작성 ( 홀수단 출력 )
*/
BEGIN
    FOR dan IN 1..9 LOOP 
       -- dan이 결정된 후 첫 실행
      
        CONTINUE WHEN MOD(dan,2) = 0;  
       
        FOR num IN 1..9 LOOP -- 곱하는 수: 정수, 1~9
            DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num) || ' ');
        END LOOP;
    END LOOP;
END;
/

/*
5. 부서번호 입력하면 해당 부서에 근무하는 모든 사원의 사번, 이름, 급여를 출력하는 PL/SQL블록 작성(CURSOR 사용)
*/
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id=&부서번호;

DECLARE
    -- 1. 커서 정의
     CURSOR emp_cursor IS
         SELECT employee_id, last_name, salary
         FROM employees
         WHERE department_id=&부서번호;
         
    -- INTO절에 사용할 변수
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
BEGIN
    -- 2. 커서 실행
    OPEN emp_cursor;
    LOOP
        -- 3. 커서에서 데이터 인출
        FETCH emp_cursor INTO v_eid, v_ename, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;  --새로운 데이터의 존재유무 확인(새로운 데이터 없으면 TRUE 반환)
        
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : '); 
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_sal);
    END LOOP;
    
    -- 4. 커서 종료
    CLOSE emp_cursor;
END;
/


/*
6. 직원들의 사번, 급여 증가치(비율)만 입력하면 Employees 테이블에
쉽게 사원급여 갱신할 수 있도록 procedure 작성. 없는 사원 'No search employee!!' 라는 메시지 출력
단, exception 절 사용
*/

-- 실행) 없는 사원 :EXECUTE y_update(0, 10);
-- 실행) 있는 사원 :EXECUTE y_update(100, 10);

select employee_id, salary
from employees
where employee_id = 100;


DROP PROCEDURE y_update;
CREATE PROCEDURE y_update
(p_eid IN employees.employee_id%TYPE,
 p_raise IN NUMBER)

IS
    e_no_emp EXCEPTION;
BEGIN
    UPDATE employees 
    SET salary = salary + (salary * (p_raise/100))
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
       RAISE e_no_emp;
    END IF;
EXCEPTION
    WHEN e_no_emp THEN
         DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

rollback;



/*
7. 주민등록번호(0211023234597)를 입력받으면 만 나이와 성별을 모두 출력하는 프로그램을 하나만 작성하세요.
*/
CREATE OR REPLACE FUNCTION get_age
(p_jumin IN VARCHAR2)
RETURN NUMBER
IS
    v_age NUMBER;
BEGIN
    IF SUBSTR(v_jumin, 7,1) IN(1,2)  
      THEN v_age := EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(p_jumin,1,2)+1900);
    ELSE v_age := EXTRACT(YEAR FROM SYSDATE) - (SUBSTR(p_jumin,1,2)+2000);
    END IF;
    --v_age := v_age +1;
    RETURN v_age;
END;


SELECT get_age('0211023234597')
FROM dual;












/*
8. 사원번호 입력받으면 해당 사원 근무한 기간의 근무년수만 출력하는 function 작성.
단, 근무기간이 근무년수, 근무개월수로 구성되면 근무개월 제외
ex) 5년 10개월일 경우 5년만 표기함.
*/
SELECT employee_id
       , hire_date
       , MONTHS_BETWEEN(sysdate, hire_date) as 총개월수
       -- 일한 년도로써의 연차 : 1년차부터 시작
       , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) as 연차1
FROM employees
WHERE employee_id = &사원번호;

DROP FUNCTION get_emp_year;
CREATE FUNCTION get_emp_year
(p_deptno departments.department_id%TYPE)
RETURN NUMBER
IS
    CURSOR emp_of_dept_cursor IS 
        SELECT employee_id
           , last_name
           , hire_date
        FROM employees
        WHERE employee_id = p_deptno;
    v_emp_info emp_of_dept_cursor%ROWTYPE;
    v_years NUMBER(2,0);
    
BEGIN
    -- 2. 커서 실행
    OPEN emp_of_dept_cursor;
        LOOP
            -- 3. 커서에서 데이터 인출
            FETCH emp_of_dept_cursor INTO v_emp_info; --계속 데이터 가져옴
            EXIT WHEN emp_of_dept_cursor%NOTFOUND;  --새로운 데이터의 존재유무 확인(새로운 데이터 없으면 TRUE 반환)
            -- 부서에 속한 사원이 있는 경우
            
            v_years := CEIL(MONTHS_BETWEEN(sysdate, v_emp_info.hire_date)/12);
            --출력
        END LOOP;
        -- LOOP문 밖에서 ROWCOUNT 속성 : 현재 커서가 가지고 있는 총 데이터 갯수
    -- 4. 커서 종료
    CLOSE emp_of_dept_cursor;
 RETURN (v_years); 
END;
/

SELECT get_emp_year(100)
FROM dual;

ROLLBACK;


/*
9. 부서이름을 입력하면 부서의 책임자(Manager)이름을 출력하는 Function을 작성 (서브쿼리 이용)
*/
SELECT e.last_name as mgr_name
FROM employees e
WHERE employee_id = (SELECT d.manager_id
                     FROM departments d
                     WHERE LOWER(d.department_name) = LOWER('&부서이름'));
      
DROP FUNCTION get_mgr;    
CREATE FUNCTION get_mgr
(p_dname departments.department_name%TYPE)
RETURN VARCHAR2
IS
    v_mname VARCHAR2(100);
BEGIN
    SELECT e.last_name as mgr_name
    INTO v_mname
    FROM employees e
    WHERE employee_id = (SELECT d.manager_id
                         FROM departments d
                         WHERE LOWER(d.department_name) = LOWER(p_dname));
    
    RETURN (v_mname);
END;
/

SELECT get_mgr('IT')
FROM dual;


/*
10. HR사용자에게 존재하는 PROCEDURE, FUNCTION, PACKAGE, PACKAGE BODY의 이름과 소스코드를 한꺼번에 확인하는 SQL구문을 작성하세요
*/
SELECT  name, type, line, text
FROM user_source;

/*
11. 
*/
DECLARE
    v_cnt   NUMBER := 1;
    v_str   VARCHAR2(10) := NULL;
BEGIN
    WHILE v_cnt < 10 LOOP
        v_str := v_str || '*';
        dbms_output.put_line(v_str);
        v_cnt := v_cnt + 1;
    END LOOP;
END;
/
