--2024.11.26
--�����о�� continue, go to �� ����

SET SERVEROUTPUT ON;

--DBMS_OUTPUT.PUT(���ν���)�� PUT_LINE���� ������ ���ι�ġ
BEGIN
    FOR num IN 1 .. 9 LOOP -- ù��° LOOP�� : ���� ����, ������ 2 ~ 9
       FOR dan IN 2 .. 9 LOOP -- �ι�° LOOP�� : ���ϴ� ���� ����, ������ 1 ~ 9
           DBMS_OUTPUT.PUT(dan|| ' * '|| num || ' = ' || (dan * num) || ' ');
       END LOOP;
           DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
    -- ���ϴ� ���� ����
END;
/

-- �������

/*
9. ������ 1~9�ܱ��� ��µǵ��� �Ͻÿ�.
   (��, Ȧ���� ���)
   MOD(num,2) = 0 ���
*/

-- ������
--1. if then ��� (�����ڵ� ������ ������ ������)
BEGIN
    FOR dan IN 1..9 LOOP -- ��: ����, 1~9
       -- dan�� ������ �� ù ����
       IF MOD(dan,2) <> 0 THEN -- Ȧ������ Ȯ��
          FOR num IN 1..9 LOOP -- ���ϴ� ��: ����, 1~9
             DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num) || ' ');
          END LOOP;
       END IF;
    END LOOP;
END;
/
--2. continue ���
BEGIN
    FOR dan IN 1..9 LOOP -- ��: ����, 1~9
       -- dan�� ������ �� ù ����
       /*
       IF MOD(dan,2) = 0 THEN --¦������ ���
           CONTINUE; -- �������� ���� ���·� ���� �������� �Ѿ(���� ���ǿ��� ������������.PASS��)
       END IF;
       */
        CONTINUE WHEN MOD(dan,2) = 0;  --IF�� �Բ� ���� �ͺ��ٴ� ����
       
        FOR num IN 1..9 LOOP -- ���ϴ� ��: ����, 1~9
            DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num) || ' ');
        END LOOP;
    END LOOP;
END;
/

-- ���� NODE,VUE ������(24.11.27 ��) / (����(24.11.27 ��) ���ƴ϶� ���� �ϸ� ������)
-- ��ȣ:�߾����� / TEXT:���� / ����:������ (���������� ���� ���)
-- ������Ʈ ���� ������ ���޹޴°� �����ϱ�
-- CS (computer science) ���� : ���α׷��־��, �˰���/�ڷᱸ��, �����ͺ��̽�, ���������(��Ʈ��ũ),�ü��, ��ǻ�ͱ��� .. (��ü 14����)
    --> IT�� �⺻ ���̽��� // ***���������(��Ʈ��ũ), **�����ͺ��̽�, *�ü��(�������迭), ��ǻ�ͱ��� ��� 4���� �ؾ���
    --> �Ի����ڸ��� ���м� �������̴°� ��� �� �Ǿ� �о��.
    --> �¶��κ��� �������ΰ��� �о�� ���� �ٰ��´� ������ �� ���. (�����ͺ��̽� ����)
    
    
-- ������ ȭ����(24.12.03)������Ʈ: MES(��������ý���:�������嵹���½ý���->�湮�غ��°͵� ����/order ���� ���� process) �� �������� 12~15 / �� 25�� ��
   --> �ڷ�, �ǵ���� ������ �䱸�������Ǽ�,(ȭ��,DB)����,����,�׽�Ʈ,�������� ���� ������ �Ѵ�.(������ ��ȹ������, ���� �������־)
   --> �⺻ UI�� ȸ�� ���α׷��̶� �ʹ� ȭ���ϸ� �����. �����: �����ε��� �̿��ϱ� ���� ������� ������ ��.
   --> ���������� �ʿ��� ������ �� ����ִ� ���� ������.(��ũ��, �������̵� �Ⱦ���)
   --> ������ ������ ȭ���� Ȯ��
-- ���� ������Ʈ: SCM�� ������ ERP���


-- PPT ) 07_���SQL��SQLƩ��/PPT/2017_06
-- ���� ������ ����
-- ������ [CONSTANT] ������Ÿ�� [NOT NULL] [:= | default expr]
-- �ʵ��            ������Ÿ�� [NOT NULL] [:= | default expr]
   -->�̸�, ������Ÿ��, (not null �������ǰ� �ʱⰪ�� ���û���)
   
