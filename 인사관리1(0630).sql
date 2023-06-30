-- 1번  primary key 이외는 null 허용함

/*
   2번 sql문 실행순서: select(5) from(1) where(2) group by(3) having(4) oder by(6)
   페이징 처리(실행순서때문에 여러번 인라인뷰사용) rownum 과 order by 가 같이 존재하면 rownum 이 정상적으로작동되지않음 (rownum은 의사열)
   따라서 조건을 다건 후 감싸서 rownum 을 먹여 줘야함 거기에 rownum 을 where 절을 사용하려면 한번더 감싸 줘야함
   첫번째 방법
*/
select * 
from(    select rownum rn, e.*
        from(   select *
                from employees
                order by last_name asc)e)
where rn BETWEEN 1 and 10;
-- 2번째 방법
select *
        from (select *
              from employees
              order by last_name asc)
where rownum BETWEEN 1 and 10;

-- 3번
-- like에서만 특수문자만 사용가능함(_:한글자, %:글수수 상관없음, 이거는 like가 들고있는 기능임)  in,between에서는 특수문자 사용불가능

-- 4번(조인 갯수 : 최소 테이블수-1)

-- 5번 하나의 쿼리의 안에 존재하고 
-- table 은 물리적으로 존재
-- view 는 논리적으로 존재(서브쿼리와 같다볼수 있음)

--6번
CREATE TABLE department(
deptid NUMBER(10) PRIMARY key,
deptname VARCHAR2(10),
location VARCHAR2(10),
tel VARCHAR2(15));

select * from department;
desc department;
drop TABLE department;

CREATE TABLE employee(
empid NUMBER(10) PRIMARY KEY,
empname VARCHAR2(10),
hiredate DATE,
addr VARCHAR2(12),
tel VARCHAR2(15),
deptid NUMBER(10));
/* 외래키 설정 방법
  deptid NUMBER(10) reperences department(deptid)
  deptid NUMBER(10),
  foreign key(depid) reperences department(depid)
*/

select * from employee;
desc employee;

INSERT INTO department VALUES(1001,'총무팀','본101호','053-777-8777');
INSERT INTO department VALUES(1002,'회계팀','본102호','053-888-9999');
INSERT INTO department VALUES(1003,'영업팀','본103호','053-222-3333');

COMMIT;

--7번(컬럼 추가는 alter 없는걸 추가하는것은 add)
alter TABLE employee add birthday date;

--8번
--이렇게 쓰는게 정석 (데이트 타입 버전에따라 지원 형식이 다르기 때문)
insert into employee(empid,empname,hiredate,addr,tel, deptid)
VALUES(20121945,'박민수',to_date('12/03/02','YY/MM/DD'),'대구','010-1111-1234',1001);

INSERT into employee VALUES(20211945,'박민수','20120302','대구','010-1111-1234',1001);
INSERT into employee VALUES(20101817,'박준식','20100901','경산','010-2222-1234',1003);
INSERT into employee VALUES(20122245,'선아라','20120302','대구','010-3333-1222',1002);
INSERT into employee VALUES(20121729,'이범수','20110302','서울','010-3333-4444',1001);
INSERT into employee VALUES(20121646,'이융희','20100901','부산','010-1234-2222',1003);


--9번(제약조건중 not null만  modify가 허용  나머지 modify 쓸려면 제약조건 삭제후 사용해야함)
alter TABLE employee modify empname not null;


--10번(조인이 가능한거는 되도록 조인으로 처리 안되면 서브쿼리를 사용)
--첫번째 방법(오라클 조인)
select e.empname,e.hiredate,d.deptname
from employee e, department d
where e.deptid = d.deptid
and d.deptname = '총무팀';
-- 두번째 방법 (모든 db에 사용가능)
select e.empname,e.hiredate,d.deptname
from employee e join department d
                    on (e.deptid = d.deptid)
where d.deptname='총무팀';


--11번 
DELETE from employee where addr='대구';


--12번
update employee
set deptid = (select deptid
             from department
             where deptname = '회계팀')
where deptid = (select deptid
                from department
                where deptname='영업팀');
                
--13번
--1)표준
select e.empid,e.empname,e.birthday,d.deptname
from employee e join department d
where  e.hiredate >(select hiredate
                    from employee
                    where empid = 20121729);

--14번
--표준방법
create view emp_vu
as
    select e.empname, e.addr, d.deptname
    from employee e join department d
                    on(d.deptid = e.deptid)
    where d.deptname='총무팀';
