-- 1��  primary key �ܴ̿� null �����

/*
   2�� sql�� �������: select(5) from(1) where(2) group by(3) having(4) oder by(6)
   ����¡ ó��(������������� ������ �ζ��κ���) rownum �� order by �� ���� �����ϸ� rownum �� �����������۵��������� (rownum�� �ǻ翭)
   ���� ������ �ٰ� �� ���μ� rownum �� �Կ� ����� �ű⿡ rownum �� where ���� ����Ϸ��� �ѹ��� ���� �����
   ù��° ���
*/
select * 
from(    select rownum rn, e.*
        from(   select *
                from employees
                order by last_name asc)e)
where rn BETWEEN 1 and 10;
-- 2��° ���
select *
        from (select *
              from employees
              order by last_name asc)
where rownum BETWEEN 1 and 10;

-- 3��
-- like������ Ư�����ڸ� ��밡����(_:�ѱ���, %:�ۼ��� �������, �̰Ŵ� like�� ����ִ� �����)  in,between������ Ư������ ���Ұ���

-- 4��(���� ���� : �ּ� ���̺��-1)

-- 5�� �ϳ��� ������ �ȿ� �����ϰ� 
-- table �� ���������� ����
-- view �� �������� ����(���������� ���ٺ��� ����)

--6��
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
/* �ܷ�Ű ���� ���
  deptid NUMBER(10) reperences department(deptid)
  deptid NUMBER(10),
  foreign key(depid) reperences department(depid)
*/

select * from employee;
desc employee;

INSERT INTO department VALUES(1001,'�ѹ���','��101ȣ','053-777-8777');
INSERT INTO department VALUES(1002,'ȸ����','��102ȣ','053-888-9999');
INSERT INTO department VALUES(1003,'������','��103ȣ','053-222-3333');

COMMIT;

--7��(�÷� �߰��� alter ���°� �߰��ϴ°��� add)
alter TABLE employee add birthday date;

--8��
--�̷��� ���°� ���� (����Ʈ Ÿ�� ���������� ���� ������ �ٸ��� ����)
insert into employee(empid,empname,hiredate,addr,tel, deptid)
VALUES(20121945,'�ڹμ�',to_date('12/03/02','YY/MM/DD'),'�뱸','010-1111-1234',1001);

INSERT into employee VALUES(20211945,'�ڹμ�','20120302','�뱸','010-1111-1234',1001);
INSERT into employee VALUES(20101817,'���ؽ�','20100901','���','010-2222-1234',1003);
INSERT into employee VALUES(20122245,'���ƶ�','20120302','�뱸','010-3333-1222',1002);
INSERT into employee VALUES(20121729,'�̹���','20110302','����','010-3333-4444',1001);
INSERT into employee VALUES(20121646,'������','20100901','�λ�','010-1234-2222',1003);


--9��(���������� not null��  modify�� ���  ������ modify ������ �������� ������ ����ؾ���)
alter TABLE employee modify empname not null;


--10��(������ �����ѰŴ� �ǵ��� �������� ó�� �ȵǸ� ���������� ���)
--ù��° ���(����Ŭ ����)
select e.empname,e.hiredate,d.deptname
from employee e, department d
where e.deptid = d.deptid
and d.deptname = '�ѹ���';
-- �ι�° ��� (��� db�� ��밡��)
select e.empname,e.hiredate,d.deptname
from employee e join department d
                    on (e.deptid = d.deptid)
where d.deptname='�ѹ���';


--11�� 
DELETE from employee where addr='�뱸';


--12��
update employee
set deptid = (select deptid
             from department
             where deptname = 'ȸ����')
where deptid = (select deptid
                from department
                where deptname='������');
                
--13��
--1)ǥ��
select e.empid,e.empname,e.birthday,d.deptname
from employee e join department d
where  e.hiredate >(select hiredate
                    from employee
                    where empid = 20121729);

--14��
--ǥ�ع��
create view emp_vu
as
    select e.empname, e.addr, d.deptname
    from employee e join department d
                    on(d.deptid = e.deptid)
    where d.deptname='�ѹ���';
--����Ŭ (�ؿ� replace�� ���� ������ ����� ����)
create or replace view emp_vu
as
    select e.empname, e.addr, d.deptname
    from employee e, department d
    where d.deptid = e.deptid
    and d.deptname='�ѹ���';


