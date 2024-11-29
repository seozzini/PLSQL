--2024.11.27

-- https://poiemaweb.com/  (PoiemaWeb) �Ұ�
-- ���߽� �ñ��Ѱ� ����� ���۸��� ������
-- ��Ʈ�� �ش� ���� ������� �̾����.

--å��õ: �ھ� �ڹٽ�ũ��Ʈ ���糲 ��(�߱��̻�): ���ʹ��� ���� ����. ���ۿ��� ������ å
-- ��ä������� �� �������� ITå ����. ����~


-- CURSOR CLOSE���� ������?
-- DECLARE���� ����Ǿ� �־ BLOCK END�� ����
-- BUT, ���ɺ���, �޸𸮳��� ���� ������ ����� ���� �ʿ�

-- FETCH ���� EXIT WHEN���� ����? ������ ������ �ߺ����� �ʵ��� ����

-- ������ �̾� ������ ����Ǯ��

SET SERVEROUTPUT ON;

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
        SELECT last_name ename, salary sal, (salary*12+(salary*nvl(commission_pct,0)*12)) as year --pl/sql, mybatis, node�� ����� ""(X)
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    v_emp_rec emp_in_dept_cursor%ROWTYPE; --SELECT���� �ִ°Ÿ� �����ͼ� Ÿ�� ����
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

-- Ŀ�� FOR LOOP : ����� Ŀ���� ����ϴ� ������
-- 1) ����
DECLARE
    CURSOR Ŀ���� IS
        SELECT��;
BEGIN
    FOR �ӽú���(���ڵ�Ÿ��) IN Ŀ���� LOOP --�Ͻ������� OPEN�� FETCH
        -- Ŀ���� �����Ͱ� �����ϴ� ��� �����ϴ� �ڵ�
    END LOOP; -- �Ͻ������� CLOSE
END;
/

-- 2) ����
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


-- Q. �μ���ȣ�� �Է¹޾� �ش� �μ��� �Ҽӵ� �������(�����ȣ, �̸�, �޿�)�� ����ϼ���.
-- �μ���ȣ 0 : Ŀ���� �����Ͱ� ����
-- �μ���ȣ 50 : Ŀ���� �����Ͱ� ������

DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' : ');
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
    END LOOP; -- �Ͻ������� CLOSE
    -- DBMS_OUTPUT.PUT_LINE('�� ������ ����: '|| emp_dept_cursor%ROWCOUNT);
END;
/

-- Ŀ�� FOR LOOP ���� ��� ����� Ŀ���� �����͸� ������ �� ���� �� ���Ұ�
--> Ŀ�� FOR LOOP ���� ��� ����� Ŀ���� �����͸� ������ �� ���� ���� ���

-- Ŀ�� FOR LOOP�� Ǯ��

/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬���� 
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.

�Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է�
*/
--������ Ǯ��
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees;
BEGIN
     FOR emp_rec IN emp_cursor LOOP
     -- ���ǹ�
        IF emp_rec.hire_date <= '20151231' THEN
            INSERT INTO test01(empid, ename, hiredate)
            VALUES (emp_rec.employee_id, emp_rec.last_name, emp_rec.hire_date );  --��Ģ*
        ELSE
            INSERT INTO test02
            VALUES emp_rec;  --record�� ���� field�� ������ table�� ���� �÷� ������ ���ٸ� �ӽú��� ��°�� �ֱ�
        END IF;
     END LOOP;

END;
/

select *
from test02;

delete from test01;
delete from test02;


--��Ǯ��
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
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
*/
-- ������Ǯ�� 1
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, hire_date, department_name
        FROM EMPLOYEES e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;
BEGIN
    FOR info IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(info.last_name || ',' || info.hire_date || ', ' || info.department_name);
    END LOOP;

END;
/

-- 2 ��������

BEGIN
    FOR emp_rec IN (SELECT last_name, hire_date, department_name
                     FROM EMPLOYEES e JOIN departments d
                                   ON (e.department_id = d.department_id)
                  WHERE e.department_id = &�μ���ȣ) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_rec.last_name || ',' || emp_rec.hire_date || ', ' || emp_rec.department_name);
    END LOOP;

END;
/

