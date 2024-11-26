--2024.11.25

--SQL%ROWCOUNT �ǽ�

-- DBMS_OUTPUT.PUT_LINE ���ν����� �����ϱ� ���� ���� ����
SET SERVEROUTPUT ON;

-- �Ͻ��� Ŀ�� : SQL���� ���� ����� ���� �޸� ����
--> �� ���� : DML�� ������ Ȯ��, SQL%ROWCOUNT (�Ͻ����� �̸���� SQL ����)
--> ���ǻ��� :  ������ ����� SQL���� ����� Ȯ�� ����

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '���� �����Ǿ����ϴ�.');
END;
/

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- ���ǹ�
-- 1) �⺻ IF �� : Ư�� ������ TRUE�� ��츸 üũ
-- 2) IF ~ ELSE �� : Ư�� ������ �������� TRUE/FALSE ��� Ȯ�� (�ַ� ��)
-- 3) IF ~ ELSIF ~ ELSE �� : ���� ������ ������� �� ����� ���� ó��(ELSE������ �������ϰ� ���� ��)

-- ���ǹ� �ǽ�

-- 1) �⺻ IF �� 

BEGIN 
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�');
    END IF;
END;
/

rollback;

--> employees,departments �� ���� ���̺� ��ο��� manager_id ������ ���� �ȵǴ� Ȯ�� �� �����غ���
--���� ���� üũ��
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

-- 2) IF ~ ELSE ��

BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- ���ǽ��� TRUE�� ���
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�.');
    ELSE
        -- ���� ������ ��� ���ǽ��� FALSE�� ���
        DBMS_OUTPUT.PUT_LINE('�������� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���');
    END IF;
END;
/

---------------------------------------------------------------------------------------------------------

-- 3) IF ~ ELSIF ~ ELSE ��

DECLARE
    v_score NUMBER(2,0) := &����;
    v_grade CHAR(1) := 'F';  -- �ʱⰪ �̷��� ���ý� ELSE ���� �ʿ���� ��쵵 ����.
    
BEGIN                         -- v_score�� ������ �ִ밪�� �ּҰ� ǥ�� : �ּҰ� < v_score < �ִ밪
    IF v_score >= 90 THEN     -- 90 <= v_score < 100
       v_grade := 'A';
    ELSIF v_score >= 80 THEN  -- 80 <= v_score < 90
          v_grade := 'B';
    ELSIF v_score >= 70 THEN  -- 70 <= v_score < 80
          v_grade := 'C';
    ELSIF v_score >= 60 THEN  -- 60 <= v_score 70
          v_grade := 'D';
    ELSE  -- ==>�⺻������ ��ü ����  -- v_score < 60
       v_grade := 'F';       
   
    END IF;
    DBMS_OUTPUT.PUT_LINE('��� : ' || v_grade);
END;
/

---------------------------------------------------------------------------------------------------------
-- ����Ǯ���

-- �����ȣ�� �Է¹޾� �ش� ����� ����(JOB_ID)�� ����('SA'�� ���Ե� ���)�� ��츦 Ȯ�����ּ���.
-- ��¹��� : �ش� ����� �������� �����о� �Դϴ�.

/*
1. �����ȣ�� �Է¹޾�
2. �ش����� ������ ������ ��� Ȯ�� => ���ǹ�
2-1) �Է� : �����ȣ -> ���� �ʿ��� ���� : ���� ,  SELECT���� �ʿ��ϴ�
SELECT ����
FROM employees
WHERE �����ȣ = �Է¹��� �����ȣ;
2-2)
IF ������ ������ ��� => UPPER(����) LIKE '%SA%' THEN
   ��� : '�ش� ����� �������� �����о� �Դϴ�.'
END IF;

*/

--SELECT��
SELECT job_id
FROM employees
WHERE employee_id = &�����ȣ;

DECLARE 
    v_job employees.job_id%TYPE;
    
BEGIN
    SELECT job_id
    INTO v_job
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF UPPER(v_job) LIKE '%SA%' THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �����о� �Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� ' || v_job || ' �Դϴ�.');
    END IF;