-- ���� ������ ���� : ���� ���� ���� �� �ִ� ������ Ÿ��
-- RECORD : ���ο� �ʵ带 ������ ������ ����, SELECT�� ó�� �����͸� ��ȸ�ϴ� ��� ���� ����.
-- 1) ����
DECLARE
    -- 1. ���ڵ� Ÿ�� ���� (���� ������ ���������� �ʾƼ� �������� ��)
    TYPE ���ڵ�Ÿ�Ը� IS RECORD
           ( �ʵ�� ������Ÿ��,
             �ʵ�� ������Ÿ�� := �ʱⰪ,
             �ʵ�� ������Ÿ�� NOU NULL := �ʱⰪ );
             
    -- 2. ���� ����
    ������ ���ڵ�Ÿ�Ը�;
BEGIN
    -- 3. ���
    ������.�ʵ�� := ���氪;
    DBMS_OUTPUT.PUT_LINE(������.�ʵ��); -- �������� ��ºҰ� / ���� �ʵ�� �����ؼ� ����ؾ���
END;
/

-- 2)����
DECLARE
    -- 1) Ÿ�� ���� (_record_type ����ϴ°� ����) => INTO ������ ����ϴ� ��� SELECT���� �÷��� ������ ���·� ����
    TYPE emp_record_type IS RECORD
             ( empno NUMBER(6,0),
               ename employees.last_name%TYPE NOT NULL := 'Hong',
               sal employees.salary%TYPE := 0);
    --2)���� ����
    v_emp_info emp_record_type;
    v_emp_rec emp_record_type;
BEGIN
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
    
    v_emp_rec.empno := &�����ȣ;
    
    SELECT employee_id, last_name, salary
    INTO v_emp_info          -- INTO���� ���� RECORD TYPE�� �ݵ�� �ϳ�.(�� �࿡ ����)/ ������ �ϳ����� ���ο� �����Ǵ� �ʵ�����(�����߿�)
    FROM employees
    WHERE employee_id = v_emp_rec.empno;
    
    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);

END;
/

--%ROWTYPE : ���̺� Ȥ�� ���� �� ���� RECORD TYPE���� ��ȯ => Ÿ�� ���� ���� ���� �������� �ٷ� ���(�ʵ�� �÷����� �״�� ����)
DECLARE
    v_emp_rec employees%ROWTYPE; 
BEGIN
    SELECT *    -- �ݵ�� * �ٿ��� ��(�����÷� �� �� ����)
    INTO v_emp_rec
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.last_name);
    DBMS_OUTPUT.PUT_LINE(v_emp_rec.salary);
    
END;
/


-- TABLE : ������ ������ Ÿ���� ���� ������ ����. �ַ�, ���ڵ�Ÿ�԰� �Բ� Ư�� ���̺��� ��� �����͸� ������ ���� �� ���
-- 1) ����
DECLARE
    -- 1. Ÿ�� ����
    TYPE ���̺�Ÿ�Ը� IS TABLE OF ������Ÿ��
        INDEX BY BINARY_INTEGER;
    -- 2. ���� ����
    ������ ���̺�Ÿ�Ը�;
BEGIN
    -- 3. ���
    ������(�ε���) := �ʱⰪ;
    DBMS_OUTPUT.PUT_LINE(������(�ε���));
END;
/

-- 2) ����
DECLARE
    -- 1. ����
    TYPE num_table_type IS TABLE OF NUMBER
           INDEX BY PLS_INTEGER;
    -- 2. ���� ����
    v_num_info num_table_type;
BEGIN
    v_num_info(-123456789) := 1000;
    v_num_info(1111111111) := 1234;
    DBMS_OUTPUT.PUT_LINE(v_num_info(-123456789));
    DBMS_OUTPUT.PUT_LINE(v_num_info(1111111111));
    -- DBMS_OUTPUT.PUT_LINE(v_num_info(-1111111111));  --���� �ε��� ���ٽ� "no data found" ����
END;
/

-- ���̺� Ÿ���� �޼��� Ȱ��
DECLARE
    -- 1. ���̺� Ÿ�� ����
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
    
    -- 2. ���� ����
    v_num_info num_table_type;
    v_idx NUMBER;
