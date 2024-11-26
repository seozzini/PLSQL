drop table department;
drop table employee2;
-- 6.생성쿼리
select * from department;

-- 7.컬럼추가
alter table employee2 add birthday date; 

-- 8.삽입쿼리
insert into department (deptid, deptname, location, tel)
values('1001', '총무팀','본101호','053-777-8777');
insert into department (deptid, deptname, location, tel)
values('1002', '회계팀','본102호','053-888-9999');
insert into department (deptid, deptname, location, tel)
values('1003', '영업팀','본103호','053-222-3333');

select * from employee2;

insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121945','박민수','20120302','대구','010-1111-1234','1001');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20101817','박준식','20100901','경산','010-2222-1234','1003');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20122245','선아라','20120302','대구','010-3333-1222','1002');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121729','이범수','20110302','서울','010-3333-4444','1001');
insert into employee2 (empid, empname,hiredate,addr,tel,deptid)
values('20121646','이융희','20120901','부산','010-1234-2222','1003');

-- 9.직원 테이블의 직원명(empname) 컬럼에 NOT NULL 제약 조건을 추가하시오.
alter table employee2
modify empname constraint emp_empname_nn not null;

-- 10. 총무팀에 근무하는 직원의 이름, 입사일, 부서명을 출력하시오.
select empname, hiredate, a.deptname 
from department a join employee2 b 
  on a.deptid = b.deptid
where a.deptname = '총무팀';
  
-- 11. 직원 테이블에서 "대구"에 살고 있는 직원을 모두 삭제하시오.
DELETE FROM employee2 WHERE addr = '대구';
select * from employee2;

-- 12. 직원 테이블에서 "영업팀"에 근무하는 직원을 모두 "회계팀"으로 수정하는 SQL문을 작성하시오.
UPDATE department SET tbl.n = tbl.n+1

-- 13. 직원 테이블에서 직원번호가 "20121729"인 직원의 입사일보다 늦게 입사한 직원의
--직원번호, 이름, 생년월일, 부서이름을 출력하는 SQL문을 작성하시오.

--14. 총무팀에 근무하는 직원의 이름, 주소, 부서명을 볼 수 있는 뷰(view)를 생성하시오.
create view emp_view as (select empname, addr, a.deptname 
                         from department a join employee2 b 
                         on a.deptid = b.deptid
                         where a.deptname = '총무팀');
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

--페이징은 이런부분때문에 기본 서브쿼리 2개 들어감

--3. LIKE연산자 : _ , % 

--4. n개의 table join시 join 조건 갯수: n-1개 (붙인다고 생각) -> join 조건은 나중에 다시 수업

--5. FROM절 서브쿼리: 인라인뷰, SELECT절 서브쿼리: 스칼라 서브쿼리
--SELECT : 스칼라 서브쿼리(원래경우랑 다르게/메인쿼리 먼저 실행 후 서브쿼리실행=>자원소모가 많다.) / 조건: '무조건' 단일행: 값하나 컬럼하나
--FROM : 인라인뷰(1회성 뷰, 뷰는 이름부여해서 재사용가능)
--그 외(having 등..) : 서브쿼리(단일행,다중행,다중컬럼)

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

/*
오라클 데이터 변환함수
CHAR -> DATE         : TO_DATE
CHAR -> NUM          : TO_NUMBER
DATE,NUMBER -> CHAR  : TO_CHAR
*/


SELECT * FROM department1;
SELECT * FROM employees1;

--9. 제약조건은 modify가 안되는데, 예외: not null과 default만 가능.
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
WHERE    d.deptname = '총무팀';

-- ***** 모든 사원의 부서정보 //모든의 경우에 inner join은 조건만족하지 않으면 안보여줌.. outer로 해야함
SELECT employee_id, 
	   first_name, 
	   department_name
FROM employees e 
	 LEFT OUTER JOIN departments d
     ON(e.department_id = d.department_id);

-- ***** 모든 사원의 부서정보와 각 부서의 부서장 정보
SELECT e.employee_id, 
	   e.first_name, 
	   d.department_name,
       m.first_name
FROM employees e 
	 JOIN departments d
     ON(e.department_id = d.department_id)
     LEFT OUTER JOIN employees m
     ON(d.manager_id = m.employee_id);
-->INNER OUTER 함께 사용하면 순서에 따라 결과가 달라진다.

--11.
DELETE FROM employee
WHERE  ADDR = '대구';

--12.
UPDATE employee
SET    deptid = (SELECT deptid
                 FROM   department
                 WHERE  deptname='회계팀')
WHERE  deptid = (SELECT deptid
                 FROM   department
                 WHERE  deptname='영업팀');
                 
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
                     
-- DDL, DML, DCL, TCL 기억하기.                     
                     
--14. alter불가능, create or drop만 가능 /create는 가능 create or replace는 주의해서 쓰기
GRANT CREATE VIEW TO hr;
CREATE OR REPLACE VIEW emp_vu 
AS
  SELECT e.empname, 
		 e.addr, 
		 d.deptname
  FROM   employee e 
         JOIN department d
         ON (d.deptid = e.deptid)
  WHERE  d.deptname='총무팀';

  
  SELECT empname, 
		 addr, 
		 deptname
  FROM emp_vu;

-->view는 dml이 가능한가요? 정답은 반반
--원칙상 가능은 하지만 안한다. 조인X,서브쿼리X,not null 제약조건 만족 ->까다로움
/*
view를 사용하는 이유?
1. 복잡한 쿼리문 select로 땡겨쓰려고
2. 보안
*/