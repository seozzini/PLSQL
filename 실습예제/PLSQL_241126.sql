SET SERVEROUTPUT ON

/*
9. 구구단 1~9단까지 출력되도록 하시오.
   (단, 홀수단 출력)
   num % 2 == 0 
   MOD(num, 2) = 0
*/

-- 구구단
BEGIN
    FOR dan IN 1..9 LOOP -- 단 : 정수, 1 ~ 9
        -- dan이 결정된 후 첫 실행
        IF MOD(dan,2) <> 0 THEN -- 홀수단을 확인 
            FOR num IN 1..9 LOOP -- 곱하는수 : 정수, 1 ~ 9
                DBMS_OUTPUT.PUT_LINE(dan || ' X ' || num || ' = ' || (dan * num) || ' ');
            END LOOP;
        END IF;
    END LOOP;
END;
/

BEGIN
    FOR dan IN 1..9 LOOP -- 단 : 정수, 1 ~ 9
        -- dan이 결정된 후 첫 실행
        /*
        IF MOD(dan,2) = 0 THEN -- 짝수단일 경우
            CONTINUE; -- 진행하지 않은 상태로 다음 조건으로 넘어감
        END IF;
        */        
        CONTINUE WHEN MOD(dan,2) = 0;
        
        FOR num IN 1..9 LOOP -- 곱하는수 : 정수, 1 ~ 9
            DBMS_OUTPUT.PUT_LINE(dan || ' X ' || num || ' = ' || (dan * num) || ' ');
        END LOOP;
    END LOOP;
END;
/

-- 조합 데이터 유형 : 여러 값을 가질 수 있는 데이터 타입
-- RECORD : 내부에 필드를 가지는 데이터 구조, SELECT문처럼 데이터를 조회하는 경우 많이 쓰임.
-- 1) 문법
DECLARE
    -- 1. 레코드 타입 정의
    TYPE 레코드타입명 IS RECORD
            ( 필드명 데이터타입,
              필드명 데이터타입 := 초기값,
              필드명 데이터타입 NOT NULL := 초기값);
              
    -- 2. 변수 선언
    변수명 레코드타입명;
BEGIN
    -- 3. 사용
    변수명.필드명 := 변경값;
    DBMS_OUTPUT.PUT_LINE(변수명.필드명);
END;
/

-- 2. 적용
DECLARE
    -- 1) 타입 정의  => INTO 절에서 사용되는 경우 SELECT절의 컬럼과 동일한 형태로 구성
    TYPE emp_record_type IS RECORD
            ( empno NUMBER(6,0),
              ename employees.last_name%TYPE NOT NULL := 'Hong',
              sal employees.salary%TYPE := 0);
              
    -- 2) 변수선언
    v_emp_info emp_record_type;
    v_emp_rec  emp_record_type;
BEGIN
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
    
    v_emp_rec.empno := &사원번호;
    
    SELECT employee_id, last_name, salary
    INTO v_emp_info
    FROM employees
    WHERE employee_id = v_emp_rec.empno;

    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
END;
/

-- %ROWTYPE : 테이블 혹은 뷰의 한행을 RECORD TYPE으로 반환 => 타입 정의 없이 변수 선언으로 바로 사용
DECLARE
    v_emp_rec employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_emp_rec
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.last_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.salary);

END;
/

-- TABLE : 동일한 데이터 타입의 값을 여러개 가짐. 주로, 레코드타입과 함께 특정 테이블의 모든 데이터를 변수에 담을 때 사용
-- 1) 문법
DECLARE
    -- 1. 타입 정의
    TYPE 테이블타입명 IS TABLE OF 데이터타입
        INDEX BY BINARY_INTEGER;
    
    -- 2. 변수 선언
    변수명 테이블타입명;
BEGIN
    -- 3. 사용
    변수명(인덱스) := 초기값;
    DBMS_OUTPUT.PUT_LINE(변수명(인덱스));
END;
/

-- 2) 적용
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
            INDEX BY PLS_INTEGER;
    -- 2) 변수 선언
    v_num_info num_table_type;
BEGIN
    v_num_info(-123456789) := 1000;
    v_num_info(1111111111) := 1234;
    DBMS_OUTPUT.PUT_LINE(v_num_info(-123456789));
    DBMS_OUTPUT.PUT_LINE(v_num_info(1111111111));
END;
/

-- 테이블 타입의 메서드 활용
DECLARE
    -- 1) 테이블 타입 정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
    
    -- 2) 변수 선언
    v_num_info num_table_type;
    v_idx NUMBER;
