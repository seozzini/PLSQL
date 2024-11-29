--2024.11.28

-- ����ó��
-- ���ܴ� �ݺ������� �߻��ϴ� ��� �ݵ�� �ذ��ؾ���
-- ���Ḧ ���� �� �� ���������� ����� ���� �ƴ�.

-- ���� Ǯ��� (�Ű����� IN MODE������)
/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju('9501011667777');
950101-1******
EXECUTE yedam_ju('1511013689977');
151101-3******

�Ű������� ���ͷ� => IN �Ű����� �ϳ��� + ������ ��±��� => DBMS_OUTPUT.PUT_LINE�� ���ο��� ����
*/
--������ Ǯ��
DROP PROCEDURE yedam_ju;
CREATE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)  --�� VARCHAR2�� ����? 2000����� ��� 00���� �����ؾ� �ϱ⶧�� (���̴°� �ƴ϶� �ǹ̸� ������.)
IS
    v_result VARCHAR2(30); -- ���� ���� (����� ���, IN MODE�� P�� ���)
BEGIN
    
    v_result := SUBSTR(p_ssn, 1, 6)  -- �� 6�ڸ�
                -- || '-' ||SUBSTR(p_ssn, 7,1)||'******'; -- �� 7�ڸ�-1: ������ ���̸�ŭ ä�ﶧ
                 || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*'); -- �� 7�ڸ�-2: �׻� ���� ���ڼ� ���
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

SELECT salary, LPAD(salary, 10, '-'), RPAD(salary, 10, '-')
FROM employees;

--���ڵ�
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
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/
--������
--SQL��
DELETE FROM employees
WHERE employee_id = &�����ȣ;
--PROCEDURE (���ν���, �Լ��� ġȯ���� �Ⱦ���.�Ű������� �Ѱܹ޾ƾ���)
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid IN employees.employee_id%TYPE)

IS

BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid;
    
    --DML�� ��� SQL%ROWCOUNT
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
    END IF;
END;
/
EXECUTE TEST_PRO(176);
ROLLBACK;

--��Ǯ��
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid IN employees.employee_id%TYPE)
IS
BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid;
    DBMS_OUTPUT.PUT_LINE(p_eid || '�� ����� �����Ǿ����ϴ�.');
    
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
    END IF;
    ROLLBACK;
END;
/

--�����ڵ�
EXECUTE TEST_PRO(176);
EXECUTE TEST_PRO(300);

/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
*/
--������Ǯ��
-- �Է� : �����ȣ -> ��� : ����̸� / SELECT��
SELECT last_name, SUBSTR(last_name,1,1), RPAD(SUBSTR(last_name,1,1),LENGTH(last_name),'*')
FROM employees
WHERE employee_id = &�����ȣ;

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

--��Ǯ��
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
�μ���ȣ�� �Է��� ��� 
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name), ����(���)�� ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
*/
/* MONTHS_BETWEEN([��¥ ������1(�ʼ�)], [��¥ ������2(�ʼ�)]) */

-- ������ Ǯ��
-- ���� �⵵�ν��� ���� : 1�������� ����
-- ������ν��� ����   : ���������� ����

SELECT employee_id
       , hire_date
       , MONTHS_BETWEEN(sysdate, hire_date) as �Ѱ�����
       -- ���� �⵵�ν��� ���� : 1�������� ����
       , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) as ����1
       , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0) + 1 as ����2
       -- ������ν��� ���� : ���������� ����
       , MONTHS_BETWEEN(sysdate, hire_date)/12 ��1
       , MOD(MONTHS_BETWEEN(sysdate, hire_date),12) as ����1
       , TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12, 0) as ��2
       , ROUND (MOD(MONTHS_BETWEEN(sysdate, hire_date),12),0) as ����2
FROM employees;

-- �����ȣ, ����̸�, �Ի����� ��ȸ, ���� �μ���ȣ
SELECT employee_id
       , last_name
       , hire_date
FROM employees
WHERE department_id = &�μ���ȣ;
-- ������ => ����� Ŀ�� ����
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
    -- 2. Ŀ�� ����
    OPEN emp_of_dept_cursor;
        LOOP
            -- 3. Ŀ������ ������ ����
            FETCH emp_of_dept_cursor INTO v_emp_info; --��� ������ ������
            EXIT WHEN emp_of_dept_cursor%NOTFOUND;  --���ο� �������� �������� Ȯ��(���ο� ������ ������ TRUE ��ȯ)
            -- �μ��� ���� ����� �ִ� ���
            
            v_years := CEIL(MONTHS_BETWEEN(sysdate, v_emp_info.hire_date)/12);
            --���
            DBMS_OUTPUT.PUT(v_emp_info.employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_info.last_name);
            DBMS_OUTPUT.PUT_LINE(', '  || v_years);
        END LOOP;
        -- LOOP�� �ۿ��� ROWCOUNT �Ӽ� : ���� Ŀ���� ������ �ִ� �� ������ ����
        IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
            RAISE e_no_search_emp;
        END IF;
 
    -- 4. Ŀ�� ����
    CLOSE emp_of_dept_cursor;
EXCEPTION
    WHEN e_no_search_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
        CLOSE emp_of_dept_cursor;
END;
/

EXECUTE get_emp(30);
ROLLBACK;

-- ��Ǯ��
SELECT employee_id, last_name, 

SELECT employee_id, last_name,(to_char(sysdate,'yyyy') - to_char(hire_date,'yyyy')) as year
FROM employees
WHERE department_id = &�μ���ȣ;

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
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.year || '����');
    END LOOP;
