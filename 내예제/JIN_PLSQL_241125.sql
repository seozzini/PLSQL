--2024.11.25

--SQL%ROWCOUNT 실습

-- DBMS_OUTPUT.PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- 암시적 커서 : SQL문의 실행 결과를 담은 메모리 영역
--> 주 목적 : DML의 실행결과 확인, SQL%ROWCOUNT (암시적은 이름대신 SQL 붙음)
--> 주의사항 :  직전에 실행된 SQL문의 결과만 확인 가능

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '건이 삭제되었습니다.');
END;
/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- 조건문
-- 1) 기본 IF 문 : 특정 조건이 TRUE인 경우만 체크
-- 2) IF ~ ELSE 문 : 특정 조건을 기준으로 TRUE/FALSE 모두 확인 (주로 씀)
-- 3) IF ~ ELSIF ~ ELSE 문 : 여러 조건을 기반으로 각 경우의 수를 처리(ELSE영역을 디테일하게 나눈 것)

-- 조건문 실습

-- 1) 기본 IF 문 

BEGIN 
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다');
    END IF;
END;
/

rollback;

--> employees,departments 두 개의 테이블 모두에서 manager_id 없으면 삭제 안되니 확인 후 삭제해보기
--위의 조건 체크식
SELECT employee_id
FROM employees
WHERE employee_id NOT IN ( SELECT manager_id
                           FROM employees
                           WHERE manager_id IS NOT NULL
                           UNION
                           SELECT manager_id
                           FROM departments
                           WHERE manager_id IS NOT NULL );
                           
---------------------------------------------------------------------------------------------------------

-- 2) IF ~ ELSE 문

BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- 조건식이 TRUE일 경우
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    ELSE
        -- 위에 선언한 모든 조건식이 FALSE일 경우
        DBMS_OUTPUT.PUT_LINE('삭제되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요');
    END IF;
END;
/

---------------------------------------------------------------------------------------------------------

-- 3) IF ~ ELSIF ~ ELSE 문

DECLARE
    v_score NUMBER(2,0) := &점수;
    v_grade CHAR(1) := 'F';  -- 초기값 이렇게 세팅시 ELSE 구문 필요없는 경우도 있음.
    
BEGIN                         -- v_score이 가지는 최대값과 최소값 표기 : 최소값 < v_score < 최대값
    IF v_score >= 90 THEN     -- 90 <= v_score < 100
       v_grade := 'A';
    ELSIF v_score >= 80 THEN  -- 80 <= v_score < 90
          v_grade := 'B';
    ELSIF v_score >= 70 THEN  -- 70 <= v_score < 80
          v_grade := 'C';
    ELSIF v_score >= 60 THEN  -- 60 <= v_score 70
          v_grade := 'D';
    ELSE  -- ==>기본값으로 대체 가능  -- v_score < 60
       v_grade := 'F';       
   
    END IF;
    DBMS_OUTPUT.PUT_LINE('등급 : ' || v_grade);
END;
/

---------------------------------------------------------------------------------------------------------
-- 문제풀어보기

-- 사원번호를 입력받아 해당 사원의 업무(JOB_ID)가 영업('SA'가 포함된 경우)인 경우를 확인해주세요.
-- 출력문구 : 해당 사원의 담당업무는 영업분야 입니다.

/*
1. 사원번호를 입력받아
2. 해당사원의 업무가 영업인 경우 확인 => 조건문
2-1) 입력 : 사원번호 -> 내가 필요한 것은 : 업무 ,  SELECT문이 필요하다
SELECT 업무
FROM employees
WHERE 사원번호 = 입력받은 사원번호;
2-2)
IF 업무가 영업인 경우 => UPPER(업무) LIKE '%SA%' THEN
   출력 : '해당 사원의 담당업무는 영업분야 입니다.'
END IF;

*/

--SELECT문
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

-- 문제 풀어보기
/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2025년 이후(2025년 포함)이면 'New employee' 출력
      2025년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/