BEGIN
    v_num_info(-23)   := 1;
    v_num_info(-5)    := 2;
    v_num_info(11)    := 3;
    v_num_info(1121)  := 4;
    
    DBMS_OUTPUT.PUT_LINE('값의 갯수 : ' || v_num_info.COUNT);

    -- FOR LOOP문       
    FOR idx IN v_num_info.FIRST .. v_num_info.LAST LOOP
        IF v_num_info.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(idx || ' : ' || v_num_info(idx));
        END IF;
    END LOOP;
    
    -- 기본 LOOP문 : 실제 값만 검색
    v_idx := v_num_info.FIRST;
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_idx || ' : ' || v_num_info(v_idx));    
        
        EXIT WHEN v_num_info.LAST <= v_idx;
        v_idx := v_num_info.NEXT(v_idx);
    END LOOP;    
END;
/

-- TABLE + RECORD
DECLARE
    -- 1) 타입 정의
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2) 변수를 선언
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
BEGIN
    -- 테이블 조회
    FOR eid IN 100 .. 104 LOOP
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;

    -- 테이블 타입의 데이터 조회
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- 해당 인덱스에 데이터가 있는 경우
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;
    END LOOP;
END;
/
-- Employees 테이블 전체 데이터 => 테이블 타입의 변수에 담기
DECLARE
    -- 1) 타입 정의
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2) 변수를 선언
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
    
    -- 추가 변수
    v_min employees.employee_id%TYPE;
    v_max v_min%TYPE;
    v_count NUMBER;
BEGIN
    -- employee_id 최소값, 최대값
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    -- 테이블 조회
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_count
        FROM employees
        WHERE employee_id = eid;
        -- 해당 사원번호 기준 데이터가 없는 경우 다음 조건으로
        CONTINUE WHEN v_count = 0;
        
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;

    -- 테이블 타입의 데이터 조회
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- 해당 인덱스에 데이터가 있는 경우
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;
    END LOOP;
END;
/
-- COUNT 그룹함수
SELECT COUNT(*), COUNT(commission_pct)
FROM employees;

-- 명시적 커서 : 다중 행 SELECT문을 실행하기 위한 PL/SQL 문법
SELECT *
FROM employees;
-- 1) 문법
DECLARE
    -- 1. 커서 정의
    CURSOR 커서명 IS
        SELECT문(SQL의 SELECT문, INTO절 사용불가);        
        
BEGIN
    -- 2. 커서 실행
    -- 2-1) 커서를 실제 실행해서 활성집합(결과)를 식별
    -- 2-2) 포인터를 가장 위로 배치
    OPEN 커서명;
    
    -- 3. 데이터 인출
    -- 3-1) 포인터를 아래로 이동
    -- 3-2) 현재 가리키는 데이터를 인출
    FETCH 커서명 INTO 변수;
    
    -- 4. 커서 종료 : 활성집합(결과)를 삭제
    CLOSE 커서명;
    
END;
/

-- 2) 적용
DECLARE
    -- 1. 커서 정의
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. 커서 실행
    OPEN emp_cursor;
    
    -- 3. 커서에서 데이터 인출
    FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
    
    -- 3.5 데이터를 기반으로 연산
    DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    
    -- 4. 커서 종료
    CLOSE emp_cursor;

END;
/
-- 명시적 커서의 속성과 기본 LOOP문
DECLARE
    -- 1. 커서 정의
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. 커서 실행
    OPEN emp_cursor;

    LOOP
        -- 3. 커서에서 데이터 인출
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND; -- 새로운 데이터의 존재유무 확인
        
        -- 3.5 데이터를 기반으로 연산
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : ' ); -- FETCH를 실행해서 가져온 행수 
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    END LOOP;
    -- ERROR 1 : 커서가 실행된 상태에서 다시 실행 => cursor already open
    IF NOT emp_cursor%ISOPEN THEN -- 커서 실행 여부 확인
        OPEN emp_cursor;
    END IF;
    
    -- 4. 커서 종료
    CLOSE emp_cursor;
    -- ERROR 2 : 커서가 종료된 상태에서 속성 사용 => invalid cursor
    -- DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
END;
/

-- 주의사항 : 명시적 커서는 결과가 없는 경우 에러가 발생하지 않음.
-- 특정 부서에 속한 사원의 사원번호와 이름, 업무를 출력
-- 명시적 커서 => SQL의 SELECT문을 요구
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = &부서번호;
-- 부서번호 0  => 데이터 없음
-- 부서번호 10 => 데이터 한건
-- 부서번호 50 => 데이터 여러건

DECLARE
    -- 1. 커서 정의
    CURSOR emp_of_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
        
    v_eid   employees.employee_id%TYPE

select * from table(dbms_xplan.display_cursor(sql_id=>'null', format=>'ALLSTATS LAST'));
;
    v_ename employees.last_name%TYPE;
    v_job   employees.job_id%TYPE;
 
BEGIN
    -- 2. 커서 실행
    OPEN emp_of_dept_cursor;
    
    LOOP
        -- 3. 데이터 인출
        FETCH emp_of_dept_cursor INTO v_eid, v_ename, v_job

