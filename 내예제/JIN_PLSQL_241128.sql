--2024.11.28

-- 예외처리
-- 예외는 반복적으로 발생하는 경우 반드시 해결해야함
-- 종료를 막은 것 뿐 정상적으로 실행된 것은 아님.

-- 문제 풀어보기 (매개변수 IN MODE만으로)
/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777');
950101-1******
EXECUTE yedam_ju('1511013689977');
151101-3******

매개변수가 리터럴 => IN 매개변수 하나뿐 + 정해진 출력구문 => DBMS_OUTPUT.PUT_LINE을 내부에서 실행
*/
--교수님 풀이
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)  --왜 VARCHAR2로 지정? 2000년생의 경우 00으로 시작해야 하기때문 (보이는게 아니라 의미를 봐야함.)
IS
    v_result VARCHAR2(30); -- 로컬 변수 (결과를 담는, IN MODE는 P가 상수)
BEGIN
    
    v_result := SUBSTR(p_ssn, 1, 6)  -- 앞 6자리
                -- || '-' ||SUBSTR(p_ssn, 7,1)||'******'; -- 뒷 7자리-1: 정해진 길이만큼 채울때
                 || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*'); -- 뒷 7자리-2: 항상 같은 글자수 출력
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

SELECT salary, LPAD(salary, 10, '-'), RPAD(salary, 10, '-')
FROM employees;

--내코드
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
(p_jumin IN VARCHAR2)
IS
  v_jumin VARCHAR2(14);
BEGIN
    v_jumin := SUBSTR(p_jumin, 1, 6)
                 || '-' ||RPAD((SUBSTR(p_jumin,7,1)),7,'*');
    DBMS_OUTPUT.PUT_LINE('p_jumin :' || v_jumin);
    
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

SET SERVEROUTPUT ON;

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
--교수님
--SQL문
DELETE FROM employees
WHERE employee_id = &사원번호;
--PROCEDURE (프로시저, 함수는 치환변수 안쓴다.매개변수로 넘겨받아야함)
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid IN employees.employee_id%TYPE)

IS

BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid;
    
    --DML의 경우 SQL%ROWCOUNT
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF;
END;
/
EXECUTE TEST_PRO(176);
ROLLBACK;

--내풀이
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid IN employees.employee_id%TYPE)
IS
BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid;
    DBMS_OUTPUT.PUT_LINE(p_eid || '번 사원이 삭제되었습니다.');
    
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF;
    ROLLBACK;
END;
/

--실행코드
EXECUTE TEST_PRO(176);
EXECUTE TEST_PRO(300);

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/
--교수님풀이
-- 입력 : 사원번호 -> 출력 : 사원이름 / SELECT문
SELECT last_name, SUBSTR(last_name,1,1), RPAD(SUBSTR(last_name,1,1),LENGTH(last_name),'*')
FROM employees
WHERE employee_id = &사원번호;

--PROCEDURE
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE)

IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
    v_result := RPAD(SUBSTR(v_ename,1,1),LENGTH(v_ename),'*');
    
    DBMS_OUTPUT.PUT_LINE( v_ename || ' -> ' || v_result );
END;
/

EXECUTE yedam_emp(176);

--내풀이
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
    (p_eid IN employees.employee_id%TYPE)
IS
    v_ename VARCHAR2(20);
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
     v_ename := RPAD((SUBSTR(v_ename,1,1)),LENGTH(v_ename),'*');
    DBMS_OUTPUT.PUT_LINE('p_ename :' || v_ename);
END;
/

EXECUTE yedam_emp(176);



/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차(경력)를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
/* MONTHS_BETWEEN([날짜 데이터1(필수)], [날짜 데이터2(필수)]) */

-- 교수님 풀이
-- 일한 년도로써의 연차 : 1년차부터 시작
-- 경력으로써의 연차   : 개월수부터 시작

SELECT employee_id
       , hire_date
       , MONTHS_BETWEEN(sysdate, hire_date) as 총개월수
       -- 일한 년도로써의 연차 : 1년차부터 시작
       , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) as 연차1
       , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0) + 1 as 연차2
       -- 경력으로써의 연차 : 개월수부터 시작
       , MONTHS_BETWEEN(sysdate, hire_date)/12 년1
       , MOD(MONTHS_BETWEEN(sysdate, hire_date),12) as 개월1
       , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0) as 년2
       , ROUND (MOD(MONTHS_BETWEEN(sysdate, hire_date),12),0) as 개월2
