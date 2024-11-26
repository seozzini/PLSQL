-- DBMS_OUTPUT.PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON 

-- 암시적 커서 : SQL문의 실행 결과를 담은 메모리 영역
-- => 주 목적 : DML의 실행결과 확인, SQL%ROWCOUNT
-- => 주의사항 : 직전에 실행된 SQL문의 결과만 확인 가능

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '건이 삭제되었습니다.');
END;
/


-- 조건문
-- 1) 기본 IF문 : 특정 조건이 TRUE 인 경우만
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    END IF;
END;
/

SELECT employee_id
FROM employees
WHERE employee_id NOT IN ( SELECT manager_id
                           FROM employees
                           WHERE manager_id IS NOT NULL
                           UNION
                           SELECT manager_id
                           FROM departments
                           WHERE manager_id IS NOT NULL);

-- 2) IF ~ ELSE 문 : 특정 조건을 기준으로 TRUE/FALSE 모두 확인
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- 조건식이 TRUE일 경우
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    ELSE
        -- 위에 선언한 모든 조건식이 FALSE일 경우
        DBMS_OUTPUT.PUT_LINE('삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요.');
    END IF;

END;
/
-- 3) IF ~ ELSIF ~ ELSE 문 : 여러 조건을 기반으로 각 경우의 수를 처리
DECLARE
    v_score NUMBER(2,0) := &점수;
    v_grade CHAR(1);
BEGIN
    -- v_score이 가지는 최대값과 최소값 : 최소값 < v_score < 최대값
    IF v_score >= 90 THEN -- 90 <= v_score < 100
        v_grade := 'A';
    ELSIF v_score >= 80 THEN -- 80 <= v_score < 90
        V_grade := 'B';
    ELSIF v_score >= 70 THEN -- 70 <= v_score < 80
        V_grade := 'C';
    ELSIF v_score >= 60 THEN -- 60 <= v_score < 70
        V_grade := 'D';
    ELSE  -- ==> 기본값으로 대체 가능  -- v_score  < 60
        v_grade := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_grade);
END;
/

-- 사원번호를 입력받아 해당 사원의 업무(JOB_ID)가 영업인 경우('SA'가 포함된 경우)를 확인해주세요.
-- 출력문구 : 해당 사원의 담당업무는 영업분야 입니다.

/*
1. 사원번호를 입력받아
2. 해당사원의 업무가 영업인 경우 확인 => 조건문
2-1) 입력 : 사원번호 -> 필요 : 업무 , SELECT문
SELECT 업무
FROM employees
WHERE 사원번호 = 입력받은 사원번호;
2-2)
IF 업무가 영업인 경우 => UPPER(업무) LIKE '%SA%' THEN
    출력 : '해당 사원의 담당업무는 영업분야 입니다.'
END IF;

*/

-- SELECT문
SELECT job_id
FROM employees
WHERE employee_id = &사원번호;


DECLARE
    v_job employees.job_id%TYPE;
BEGIN
    SELECT job_id
    INTO v_job
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF UPPER(v_job) LIKE '%SA%' THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 영업분야 입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 ' || v_job || ' 입니다.');
    END IF;
END;
/

SELECT employee_id, job_id
FROM employees
WHERE job_id LIKE 'SA_%';

/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2025년 이후(2025년 포함)이면 'New employee' 출력
      2025년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/

/*
1. 사원번호를 입력받아
2. 사원번호 -> 입사일 조회, SELECT문
3. 입사일이 2025년 이후(2025년 포함) -> 'New employee'
           2025년 이전             -> 'Career employee'
*/

-- SELECT문
SELECT hire_date
FROM employees
WHERE employee_id = &사원번호;

-- 조건문
IF 입사일 >= 2025년 THEN
    출력 : 'New employee';
ELSE
    출력 : 'Career employee';
END If;

