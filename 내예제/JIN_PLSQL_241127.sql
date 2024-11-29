--2024.11.27

-- https://poiemaweb.com/  (PoiemaWeb) 소개
-- 개발시 궁금한거 생기면 구글링도 좋지만
-- 파트별 해당 내용 기반으로 이어가보기.

--책추천: 코어 자바스크립트 정재남 저(중급이상): 기초문법 설명 없음. 동작원리 설명한 책
-- 국채보상공원 쪽 도서관에 IT책 많음. 참고~


-- CURSOR CLOSE하지 않으면?
-- DECLARE에서 선언되어 있어서 BLOCK END시 끝남
-- BUT, 성능부하, 메모리낭비 등의 이유로 명시적 종료 필요

-- FETCH 다음 EXIT WHEN쓰는 이유? 마지막 데이터 중복되지 않도록 보장

-- 어제에 이어 마지막 문제풀이

SET SERVEROUTPUT ON;

/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/


-- 3-1 : 연봉을 따로 계산
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id = &부서번호;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE; --SELECT절에 있는거만 가져와서 타입 적용
    v_year NUMBER(10,2);
BEGIN
    OPEN emp_in_dept_cursor;
    
        LOOP
            FETCH emp_in_dept_cursor INTO v_emp_rec;
            EXIT WHEN emp_in_dept_cursor%NOTFOUND;
            
            v_year := (v_emp_rec.salary*12+(v_emp_rec.salary*nvl(v_emp_rec.commission_pct,0)*12));
            
            DBMS_OUTPUT.PUT(v_emp_rec.last_name);
            DBMS_OUTPUT.PUT(', ' || v_emp_rec.salary);
            DBMS_OUTPUT.PUT_LINE(', '|| v_year);
            
        END LOOP;
        
    CLOSE emp_in_dept_cursor;

END;
/

-- 3-2
SELECT last_name, salary, (salary*12+(salary*nvl(commission_pct,0)*12)) as year
        FROM employees
        WHERE department_id = &부서번호;
        
        
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal, (salary*12+(salary*nvl(commission_pct,0)*12)) as year --pl/sql, mybatis, node와 연결시 ""(X)
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE; --SELECT절에 있는거만 가져와서 타입 적용
BEGIN
    OPEN emp_in_dept_cursor;
    
        LOOP
            FETCH emp_in_dept_cursor INTO v_emp_rec;
            EXIT WHEN emp_in_dept_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT(v_emp_rec.ename);
            DBMS_OUTPUT.PUT(', ' || v_emp_rec.sal);
            DBMS_OUTPUT.PUT_LINE(', '|| v_emp_rec.year);
            
        END LOOP;
        
    CLOSE emp_in_dept_cursor;

END;
/

-- 커서 FOR LOOP : 명시적 커서를 사용하는 단축방법
-- 1) 문법
DECLARE
    CURSOR 커서명 IS
        SELECT문;
BEGIN
    FOR 임시변수(레코드타입) IN 커서명 LOOP --암시적으로 OPEN과 FETCH
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


-- Q. 부서번호를 입력받아 해당 부서에 소속된 사원정보(사원번호, 이름, 급여)를 출력하세요.
-- 부서번호 0 : 커서의 데이터가 없음
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
    -- DBMS_OUTPUT.PUT_LINE('총 데이터 갯수: '|| emp_dept_cursor%ROWCOUNT);
END;
/

-- 커서 FOR LOOP 문의 경우 명시적 커서의 데이터를 보장할 수 없을 때 사용불가
--> 커서 FOR LOOP 문의 경우 명시적 커서의 데이터를 보장할 수 있을 때만 사용

-- 커서 FOR LOOP로 풀기

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
*/
--교수님 풀이
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
BEGIN
     FOR emp_rec IN emp_cursor LOOP
     -- 조건문
        IF emp_rec.hire_date <= '20151231' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date );  --원칙*
        ELSE
            INSERT INTO test02
            VALUES emp_rec;  --record가 가진 field의 구성이 table이 가진 컬럼 구성과 같다면 임시변수 통째로 넣기
        END IF;
     END LOOP;

