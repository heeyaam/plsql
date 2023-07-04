--dbms 내부의 성정을 실행하는것 항상 첫번째에 실행해줘야함
--DECLARE 에 선언된 변수는 END 가 될때까지 살아있다. 이름이 같은게 있으면 내가 만든것이 우선적으로 사용된다.
set serveroutput on

DECLARE
--<*변수선언시 이름 타입 순서 값을 주고 싶다면 :을 붙여줘야함
    v_sal NUMBER(7,2) := 60000;
    --선언된 변수의 경우 타입을 아래에 끌어올수있다. 이럴때 반드시 결과의 타입이 동일해야함
    v_comm v_sal%TYPE :=v_sal * .20;
    v_message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('v_comm' || v_comm);
    DBMS_OUTPUT.PUT_LINE('v_message' || v_message);
    DBMS_OUTPUT.PUT_LINE('==========================');
    DECLARE
        v_sal NUMBER(7,2) := 50000;
        v_comm v_sal%TYPE :=0;
        v_total_comm NUMBER(7,2) := v_sal + v_comm;
    
        BEGIN
        DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);
        DBMS_OUTPUT.PUT_LINE('v_comm' || v_comm);
        DBMS_OUTPUT.PUT_LINE('v_message' || v_message);
        DBMS_OUTPUT.PUT_LINE('v_total' || v_total_comm);
        DBMS_OUTPUT.PUT_LINE('==========================');
        v_message := 'CLERK not' || v_message;
        V_comm := v_sal * .30;
    END;
        DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);
        DBMS_OUTPUT.PUT_LINE('v_comm' || v_comm);
        DBMS_OUTPUT.PUT_LINE('v_message' || v_message);
        DBMS_OUTPUT.PUT_LINE('==========================');
        v_message := ' SALESMEN ' || v_message;
        DBMS_OUTPUT.PUT_LINE('v_message' || v_message);
END;
/
DECLARE
    v_empid employees.employee_id%TYPE;
    v_empname VARCHAR2(100);
BEGIN

    SELECT employee_id, first_name || ',' || last_name
    INTO v_empid, v_empname
    FROM employees
    WHERE employee_id =&사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원 번호 : ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('사원 이름 :' || v_empname);
END;
/

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE :=0.1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES(1000,'Hong', 'hidk@google.com', sysdate, 'IT_PROG', v_deptno);
    
    UPDATE employees
    SET salary = (NVL(salary,0) +10000) * v_comm
    WHERE employee_id =1000;
END;
/

--2 delete
select * from employees where employee_id =1000;
/
DECLARE
    v_empid employees.employee_id%TYPE;
BEGIN
    SELECT employee_id
    INTO v_empid
    FROM employees
    WHERE salary is null;
    
    DELETE FROM employees
    WHERE employee_id = v_empid;
END;
/
CREATE TABLE test_employees
AS
 SELECT * FROM employees;

select * from test_employees;

DECLARE
    v_empid employees.employee_id%TYPE;
    
BEGIN 
    DELETE FROM test_employees
    WHERE employee_id =0;
    
     IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다');
    END IF;
    
    UPDATE test_employees
    SET salary =salary *1.1
    WHERE employee_id =&사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다');
    END IF;
    DBMS_OUTPUT.PUT_LINE('실행결과'  || SQL%ROWCOUNT || '이 삭제되었습니다.');
END;
/






--1번 문제
--1) 조인 방법
DECLARE
    v_empid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_depname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_empid, v_name, v_depname
    FROM employees e join departments d
                    on(e.department_id = d.department_id)
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호' || v_empid);
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_name);
    DBMS_OUTPUT.PUT_LINE('부서이름' || v_depname);
END;
/

--2)select 2개 사용
DECLARE
    v_empid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_depid employees.department_id%TYPE;
    v_depname departments.department_name%TYPE;
BEGIN
    select employee_id, last_name, department_id
    into v_empid, v_name, v_depid
    from employees
    WHERE employee_id = &사원번호;
    
    select department_name
    into v_depname
    from departments
    where department_id= v_depid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호' || v_empid);
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_name);
    DBMS_OUTPUT.PUT_LINE('부서이름' || v_depname);