-- PL/SQL
DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR2(100);
BEGIN
    -- 1)
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2)
    -- IF v_hdate >= TO_DATE('2025-01-01', 'yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
       v_msg := 'New employee';
    ELSE
       v_msg := 'Career employee';
    END If;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

사원번호를 입력(치환변수사용&)할 경우
사원들 중 2025년 이후(2025년 포함)에 입사한 사원의 사원번호, 
사원이름, 입사일을 test01 테이블에 입력하고, 2025년 이전에 
입사한 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력하시오.
*/

/*
1. 사원번호를 입력받아
2. 사원번호 -> 사원번호, 사원이름, 입사일 조회, SELECT문
3. 입사일이 2025년 이후(2025년 포함) -> 사원의 사원번호, 사원이름, 입사일을 test01 테이블에 입력
           2025년 이전             -> 사원의 사원번호, 사원이름, 입사일을 test02 테이블에 입력
*/

-- SELECT문
SELECT employee_id, last_name, hire_date
FROM employees
WHERE employee_id = &사원번호;

-- 조건문
IF 입사일 >= 2025년 THEN
    INSERT INTO test01 (empid, ename, hiredate)
    VALUES ();
ELSE 
    INSERT INTO test02 (empid, ename, hiredate)
    VALUES ();
END IF;

-- PL/SQL
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT employee_id, last_name, hire_date
    INTO v_eid, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hdate >= TO_DATE('20250101', 'yyyyMMdd') THEN
        INSERT INTO test01 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    ELSE 
        INSERT INTO test02 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    END IF;
END;
/
SELECT *
FROM test02;

/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/

/*
1. 사원번호 입력 -> 사원이름, 급여, 인상된 급여가 출력
-1) SELECT문 : 사원번호 -> 사원이름, 급여
-2) 인상된 급여?
    급여가  5000이하이면 20% 인상된 급여
    급여가 10000이하이면 15% 인상된 급여
    급여가 15000이하이면 10% 인상된 급여
    급여가 15001이상이면 급여 인상없음
*/

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal empeloyees.salary%TYPE;
    v_new_sal v_sal%TYPE;
    v_raise NUMBER(5,2);
BEGIN
    -- 1) SELECT문
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2) 조건문
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
         v_raise := 15;
    ELSIF v_sal <= 15000 THEN
         v_raise := 10;
    ELSE -- 급여가 15001이상
         v_raise := 0;
    END IF;
    
    v_new_sal := v_sal + v_sal * (v_raise/100);
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_sal || ', ' || v_new_sal);
END;
/

-- LOOP문
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello!!!');
    END LOOP;
END;
/

-- 기본 LOOP문 : 조건없이 무한 LOOP문을 의미 => 반드시 EXIT문을 포함하라고 권장
-- 1) 문법
BEGIN
    LOOP
        -- 반복하고자 하는 코드
        EXIT WHEN -- 종료조건을 의미
    END LOOP;
END;
/
-- 2) 적용
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        EXIT;
    END LOOP;
END;
/

DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    LOOP
        -- 반복하고자 하는코드
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP문을 제어하는 코드
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1 부터 10까지 정수의 총합 구하기
/*
1) 1부터 10까지 정수
2) 그 정수들의 총합
*/

-- 1) 정수부터 구하기
-- 2) 정수들의 총합 : 누적합 구하기
DECLARE
    v_num NUMBER(2,0) := 1; -- 정수 : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- 총합
BEGIN
    LOOP
    
        DBMS_OUTPUT.PUT_LINE(v_num); -- 여기서 정수가 결정
        v_sum := v_sum + v_num;      -- 그 정수를 총합에 계속 더하기
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총합 : ' || v_sum);
END;
/

/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/
/*
 반복하고자 하는 코드 : * 더하기 *   , 이걸 총 5번 반복
*/
DECLARE
    v_count NUMBER(1,0) := 0;  -- 반복 횟수
    v_tree VARCHAR2(6)  := ''; -- '*' 총합
BEGIN
    LOOP
        -- 반복하고자 하는 코드
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        -- 반복을 제어하고자 하는 코드
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;  

END;
/
DECLARE
    v_tree VARCHAR2(6)  := ''; -- '*' 총합
BEGIN
    LOOP
        -- 반복하고자 하는 코드
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        -- 반복을 제어하고자 하는 코드
        EXIT WHEN LENGTH(v_tree) >= 5;
    END LOOP;  
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...

*/

-- 반복하고자 하는 코드 : 곱하는 수의 증가 ( 정수, 1 ~ 9 ) => 반복문
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &단;
    v_num NUMBER(2,0) := 1;     -- 곱하는 수 : 정수, 1 ~ 9
BEGIN
    LOOP
        -- v_num 사용;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
    
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/



/*
8. 구구단 2~9단까지 출력되도록 하시오. => 이중 반복문
-- 1) 2 ~ 9 단, 단이 증가해야 함. => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1 ~ 9 까지 정해진 값을 사용 => 두번째 LOOP문
*/

DECLARE
    v_dan NUMBER(2,0) := 2; -- 단 : ( 정수, 2 ~ 9)
    v_num NUMBER(2,0) := 1;     -- 곱하는 수 : 정수, 1 ~ 9
BEGIN
    LOOP
        -- v_dan을 사용
        v_num := 1; -- 안쪽 LOOP문의 변수 초기화 필요
        LOOP
            -- v_num 사용;
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
    
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP; -- 2단이 끝난 순간 v_num = 10;
        
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- WHILE LOOP문 : 특정조건을 만족하는 동안 반복하는 LOOP문을 의미 => 경우에 따라 실행이 안되는 경우도 있음.
-- 1) 문법
BEGIN
    WHILE 반복조건 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
END;
/

-- 2) 적용
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP -- 명확한 반복조건 표기
        -- 반복하고자 하는 코드
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP문을 제어하는 코드
        v_count := v_count + 1;
    END LOOP;
END;
/