-- ��Ǯ��
 SELECT last_name ename, hire_date hdate, department_name dname
        FROM employees e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, hire_date hdate, department_name dname
        FROM employees e JOIN departments d
                          ON (e.department_id = d.department_id)
        WHERE e.department_id = &�μ���ȣ;
        
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE( emp_rec.ename || ', ' || emp_rec.hdate || ', ' || emp_rec.dname );
    END LOOP;
    

END;
/


/*
3.
�μ���ȣ�� �Է�(&���)�� ��� 
����̸�, �޿�, ����->(�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
*/

-- 3-1 : ������ ���� ���
DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    v_year NUMBER(10,2); -- ����
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
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_in_dept_cursor LOOP
        
        DBMS_OUTPUT.PUT(emp_rec.ename);
        DBMS_OUTPUT.PUT(', ' || emp_rec.sal);
        DBMS_OUTPUT.PUT_LINE(', '|| emp_rec.year);
    END LOOP;
END;
/

-- ���� ����: 11�� ����(�÷����� PL/SQL���� �����ϴ� ������ Ÿ�� �� �ϳ��� �츮�� ��� �͵�,�ȹ�� �͵� ��� ���ԵǾ��ִ� �κ���)


-- ����ó�� : ���ܰ� �߻����� �� ���������� �۾��� ����� �� �ֵ��� ó��
-- 1) ����
DECLARE

BEGIN

EXCEPTION
    WHEN �����̸� THEN -- �ʿ��� ��ŭ �߰� ����
        -- ���ܹ߻��� ó���ϴ� �ڵ�
    WHEN OTHERS THEN -- ���� ���ǵ� ���� ���� �߻��ϴ� ��� �ϰ�ó��
        -- ���ܹ߻��� ó���ϴ� �ڵ�

END;
/

-- 2) ����
-- 2-1) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �����ϴ� ���ܻ���
-- 2-2) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �������� �ʴ� ���ܻ���
-- 2-3) ����� ���� ���� => ����Ŭ ���忡���� �����ڵ�� ����


-- 2-1) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �����ϴ� ���ܻ���
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : ORA-01403, NO_DATA_FOUND
    -- �μ���ȣ 10 : �������
    -- �μ���ȣ 50 : ORA-01422, TOO_MANY_ROWS
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����ϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���ܻ����� �߻��߽��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('����� ����Ǿ����ϴ�.');
END;
/

-----------------
-- ������ ����ü ���� �𸦶� �װ� ��ȯ�ϴ� ��
DECLARE
    v_ename employees.last_name%type;
BEGIN
    select last_name
    into v_ename
    from employees
    where department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : ORA-01403, NO_DATA_FOUND
    -- �μ���ȣ 10 : �������
    -- �μ���ȣ 50 : ORA-01422, TOO_MANY_ROWS
    
    dbms_output.put_line(v_ename);  -- ���ܰ� �߻��ϸ� �̰� ���� �ȵ�
    -- ������ ����ó���� �����ν� ���������� ������ �� �� ����

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('�ش� �μ��� ���� ����� �����ϴ�.');
    WHEN OTHERS THEN
        dbms_output.put_line('��Ÿ ���ܻ����� �߻��߽��ϴ�.');
        
        dbms_output.put_line('ORA' || SQLCODE); -- �����ڵ� ǥ��
        dbms_output.put_line( SUBSTR(SQLERRM,12));  -- �����޼��� ǥ��(�ش�޼����� ORA-1422 : �� �ִµ� �̺κ��� �߶� ǥ����)
END;
/

-----------------


-- 2-2) �̹� ����Ŭ�� ���ǵǾ� �ְ�(�����ڵ尡 ����) �̸��� �������� �ʴ� ���ܻ��� // DELETE , UPDATE ���� DML���� ���� �߻�
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 10 :  ORA-02292 : integrity constraint (HR.EMP_DEPT_FK) violated - child record found
EXCEPTION
    WHEN e_emps_remaining THEN
    DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �ٸ� ���̺��� ��� ���Դϴ�.');
END;
/
rollback;

-- 2-3) ����� ���� ���� => ����Ŭ ���忡���� �����ڵ�� ���� (�帧�� ���ϰ� ����� �� ��)
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    -- �μ���ȣ 0 : ���������� ��������� ��ɻ� ���з� �����ؾ� �ϴ� ���
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
    DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ�� Ȯ�����ּ���.');
END;
/