END;
/

--2번 문제
--1) SELECT 문
DECLARE
     v_name employees.last_name%TYPE;
     v_sal employees.salary%TYPE;
     v_annual employees.salary%TYPE;
BEGIN
    SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
    INTO v_name, v_sal, v_annual
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_name);
    DBMS_OUTPUT.PUT_LINE('급여' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉' || v_annual);
END;
/
--2)별도 연산
DECLARE
    v_ename employees.first_name%TYPE; 
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT first_name, salary, commission_pct
    INTO v_ename, v_sal, v_comm
    FROM employees
    WHERE employee_id = &사원번호;
    
    v_annual := v_sal *12 +NVL(v_sal,0) * NVL(v_comm,0) *12;
    
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉' || v_annual);
END;
/

-- IF 표현식 예제


BEGIN
    DELETE FROM test_employees
    WHERE employee_id =&사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원은 존재하지 않습니다.');
    END IF;
END;
/

--IF ~ ELSE 문 :팀장급
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count
    FROM employees
    WHERE manager_id = &사원번호;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반사원입니다');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('팀장입니다');
    END IF;
END;
/

--IF ~ELSE ~ ELSE 문 : 연차
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id =&사원번호;
    
    -- 각 조건에서 가질수 있는 최솟값과 최댓값의 범위 산출
    IF  v_hdate <1 THEN 
        --1보다 작은 실수 값
        DBMS_OUTPUT.PUT_LINE('입사한지 1년 미만입니다');
    ELSIF v_hdate <3 THEN
        --1보다 크거나 같고 3보다 작은 실수 값
        DBMS_OUTPUT.PUT_LINE('입사한지 3년 미만입니다');
    ELSIF v_hdate <5 THEN
        --3보다 크거나 같고 5보다 작은 실수 값
        DBMS_OUTPUT.PUT_LINE('입사한지 5년 미만입니다');
    ELSE
        -- 5보다 큰 실수 값
        DBMS_OUTPUT.PUT_LINE('입사한지 5년 이상입니다');
    END IF;
END;
/

--연습문제1
--사원번호를 입력(치환변수사용&) 할 경우 입사일이 2005년 이후(2005년 포함) 이면 'New employee' 이전이면 'Career employee' 출력
--내가 한것
DECLARE
    hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO hdate
    FROM employees
    WHERE employee_id =&사원번호;
    
    IF to_char(hdate,'YYYY') >= 2005 THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/
--교수님 한것
DECLARE 
    
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id =v_empid;
    
    IF v_hdate >= TO_DATE('05-01-01','YY-MM-DD') THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/
--연습문제2
--사원번호를 입력(치환변수사용&) 할 경우 입사일이 2005년 이후(2005년 포함) 이면 'New employee' 이전이면 'Career employee' 출력
-- 단 DBMS_OUTPUT.PUT_LINE 하나만 사용
--내가 한것
DECLARE
    hdate employees.hire_date%TYPE;
    message VARCHAR2(100);
BEGIN
    SELECT hire_date
    INTO hdate
    FROM employees
    WHERE employee_id =&사원번호;
    
    IF to_char(hdate,'YYYY') >= '2005' THEN
        message := 'New employee';
    ELSE
        message := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(message);
END;
/
--교수님 한것
/*
3-1.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
      2005년 이전이면 'Career employee' 출력
 */
 
DECLARE
    v_empid employees.employee_id%TYPE := &사원번호;
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = v_empid;
    
    IF v_hdate >= TO_DATE('05-01-01', 'yy-MM-dd') THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Careear employee');
    END IF;
END;
/