/*
1. 사원번호를 입력받아
2. 입사일이 2025년 이후(2025년 포함) -> 'New employee'
          2025년 이전              -> 'Career employee'
*/

/*
-- SELECT문
SELECT hire_date
FROM employees
WHERE employee_id = &사원번호;

-- 조건문
IF 입사일 >= 2025년 THEN
   출력 : 'New employee'

ELSE
   출력 : 'Career employee'
END IF;
/
*/
-- PL/SQL 100번, 149번 확인해보기



DECLARE
    v_hdate employees.hire_date%type;
    v_msg VARCHAR2(100);

BEGIN
    -- 1)
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 2)
    --IF v_hdate >= TO_DATE('2025-01-01','yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);

END;
/


/*
4.
drop table test01;
drop table test02;

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
2. 입사일이 2025년 이후(2025년 포함) -> 사원의 사원번호,사원이름,입사일을 test01 테이블에 입력
          2025년 이전              -> 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력
*/
-- SELECT문
SELECT employee_id, last_name, hire_date
FROM employees
WHERE employee_id = &사원번호;

-- 조건문
IF 입사일 >=2025년 THEN
    INSERT INTO test01(empid, ename, hiredate)
    VALUES ();
ELSE
    INSERT INTO test02(empid, ename, hiredate)
    VALUES ();

END IF;

-- PL/SQL
DECLARE
    v_eid employees.employee_id%type;
    v_ename employees.last_name%type;
    v_hdate employees.hire_date%type;
    
BEGIN
    SELECT employee_id, last_name, hire_date
    INTO v_eid, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hdate >= TO_DATE('20250101', 'yyyyMMdd') THEN
        INSERT INTO test01(empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    ELSE
        INSERT INTO test02(empid, ename, hiredate)
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
1. 사원번호 입력 -> 사원이름, 급여, 인상된 급여
-1) SELECT문 : 사원번호 -> 사원이름, 급여
-2) 인상된 급여?
    급여가  5000이하이면 20% 인상된 급여
    급여가 10000이하이면 15% 인상된 급여
    급여가 15000이하이면 10% 인상된 급여
    급여가 15001이상이면 급여 인상없음
*/

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_new_sal v_sal%TYPE;
    v_raise NUMBER(5,2);

BEGIN
    -- 1) SELECT문
    SELECT last_name, salary
    into v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- 1) 조건문
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
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_sal || ', ' || v_new_sal);
END;
/
--> 다시 확인해보기 (값나오는거 확인완료)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

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
        --반복하고자 하는 코드
        EXIT WHEN --종료조건을 의미
    END LOOP;
END;
/
-- 2) 적용
-- 1번 실행 후 STOP
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello!!!!');
        EXIT;  --이유 불문하고 STOP함
    END LOOP;
END;
/

-- 5번 실행 후 STOP
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    LOOP
        -- 반복하고자 하는 코드
        DBMS_OUTPUT.PUT_LINE('Hello!!!!');
        
        -- LOOP문을 제어하는 코드
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1부터 10까지의 정수의 총합 구하기
/*
1) 1부터 10까지 정수
2) 그 정수들의 총합
*/

-- 1) 정수부터 구하기
DECLARE
    v_num NUMBER(2,0) := 1; -- 정수 : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- 총합
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE (v_num);  -- 여기서 정수가 결정
        v_sum := v_sum + v_num;        -- 그 정수를 총합에 계속 더하기
        
        v_num := v_num + 1; 
        EXIT WHEN v_num > 10;  -- exit when 위에 exit에 쓰는 count를 붙여놓자~ (누락방지)
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총합 :' || v_sum);
END;
/

--5교시

/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/

/*
5번 카운트하는 변수!
*담는 변수 
담고나서 바로 출력하기
*/

declare
    v_star varchar2(100) := '';
    v_count number(1,0) := 0;