END;
/

-- ���� Ǯ���
/*
3.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2025�� ����(2025�� ����)�̸� 'New employee' ���
      2025�� �����̸� 'Career employee' ���
��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
*/

/*
1. �����ȣ�� �Է¹޾�
2. �Ի����� 2025�� ����(2025�� ����) -> 'New employee'
          2025�� ����              -> 'Career employee'
*/

/*
-- SELECT��
SELECT hire_date
FROM employees
WHERE employee_id = &�����ȣ;

-- ���ǹ�
IF �Ի��� >= 2025�� THEN
   ��� : 'New employee'

ELSE
   ��� : 'Career employee'
END IF;
/
*/
-- PL/SQL 100��, 149�� Ȯ���غ���



DECLARE
    v_hdate employees.hire_date%type;
    v_msg VARCHAR2(100);

BEGIN
    -- 1)
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
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

�����ȣ�� �Է�(ġȯ�������&)�� ���
����� �� 2025�� ����(2025�� ����)�� �Ի��� ����� �����ȣ, 
����̸�, �Ի����� test01 ���̺� �Է��ϰ�, 2025�� ������ 
�Ի��� ����� �����ȣ,����̸�,�Ի����� test02 ���̺� �Է��Ͻÿ�.
*/

/*
1. �����ȣ�� �Է¹޾�
2. �Ի����� 2025�� ����(2025�� ����) -> ����� �����ȣ,����̸�,�Ի����� test01 ���̺� �Է�
          2025�� ����              -> ����� �����ȣ,����̸�,�Ի����� test02 ���̺� �Է�
*/
-- SELECT��
SELECT employee_id, last_name, hire_date
FROM employees
WHERE employee_id = &�����ȣ;

-- ���ǹ�
IF �Ի��� >=2025�� THEN
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
    WHERE employee_id = &�����ȣ;
    
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
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�.
*/

/*
1. �����ȣ �Է� -> ����̸�, �޿�, �λ�� �޿�
-1) SELECT�� : �����ȣ -> ����̸�, �޿�
-2) �λ�� �޿�?
    �޿���  5000�����̸� 20% �λ�� �޿�
    �޿��� 10000�����̸� 15% �λ�� �޿�
    �޿��� 15000�����̸� 10% �λ�� �޿�
    �޿��� 15001�̻��̸� �޿� �λ����
*/

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_new_sal v_sal%TYPE;
    v_raise NUMBER(5,2);

BEGIN
    -- 1) SELECT��
    SELECT last_name, salary
    into v_ename, v_sal
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- 1) ���ǹ�
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
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_sal || ', ' || v_new_sal);
END;
/
--> �ٽ� Ȯ���غ��� (�������°� Ȯ�οϷ�)

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- LOOP��
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE('Hello!!!');
    END LOOP;
END;
/

-- �⺻ LOOP�� : ���Ǿ��� ���� LOOP���� �ǹ� => �ݵ�� EXIT���� �����϶�� ����
-- 1) ����
BEGIN
    LOOP
        --�ݺ��ϰ��� �ϴ� �ڵ�
        EXIT WHEN --���������� �ǹ�
    END LOOP;
END;
/
-- 2) ����
-- 1�� ���� �� STOP
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello!!!!');
        EXIT;  --���� �ҹ��ϰ� STOP��
    END LOOP;
END;
/

-- 5�� ���� �� STOP
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello!!!!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1���� 10������ ������ ���� ���ϱ�
/*
1) 1���� 10���� ����
2) �� �������� ����
*/

-- 1) �������� ���ϱ�
DECLARE
    v_num NUMBER(2,0) := 1; -- ���� : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- ����
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE (v_num);  -- ���⼭ ������ ����
        v_sum := v_sum + v_num;        -- �� ������ ���տ� ��� ���ϱ�
        
        v_num := v_num + 1; 
        EXIT WHEN v_num > 10;  -- exit when ���� exit�� ���� count�� �ٿ�����~ (��������)
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('���� :' || v_sum);
END;
/

