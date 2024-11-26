drop table department;
drop table employee2;
-- 6.��������
select * from department;

-- 7.�÷��߰�
alter table employee2 add birthday date; 

-- 8.��������
insert into department (deptid, deptname, location, tel)
values('1001', '�ѹ���','��101ȣ','053-777-8777');
insert into department (deptid, deptname, location, tel)
values('1002', 'ȸ����','��102ȣ','053-888-9999');
insert into department (deptid, deptname, location, tel)
values('1003', '������','��103ȣ','053-222-3333');

select * from employee2;

insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121945','�ڹμ�','20120302','�뱸','010-1111-1234','1001');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20101817','���ؽ�','20100901','���','010-2222-1234','1003');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20122245','���ƶ�','20120302','�뱸','010-3333-1222','1002');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121729','�̹���','20110302','����','010-3333-4444','1001');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121646','������','20120901','�λ�','010-1234-2222','1003');

-- 9.���� ���̺��� ������(empname) �÷��� NOT NULL ���� ������ �߰��Ͻÿ�.
alter table employee2
modify empname constraint emp_empname_nn not null;

-- 10. �ѹ����� �ٹ��ϴ� ������ �̸�, �Ի���, �μ����� ����Ͻÿ�.
select empname, hiredate, a.deptname 
from department a join employee2 b 
  on a.deptid = b.deptid
where a.deptname = '�ѹ���';
  
-- 11. ���� ���̺��� "�뱸"�� ��� �ִ� ������ ��� �����Ͻÿ�.
DELETE FROM employee2 WHERE addr = '�뱸';
select * from employee2;

-- 12. ���� ���̺��� "������"�� �ٹ��ϴ� ������ ��� "ȸ����"���� �����ϴ� SQL���� �ۼ��Ͻÿ�.
UPDATE department SET tbl.n = tbl.n+1

-- 13. ���� ���̺��� ������ȣ�� "20121729"�� ������ �Ի��Ϻ��� �ʰ� �Ի��� ������
--������ȣ, �̸�, �������, �μ��̸��� ����ϴ� SQL���� �ۼ��Ͻÿ�.

--14. �ѹ����� �ٹ��ϴ� ������ �̸�, �ּ�, �μ����� �� �� �ִ� ��(view)�� �����Ͻÿ�.
create view emp_view as (select empname, addr, a.deptname 
                         from department a join employee2 b 
                         on a.deptid = b.deptid
                         where a.deptname = '�ѹ���');
select * from emp_view;


---------------------------------------------------------------------------------------------------
-- PAGING
SELECT *
FROM employees;

SELECT d.* 
FROM (SELECT ROWNUM rn,e.* 
      FROM( SELECT *
            FROM employees 
            ORDER BY first_name
            ) e
      ) d
WHERE rn BETWEEN 1 AND 10;

--����¡�� �̷��κж����� �⺻ �������� 2�� ��

--3. LIKE������ : _ , % 

--4. n���� table join�� join ���� ����: n-1�� (���δٰ� ����) -> join ������ ���߿� �ٽ� ����

--5. FROM�� ��������: �ζ��κ�, SELECT�� ��������: ��Į�� ��������
--SELECT : ��Į�� ��������(�������� �ٸ���/�������� ���� ���� �� ������������=>�ڿ��Ҹ� ����.) / ����: '������' ������: ���ϳ� �÷��ϳ�
--FROM : �ζ��κ�(1ȸ�� ��, ��� �̸��ο��ؼ� ���밡��)
--�� ��(having ��..) : ��������(������,������,�����÷�)

--6.
DROP TABLE department1;
CREATE TABLE department1
(deptid    NUMBER(10) PRIMARY KEY,
 deptname  VARCHAR2(10),
 location  VARCHAR2(10),
 tel       VARCHAR2(15)
);

DROP TABLE employees1;
CREATE TABLE employees1
(empid    NUMBER(10) PRIMARY KEY,
 empname  VARCHAR2(10),
 hiredate DATE,
 addr     VARCHAR2(12),
 tel      VARCHAR2(15),
 deptid   NUMBER(10) REFERENCES department1(deptid)
 /*
 deptid   NUMBER(10),
 CONSTRAINT emp_deptid_fk FOREIGN KEY(deptid) REFERENCES department1(deptid)
 */
);

