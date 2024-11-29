-- DBMS_OUTPUT.PUT_LINE ���ν��� ������ؼ� / PPT02-18p����
-- console.log PL/SQL �����̶� �����ϻ�

SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!!');
END;
/


DECLARE
-- ����� : ���� �� ����
BEGIN
-- ����� : ���� ���μ��� ����
EXCEPTION
-- ����ó�� : ���� �߻��� ó���ϴ� �۾�
END;
/


DECLARE
    v_str VARCHAR2(100); --�⺻
    v_num CONSTANT NUMBER(2,0) := 10; --���
    v_count NUMBER(2,0) NOT NULL DEFAULT 5; -- NOT NULL ������ ����
    v_sum NUMBER(3,0) := v_num + v_count; -- ǥ����(����)�� ������� �ʱ�ȭ
BEGIN
     DBMS_OUTPUT.PUT_LINE('v_str :' || v_str);
     DBMS_OUTPUT.PUT_LINE('v_num :' || v_num);
     -- v_num := 100; // expression 'V_NUM' cannot be used as an assignment target
     DBMS_OUTPUT.PUT_LINE('v_count :' || v_count);
     DBMS_OUTPUT.PUT_LINE('v_sum :'|| v_sum);
END;
/

-- %TYPE �Ӽ�
DECLARE
    v_eid employees.employee_id%TYPE; --NUMBER(6,0)
    v_ename employees.last_name%TYPE; -- VARCHAR2(25 BYTE) <=> VARCHAR2(25 char) // ���� �����ϴ� ���̺� �÷��� ������ Ÿ�� ���� 
    v_new v_ename%TYPE; -- VARCHAR2(25 BYTE)// �̹� ����� ������ ������ Ÿ���� �����ϴ� �͵� ����
BEGIN
    SELECT employee_id, last_name
    INTO v_eid, v_ename
    FROM employees
    WHERE employee_id=100;
    -- v_eid := 'eid : 100'; // character to number conversion error
    v_new := v_eid || ' ' || v_ename;
    DBMS_OUTPUT.PUT_LINE(v_new);
END;
/

--PL/SQL���� �ܵ� ��밡���� SQL�Լ� => ������ �Լ��� (DECODE, �׷��Լ� ����)
DECLARE
    v_date DATE;
BEGIN
    v_date := sysdate+7;
    DBMS_OUTPUT.PUT_LINE(v_date);
END;
/

-- PL/SQL�� SELECT��
-- 1) INTO�� : ��ȸ�� �÷��� ���� ��� ���� ���� => �ݵ�� �����ʹ� �ϳ��� �ุ ��ȯ
DECLARE
   v_name employees.last_name%TYPE;
BEGIN
   SELECT last_name
   INTO v_name  -- ������ PLS-00428: an INTO clause is expected in this SELECT statement (PLS�� ��������)
   FROM employees
   WHERE employee_id = 100;
   
   DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 2) ��� ���� ������ �ϳ��� ��
DECLARE
   v_name employees.last_name%TYPE;
BEGIN
   SELECT last_name
   INTO v_name
   FROM employees
   WHERE department_id = &�μ���ȣ;
   -- �μ���ȣ 0 : "no data found"
   -- �μ���ȣ 50 : "exact fetch returns more than requested number of rows"
   -- �μ���ȣ 10 : �������
   DBMS_OUTPUT.PUT_LINE(v_name);
END;
/

-- 3) SELECT���� �÷� ���� == INTO���� ���� ����
DECLARE
  v_eid employees.employee_id%TYPE;
  v_ename employees.last_name%TYPE;
BEGIN
  SELECT employee_id, last_name
  INTO v_eid, v_ename
  -- SELECT > INTO : not enough values 
  -- SELECT < INTO : too many values
  FROM employees
  WHERE employee_id=100;
  DBMS_OUTPUT.PUT_LINE(v_eid);
  DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/


--����Ǯ���
/*
1.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�����ȣ, ����̸�, �μ��̸�  
�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.

=> SELECT��
-- �Է� : �����ȣ                   /employees ���̺�
-- ��� : �����ȣ, ����̸�, �μ��̸�  /employees���̺�(�����ȣ, ����̸�) + departments ���̺�(�μ��̸�)
                                     => JOIN | ��������

-- 1)�ʿ��� SQL�� Ȯ��                                
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
      JOIN departments d
      ON (e.department_id = d.department_id)
WHERE e.employee_id = &�����ȣ;
-- 2)PL/SQL ��� �ۼ�

DECLARE
   v_eid employees.employee_id%TYPE;
   v_ename employees.first_name%TYPE;
   v_deptname departments.department_name%TYPE;
BEGIN
   SELECT e.employee_id, e.last_name, d.department_name
   INTO v_eid, v_ename, v_deptname
   FROM employees e
      JOIN departments d
      ON (e.department_id = d.department_id)
   WHERE e.employee_id = &�����ȣ;
   
   DBMS_OUTPUT.PUT_LINE(v_eid);
   DBMS_OUTPUT.PUT_LINE(v_ename);
   DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/

-- �������� ���
DECLARE
   v_eid employees.employee_id%TYPE;
   v_ename employees.first_name%TYPE;
   v_deptname departments.department_name%TYPE;
BEGIN
   SELECT e.employee_id, 
          e.last_name, 
          (SELECT d.department_name FROM departments d WHERE d.department_id =  e.department_id)
   INTO v_eid, 
        v_ename, 
        v_deptname
   FROM employees e
   WHERE e.employee_id = &�����ȣ;
   
   DBMS_OUTPUT.PUT_LINE(v_eid);
   DBMS_OUTPUT.PUT_LINE(v_ename);
   DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/
*/