BEGIN
    v_num_info(-23)  := 1;
    v_num_info(-5)   := 2;
    v_num_info(11)   := 3;
    v_num_info(1121) := 4;
    
    DBMS_OUTPUT.PUT_LINE('���� ���� : ' || v_num_info.COUNT);
    
    -- FOR LOOP�� : ���� ���� ������ �˻��ؼ� ����
    FOR idx IN v_num_info.FIRST .. v_num_info.LAST LOOP
        IF v_num_info.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(idx || ':' || v_num_info(idx));
        END IF;
    END LOOP;
    
    -- �⺻ LOOP�� : ���� ���� �˻�
    v_idx := v_num_info.FIRST;
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_idx || ' : ' || v_num_info(v_idx));
        
        EXIT WHEN v_num_info.LAST <= v_idx;
        v_idx := v_num_info.NEXT(v_idx);
    END LOOP;

END;
/

-- TABLE + RECORD : ª�� �������� ��ü������ �������� (���� ��ü���������� �����Ŀ�� �ʿ�)
-- EMPLOYEES ���̺� Ȯ�θ��� �ϻ� (100~206)
DECLARE
    -- 1) Ÿ�� ����
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2) ������ ����
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
BEGIN
    -- ���̺� ��ȸ
    FOR eid IN 100 .. 104 LOOP
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid ;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;
    
    -- ���̺� Ÿ���� ������ ��ȸ
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- �ش� �ε����� �����Ͱ� �ִ� ���
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;    
    END LOOP;

END;
/

--employee_id�� �ּҰ��� �ִ밪 �̾Ƴ��� �� ��������

DECLARE
    -- 1) Ÿ�� ����
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
        
    -- 2) ������ ����
    v_emp_list emp_table_type;
    v_emp_rec employees%ROWTYPE;
    v_count NUMBER;
    
    -- �߰� ����
    v_min employees.employee_id%TYPE;
    v_max v_min%TYPE;
BEGIN
    -- employee_id �ּҰ�, �ִ밪
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    -- ���̺� ��ȸ(TABLE TYPE�� ���� ������ ���� ���� �����ͺ��� �� ���� ����Ʈ�� �����ؾ���/ �������� �ʴ� �ڵ�)
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_count
        FROM employees
        WHERE employee_id = eid;
        -- �ش� �����ȣ ���� �����Ͱ� ���� ��� ���� ��������
        CONTINUE WHEN v_count = 0;
        
        SELECT *
        INTO v_emp_rec
        FROM employees
        WHERE employee_id = eid ;
        
        v_emp_list(eid) := v_emp_rec;
    END LOOP;
    
    -- ���̺� Ÿ���� ������ ��ȸ
    FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(idx) THEN
            -- �ش� �ε����� �����Ͱ� �ִ� ���
            DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
            DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
            DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
        END IF;    
    END LOOP;

END;
/

-- COUNT �׷��Լ�(�÷��� ���� �� �� ����)
SELECT COUNT(*), COUNT(commission_pct)
FROM employees;



-- ����� Ŀ�� : ���� �� SELECT���� �����ϱ� ���� PL/SQL ����

--��ü SELECT�� �����Ŀ���� �޸𸮿� ������ �÷����� ���¿� ����
--Ŀ���� �� �������� ���� : 'Ȱ�� ����(Active set)'
--�����ʹ� Ȱ������ ������ �ٷ� �տ� ��ġ��. �����͸� �Űܼ� �����͸� �̾Ƴ�.
--�����ʹ� ������ �����θ� ��. �����İ� �����Ϳ��� �ö� �� ����.
SELECT *
FROM employees;

-- 1) ����
DECLARE
    -- 1. Ŀ�� ����
    CURSOR Ŀ���� IS
        SELECT��(SQL�� SELECT��, INTO�� ���Ұ�);
        
BEGIN
    -- 2. Ŀ�� ����
    -- 2-1) Ŀ���� ���� �����ؼ� Ȱ������(���)�� �ĺ� / �޸𸮿� �ø�
    -- 2-2) �����͸� ���� ���� ��ġ
    OPEN Ŀ����;
    
    -- 3. ������ ����
    -- 3-1) �����͸� �Ʒ��� �̵�
    -- 3-2) ���� ����Ű�� �����͸� ����
    FETCH Ŀ���� INTO ����;
    
    -- 4. Ŀ�� ���� : Ȱ������(���)�� ����
    CLOSE Ŀ����;
    