FROM employees;

-- 사원번호, 사원이름, 입사일자 조회, 조건 부서번호
SELECT employee_id
       , last_name
       , hire_date
FROM employees
WHERE department_id = &부서번호;
-- 다중행 => 명시적 커서 적용
DROP PROCEDURE get_emp;
CREATE PROCEDURE get_emp
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR emp_of_dept_cursor IS 
        SELECT employee_id
           , last_name
           , hire_date
        FROM employees
        WHERE department_id = p_deptno;
    v_emp_info emp_of_dept_cursor%ROWTYPE;
    v_years NUMBER(2,0);
    
    e_no_search_emp EXCEPTION;
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
            DBMS_OUTPUT.PUT(v_emp_info.employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_info.last_name);
            DBMS_OUTPUT.PUT_LINE(', '  || v_years);
        END LOOP;
        -- LOOP문 밖에서 ROWCOUNT 속성 : 현재 커서가 가지고 있는 총 데이터 갯수
        IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
            RAISE e_no_search_emp;
        END IF;
 
    -- 4. 커서 종료
    CLOSE emp_of_dept_cursor;
EXCEPTION
    WHEN e_no_search_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
        CLOSE emp_of_dept_cursor;
END;
/

EXECUTE get_emp(30);
ROLLBACK;

-- 내풀이
SELECT employee_id, last_name, 

SELECT employee_id, last_name,(to_char(sysdate,'yyyy') - to_char(hire_date,'yyyy')) as year
FROM employees
WHERE department_id = &부서번호;

DROP PROCEDURE get_emp;
CREATE PROCEDURE get_emp
(p_did employees.department_id%TYPE)
IS
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, (to_char(sysdate,'yyyy') - to_char(hire_date,'yyyy')) as year
        FROM employees
        WHERE department_id = p_did;

BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ');
        DBMS_OUTPUT.PUT(emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.year || '년차');
    END LOOP;
END;
/

EXECUTE get_emp(50);



/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/

-- 교수님 풀이
-- SQL문
UPDATE employees 
SET salary = salary + (salary*(급여증가치/100))
WHERE employee_id = &사원번호;

-- PROCEDURE
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

SELECT salary
FROM employees
WHERE employee_id = 200;

EXECUTE y_update(200, 10);

rollback;

-----------------------------------------------------------------------------------

--함수 FUNCTION
--11번 PPT

-- FUNCTION : 주로 계산하는 용도로 많이 사용하는 객체
--  => DML 없이 VARCHAR2, NUMBER, DATE 등 SQL에서 사용하는 데이터 타입으로 반환할 경우 SQL문과 함께 사용 가능.

-- 1) 문법
CREATE FUNCTION 함수명
( 매개변수명 데이터 타입, ... ) -- IN 모드로만 사용가능하므로 모드는 생략
RETURN 리턴타입
IS
    -- 선언부 : 변수, 커서, 예외사항 등을 선언
BEGIN
    -- 실행하고자 하는 코드
    RETURN 리턴값;
EXCEPTION
    WHEN 예외이름 THEN
        -- 예외처리 코드
        RETURN 리턴값;

END;

-- 2) 적용
CREATE FUNCTION test_func
(p_msg VARCHAR2)
RETURN VARCHAR2
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    RETURN (v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다.';
END;
/

-- 3) 실행
-- 3-1) PL/SQL블록
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- 함수호출시 반드시 변수가 필요
    v_result := test_func('PL/SQL');
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
-- 3-2) SQL문
SELECT test_func('PL/SQL')
FROM dual;

-- 더하기를 함수로
CREATE FUNCTION y_sum
(p_x NUMBER,
 p_y NUMBER)
RETURN NUMBER
IS 

BEGIN
    RETURN (P_X + P_Y);
END;
/

-- 실행 (PL/SQL)
DECLARE
    v_sum NUMBER(10,0);
BEGIN
    -- 함수호출시 반드시 변수가 필요
    v_sum := y_sum(10,5);
    
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 실행 (SQL)
SELECT y_sum(10,5)
FROM dual;