/*
3-2.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
      2005년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/
DECLARE
   v_empid employees.employee_id%TYPE := &사원번호;
   v_hdate employees.hire_date%TYPE;
   v_message VARCHAR2(100);
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = v_empid;

    IF TO_CHAR(v_hdate, 'yyyy') > '2004' THEN
        v_message := 'New employee';
    ELSE
        v_message := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/

--문제 4번
/* 4. 
사원번호를 입력(치환변수& 사용)할 경우
부서별로 구분하여 각각의 테이블에 입력하는 PL/SQL 블록을 작성하시오.
단, 해당 부서가 없는 사원은 emp00 테이블에 입력하시오.
   : 부서번호10->emp10, 부서번호20->emp20 ....
emp20
emp30
emp40
emp50
emp00

   */
   
create table emp10(empid, ename, hiredate)
as
  select employee_id, first_name, hire_date
  from   employees
  where  employee_id = 0;

DECLARE
    deptid employees.department_id%TYPE;
    empid employees.employee_id%TYPE := &사원번호;
    ename employees.first_name%TYPE;
    hdate employees.hire_date%TYPE;
BEGIN
    SELECT department_id, first_name,hire_date
    INTO deptid, ename, hdate
    FROM employees
    WHERE employee_id = empid;
    
    IF deptid = 10 THEN
        INSERT INTO emp10
        values (empid, ename, hdate);
    ELSIF deptid = 20 THEN
        INSERT INTO emp20
        values (empid, ename, hdate);
    ELSIF deptid = 30 THEN
        INSERT INTO emp30
        values (empid, ename, hdate);
    ELSIF deptid = 40 THEN
        INSERT INTO emp40
        values (empid, ename, hdate);
    ELSIF deptid = 50 THEN
        INSERT INTO emp50
        values (empid, ename, hdate);
    ELSE
        INSERT INTO emp00
        values (empid, ename, hdate);
    END IF;  
END;
/
--교수님
-- 1) INSERT문 반복
DECLARE
    v_empid employees.employee_id%TYPE := &사원번호;
    v_ename employees.first_name%TYPE;
    v_hdate employees.hire_date%TYPe;
    v_deptid employees.department_id%TYPE;
BEGIN
    SELECT first_name, hire_date, department_id
    INTO v_ename, v_hdate, v_deptid
    FROM employees
    WHERE employee_id = v_empid;
    
    IF v_deptid = 10 THEN
        INSERT INTO emp10
        VALUES (v_empid, v_ename, v_hdate);
    ELSIF v_deptid = 20 THEN
        INSERT INTO emp20
        VALUES (v_empid, v_ename, v_hdate);
    ELSIF v_deptid = 30 THEN
        INSERT INTO emp30
        VALUES (v_empid, v_ename, v_hdate);
    ELSIF v_deptid = 40 THEN
        INSERT INTO emp40
        VALUES (v_empid, v_ename, v_hdate);
    ELSIF v_deptid = 50 THEN
        INSERT INTO emp50
        VALUES (v_empid, v_ename, v_hdate);
    ELSE
        INSERT INTO emp00
        VALUES (v_empid, v_ename, v_hdate);
    END IF;    
END;
/

SELECT * FROM emp00;


-- 2) 동적 쿼리
DECLARE
    v_empid employees.employee_id%TYPE := &사원번호;
    v_ename employees.first_name%TYPE;
    v_hdate employees.hire_date%TYPe;
    v_deptid employees.department_id%TYPE;
    v_sql VARCHAR2(100);
BEGIN
    SELECT first_name, hire_date, TRUNC(department_id/10)
    INTO v_ename, v_hdate, v_deptid
    FROM employees
    WHERE employee_id = v_empid;
    
    IF  v_deptid BETWEEN 1 AND 5 THEN
        v_sql := 'INSERT INTO emp' || (v_deptid * 10);
        v_sql := v_sql || ' VALUES (' || v_empid || ', ''' || v_ename || ''', ''' || v_hdate || ''')';
        DBMS_OUTPUT.PUT_LINE(v_sql);
        EXECUTE IMMEDIATE v_sql;
    ELSE
        INSERT INTO emp00
        VALUES (v_empid, v_ename, v_hdate);
    END IF;    
END;
/


/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오
*/

DECLARE
    v_ename employees.first_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER := 0;
BEGIN
    SELECT first_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || (v_sal * (1 + v_raise/100)));
     
END;
/