END;
/

-- 2) ����
DECLARE
    -- 1. Ŀ�� ����
     CURSOR emp_cursor IS
         SELECT employee_id, last_name, hire_date
         FROM employees;
         
    -- INTO���� ����� ������ �ʿ� => Ŀ���� SELECT�� �÷� ������ŭ
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    
    -- 3. Ŀ������ ������ ����
    FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
    
    -- 3.5 �����͸� ������� ���� (���� ������ ����)
    DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
    
END;
/


-- ����� Ŀ�� �Ӽ� �ǽ�
--%NOTFOUND �ǽ�
DECLARE
    -- 1. Ŀ�� ����
     CURSOR emp_cursor IS
         SELECT employee_id, last_name, hire_date
         FROM employees;
         
    -- INTO���� ����� ������ �ʿ� => Ŀ���� SELECT�� �÷� ������ŭ
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    LOOP
        -- 3. Ŀ������ ������ ����
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate; --��� ������ ������
        EXIT WHEN emp_cursor%NOTFOUND;  --���ο� �������� �������� Ȯ��(���ο� ������ ������ TRUE ��ȯ)
        
        -- 3.5 �����͸� ������� ���� (���� ������ ����)
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : '); -- FETCH�� �����ؼ� ������ ���
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    END LOOP;
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
END;
/

--%ISOPEN �ǽ�
DECLARE
    -- 1. Ŀ�� ����
     CURSOR emp_cursor IS
         SELECT employee_id, last_name, hire_date
         FROM employees;
         
    -- INTO���� ����� ������ �ʿ� => Ŀ���� SELECT�� �÷� ������ŭ
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_cursor;
    
    LOOP
        -- 3. Ŀ������ ������ ����
        FETCH emp_cursor INTO v_eid, v_ename, v_hdate; --��� ������ ������
        EXIT WHEN emp_cursor%NOTFOUND;  --���ο� �������� �������� Ȯ��(���ο� ������ ������ TRUE ��ȯ)
        
        -- 3.5 �����͸� ������� ���� (���� ������ ����)
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' : '); -- FETCH�� �����ؼ� ������ ���
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
    END LOOP;
    
    -- ERROR 1 : Ŀ���� ����� ���¿��� �ٽ� ���� => "PL/SQL: cursor already open"
    -- OPEN emp_cursor;  
    IF NOT emp_cursor%ISOPEN THEN -- Ŀ�� ���� ���� Ȯ��
       OPEN emp_cursor;
    END IF;
    
    -- 4. Ŀ�� ����
    CLOSE emp_cursor;
    -- ERROR 2 : Ŀ���� ����� ���¿��� �Ӽ� ��� => ORA-01001: invalid cursor
    -- DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
END;
/


-- ���ǻ��� : ����� Ŀ���� ����� ���� ��� ������ �߻����� ����.
-- Ư�� �μ��� ���� ����� �����ȣ�� �̸�, ������ ���
-- ����� Ŀ�� => SQL�� SELECT���� �䱸
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = &�μ���ȣ;
-- �μ���ȣ 0  => ������ ����
-- �μ���ȣ 10 => ������ �� ��
-- �μ���ȣ 50 => ������ ���� ��


DECLARE
    -- 1. Ŀ�� ����
    CURSOR emp_of_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = & �μ���ȣ;
BEGIN
    -- 2. Ŀ�� ����
    OPEN;
    
    LOOP
        -- 3. ������ ����
        FETCH INTO ;
        EXIT WHEN ;
    
    -- 4. ������ ���� ���� �� ����
    
    END LOOP;
    -- 5. Ŀ�� ����
    CLOSE;

END;
/
-->  Ŀ���� �ϴ� �̷��� ����� ��� ���� ����� Ŀ���� ������ ��ġ�� ��ġ���Ѿ� ��

DECLARE
    -- 1. Ŀ�� ����
    CURSOR  emp_of_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = & �μ���ȣ;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_job employees.job_id%TYPE;
