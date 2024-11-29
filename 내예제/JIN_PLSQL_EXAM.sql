--2024.11.28 EXAM
/*
2.�����ȣ �Է¹޾� �μ��̸�, job_id, �޿�, ���� �Ѽ��� ���.
�޿��� Ŀ�̼��� NULL�� ���� ���� ��µǵ���
*/
SELECT department_name ,job_id, salary, ((NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12) as year   --salary�� nvló�����ֱ�~~
FROM employees e join departments d
                on e.department_id = d.department_id
WHERE employee_id = &�����ȣ;


DECLARE
  v_dname employees.last_name%TYPE;
  v_jid employees.job_id%TYPE;
  v_sal employees.salary%TYPE;
  v_year NUMBER(20,2);
BEGIN
    SELECT department_name ,job_id, salary , ((NVL(salary,0)+(NVL(salary,0)*NVL(commission_pct,0)))*12)   --salary�� nvló�����ֱ�~~
    INTO v_dname,v_jid, v_sal, v_year
    FROM employees e join departments d
                on e.department_id = d.department_id
    WHERE e.employee_id = &�����ȣ;
  
  DBMS_OUTPUT.PUT_LINE('�μ��̸� : '|| v_dname);
  DBMS_OUTPUT.PUT_LINE('job_id : '|| v_jid);
  DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
  DBMS_OUTPUT.PUT_LINE('���� �Ѽ��� : ' || v_year);

END;
/


/*
3. �����ȣ�� �Է¹޾� Employees ���̺��� �����ؼ� ����� �Ի�⵵�� 2015�� ����(2015�� ����)�� �Ի��
'New employee', �ƴϸ� 'Career employee'��� ���
*/
SELECT employee_id, hire_date
    FROM employees
    WHERE employee_id = &�����ȣ;

DECLARE
    v_hdate employees.hire_date%type;
    v_msg VARCHAR2(100);

BEGIN

    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF TO_CHAR(v_hdate, 'yyyy') > '2015' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);

END;
/



/*
4. ������ 1�� ~ 9���� ����ϴ� PL/SQL ��� �ۼ� ( Ȧ���� ��� )
*/
BEGIN
    FOR dan IN 1..9 LOOP 
       -- dan�� ������ �� ù ����
      
        CONTINUE WHEN MOD(dan,2) = 0;  
       
        FOR num IN 1..9 LOOP -- ���ϴ� ��: ����, 1~9
            DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num) || ' ');
        END LOOP;
    END LOOP;
END;
/

/*
5. �μ���ȣ �Է��ϸ� �ش� �μ��� �ٹ��ϴ� ��� ����� ���, �̸�, �޿��� ����ϴ� PL/SQL��� �ۼ�(CURSOR ���)
*/
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id=&�μ���ȣ;

DECLARE
    -- 1. Ŀ�� ����
     CURSOR emp_cursor IS
         SELECT employee_id, last_name, salary
         FROM employees
         WHERE department_id=&�μ���ȣ;
         
    -- INTO���� ����� ����
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    LOOP
        -- 3. Ŀ������ ������ ����
        FETCH emp_cursor INTO v_eid, v_ename, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;  --���ο� �������� �������� Ȯ��(���ο� ������ ������ TRUE ��ȯ)
        
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : '); 
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_sal);
    END LOOP;
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
END;
/


/*
6. �������� ���, �޿� ����ġ(����)�� �Է��ϸ� Employees ���̺�
���� ����޿� ������ �� �ֵ��� procedure �ۼ�. ���� ��� 'No search employee!!' ��� �޽��� ���
��, exception �� ���
*/

-- ����) ���� ��� :EXECUTE y_update(0, 10);
-- ����) �ִ� ��� :EXECUTE y_update(100, 10);

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
7. �ֹε�Ϲ�ȣ(0211023234597)�� �Է¹����� �� ���̿� ������ ��� ����ϴ� ���α׷��� �ϳ��� �ۼ��ϼ���.
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
8. �����ȣ �Է¹����� �ش� ��� �ٹ��� �Ⱓ�� �ٹ������ ����ϴ� function �ۼ�.
��, �ٹ��Ⱓ�� �ٹ����, �ٹ��������� �����Ǹ� �ٹ����� ����
ex) 5�� 10������ ��� 5�⸸ ǥ����.
*/
SELECT employee_id
       , hire_date
       , MONTHS_BETWEEN(sysdate, hire_date) as �Ѱ�����
       -- ���� �⵵�ν��� ���� : 1�������� ����
       , CEIL(MONTHS_BETWEEN(sysdate, hire_date)/12) as ����1
FROM employees
WHERE employee_id = &�����ȣ;

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
    -- 2. Ŀ�� ����
    OPEN emp_of_dept_cursor;
        LOOP
            -- 3. Ŀ������ ������ ����
            FETCH emp_of_dept_cursor INTO v_emp_info; --��� ������ ������
            EXIT WHEN emp_of_dept_cursor%NOTFOUND;  --���ο� �������� �������� Ȯ��(���ο� ������ ������ TRUE ��ȯ)
            -- �μ��� ���� ����� �ִ� ���
            
            v_years := CEIL(MONTHS_BETWEEN(sysdate, v_emp_info.hire_date)/12);
            --���
        END LOOP;
        -- LOOP�� �ۿ��� ROWCOUNT �Ӽ� : ���� Ŀ���� ������ �ִ� �� ������ ����
    -- 4. Ŀ�� ����
    CLOSE emp_of_dept_cursor;
 RETURN (v_years); 
END;
/

SELECT get_emp_year(100)
FROM dual;

ROLLBACK;


/*
9. �μ��̸��� �Է��ϸ� �μ��� å����(Manager)�̸��� ����ϴ� Function�� �ۼ� (�������� �̿�)
*/
SELECT e.last_name as mgr_name
FROM employees e
WHERE employee_id = (SELECT d.manager_id
                     FROM departments d
                     WHERE LOWER(d.department_name) = LOWER('&�μ��̸�'));
      
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
10. HR����ڿ��� �����ϴ� PROCEDURE, FUNCTION, PACKAGE, PACKAGE BODY�� �̸��� �ҽ��ڵ带 �Ѳ����� Ȯ���ϴ� SQL������ �ۼ��ϼ���
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