begin
    loop
        dbms_output.put_line(v_star);
        v_star := concat(v_star, '*');
        v_count := v_count+1;
        exit when v_count > 5;
    end loop;
end;
/
----------------------------------------------------------------------
--교수님 문풀 1-1
/*
반복하고자 하는 코드 : * 더하기 * , 이걸 총 5번 반복
*/
DECLARE
    v_count NUMBER(1,0) := 0; -- 반복 횟수
    v_tree VARCHAR2(6) := ''; -- '*' 총합
BEGIN
    LOOP
        --반복하고자 하는 코드
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        --반복을 제어하고자 하는 코드
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
        
    END LOOP;
END;
/

--교수님 문풀 1-2

DECLARE
    v_tree VARCHAR2(6) := ''; -- '*' 총합
BEGIN
    LOOP
        --반복하고자 하는 코드
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        --반복을 제어하고자 하는 코드
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

--교수님 문풀
--반복하고자 하는 코드 : 곱하는 수의 증가 ( 정수, 1~9) => 반복문

DECLARE
    v_dan CONSTANT NUMBER(2,0) := &단;
    v_num NUMBER(2,0) := 1;     -- 곱하는 수 : 정수, 1~9
BEGIN
    LOOP
        -- v_num 사용;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' ||(v_dan*v_num));
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 9 ;
    END LOOP;
END;
/


/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/

/*
-- 1) 2~9단, 단이 증가해야 함. => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1~9까지 정해진 값을 사용 => 두번째 LOOP문
*/

DECLARE
    v_dan NUMBER(2,0) := 2; -- 단 : (정수, 2~9)
    v_num NUMBER(2,0) := 1; --곱하는 수: 정수, 1~9
BEGIN
    LOOP
        --v_dan 사용
        v_num := 1; -- 안쪽 LOOP문의 변수 초기화 필요
        LOOP
        -- v_num 사용;
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' ||(v_dan * v_num));
        
            v_num := v_num + 1;
            EXIT WHEN v_num > 9 ;
        END LOOP; -- 2단이 끝난 순간 v_num = 10;
        
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------------------------

-- WHILE LOOP문 : 특정조건을 만족하는 동안 반복하는 LOOP문을 의미 => 경우에 따라 실행이 안되는 경우도 있음
-- 1) 문법
BEGIN
    WHILE 반복조건 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
END;
/

-- 2) 적용 (기본적으로 무한루프에 빠지지 않지만, 항상 TRUE인 BOOLEAN 타입 넣으면 무한루프 가능성)
BEGIN
    WHILE TRUE LOOP
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
    END LOOP;
END;
/

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
그 정수들의 총합
*/
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(2,0) := 0;
BEGIN
    --WHILE (v_num <= 10) LOOP
    LOOP
    -- v_num 사용 => 총합 구하기
        v_sum := v_sum + v_num;
    
        v_num := v_num + 1;
        EXIT WHEN v_num >10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1부터 10까지의 합 : ' || v_sum);
END;
/

-- 문제 6,7,8 WHILE문으로 풀어보기

/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/
DECLARE
    v_count number(1,0) := 1;
    v_star varchar2(100):= '';
BEGIN
    WHILE(v_count <= 5) LOOP
    v_star := v_star || '*';
    
    DBMS_OUTPUT.PUT_LINE(v_star);
    v_count := v_count+1;
    END LOOP;
END;
/

-- 다른 방법
DECLARE
    --변수 선언
    v_tree VARCHAR2(10) := '*';
BEGIN
    --v_tree 문자열 길이가 5보다 작거나 같을때까지 반복문 실행
    WHILE LENGTH(v_tree) <= 5 LOOP
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --반복문이 실행될 때마다 '*'추가
    END LOOP;
END;
/

-- ''공백 넣어서 null 처리하려면 nvl함수 쓰기
DECLARE
    --변수 선언
    v_tree VARCHAR2(10) := '';