select * from table(dbms_xplan.display_cursor(sql_id=>'null', format=>'ALLSTATS LAST'));
;
        EXIT WHEN emp_of_dept_cursor%NOTFOUND;
        
        -- 4. 데이터 인출 성공 시 연산
        DBMS_OUTPUT.PUT(emp_of_dept_cursor%ROWCOUNT || ' : '); -- LOOP문 내부 유동값, 현재 반환된 데이터 갯수
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_job);
    END LOOP;
    
    -- LOOP문 바깥 고정값, 커서의 총 데이터 갯수
    DBMS_OUTPUT.PUT_LINE(emp_of_dept_cursor%ROWCOUNT);
    IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 소속사원이 없습니다');
    END IF;
    -- 5. 커서 종료
    CLOSE emp_of_dept_cursor;
END;
/

/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를  => 명시적 커서 : 다중행 SELECT문
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
=> 조건문
*/
-- SELECT문 : 사원 테이블에서 사원번호, 사원이름, 입사년도 조회 => 명시적 커서
SELECT employee_id, last_name, hire_date
FROM employees;

-- 조건문
IF 입사년도가 2025년(포함) 이전 THEN
    test01 테이블에 입력
ELSE
    test02 테이블에 입력
END IF;

-- PL/SQL 블록
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
       
    v_eid employees.employee_id%TYPE; 
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;

BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate;        
        EXIT WHEN emp_cursor%NOTFOUND;
    
        -- 커서에서 반환되는 데이터가 있는 경우 
        -- IF v_hdate <= TO_DATE('20251231', 'yyyyMMdd') THEN
        IF TO_CHAR(v_hdate, 'yyyy') <= '2025' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        ELSE
            INSERT INTO test02(empid, ename, hiredate)
            VALUES (v_eid, v_ename, v_hdate);
        END IF;
    END LOOP;
    
    CLOSE emp_cursor;
END;
/
SELECT sysdate, TO_CHAR(sysdate, 'HH:mm:ss')
FROM dual;

DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
    
    TYPE emp_recode_type IS RECORD
        ( eid employees.employee_id%TYPE, 
          ename employees.last_name%TYPE,
          hdate employees.hire_date%TYPE);
    v_emp_info emp_recode_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP

        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
    
        -- 커서에서 반환되는 데이터가 있는 경우 
        -- IF v_emp_info.hdate <= TO_DATE('20251231', 'yyyyMMdd') THEN
        IF TO_CHAR(v_emp_info.hdate, 'yyyy') <= '2025' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (v_emp_info.eid, v_emp_info.ename, v_emp_info.hdate);
        ELSE
            INSERT INTO test02
            VALUES v_emp_info;
        END IF;
    END LOOP;
    
    CLOSE emp_cursor;
END;
/
SELECT *
FROM test02;

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/
-- SELECT문 : 부서번호 -> employees(사원이름, 입사일자), departments(부서명) / JOIN
SELECT last_name, hire_date, department_name
FROM employees e JOIN departments d
               ON (e.department_id = d.department_id)
WHERE e.department_id = &부서번호;

-- PL/SQL 블록
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, hire_date, department_name
        FROM employees e JOIN departments d
                         ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
    
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dept_name departments.department_name%TYPE;
BEGIN
    OPEN emp_in_dept_cursor;
    
    LOOP
        FETCH emp_in_dept_cursor INTO v_ename, v_hdate, v_dept_name;
        EXIT WHEN emp_in_dept_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_hdate || ', ' || v_dept_name);
    END LOOP;

    CLOSE emp_in_dept_cursor;
END;
/
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
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE;
    v_year NUMBER(10,2);
BEGIN
    OPEN emp_in_dept_cursor;
    
    LOOP
        FETCH emp_in_dept_cursor INTO v_emp_rec;
        EXIT WHEN emp_in_dept_cursor%NOTFOUND;
        
        v_year := (v_emp_rec.salary*12+(v_emp_rec.salary*nvl(v_emp_rec.commission_pct,0)*12));
        
        DBMS_OUTPUT.PUT(v_emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || v_emp_rec.salary);
        DBMS_OUTPUT.PUT_LINE(', ' || v_year);
    END LOOP;
    
    CLOSE emp_in_dept_cursor;
END;
/

-- 3-2
SELECT last_name, salary, (salary*12+(salary*nvl(commission_pct,0)*12))
FROM employees
WHERE department_id = &부서번호;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal, (salary*12+(salary*nvl(commission_pct,0)*12)) as year
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE;
BEGIN
    OPEN emp_in_dept_cursor;
    
    LOOP
        FETCH emp_in_dept_cursor INTO v_emp_rec;
        EXIT WHEN emp_in_dept_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(v_emp_rec.ename);
        DBMS_OUTPUT.PUT(', ' || v_emp_rec.sal);
        DBMS_OUTPUT.PUT_LINE(', ' || v_emp_rec.year);        
    END LOOP;
    
    CLOSE emp_in_dept_cursor;
END;
/











