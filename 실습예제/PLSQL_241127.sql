SET SERVEROUTPUT ON

-- 커서 FOR LOOP : 명시적 커서를 사용하는 단축방법
-- 1) 문법
DECLARE
    CURSOR 커서명 IS
        SELECT문;
BEGIN
    FOR 임시변수(레코드타입) IN 커서명 LOOP -- 암시적으로 OPEN과 FETCH
        -- 커서에 데이터가 존재하는 경우 수행하는 코드
    END LOOP; -- 암시적으로 CLOSE
END;
/

-- 2) 적용
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, salary
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ');
        DBMS_OUTPUT.PUT(emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.salary);
    END LOOP;
END;
/

-- 부서번호를 입력받아 해당 부서에 소속된 사원정보(사원번호, 이름, 급여)를 출력하세요.
-- 부서번호 0  : 커서의 데이터가 없음
-- 부서번호 50 : 커서의 데이터가 존재함
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ');
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP; -- 암시적으로 CLOSE
    DBMS_OUTPUT.PUT_LINE('총 데이터 갯수 : ' || emp_dept_cursor%ROWCOUNT);
END;
/

--  커서 FOR LOOP 문의 경우 명시적 커서의 데이터를 보장할 수 있을때만 사용

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
*/

DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
        
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        -- 조건문
        IF emp_rec.hire_date <= '20251231' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date);
        ELSE
            INSERT INTO test02
            VALUES emp_rec;
        END IF;
    END LOOP;
END;
/
SELECT * 
FROM test01;

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, hire_date, department_name
        FROM employees e JOIN departments d
                         ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
BEGIN
    FOR info IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(info.last_name || ', ' || info.hire_date || ', ' || info.department_name);
    END LOOP;
END;
/
-- 커서 FOR LOOP문은 서브쿼리를 이용해서 동작 가능 (단, 속성은 사용불가)
BEGIN
    FOR emp_rec IN (SELECT last_name, hire_date, department_name
                    FROM employees e JOIN departments d
                                    ON (e.department_id = d.department_id)
                    WHERE e.department_id = &부서번호) LOOP
            
        DBMS_OUTPUT.PUT_LINE(emp_rec.last_name || ', ' || emp_rec.hire_date || ', ' || emp_rec.department_name);
    END LOOP;
END;
/
/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
-- 3-1 : 연봉을 따로 계산
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &부서번호;
 
    v_year NUMBER(10,2); -- 연봉
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        v_year := (emp_rec.salary*12+(emp_rec.salary*NVL(emp_rec.commission_pct,0)*12));
        
        DBMS_OUTPUT.PUT(emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || emp_rec.salary);
        DBMS_OUTPUT.PUT_LINE(', ' || v_year);
    END LOOP;
END;
/

-- 3-2
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal, (salary*12+(salary*nvl(commission_pct,0)*12)) as year
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_rec.ename);
        DBMS_OUTPUT.PUT(', ' || emp_rec.sal);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.year);
    END LOOP;
END;
/

-- 예외처리 : 예외가 발생했을 때 정상적으로 작업이 종료될 수 있도록 처리
-- 1) 문법
DECLARE

BEGIN


EXCEPTION
    WHEN 예외이름 THEN -- 필요한 만큼 추가 가능
        -- 예외발생시 처리하는 코드
    WHEN OTHERS THEN --  위에 정의된 예외말고 발생하는 경우 일괄처리
        -- 예외발생시 처리하는 코드
END;
/
-- 2) 적용
-- 2-1) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름도 존재하는 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    -- 부서번호 0 : ORA-01403, NO_DATA_FOUND
    -- 부서번호 10 : 정상실행
    -- 부서번호 50 : ORA-01422, TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생했습니다.');
        
        DBMS_OUTPUT.PUT_LINE('ORA' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 12));
        
        DBMS_OUTPUT.PUT_LINE('블록이 종료되었습니다.');      
END;
/
-- 2-2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름은 존재하지 않는 예외사항
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 부서번호 10 : ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 다른 테이블에서 사용 중입니다.');
END;
/
-- 2-3) 사용자 정의 예외 => 오라클 입장에선 정상코드로 인지
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = 0;
    -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;
    END IF;