--����ó�������ʰ� ���ǹ� ������� ����
BEGIN
    DELETE FROM departments
    WHERE department_id = 0;
    -- �μ���ȣ 0 : ���������� ��������� ��ɻ� ���з� �����ؾ� �ϴ� ���
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�μ���ȣ�� Ȯ�����ּ���.');
    END IF;
END;
/

-- ���� Ʈ�� �Լ�
-- ����Ǯ��
/*
1.
drop table emp_test;

create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;

emp_test ���̺��� �����ȣ�� ���(&ġȯ���� ���)�Ͽ� ����� �����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
(��, ����� ���� ���ܻ��� ���)
(��, ����� ������ "�ش����� �����ϴ�."��� �����޽��� �߻�)
*/
-- ������ ����Ǯ��
DECLARE
    e_emp_not_found EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        --DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.'); --> �׳� ó��
        RAISE e_emp_not_found;
    END IF;
EXCEPTION
    WHEN e_emp_not_found THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.'); --> ���ܷ� ó��
END;
/

-- �����ȣ�� a01������ ���� --invalid identifier
-- ġȯ������ ���ڸ� �־��ְ� ������ ����� �� ����
-- 1. WHERE employee_id = &�����ȣ; �� '&�����ȣ'�� ���� --invalid number
-- 2. �Է� �� ���� 'a01' �־��� �� ����


-- �� ����Ǯ��
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;  -- RAISE ���������߻� ==> ����ä�� ���ܷ� ó����
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
    DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�.');
    DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���.');
END;
/

-- PROCEDURE
-- 1) ����
CREATE PROCEDURE ���ν�����
 ( �Ű������� [���] ������Ÿ�� , ...)
IS
    -- ����� : ���ú���, Ŀ��, ���ܻ��� ���� ���� (DECLARE ��� �� IS�� �浹��. ����δ� ������ ���� ���·� ����)
BEGIN
    -- PROCEDURE�� ������ �ڵ� 
EXCEPTION
    -- ����ó��
END;
 /

-- 2) ����
DROP PROCEDURE test_pro; -- �߸��ۼ� �� drop���� ��������

CREATE PROCEDURE test_pro
(p_msg VARCHAR2) -- �Ͻ������� IN ���� /�Ű������� ���ξ�� p (parameter) / �Ű������� ũ�� ���� �ȵ�(�Ѿ���� �� ũ�� ���� �Ұ�)
IS
    v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�����Ͱ� �������� �ʽ��ϴ�.');
END;
/

--> ��ũ��Ʈ: Procedure TEST_PRO��(��) �����ϵǾ����ϴ�.
--> �ش� PROCEDURE ����� ��, ERROR) ORA-00955: name is already used by an existing object
--> PROCEDURE �߸� �ۼ� �� DROP ���� ��������

-- 3) ����
DECLARE
    v_result VARCHAR2(1000);
BEGIN
    -- ����Ŭ�� ���� �����ϴ� ��ü�� PROCEDURE���� FUNCTION������ �����ϴ� ���
    -- => **ȣ������ ( ���ʿ� ������ �����ϴ� �� )
    -- v_result := test_pro('PL/SQL');  --PROCEDUER ȣ��� �������� �ܵ� ȣ���ؾ���. ������ �Ҵ��ϸ� �Լ��� �ν��ؼ� ����(���� ���ν����ε�!)
    test_pro('PL/SQL');
END;
/

EXECUTE test_pro('WORLD'); --SQL DEVELOPER�� �� �ϳ��� PROCEDURE�� Ȯ���� ��, �ܵ����� �����. 
                           -- ���ݽ����� ��û�� PROCEDURE�� ������ BEGIN�� END���� �����־� TEST�ϴ� ����

-- PROCEDURE�� ���� 3���� MODE �ǽ�

-- IN ��� : ȣ��ȯ�� ->���ν����� ���� ����, ���ν��� ���ο��� ��� ���
DROP PROCEDURE raise_salary;
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS

BEGIN
    -- p_eid := 100;  -- �Ű����� ���� ����(���ν��� ���ο��� ��� ���. �� ����Ұ�/������ ���⸸ ����)
                   --> PLS-00363: expression 'P_EID' cannot be used as an assignment target
    UPDATE employees
    SET salary = salary * 1.1  --eid�������� �ӱ� 10�����λ�
    WHERE employee_id = p_eid;