--7. 
ALTER TABLE employees1
ADD birthday DATE;

--8.
INSERT INTO department1
VALUES(1001, '�ѹ���', '��101ȣ', '053-777-8777');
INSERT INTO department1
VALUES(1002, 'ȸ����', '��102ȣ', '053-888-9999');
INSERT INTO department1
VALUES(1003, '������', '��103ȣ', '053-222-3333');

INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121945, '�ڹμ�', TO_DATE('12/03/02', 'YY/MM/DD'), '�뱸','010-1111-1234',1001);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20101817, '���ؽ�', TO_DATE('10/09/01', 'YY/MM/DD'), '���','010-2222-1234',1003);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20122245, '���ƶ�', TO_DATE('12/03/02', 'YY/MM/DD'), '�뱸','010-3333-1222',1002);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121729, '�̹���', TO_DATE('11/03/02', 'YY/MM/DD'), '����','010-3333-4444',1001);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121646, '������', TO_DATE('12/09/01', 'YY/MM/DD'), '�λ�','010-1234-2222',1003);

/*
����Ŭ ������ ��ȯ�Լ�
CHAR -> DATE         : TO_DATE
CHAR -> NUM          : TO_NUMBER
DATE,NUMBER -> CHAR  : TO_CHAR
*/


SELECT * FROM department1;
SELECT * FROM employees1;

--9. ���������� modify�� �ȵǴµ�, ����: not null�� default�� ����.
ALTER TABLE employees1
MODIFY empname NOT NULL;

desc employees1;

--10. 
SELECT e.empname, 
	   e.hiredate, 
	   d.deptname
FROM   employee e 
	   INNER JOIN department d
       ON(e.deptid = d.deptid)
WHERE    d.deptname = '�ѹ���';

-- ***** ��� ����� �μ����� //����� ��쿡 inner join�� ���Ǹ������� ������ �Ⱥ�����.. outer�� �ؾ���
SELECT employee_id, 
	   first_name, 
	   department_name
FROM employees e 
	 LEFT OUTER JOIN departments d
     ON(e.department_id = d.department_id);

-- ***** ��� ����� �μ������� �� �μ��� �μ��� ����
SELECT e.employee_id, 
	   e.first_name, 
	   d.department_name,
       m.first_name
FROM employees e 
	 JOIN departments d
     ON(e.department_id = d.department_id)
     LEFT OUTER JOIN employees m
     ON(d.manager_id = m.employee_id);
-->INNER OUTER �Բ� ����ϸ� ������ ���� ����� �޶�����.

--11.
DELETE FROM employee
WHERE  ADDR = '�뱸';

--12.
UPDATE employee
SET    deptid = (SELECT deptid
                 FROM   department
                 WHERE  deptname='ȸ����')
WHERE  deptid = (SELECT deptid
                 FROM   department
                 WHERE  deptname='������');
                 
--13.
SELECT e.empid, 
	   e.empname, 
	   e.birthday, 
	   d.deptname
FROM   employee e 
	   JOIN department d
       ON (d.deptid = e.deptid)
WHERE  e.hiredate > (SELECT hiredate
                     FROM   employee
                     WHERE  empid = 20121729);
                     
-- DDL, DML, DCL, TCL ����ϱ�.                     
                     
--14. alter�Ұ���, create or drop�� ���� /create�� ���� create or replace�� �����ؼ� ����
GRANT CREATE VIEW TO hr;
CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, 
		 e.addr, 
		 d.deptname
  FROM   employee e 
         JOIN department d
         ON (d.deptid = e.deptid)
  WHERE  d.deptname='�ѹ���';

  
  SELECT empname, 
		 addr, 
		 deptname
  FROM emp_vu;

-->view�� dml�� �����Ѱ���? ������ �ݹ�
--��Ģ�� ������ ������ ���Ѵ�. ����X,��������X,not null �������� ���� ->��ٷο�
/*
view�� ����ϴ� ����?
1. ������ ������ select�� ���ܾ�����
2. ����
*/