EXCEPTION 
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
END;
/

BEGIN
    DELETE FROM departments
    WHERE department_id = 0;
    -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
        DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
    END IF;
END;
/

/*
1.
drop table emp_test;

create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;

emp_test 테이블에서 사원번호를 사용(&치환변수 사용)하여 사원을 삭제하는 PL/SQL을 작성하시오.
(단, 사용자 정의 예외사항 사용)
(단, 사원이 없으면 "해당사원이 없습니다.'라는 오류메시지 발생)
*/
DECLARE
    e_emp_not_found EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_not_found;
    END IF;
EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/

-- PROCEDURE
-- 1) 문법
CREATE PROCEDURE 프로시저명
 ( 매개변수명 [모드] 데이터타입 , ... )
IS
    -- 선언부 : 로컬변수, 커서, 예외사항 등을 선언
BEGIN
    -- PROCEDURE가 수행할 코드
EXCEPTION
    -- 에러처리
END;
/
-- 2) 적용
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_msg VARCHAR2) -- 암시적으로 IN으로 선언
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다.');
END;
/

-- 3) 실행
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- 오라클이 현재 실행하는 객체가 PROCEDURE인지 FUNCTION인지를 구분하는 방법
    -- => 호출형태 ( 왼쪽에 변수가 존재하는 가 )
    -- v_result := test_pro('PL/SQL');
    test_pro('PL/SQL');
END;
/

EXECUTE test_pro('WORLD');

-- IN 모드 : 호출환경 -> 프로시저로 값을 전달, 프로시저 내부에서 상수 취급
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    -- ERROR : 프로시저 내부에서 상수 취급되므로 값을 변경할 수 없음
    -- p_eid := 100; 
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;    
END;
/

SELECT employee_id, salary
FROM employees
WHERE employee_id IN (100, 130, 149);

DECLARE
    v_first NUMBER(3,0) := 100; -- 초기화된 변수
    v_second CONSTANT NUMBER(3,0) := 149; -- 상수
BEGIN
    raise_salary(100);          -- 리터럴
    raise_salary(v_first+30);   -- 표현식
    raise_salary(v_first);      -- 초기화변 변수
    raise_salary(v_second);     -- 상수
END;
/

-- OUT 모드 : 프로시저 -> 호출환경으로 값을 반환, 프로시저 내부에서 초기화되지 않은 변수로 인지
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,
 p_out OUT NUMBER)
IS
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END; -- 블록이 종료되는 순간 OUT 모드의 매개변수가 가지고 있는 값이 그대로 반환
/
-- 실행코드
DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result : ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result : ' || v_result);
END;
/

-- 더하기
CREATE PROCEDURE pro_plus
(p_x IN NUMBER,
 p_y IN NUMBER,
 p_sum OUT NUMBER)
IS

BEGIN
    p_sum := p_x + p_y;
END;
/

DECLARE
    v_total NUMBER(10,0);
BEGIN
    pro_plus(10, 25, v_total);
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

-- IN OUT 모드 : IN 모드와 OUT 모드 두가지를 하나의 변수로 처리
-- '01012341234' => '010-1234-1234'
-- 날짜를 지정한 포맷으로 변경 : '24/11/27' => '24년11월'
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('before : ' || p_phone_no);
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                 || '-' || SUBSTR(p_phone_no, 4, 4)
                 || '-' || SUBSTR(p_phone_no, 8);
    DBMS_OUTPUT.PUT_LINE('after : ' || p_phone_no);
END;
/   

DECLARE
    v_no VARCHAR2(100) := '01012341234';
BEGIN
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no);-- '01012341234' => '010-1234-1234'
END;
/

CREATE FUNCTION hello
RETURN VARCHAR2
IS
BEGIN
    RETURN 'Hello !!!';
END;
/
SELECT hello
FROM dual;

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
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
    v_result VARCHAR2(30); -- 로컬 변수
BEGIN    
    v_result := SUBSTR(p_ssn, 1, 6) -- 앞 6자리    
                -- || '-' || SUBSTR(p_ssn, 7, 1) || '******'; -- 뒷 7자리
                || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

SELECT LPAD(salary, 10, '-'), RPAD(salary, 10, '-')
FROM employees;






