END;
/
--> ������ ���� ���� ����ǹǷ� ERROR��. DROP�ϰ� �ٽ� CREATE�ϻ� (ORA-00955: name is already used by an existing object)


SELECT employee_id, salary
FROM employees
WHERE employee_id IN (100, 130, 149);

DECLARE
    v_first NUMBER(3,0) := 100; --�ʱ�ȭ�� ����
    v_second CONSTANT NUMBER(3,0) := 149; --���
BEGIN
    raise_salary(100);            -- ���ͷ�
    raise_salary(v_first+30);     -- ǥ����
    raise_salary(v_first);        -- �ʱ�ȭ�� ����
    raise_salary(v_second);       -- ���
END;
/

-- OUT ��� : ���ν��� -> ȣ��ȯ������ ���� ��ȯ, ���ν��� ���ο��� �ʱ�ȭ���� ���� ������ ����
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,  --OUT����� ������ ���ϰ� ���� ����
p_out OUT NUMBER)
IS

BEGIN
    DBMS_OUTPUT.PUT_LINE('IN : ' || p_num);
    DBMS_OUTPUT.PUT_LINE('OUT : ' || p_out);
END; --����� ����Ǵ� ���� OUT ����� �Ű������� ������ �ִ� ���� �״�� ��ȯ
/

-- �����ڵ� 
DECLARE
    v_result NUMBER(4,0) := 1234;
BEGIN
    DBMS_OUTPUT.PUT_LINE('1) result: ' || v_result);
    test_p_out(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('2) result: ' || v_result);
END; 
/

-- ���ϱ� (�� PROCEDURE�� ����)
CREATE PROCEDURE pro_plus
(p_x IN NUMBER,
p_y IN NUMBER,
p_sum OUT NUMBER)
IS

BEGIN
    p_sum := p_x + p_y;
END;
/
-- �����ڵ�
DECLARE
    v_total NUMBER(10,0);
BEGIN
   pro_plus(10, 25, v_total);
   DBMS_OUTPUT.PUT_LINE(v_total);
END; 
/

-- IN OUT ��� : IN ���� OUT ��� �ΰ����� �ϳ��� ������ ó��
-- ������: ���� �����Ͱ� ����� (OUT��� ���ν��� ȣ�� �� ������ ���� ���� �����. ���. IN���� ������)
--> ���� �������� ���� ����Ǿ�� �� ��쿡 ���� / ����Ǿ ������� ��

-- ���� ��� ����
-- '01012341234' => '010-1234-1234'
-- ��¥�� ������ �������� ����: '24/11/27' => '24��11��'

CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)  -- ������ �ϳ���� ���� �������
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('before: ' || p_phone_no); -- ����� ���ް� Ȯ��
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                 || '-' || SUBSTR(p_phone_no, 4, 4)
                 || '-' || SUBSTR(p_phone_no, 8); --> ������ �Ű����� ������ ������ġ���� ������ ��~��
    DBMS_OUTPUT.PUT_LINE('after: ' || p_phone_no); -- �������� ����� �� Ȯ��
END;
/

-- �����ڵ�
DECLARE
    v_no VARCHAR2(100) := '01012341234';
BEGIN
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no); -- '01012341234' => '010-1234-1234'
                                -- ����, ���浥���� ��� �����ְ� �ʹٸ�? �������� ���� �����͸� �����ֱ� �Ұ���..
                                -- IN, OUT �и��� ���°� ���������� ����ϱ� ����
END;
/

-- ���ν��������� DML��� (INSERT,UPDATE,DELETE) / �������� �Ű����� �ʿ�
-- FUCTION�� RETURN �� ��. ��.��.�� ���� �����ؾ���(JAVA�� VOID, JS�� ���� �Ұ�)
-- �Լ��� ����� ��, ����� ����� ������ ���� ��� ,
-- ���ν����� ���� �����͸� �����Ӱ� INSERT�ϰ� �������� ��

CREATE FUNCTION hello
RETURN VARCHAR2
IS
BEGIN
    RETURN 'Hello !!!';
END;
/
SELECT hello
FROM dual;

-- �� ������ ���� ������ function������

-- https://onecompiler.com/ �������Ϸ� ->������ ���� �׽�Ʈ�� ����

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

/*
2.
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
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
CREATE PROCEDURE yedam_emp



/*
4.
�μ���ȣ�� �Է��� ��� 
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name), ������ ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
*/

/*
5.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/