-- 사원번호를 입력받아 해당 사원의 직속상사 이름을 출력 => 셀프조인
-- 사원 employees e
-- 직속상사 employees m
-- 원래 SELECT문
SELECT e.employee_id
       , m.last_name
FROM employees e -- 사원번호를 입력받아
         join employees m -- 상사정보를 가져옴
         on m.employee_id = e.manager_id
WHERE e.employee_id = &사원번호 ;

--함수 사용
SELECT employee_id, get_mgr(employee_id)
FROM employees;


DROP FUNCTION get_mgr;
CREATE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE) --사원번호
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT m.last_name
    INTO v_mgr_name
    FROM employees e   -- 사원
         join employees m  -- 상사
         on  e.manager_id = m.employee_id
    WHERE e.employee_id = p_eid ;
    
    RETURN (v_mgr_name);
END;
/

SELECT get_mgr(105)
FROM dual;

-- DATA DICTIONARY (데이터 딕셔너리) VIEW
SELECT  name, line, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION');
-->정보를 알 수 있는 테이블, VIEW가 있다는 거 알기


-- 함수 문제풀기

/*
1.
사원번호를 입력하면 
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
--교수님 풀이

SELECT  employee_id, first_name || ' ' || last_name
FROM employees;

DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2 -- 이름이므로 문자열
IS
    v_ename VARCHAR2(100);
BEGIN
    SELECT  first_name || ' ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN (v_ename);
END;
/

--내 풀이
SELECT first_name ||' ' ||last_name as fullname
FROM employees
WHERE employee_id = &사원번호;

DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_fullName VARCHAR2(100);
BEGIN
    SELECT last_name ||' ' ||first_name as fullname
    INTO v_fullName
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN (v_fullName);
END;
/

-- 함수사용
SELECT employee_id, y_yedam(employee_id)
FROM employees;





/*
2.
사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 초과이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees; 
*/

-- 교수님 풀이
DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal employees.salary%TYPE;
    v_raise NUMBER(5,2);
BEGIN

    -- 1) 입력: 사원번호 => 출력 : 급여 /  SELECT문 
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
-- 2) 조건문 : 각 범위마다 정해진 인상율 가져오기
   IF v_sal <= 5000  THEN
        v_raise := 20;
    ELSIF v_sal <= 10000  THEN
        v_raise := 15;
    ELSIF v_sal <= 20000  THEN
        v_raise := 10;
    ELSE 
        v_raise := 0;
    END IF;
-- 3) 출력 : 인상된 급여
    RETURN (v_sal+ (v_sal *(v_raise/100)));
END;
/



-- 내 풀이
select last_name, salary
from employees
where employee_id = &사원번호;

DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
(p_eid employees.employee_id%TYPE) 
RETURN NUMBER
IS
v_ename employees.last_name%TYPE;
v_sal employees.salary%TYPE;
v_new_sal v_sal%TYPE;
v_raise NUMBER(5,2);
BEGIN

    select last_name, salary
    into v_ename, v_sal
    from employees
    where employee_id = p_eid; 
    
    IF v_sal <= 5000 THEN
       v_raise := 0.2;
    ELSIF v_sal <= 10000 THEN
          v_raise := 0.15;
    ELSIF v_sal <= 15000 THEN
          v_raise := 0.1;
    ELSE --급여가 15001 이상  
         v_raise := 0;
    END IF;
    
    v_new_sal := v_sal + v_sal *(v_raise);
    
    RETURN (v_new_sal);
END;
/

-- 실행문
SELECT last_name, salary, YDINC(employee_id)
FROM   employees; 

/*
3.
사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
->연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;  
*/


-- 교수님 풀이
SELECT (NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12   --salary도 nvl처리해주기~~
FROM employees;

DROP FUNCTION yd_func;
CREATE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_year NUMBER(20,2);
BEGIN
    SELECT (NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12
    INTO v_year
    FROM employees
    WHERE employee_id = p_eid ;
    
    RETURN v_year;
END;
/

-- 내 풀이
SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12)) as 연봉
FROM employees
WHERE employee_id = &사원번호;

DROP  FUNCTION yd_func;
CREATE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%type;
    v_year employees.salary%type;
BEGIN
   SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
   INTO v_ename, v_sal, v_year
   FROM employees
   WHERE employee_id = p_eid;
   
   RETURN v_year;

END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;  