END;
/

EXECUTE get_emp(50);



/*
5.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/

-- ������ Ǯ��
-- SQL��
UPDATE employees 
SET salary = salary + (salary*(�޿�����ġ/100))
WHERE employee_id = &�����ȣ;

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

--�Լ� FUNCTION
--11�� PPT

-- FUNCTION : �ַ� ����ϴ� �뵵�� ���� ����ϴ� ��ü
--  => DML ���� VARCHAR2, NUMBER, DATE �� SQL���� ����ϴ� ������ Ÿ������ ��ȯ�� ��� SQL���� �Բ� ��� ����.

-- 1) ����
CREATE FUNCTION �Լ���
( �Ű������� ������ Ÿ��, ... ) -- IN ���θ� ��밡���ϹǷ� ���� ����
RETURN ����Ÿ��
IS
    -- ����� : ����, Ŀ��, ���ܻ��� ���� ����
BEGIN
    -- �����ϰ��� �ϴ� �ڵ�
    RETURN ���ϰ�;
EXCEPTION
    WHEN �����̸� THEN
        -- ����ó�� �ڵ�
        RETURN ���ϰ�;

END;

-- 2) ����
CREATE FUNCTION test_func
(p_msg VARCHAR2)
RETURN VARCHAR2
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    RETURN (v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '�����Ͱ� �������� �ʽ��ϴ�.';
END;
/

-- 3) ����
-- 3-1) PL/SQL���
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- �Լ�ȣ��� �ݵ�� ������ �ʿ�
    v_result := test_func('PL/SQL');
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
-- 3-2) SQL��
SELECT test_func('PL/SQL')
FROM dual;

-- ���ϱ⸦ �Լ���
CREATE FUNCTION y_sum
(p_x NUMBER,
 p_y NUMBER)
RETURN NUMBER
IS 

BEGIN
    RETURN (P_X + P_Y);
END;
/

-- ���� (PL/SQL)
DECLARE
    v_sum NUMBER(10,0);
BEGIN
    -- �Լ�ȣ��� �ݵ�� ������ �ʿ�
    v_sum := y_sum(10,5);
    
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- ���� (SQL)
SELECT y_sum(10,5)
FROM dual;

-- �����ȣ�� �Է¹޾� �ش� ����� ���ӻ�� �̸��� ��� => ��������
-- ��� employees e
-- ���ӻ�� employees m
-- ���� SELECT��
SELECT e.employee_id
       , m.last_name
FROM employees e -- �����ȣ�� �Է¹޾�
         join employees m -- ��������� ������
         on m.employee_id = e.manager_id
WHERE e.employee_id = &�����ȣ ;

--�Լ� ���
SELECT employee_id, get_mgr(employee_id)
FROM employees;


DROP FUNCTION get_mgr;
CREATE FUNCTION get_mgr
(p_eid employees.employee_id%TYPE) --�����ȣ
RETURN VARCHAR2
IS
    v_mgr_name employees.last_name%TYPE;
BEGIN
    SELECT m.last_name
    INTO v_mgr_name
    FROM employees e   -- ���
         join employees m  -- ���
         on  e.manager_id = m.employee_id
    WHERE e.employee_id = p_eid ;
    
    RETURN (v_mgr_name);
END;
/

SELECT get_mgr(105)
FROM dual;

-- DATA DICTIONARY (������ ��ųʸ�) VIEW
SELECT  name, line, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION');
-->������ �� �� �ִ� ���̺�, VIEW�� �ִٴ� �� �˱�


-- �Լ� ����Ǯ��

/*
1.
�����ȣ�� �Է��ϸ� 
last_name + first_name �� ��µǴ� 
y_yedam �Լ��� �����Ͻÿ�.

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
--������ Ǯ��

SELECT  employee_id, first_name || ' ' || last_name
FROM employees;

DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2 -- �̸��̹Ƿ� ���ڿ�
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

--�� Ǯ��
SELECT first_name ||' ' ||last_name as fullname
FROM employees
WHERE employee_id = &�����ȣ;

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

-- �Լ����
SELECT employee_id, y_yedam(employee_id)
FROM employees;





/*
2.
�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �ʰ��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees; 
*/

-- ������ Ǯ��
DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal employees.salary%TYPE;
    v_raise NUMBER(5,2);
BEGIN

    -- 1) �Է�: �����ȣ => ��� : �޿� /  SELECT�� 
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
-- 2) ���ǹ� : �� �������� ������ �λ��� ��������
   IF v_sal <= 5000  THEN
        v_raise := 20;
    ELSIF v_sal <= 10000  THEN
        v_raise := 15;
    ELSIF v_sal <= 20000  THEN
        v_raise := 10;
    ELSE 
        v_raise := 0;
    END IF;
-- 3) ��� : �λ�� �޿�
    RETURN (v_sal+ (v_sal *(v_raise/100)));
END;
/



-- �� Ǯ��
select last_name, salary
from employees
where employee_id = &�����ȣ;

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
    ELSE --�޿��� 15001 �̻�  
         v_raise := 0;
    END IF;
    
    v_new_sal := v_sal + v_sal *(v_raise);
    
    RETURN (v_new_sal);
END;
/

-- ���๮
SELECT last_name, salary, YDINC(employee_id)
FROM   employees; 

/*
3.
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;  
*/


-- ������ Ǯ��
SELECT (NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12   --salary�� nvló�����ֱ�~~
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

-- �� Ǯ��
SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12)) as ����
FROM employees
WHERE employee_id = &�����ȣ;

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