END;
/

select *
from test02;

delete from test01;
delete from test02;


--내풀이
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, hire_date hdate
        FROM employees;
        
    TYPE emp_record_type IS RECORD
        ( eid employees.employee_id%TYPE,
         ename employees.last_name%TYPE,
         hdate employees.hire_date%TYPE );
    v_emp_info emp_record_type;

BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        
        IF TO_CHAR(emp_rec.hdate, 'yyyy') <= '2015' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (emp_rec.eid, emp_rec.ename, emp_rec.hdate);
        ELSE
            INSERT INTO test02
            VALUES emp_rec;
        END IF;
    END LOOP;
END;
/

select *
from test02;





/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/
-- 교수님풀이 1
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, hire_date, department_name
        FROM EMPLOYEES e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
BEGIN
    FOR info IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(info.last_name || ',' || info.hire_date || ', ' || info.department_name);
    END LOOP;

END;
/

-- 2 서브쿼리

BEGIN
    FOR emp_rec IN (SELECT last_name, hire_date, department_name
                     FROM EMPLOYEES e JOIN departments d
                                   ON (e.department_id = d.department_id)
                  WHERE e.department_id = &부서번호) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_rec.last_name || ',' || emp_rec.hire_date || ', ' || emp_rec.department_name);
    END LOOP;

END;
/

-- 내풀이
 SELECT last_name ename, hire_date hdate, department_name dname
        FROM employees e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, hire_date hdate, department_name dname
        FROM employees e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
        
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE( emp_rec.ename || ', ' || emp_rec.hdate || ', ' || emp_rec.dname );
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
        v_year := (emp_rec.salary*12+(emp_rec.salary*nvl(emp_rec.commission_pct,0)*12));
            
        DBMS_OUTPUT.PUT(emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || emp_rec.salary);
        DBMS_OUTPUT.PUT_LINE(', '|| v_year);
            
    END LOOP;

END;
/

-- 3-2
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal , (salary*12+(salary*nvl(commission_pct,0)*12)) as year
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        
        DBMS_OUTPUT.PUT(emp_rec.ename);
        DBMS_OUTPUT.PUT(', ' || emp_rec.sal);
        DBMS_OUTPUT.PUT_LINE(', '|| emp_rec.year);
    END LOOP;
END;
/

-- 교재 참고: 11장 참고(컬렉션은 PL/SQL에서 지원하는 데이터 타입 중 하나로 우리가 배운 것들,안배운 것들 모두 포함되어있는 부분임)


-- 예외처리 : 예외가 발생했을 때 정상적으로 작업이 종료될 수 있도록 처리
-- 1) 문법
DECLARE

BEGIN

EXCEPTION
    WHEN 예외이름 THEN -- 필요한 만큼 추가 가능
        -- 예외발생시 처리하는 코드
    WHEN OTHERS THEN -- 위에 정의된 예외 말고 발생하는 경우 일괄처리
        -- 예외발생시 처리하는 코드

END;
/

-- 2) 적용
-- 2-1) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름도 존재하는 예외사항
-- 2-2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름은 존재하지 않는 예외사항
-- 2-3) 사용자 정의 예외 => 오라클 입장에서는 정상코드로 인지


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
        DBMS_OUTPUT.PUT_LINE('블록이 종료되었습니다.');
END;
/

-----------------
-- 에러가 도대체 뭔지 모를때 그걸 반환하는 법
DECLARE
    v_ename employees.last_name%type;
BEGIN
    select last_name
    into v_ename
    from employees
    where department_id = &부서번호;
    -- 부서번호 0 : ORA-01403, NO_DATA_FOUND
    -- 부서번호 10 : 정상실행
    -- 부서번호 50 : ORA-01422, TOO_MANY_ROWS
    
    dbms_output.put_line(v_ename);  -- 예외가 발생하면 이게 실행 안됨
    -- 하지만 예외처리를 함으로써 성공적으로 마무리 할 수 있음

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('해당 부서에 속한 사원이 없습니다.');
    WHEN OTHERS THEN
        dbms_output.put_line('기타 예외사항이 발생했습니다.');
        
        dbms_output.put_line('ORA' || SQLCODE); -- 에러코드 표출
        dbms_output.put_line( SUBSTR(SQLERRM,12));  -- 에러메세지 표출(해당메세지에 ORA-1422 : 도 있는데 이부분은 잘라서 표출함)