--5����

/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    

*/

/*
5�� ī��Ʈ�ϴ� ����!
*��� ���� 
����� �ٷ� ����ϱ�
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
--������ ��Ǯ 1-1
/*
�ݺ��ϰ��� �ϴ� �ڵ� : * ���ϱ� * , �̰� �� 5�� �ݺ�
*/
DECLARE
    v_count NUMBER(1,0) := 0; -- �ݺ� Ƚ��
    v_tree VARCHAR2(6) := ''; -- '*' ����
BEGIN
    LOOP
        --�ݺ��ϰ��� �ϴ� �ڵ�
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        --�ݺ��� �����ϰ��� �ϴ� �ڵ�
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
        
    END LOOP;
END;
/

--������ ��Ǯ 1-2

DECLARE
    v_tree VARCHAR2(6) := ''; -- '*' ����
BEGIN
    LOOP
        --�ݺ��ϰ��� �ϴ� �ڵ�
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        --�ݺ��� �����ϰ��� �ϴ� �ڵ�
        EXIT WHEN LENGTH(v_tree) >= 5;
        
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/

--������ ��Ǯ
--�ݺ��ϰ��� �ϴ� �ڵ� : ���ϴ� ���� ���� ( ����, 1~9) => �ݺ���

DECLARE
    v_dan CONSTANT NUMBER(2,0) := &��;
    v_num NUMBER(2,0) := 1;     -- ���ϴ� �� : ����, 1~9
BEGIN
    LOOP
        -- v_num ���;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' ||(v_dan*v_num));
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 9 ;
    END LOOP;
END;
/


/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/

/*
-- 1) 2~9��, ���� �����ؾ� ��. => ù��° LOOP��
-- 2) �ش� ���� ���ϴ� ���� 1~9���� ������ ���� ��� => �ι�° LOOP��
*/

DECLARE
    v_dan NUMBER(2,0) := 2; -- �� : (����, 2~9)
    v_num NUMBER(2,0) := 1; --���ϴ� ��: ����, 1~9
BEGIN
    LOOP
        --v_dan ���
        v_num := 1; -- ���� LOOP���� ���� �ʱ�ȭ �ʿ�
        LOOP
        -- v_num ���;
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' ||(v_dan * v_num));
        
            v_num := v_num + 1;
            EXIT WHEN v_num > 9 ;
        END LOOP; -- 2���� ���� ���� v_num = 10;
        
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

---------------------------------------------------------------------------------------------------------

-- WHILE LOOP�� : Ư�������� �����ϴ� ���� �ݺ��ϴ� LOOP���� �ǹ� => ��쿡 ���� ������ �ȵǴ� ��쵵 ����
-- 1) ����
BEGIN
    WHILE �ݺ����� LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
END;
/

-- 2) ���� (�⺻������ ���ѷ����� ������ ������, �׻� TRUE�� BOOLEAN Ÿ�� ������ ���ѷ��� ���ɼ�)
BEGIN
    WHILE TRUE LOOP
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
    END LOOP;
END;
/

DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP -- ��Ȯ�� �ݺ����� ǥ��
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
    END LOOP;
END;
/

-- 1 ���� 10���� ������ ���� ���ϱ�
/*
1) 1���� 10���� ����
�� �������� ����
*/
DECLARE
    v_num NUMBER(2,0) := 1;
    v_sum NUMBER(2,0) := 0;
BEGIN
    --WHILE (v_num <= 10) LOOP
    LOOP
    -- v_num ��� => ���� ���ϱ�
        v_sum := v_sum + v_num;
    
        v_num := v_num + 1;
        EXIT WHEN v_num >10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1���� 10������ �� : ' || v_sum);
END;
/

-- ���� 6,7,8 WHILE������ Ǯ���

/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
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

-- �ٸ� ���
DECLARE
    --���� ����
    v_tree VARCHAR2(10) := '*';
BEGIN
    --v_tree ���ڿ� ���̰� 5���� �۰ų� ���������� �ݺ��� ����
    WHILE LENGTH(v_tree) <= 5 LOOP
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --�ݺ����� ����� ������ '*'�߰�
    END LOOP;