-----------------------------------------------------------------------------------------------
select * from employees
where last_name ='King';
--1��
--������
select *
from employees
where upper(job_id) = 'ST_CLERK'
     AND hire_date >= to_date('2006/01/01','YYYY/MM/DD');
select *
from employees
where upper(job_id) = 'ST_CLERK'
     AND to_char(hire_date, 'YYYY') >'2005';
--��
select *
from employees
where hire_date > '021231' and job_id='ST_CLERK';

--2��
select employee_id, last_name, job_id, salary, commission_pct
from employees
where commission_pct is not null
order by salary desc;

--3��
select 'The salary of ' || last_name || ' after a 10% raise is ' || round(salary*1.1) as "New Salary"
from employees
where commission_pct is null;

--4��
--������
--��� ���
select trunc(months_between(sysdate,hire_date)/12)
from employees;
--���� ���
select trunc(mod(months_between(sysdate,hire_date),12))
from employees;
--�Ѵ�
select last_name, trunc(months_between(sysdate,hire_date)/12) as years, trunc(mod(months_between(sysdate,hire_date),12)) as months
from employees;

--5��
select last_name
from  employees
where upper(last_name) like 'J%' or upper(last_name) like 'K%' or upper(last_name) like 'L%' or upper(last_name) like 'M%' ;

select last_name
from employees
where upper(substr(last_name,1,1)) in('J','K','L','M');

--6��
/*null ó�����
nvl (�÷�,null�϶�ó�����) -> null �ƴϸ� ������ ��� 
nvl2 (�÷�,null�� �ƴҶ� ó�����, null�϶� ó�����) -> ó����� �� Ÿ���� ���ƾ���
null if
coalesce
*/
--ù��° ���(nvl2ó�����
select last_name, salary, nvl2(commission_pct,'Yes','No') as com
from employees;
--�ι�° ���(case ���)
select last_name,salary,
        case
            when commission_pct is null
                then 'No'
            else 'Yes'
            End as com
from employees;

--7��
--ǥ�� ����
select d.department_name,d.location_id,e.last_name,e.salary,e.job_id
from employees e join departments d
                on(e.department_id = d.department_id)
where d.location_id='1800';


--8��
select count(*)
from employees
where last_name like('%n');

select count(*)
from employees
where lower(substr(last_name,-1)) = 'n';

--9�� //outer ���� left rigbt full 3���� ����
--count �� *�� null�� ���Խ�Ŵ
select d.department_name, d.location_id, count(e.employee_id)
from departments d left join employees e
                        on(e.department_id = d.department_id)
group by d.department_name, d.location_id;
--10��
select distinct job_id
from employees
where department_id in(10,20);

--11��
--���� ���
select e.job_id, count(e.employee_id) as freqency
from employees e join departments d
                        on(e.department_id = d.department_id)
where lower(d.department_name) in('administration','executive')
group by e.job_id
order by freqency desc;

--�������� ���
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

--12��
select last_name, hire_date
from employees
where to_char(hire_date,'DD') <'16';
--date type�� to_char(), to_date() ������
--to_char �� ��������� ���հ���(���ڿ��� �����ϴ°�) �׷��� ������ ���� varcharŸ������ ���µ� ���信�� �ڵ����� ������Ÿ������ ��ȯ�ǰ� �ϴ°�
to_char(sysdate -> 'YYYY"��" MM"��" DD"��"')
        YY/MM/DD
-- �޾Ƶ鿩���°Ͱ� ���������� �����ؾ���(������Ÿ������ �ٲ��ִ°�)
to_date('1999-01-31','YYYY-MM-DD')


--13��
select last_name,salary, trunc(salary, -3)/1000 thousands
from employees;

select last_name,salary,trunc(salary/1000) as thousands
from employees;

--14��
select w.last_name,m.last_name manager, m.salary, j.max_salary
from employees w join employees m
                    on(w.manager_id = m.employee_id)
                    join jobs j
                    on (m.job_id = j.job_id)
where m.salary >15000;

--15��
select department_id, min(salary)
from employees
group by department_id
having avg(salary) = (select max(avg(salary))
                    from employees
                    group by department_id);