END;
/

-----------------


-- 2-2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름은 존재하지 않는 예외사항 // DELETE , UPDATE 등의 DML에서 많이 발생
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 부서번호 10 :  ORA-02292 : integrity constraint (HR.EMP_DEPT_FK) violated - child record found
EXCEPTION
    WHEN e_emps_remaining THEN
    DBMS_OUTPUT.PUT_LINE('해당 부서는 다른 테이블에서 사용 중입니다.');
END;
/
rollback;

-- 2-3) 사용자 정의 예외 => 오라클 입장에서는 정상코드로 인지 (흐름을 강하게 끊어내려 할 때)
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
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

--예외처리하지않고 조건문 기반으로 실행
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

-- 예외 트랩 함수
-- 문제풀기
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
(단, 사원이 없으면 "해당사원이 없습니다."라는 오류메시지 발생)
*/
-- 교수님 문제풀이
DECLARE
    e_emp_not_found EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        --DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.'); --> 그냥 처리
        RAISE e_emp_not_found;
    END IF;
EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.'); --> 예외로 처리
END;
/

-- 사원번호에 a01넣으면 오류 --invalid identifier
-- 치환변수에 문자를 넣어주고 싶으면 방법은 두 가지
-- 1. WHERE employee_id = &사원번호; 를 '&사원번호'로 변경 --invalid number
-- 2. 입력 할 때에 'a01' 넣어줄 수 있음


-- 내 문제풀이
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;  -- RAISE 강제에러발생 ==> 낚아채서 예외로 처리함
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
    DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
    DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요.');
END;
/

-- PROCEDURE
-- 1) 문법
CREATE PROCEDURE 프로시저명
 ( 매개변수명 [모드] 데이터타입 , ...)
IS
    -- 선언부 : 로컬변수, 커서, 예외사항 등을 선언 (DECLARE 명시 시 IS와 충돌함. 선언부는 있으나 숨긴 형태로 진행)
BEGIN
    -- PROCEDURE가 수행할 코드 
EXCEPTION
    -- 에러처리
END;
 /

-- 2) 적용
DROP PROCEDURE test_pro; -- 잘못작성 시 drop으로 지워야함

CREATE PROCEDURE test_pro
(p_msg VARCHAR2) -- 암시적으로 IN 선언 /매개변수의 접두어는 p (parameter) / 매개변수는 크기 지정 안됨(넘어오는 값 크기 지정 불가)
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다.');
END;
/

--> 스크립트: Procedure TEST_PRO이(가) 컴파일되었습니다.
--> 해당 PROCEDURE 재실행 시, ERROR) ORA-00955: name is already used by an existing object
--> PROCEDURE 잘못 작성 시 DROP 으로 지워야함

-- 3) 실행
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- 오라클이 현재 실행하는 객체가 PROCEDURE인지 FUNCTION인지를 구분하는 방법
    -- => **호출형태 ( 왼쪽에 변수가 존재하는 가 )
    -- v_result := test_pro('PL/SQL');  --PROCEDUER 호출시 변수없이 단독 호출해야함. 변수에 할당하면 함수로 인식해서 오류(나는 프로시저인데!)
    test_pro('PL/SQL');
END;
/

EXECUTE test_pro('WORLD'); --SQL DEVELOPER로 단 하나의 PROCEDURE를 확인할 때, 단독으로 사용함. 
                           -- 지금실행을 요청한 PROCEDURE를 강제로 BEGIN과 END절에 끼워넣어 TEST하는 형태

-- PROCEDURE가 가진 3가지 MODE 실습

-- IN 모드 : 호출환경 ->프로시저로 값을 전달, 프로시저 내부에서 상수 취급
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    -- p_eid := 100;  -- 매개변수 값을 변경(프로시저 내부에서 상수 취급. 값 변경불가/가지고 오기만 가능)
                   --> PLS-00363: expression 'P_EID' cannot be used as an assignment target
    UPDATE employees
    SET salary = salary * 1.1  --eid가져오면 임금 10프로인상
    WHERE employee_id = p_eid;