--오라클 (밑에 replace는 원래 있으면 지우고 생성)
create or replace view emp_vu
as
    select e.empname, e.addr, d.deptname
    from employee e, department d
    where d.deptid = e.deptid
    and d.deptname='총무팀';


-----------------------------------------------------------------------------------------------
select * from employees
where last_name ='King';
--1번
--교수님
select *
from employees
where upper(job_id) = 'ST_CLERK'
     AND hire_date >= to_date('2006/01/01','YYYY/MM/DD');
select *
from employees
where upper(job_id) = 'ST_CLERK'
     AND to_char(hire_date, 'YYYY') >'2005';
--나
select *
from employees
where hire_date > '021231' and job_id='ST_CLERK';

--2번
select employee_id, last_name, job_id, salary, commission_pct
from employees
where commission_pct is not null
order by salary desc;

--3번
select 'The salary of ' || last_name || ' after a 10% raise is ' || round(salary*1.1) as "New Salary"
from employees
where commission_pct is null;

--4번
--교수님
--년수 계산
select trunc(months_between(sysdate,hire_date)/12)
from employees;
--개월 계산
select trunc(mod(months_between(sysdate,hire_date),12))
from employees;
--둘다
select last_name, trunc(months_between(sysdate,hire_date)/12) as years, trunc(mod(months_between(sysdate,hire_date),12)) as months
from employees;

--5번
select last_name
from  employees
where upper(last_name) like 'J%' or upper(last_name) like 'K%' or upper(last_name) like 'L%' or upper(last_name) like 'M%' ;

select last_name
from employees
where upper(substr(last_name,1,1)) in('J','K','L','M');

--6번
/*null 처리방법
nvl (컬럼,null일때처리방법) -> null 아니면 본랙밧 출력 
nvl2 (컬럼,null이 아닐때 처리방법, null일때 처리방법) -> 처리방법 두 타입이 같아야함
null if
coalesce
*/
--첫번째 방법(nvl2처리방법
select last_name, salary, nvl2(commission_pct,'Yes','No') as com
from employees;
--두번째 방법(case 사용)
select last_name,salary,
        case
            when commission_pct is null
                then 'No'
            else 'Yes'
            End as com
from employees;

--7번
--표준 조인
select d.department_name,d.location_id,e.last_name,e.salary,e.job_id
from employees e join departments d
                on(e.department_id = d.department_id)
where d.location_id='1800';


--8번
select count(*)
from employees
where last_name like('%n');

select count(*)
from employees
where lower(substr(last_name,-1)) = 'n';

--9번 //outer 조인 left rigbt full 3가지 있음
--count 만 *때 null을 포함시킴
select d.department_name, d.location_id, count(e.employee_id)
from departments d left join employees e
                        on(e.department_id = d.department_id)
group by d.department_name, d.location_id;
--10번
select distinct job_id
from employees
where department_id in(10,20);

--11번
--조인 방법
select e.job_id, count(e.employee_id) as freqency
from employees e join departments d
                        on(e.department_id = d.department_id)
where lower(d.department_name) in('administration','executive')
group by e.job_id
order by freqency desc;

--서브쿼리 방법
select job_id, count(job_id) as frequency
from employees
where department_id in 
                    (select department_id
                    from departments
                    where lower(department_name) in('administration','executive'))
group by job_id
order by 2 desc;

select e.job_id, count(e.job_id) as frequency
from employees e, departments d
where e.department_id = d.department_id
and (d.department_name = 'Administration'
or d.department_name ='Executive')
group by job_id
order by 2 desc;

--12번
select last_name, hire_date
from employees
where to_char(hire_date,'DD') <'16';
--date type과 to_char(), to_date() 차이점
--to_char 은 내마음대로 조합가능(문자열을 조합하는것) 그래서 끄집어 오면 varchar타입으로 오는데 포멧에서 자동으로 데이터타입으로 변환되게 하는것
to_char(sysdate -> 'YYYY"년" MM"월" DD"일"')
        YY/MM/DD
-- 받아들여오는것과 보내느것이 동일해야함(데이터타입으로 바꿔주는것)
to_date('1999-01-31','YYYY-MM-DD')


--13번
select last_name,salary, trunc(salary, -3)/1000 thousands
from employees;

select last_name,salary,trunc(salary/1000) as thousands
from employees;

--14번
select w.last_name,m.last_name manager, m.salary, j.max_salary
from employees w join employees m
                    on(w.manager_id = m.employee_id)
                    join jobs j
                    on (m.job_id = j.job_id)
where m.salary >15000;

--15번
select department_id, min(salary)
from employees
group by department_id
having avg(salary) = (select max(avg(salary))
                    from employees
                    group by department_id);