BEGIN
    -- 2. Ŀ�� ����
    OPEN emp_of_dept_cursor;
    
    LOOP
        -- 3. ������ ����
        FETCH emp_of_dept_cursor INTO v_eid, v_ename, v_job;
        EXIT WHEN emp_of_dept_cursor%NOTFOUND;  -- FETCH ���� EXIT WHEN���� ����? ������ ������ �ߺ����� �ʵ��� ����
    
        -- 4. ������ ���� ���� �� ����
        DBMS_OUTPUT.PUT(emp_of_dept_cursor%ROWCOUNT || ' : '); -- LOOP�� ���� ������, ���� ��ȯ�� ������ ����
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_job);
    END LOOP;
    
    -- LOOP�� �ٱ� ������, Ŀ���� �� ������ ����
    DBMS_OUTPUT.PUT_LINE(emp_of_dept_cursor%ROWCOUNT);
    IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �Ҽӻ���� �����ϴ�.');
    END IF;
    -- 5. Ŀ�� ����
    CLOSE emp_of_dept_cursor;

END;
/

--����Ǯ�� (����� Ŀ�� �䱸)
/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬����  => ����� Ŀ�� : ������ SELECT��
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.

�Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�  --2015�� ����
�Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է�       --2015�� ����
=>���ǹ�
*/
-- ���� Ǯ��
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
            IF TO_CHAR(v_hdate,'yyyy') <= '2015' THEN
                INSERT INTO test01 (empid, ename, hiredate)
                VALUES (v_eid, v_ename, v_hdate);
            ELSE
                INSERT INTO test02 (empid, ename, hiredate)
                VALUES (v_eid, v_ename, v_hdate);
            END IF;
    END LOOP;
    
    CLOSE emp_cursor;
END;
/
select *
from test01;

select *
from test02;

-- ������ Ǯ��
-- SELECT�� : ��� ���̺��� �����ȣ, ����̸�, �Ի�⵵ ��ȸ
SELECT employee_id, last_name, hire_date
FROM employees;

-- ���ǹ�
IF �Ի�⵵�� 2005��(����) ���� THEN
    test01 ���̺� �Է�
ELSE
    test02 ���̺� �Է�
END IF;

-- PL/SQL ���
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
        
    TYPE emp_record_type IS RECORD
        ( eid employees.employee_id%TYPE,
         ename employees.last_name%TYPE,
         hdate employees.hire_date%TYPE );
    v_emp_info emp_record_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
    
        -- Ŀ������ ��ȯ�Ǵ� �����Ͱ� �ִ� ���
        --IF v_emp_info.hdate <= TO_DATE('20251231', 'yyyyMMdd') THEN 
        IF TO_CHAR(v_emp_info.hdate, 'yyyy') <= '2015' THEN
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

select *
from test02;

--TO_CHAR�� ���������� �ǵ帮�� �ʰ� ��µǴ� ������ �ٲ�.
SELECT sysdate, TO_CHAR(sysdate, 'yyyy"��"MM"��"dd"��"')
FROM dual;

/*
2.
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
*/
-- SELECT ��: �μ���ȣ -> employees(����̸�, �Ի�����), departments(�μ���)
SELECT last_name, hire_date, department_name
FROM employees e JOIN departments d
                ON (e.department_id = d.department_id)
WHERE e.department_id = &�μ���ȣ;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, hire_date, department_name
        FROM employees e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;
        
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dept_name departments.department_name%TYPE;
BEGIN
    OPEN emp_in_dept_cursor;
        LOOP
            FETCH emp_in_dept_cursor INTO v_ename, v_hdate, v_dept_name;
            EXIT WHEN emp_in_dept_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE( v_ename || ', ' || v_hdate || ', ' || v_dept_name );
        END LOOP;
    CLOSE emp_in_dept_cursor;

END;
/


/*
3.
�μ���ȣ�� �Է�(&���)�� ��� 
����̸�, �޿�, ����->(�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
*/

-- 3-1 : ������ ���� ���
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id = &�μ���ȣ;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE; --SELECT���� �ִ°Ÿ� �����ͼ� Ÿ�� ����
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
        WHERE department_id = &�μ���ȣ;
        
        
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal , (salary*12+(salary*nvl(commission_pct,0)*12)) as year
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE; --SELECT���� �ִ°Ÿ� �����ͼ� Ÿ�� ����
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

--�ǽ����� ���ַ� ��� ���鼭 ���� Ǯ���!!
