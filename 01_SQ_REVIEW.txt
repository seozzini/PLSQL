--1. 비식별관계
--2. HAVING 절
--3. 선수영문명 중에서 두번째 문자가 A인 데이터
--4. 3개(n-1개)
--5. Inline View
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
VALUES(1001, '총무팀', '본101호', '053-777-8777');
INSERT INTO department1
VALUES(1002, '회계팀', '본102호', '053-888-9999');
INSERT INTO department1
VALUES(1003, '영업팀', '본103호', '053-222-3333');

INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121945, '박민수', TO_DATE('12/03/02', 'YY/MM/DD'), '대구','010-1111-1234',1001);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20101817, '박준식', TO_DATE('10/09/01', 'YY/MM/DD'), '경산','010-2222-1234',1003);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20122245, '선아라', TO_DATE('12/03/02', 'YY/MM/DD'), '대구','010-3333-1222',1002);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121729, '이범수', TO_DATE('11/03/02', 'YY/MM/DD'), '서울','010-3333-4444',1001);
INSERT INTO employees1(EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES(20121646, '이융희', TO_DATE('12/09/01', 'YY/MM/DD'), '부산','010-1234-2222',1003);

SELECT * FROM department1;
SELECT * FROM employees1;

--9.
ALTER TABLE employees1
MODIFY empname NOT NULL;

desc employees1;

--10. 
SELECT e.empname, e.hiredate, d.deptname
FROM   employees1 e, department1 d
WHERE  e.deptid = d.deptid
AND    d.deptname = '총무팀';

SELECT e.empname, e.hiredate, d.deptname
FROM   employees1 e JOIN department1 d
       ON(e.deptid = d.deptid)
WHERE    d.deptname = '총무팀';

--11.
DELETE FROM employees1
WHERE  ADDR = '대구';

--12.
update employees1
set    deptid = (SELECT deptid
                 FROM   department1
                 WHERE  deptname='회계팀')
where  deptid = (SELECT deptid
                 FROM   department1
                 WHERE  deptname='총무팀');
                 
--13.
SELECT e.empid, e.empname, e.birthday, d.deptname
FROM   employees1 e JOIN department1 d
                ON (d.deptid = e.deptid)
WHERE  e.hiredate > (SELECT hiredate
                     FROM   employees1
                     WHERE  empid = 20121729);

SELECT e.empid, e.empname, e.birthday, d.deptname
FROM   employees1 e, department1 d
WHERE  d.deptid = e.deptid
AND    e.hiredate > (SELECT hiredate
                     FROM   employees1
                     WHERE  empid = 20121729);
                     
--14.
GRANT CREATE VIEW TO hr;
CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, e.addr, d.deptname
  FROM   employees1 e JOIN department1 d
                ON (d.deptid = e.deptid)
  WHERE  d.deptname='총무팀';

CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, e.addr, d.deptname
  FROM   employees1 e, department1 d
  WHERE  d.deptid = e.deptid
  AND    d.deptname='총무팀';
  
  SELECT * FROM emp_vu;