BEGIN
    --v_tree 문자열 길이가 5보다 작거나 같을때까지 반복문 실행
    WHILE NVL(LENGTH(v_tree),0) <= 5 LOOP
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --반복문이 실행될 때마다 '*'추가
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
    v_dan NUMBER(1,0) := &단;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE (v_num < 10) LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    v_num := v_num + 1;
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/

/*
단 먼저 출력 , 단도 변하는 숫자로 지정
*/
DECLARE
    v_dan NUMBER(2,0) := 2;  --단 (정수, 2~9)
    v_num NUMBER(2,0) := 1;  --  (숫자 1~9)
BEGIN
   WHILE (v_dan < 10)LOOP
       v_num := 1;
       WHILE (v_num < 10) LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan*v_num));
        v_num := v_num + 1;
        END LOOP;
       v_dan := v_dan + 1;
   END LOOP;
END;
/

---------------------------------------------------------------------------------------------------------

-- FOR LOOP문 : 지정된 범위 안 모든 정수의 갯수만큼 반복
-- 1) 문법
BEGIN
    FOR 임시 변수 IN 최소값 .. 최대값 LOOP
        -- 반복하고자 하는 코드
    END LOOP;
        -- 임시변수 : 정수타입, DECLARE절에 따로 선언하지 않음. 
        -- 반드시 최소값과 최대값 사이의 정수값만 가짐.(음의 정수, 양의 정수 모두 포함) => Read Only
        -- 최소값, 최대값 : 정수 , 반드시 최소값은 최대값보다 작아야함 (최소값 <= 최대값)
END;
/

-- 2) 적용
BEGIN
    FOR idx IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

BEGIN
    FOR idx IN -10 .. -6 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

DECLARE
    v_max NUMBER(2,0) := &최대값;
BEGIN
    FOR idx IN 5 .. v_max LOOP  -- v_max < 5 일 경우 FOR LOOP문은 실행되지 않음
        -- idx := 10; // FOR LOOP문의 임시변수는 변경할 수 없음 (PLS-00363: expression 'IDX' cannot be used as an assignment target)
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

--REVERSE 개념

BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP  --REVERSE : 범위 내에 존재하는 정수 값을 내림차순으로 가지고 옴
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

-- 1부터 10까지의 정수의 총합 구하기

DECLARE
    v_sum NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
    v_sum := v_sum + num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

--8교시
--같은 문제 for loop로 바꿔보기
/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/

DECLARE 
   v_star VARCHAR2(6) := '';
BEGIN
    FOR idx IN 1 .. 5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
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
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR idx IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan||' * '|| idx || ' = ' || (v_dan * idx));
    END LOOP;
END;
/




/*
8. 구구단 2~9단까지 출력되도록 하시오.
-- 1) 2~9단, 단이 증가해야 함. => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1~9까지 정해진 값을 사용 => 두번째 LOOP문
*/


BEGIN
    FOR dan IN 2 .. 9 LOOP -- 첫번째 LOOP문 : 단을 제어, 정수며 2 ~ 9
       FOR num IN 1 .. 9 LOOP -- 두번째 LOOP문 : 곱하는 수를 제어, 정수며 1 ~ 9
           DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num));
       END LOOP;
    END LOOP;
    -- 곱하는 수가 없음
END;
/

--추가문제
-- DECLARE 절 없이 이중 FOR LOOP문 사용
/*

6. 다음과 같이 출력되도록 하시오.
*         :1줄, * 1개 출력 
**        :2줄, * 2개 출력       
***       :3줄, * 3개 출력     
****      :4줄, * 4개 출력  
*****     :5줄, * 5개 출력
=> DBMS_OUTPUT.PUT();

*/

BEGIN
    FOR line IN 1 .. 5 LOOP  -- LINE을 제어, 1 ~ 5
        FOR star IN 1 .. line LOOP -- 각 LINE마다 출력되는 '*' 제어, LINE = 최대값
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