-- �߰�����: SELEC �� 2���� Ǯ��
DECLARE
   v_eid employees.employee_id%TYPE;
   v_ename employees.first_name%TYPE;
   v_dept_id departments.department_id%TYPE;
   v_deptname departments.department_name%TYPE;
BEGIN
   SELECT e.employee_id,  e.last_name, e.department_id
   INTO v_eid, v_ename,  v_dept_id
   FROM employees e
   WHERE e.employee_id = &�����ȣ;
   
   SELECT department_name
   INTO v_deptname
   FROM departments d
   WHERE department_id = v_dept_id;
   
   DBMS_OUTPUT.PUT_LINE(v_eid);
   DBMS_OUTPUT.PUT_LINE(v_ename);
   DBMS_OUTPUT.PUT_LINE(v_deptname);
END;
/

--����Ǭ��
DECLARE
  v_eid employees.employee_id%TYPE;
  v_ename employees.first_name%TYPE;
  v_dname departments.department_name%TYPE;
BEGIN
  SELECT a.employee_id, a.first_name, b.department_name
  INTO v_eid, v_ename , v_dname
  FROM employees a join departments b
  ON a.department_id = b.department_id
  WHERE a.employee_id = &�����ȣ;
  DBMS_OUTPUT.PUT_LINE(v_eid);
  DBMS_OUTPUT.PUT_LINE(v_ename);
  DBMS_OUTPUT.PUT_LINE(v_dname);
END;
/

/*
2.
�����ȣ�� �Է�(ġȯ�������&)�� ��� 
����̸�, 
�޿�, 
����->(�޿�*12+(nvl(�޿�,0)*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.

=> SELECT��
-- �Է� : �����ȣ     => emlpoyees ���̺�
-- ��� : ����̸�,�޿�,���� / ���� = (�޿�*12+(nvl(�޿�,0)*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))

-- 1) �ʿ��� SQL�� Ȯ��
SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
FROM employees
WHERE employee_id = &�����ȣ;


-- 2) PL/SQL ��� �ۼ�
DECLARE
  v_ename employees.last_name%TYPE;
  v_sal employees.salary%TYPE;
  v_year NUMBER(20);
BEGIN
  SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
  INTO v_ename, v_sal, v_year
  FROM employees
  WHERE employee_id = &�����ȣ;
  
  DBMS_OUTPUT.PUT_LINE(v_ename);
  DBMS_OUTPUT.PUT_LINE(v_sal);
  DBMS_OUTPUT.PUT_LINE(v_year);

END;
/
*/

--����Ǭ��

select first_name,salary,
      (select salary*12+(nvl(salary,0)*nvl(COMMISSION_PCT,0)*12)
      from employees
      where employee_id = e.employee_id) ann_sal
from employees e
where employee_id=&�����ȣ;

from employees
on  

DECLARE
  v_ename employees.first_name%TYPE;
  v_esal employees.salary%TYPE;
  v_annsal employees.salary%TYPE; --Ÿ�Լ��� �߸��� sal�� ���ѰŶ� ���� �����ؾ���
BEGIN
  select first_name,salary,
      (select salary*12+(nvl(salary,0)*nvl(COMMISSION_PCT,0)*12)
      from employees
      where employee_id = e.employee_id) ann_sal
  into v_ename,v_esal,v_annsal
  from employees e
  where employee_id=&�����ȣ;
  DBMS_OUTPUT.PUT_LINE(v_ename);
  DBMS_OUTPUT.PUT_LINE(v_esal);
  DBMS_OUTPUT.PUT_LINE(v_annsal);
END;
/

-- �߰����� : SELECT ������ ���� ��� �и�

DECLARE
  v_ename employees.last_name%TYPE;
  v_sal employees.salary%TYPE;
  v_year NUMBER(20);
BEGIN
  SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
  INTO v_ename, v_sal, v_year
  FROM employees
  WHERE employee_id = &�����ȣ;
  
  v_year := (v_sal*12+(nvl(v_sal,0)*nvl(v_comm,0)*12));
  
  DBMS_OUTPUT.PUT_LINE(v_ename);
  DBMS_OUTPUT.PUT_LINE(v_sal);
  DBMS_OUTPUT.PUT_LINE(v_year);

END;
/

-- PL/SQL�ȿ��� DML
DECLARE
  v_deptno departments.department_id%TYPE;
  v_comm employees.commission_pct%TYPE := .1;
BEGIN
  SELECT department_id
  INTO v_deptno
  FROM employees
  WHERE employee_id = &�����ȣ;
  
  INSERT INTO employees
              (employee_id, last_name, email, hire_date, job_id, department_id)
  VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
  
  UPDATE employees
  SET salary = (NVL(salary,0)+10000) * v_comm
  WHERE employee_id = 1000;
  
  COMMIT; -- ��� =/= Ʈ������, �ݵ�� �ʿ��ϴٸ� ��������� COMMIT/ROLLBACK �ۼ�.
END;
/


SELECT *
FROM employees
WHERE employee_id IN (200,1000);

ROLLBACK;


-- DELETE
BEGIN
  DELETE FROM employees
  WHERE employee_id = 1000;
END;

COMMIT;
/

--�����Ͽ� �Ͻ��� Ŀ�� �ǽ��� ����~~

--2024.11.25