END;
/
--> 오류가 나도 값은 저장되므로 ERROR뜸. DROP하고 다시 CREATE하삼 (ORA-00955: name is already used by an existing object)


SELECT employee_id, salary
FROM employees
WHERE employee_id IN (100, 130, 149);

DECLARE
    v_first NUMBER(3,0) := 100; --초기화된 변수
    v_second CONSTANT NUMBER(3,0) := 149; --상수
BEGIN
    raise_salary(100);            -- 리터럴
    raise_salary(v_first+30);     -- 표현식
    raise_salary(v_first);        -- 초기화된 변수
    raise_salary(v_second);       -- 상수
END;
/

-- OUT 모드 : 프로시저 -> 호출환경으로 값을 반환, 프로시저 내부에서 초기화되지 않은 변수로 인지
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,  --OUT모드의 변수가 리턴과 같은 역할
p_out OUT NUMBER)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END; --블록이 종료되는 순간 OUT 모드의 매개변수가 가지고 있는 값이 그대로 반환
/

-- 실행코드 
DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result: ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result: ' || v_result);
END; 
/

-- 더하기 (를 PROCEDURE로 구현)
CREATE PROCEDURE pro_plus
(p_x IN NUMBER,
p_y IN NUMBER,
p_sum OUT NUMBER)
IS

BEGIN
    p_sum := p_x + p_y;
END;
/
-- 실행코드
DECLARE
    v_total NUMBER(10,0);
BEGIN
   pro_plus(10, 25, v_total);
   DBMS_OUTPUT.PUT_LINE(v_total);
END; 
/

-- IN OUT 모드 : IN 모드와 OUT 모드 두가지를 하나의 변수로 처리
-- 문제점: 원래 데이터가 사라짐 (OUT기반 프로시저 호출 시 변수의 실제 값이 사라짐. 덮어씀. IN값도 없어짐)
--> 원래 데이터의 값이 변경되어야 할 경우에 쓰임 / 변경되어도 상관없을 때

-- 쓰는 경우 예시
-- '01012341234' => '010-1234-1234'
-- 날짜를 지정한 포맷으로 변경: '24/11/27' => '24년11월'

CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)  -- 변수가 하나라는 것을 기억하자
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('before: ' || p_phone_no); -- 사용자 전달값 확인
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                 || '-' || SUBSTR(p_phone_no, 4, 4)
                 || '-' || SUBSTR(p_phone_no, 8); --> 마지막 매개변수 없으면 지정위치부터 남은거 전~부
    DBMS_OUTPUT.PUT_LINE('after: ' || p_phone_no); -- 연산으로 변경된 값 확인
END;
/

-- 실행코드
DECLARE
    v_no VARCHAR2(100) := '01012341234';
BEGIN
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no); -- '01012341234' => '010-1234-1234'
                                -- 기존, 변경데이터 모두 보여주고 싶다면? 덮어써버려 기존 데이터를 보여주기 불가능..
                                -- IN, OUT 분리된 형태가 안정적으로 사용하기 가능
END;
/

-- 프로시저에서는 DML사용 (INSERT,UPDATE,DELETE) / 여러개의 매개변수 필요
-- FUCTION은 RETURN 이 들어감. 무.조.건 값을 리턴해야함(JAVA의 VOID, JS의 생략 불가)
-- 함수는 계산할 때, 계산한 결과를 가지고 오는 경우 ,
-- 프로시저는 여러 데이터를 자유롭게 INSERT하고 돌려받을 때

CREATE FUNCTION hello
RETURN VARCHAR2
IS
BEGIN
    RETURN 'Hello !!!';
END;
/
SELECT hello
FROM dual;

-- 평가 범위는 내일 진행할 function까지임

-- https://onecompiler.com/ 원컴파일러 ->간단한 문법 테스트에 좋음

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

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
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
CREATE PROCEDURE yedam_emp



/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/

/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/