-- 1 부터 10까지 정수의 총합 구하기
/*
1) 1부터 10까지 정수
2) 그 정수들의 총합
*/

-- 1) 1부터 10까지 정수
DECLARE
    v_num NUMBER(2,0) := 1; -- 정수 : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- 총합
BEGIN
    WHILE v_num <= 10 LOOP
        -- v_num 사용 => 총합 구하기
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총합 : ' || v_sum);
END;
/

-- 기본 LOOP문으로 변환
DECLARE
    v_num NUMBER(2,0) := 1; -- 정수 : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- 총합
BEGIN
    -- WHILE v_num <= 10 LOOP
    LOOP
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
        -- WHILE v_num <= 10
        EXIT WHEN v_num > 10; 
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총합 : ' || v_sum);
END;
/

/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/

declare
    --변수 선언
    v_tree varchar2(10) := '*';
begin
    --v_tree 문자열 길이가 5보다 작거나 같을때까지 반복문 실행
    while NVL(length(v_tree),0) <= 5 loop
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --반복문이 실행될 때마다 '*'추가
    end loop;
end;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...

*/

DECLARE
    v_dan NUMBER(2,0) := &단;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
        v_num := v_num + 1; -- 10
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/

DECLARE
    v_dan NUMBER(4,0) :=2; --단 (정수, 2~9)
    v_number NUMBER(4,0):= 1; --(숫자1~9)
BEGIN
    WHILE v_dan<=9 LOOP -- 단을 반복
        v_number:= 1;
        WHILE v_number<=9 LOOP -- 곱하는수를 반복
            DBMS_OUTPUT.PUT_LINE(v_dan||'*'||v_number||'='|| (v_number*v_dan));
       
            v_number := v_number+1;                    
        END LOOP;
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- FOR LOOP문 : 지정된 범위 안 모든 정수의 갯수만큼 반복
-- 1) 문법
BEGIN
    FOR 임시 변수 IN 최소값 .. 최대값 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
    -- 임시변수 : 정수타입, DECLARE절에 따로 선언하지 않음. 반드시 최소값과 최대값 사이의 정수값만 가짐 => Read Only
    -- 최소값, 최대값 : 정수, 반드시 최소값 <= 최대값
END;
/

-- 2) 적용
BEGIN 
    FOR idx IN REVERSE 1 .. 5 LOOP -- REVERSE : 범위 내에 존재하는 정수 값을 내림차순으로 가지고 옴
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/
BEGIN 
    FOR idx IN -10 .. -6 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/
DECLARE
    v_max NUMBER(2,0) := &최대값;
BEGIN 
    FOR idx IN 5 .. v_max LOOP -- v_max := 0 일경우 FOR LOOP문은 실행되지 않음
        -- idx := 10; -- FOR LOOP문의 임시변수는 변경할 수 없음
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/

-- 1 부터 10까지 정수의 총합 구하기
DECLARE
    v_sum NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
        -- num : 1 ~ 10 까지 정수
        v_sum := v_sum + num; -- 정수의 합
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('총합 : ' || v_sum);
END;
/

/*

6. 다음과 같이 출력되도록 하시오.
*          : 1줄, * 1개 출력
**         : 2줄, * 2개 출력
***        : 3줄, * 3개 출력
****       : 4줄, * 4개 출력
*****      : 5줄, * 5개 출력
=> DBMS_OUTPUT.PUT();
*/

DECLARE
    v_tree VARCHAR2(6) := '';
BEGIN
    FOR count IN 1..5 LOOP
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
    END LOOP;
END;
/

-- DECLARE 절 없이 이중 FOR LOOP문 사용
BEGIN
    FOR line IN 1..5 LOOP -- LINE을 제어, 1 ~ 5
        FOR tree IN 1..line LOOP -- 각 LINE마다 출력되는 '*' 제어, LINE = 최대값
            DBMS_OUTPUT.PUT('*');
        END LOOP; -- 라인이 종료됨을 의미
        DBMS_OUTPUT.PUT_LINE(''); -- 라인 변경
    END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...

*/

DECLARE
    v_dan CONSTANT NUMBER(2,0) := &단;
BEGIN
    FOR num IN 1..9 LOOP -- 곱하는 수 : 정수, 1 ~ 9
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || num || ' = ' || (v_dan * num));
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
-- 1) 2 ~ 9 단, 단이 증가해야 함. => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1 ~ 9 까지 정해진 값을 사용 => 두번째 LOOP문
*/

BEGIN
    FOR dan IN 2..9 LOOP -- 첫번째 LOOP문 : 단을 제어, 정수며 2 ~ 9
        FOR num IN 1..9 LOOP -- 두번째 LOOP문 : 곱하는 수를 제어, 정수며 1 ~ 9
            -- dan은 고정값
            DBMS_OUTPUT.PUT_LINE(dan || ' X ' || num || ' = ' || (dan * num));
        END LOOP;
        -- 곱하는 수가 없음
    END LOOP;
END;
/