END;
/

-- ''���� �־ null ó���Ϸ��� nvl�Լ� ����
DECLARE
    --���� ����
    v_tree VARCHAR2(10) := '';
BEGIN
    --v_tree ���ڿ� ���̰� 5���� �۰ų� ���������� �ݺ��� ����
    WHILE NVL(LENGTH(v_tree),0) <= 5 LOOP
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --�ݺ����� ����� ������ '*'�߰�
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/
DECLARE
    v_dan NUMBER(1,0) := &��;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE (v_num < 10) LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    v_num := v_num + 1;
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/

/*
�� ���� ��� , �ܵ� ���ϴ� ���ڷ� ����
*/
DECLARE
    v_dan NUMBER(2,0) := 2;  --�� (����, 2~9)
    v_num NUMBER(2,0) := 1;  --  (���� 1~9)
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

-- FOR LOOP�� : ������ ���� �� ��� ������ ������ŭ �ݺ�
-- 1) ����
BEGIN
    FOR �ӽ� ���� IN �ּҰ� .. �ִ밪 LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
        -- �ӽú��� : ����Ÿ��, DECLARE���� ���� �������� ����. 
        -- �ݵ�� �ּҰ��� �ִ밪 ������ �������� ����.(���� ����, ���� ���� ��� ����) => Read Only
        -- �ּҰ�, �ִ밪 : ���� , �ݵ�� �ּҰ��� �ִ밪���� �۾ƾ��� (�ּҰ� <= �ִ밪)
END;
/

-- 2) ����
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
    v_max NUMBER(2,0) := &�ִ밪;
BEGIN
    FOR idx IN 5 .. v_max LOOP  -- v_max < 5 �� ��� FOR LOOP���� ������� ����
        -- idx := 10; // FOR LOOP���� �ӽú����� ������ �� ���� (PLS-00363: expression 'IDX' cannot be used as an assignment target)
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

--REVERSE ����

BEGIN
    FOR idx IN REVERSE 1 .. 5 LOOP  --REVERSE : ���� ���� �����ϴ� ���� ���� ������������ ������ ��
        DBMS_OUTPUT.PUT_LINE(idx || ', Hello !!!');
    END LOOP;
END;
/

-- 1���� 10������ ������ ���� ���ϱ�

DECLARE
    v_sum NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
    v_sum := v_sum + num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

--8����
--���� ���� for loop�� �ٲ㺸��
/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
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
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/
DECLARE
    v_dan NUMBER(1,0) := &��;
BEGIN
    FOR idx IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan||' * '|| idx || ' = ' || (v_dan * idx));
    END LOOP;
END;
/




/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
-- 1) 2~9��, ���� �����ؾ� ��. => ù��° LOOP��
-- 2) �ش� ���� ���ϴ� ���� 1~9���� ������ ���� ��� => �ι�° LOOP��
*/


BEGIN
    FOR dan IN 2 .. 9 LOOP -- ù��° LOOP�� : ���� ����, ������ 2 ~ 9
       FOR num IN 1 .. 9 LOOP -- �ι�° LOOP�� : ���ϴ� ���� ����, ������ 1 ~ 9
           DBMS_OUTPUT.PUT_LINE(dan|| ' * '|| num || ' = ' || (dan * num));
       END LOOP;
    END LOOP;
    -- ���ϴ� ���� ����
END;
/

--�߰�����
-- DECLARE �� ���� ���� FOR LOOP�� ���
/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
*         :1��, * 1�� ��� 
**        :2��, * 2�� ���       
***       :3��, * 3�� ���     
****      :4��, * 4�� ���  
*****     :5��, * 5�� ���
=> DBMS_OUTPUT.PUT();

*/

BEGIN
    FOR line IN 1 .. 5 LOOP  -- LINE�� ����, 1 ~ 5
        FOR star IN 1 .. line LOOP -- �� LINE���� ��µǴ� '*' ����, LINE = �ִ밪
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

