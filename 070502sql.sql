SET SERVEROUTPUT ON

--이미 정의 되어있고 이름도 존재하는 예외상황
DECLARE
    v_ename employees.first_name%TYPE;
BEGIN
    SELECT first_name
    INTO v_ename
    FROM employees
    WHERE department_id =&부서번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 존재하지 않습니다.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다');
        DBMS_OUTPUT.PUT_LINE('블록이 종료되었습니다');
    
END;
/

--이미 정의는 되어있지만 이름이 존재하지 않는 경우
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('다른 테이블에서 사용하고 있습니다');
END;
/

--사용자 정의 예외
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id =&부서번호;

    IF SQL%ROWCOUNT =0 THEN
        RAISE e_dept_del_fail;
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다 부서번호를 확인해 주세여');
END;
/


--예외 트랩 함수
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_mag VARCHAR2(1000);
    emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info
    FROM employees
    WHERE department_id =&부서번호;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct +10000) THEN
        RAISE e_too_many;
    END IF;
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('사용장 정의 예외 발생');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_mag := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA' ||  v_ex_code);
        DBMS_OUTPUT.PUT_LINE('-' ||  v_ex_mag);
END;
/

--문제 1) test_employees 테이블을 사용하여 선택된 사원을 삭제하는 문 작성
--조건 1) 치환변수 사용
--조건 2) 사원이 없는 경우 '해당사원이 없습니다' 메세지 출력 -> 사용자 정의 예외사항

DECLARE
    e_emp_no_found exception; 
  
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &사원번호;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_no_found;
    END IF;
EXCEPTION
    WHEN e_emp_no_found THEN
    DBMS_OUTPUT.PUT_LINE('해당 사원은 없습니다');
END;
/

-- IN 모드
--프로시저는 재사용가능 하기에 이름이 있어야함
--프로시저는 is 가 생기면서 DECLARE 라고 명시되는 부분이 빠짐
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS 
--선언부 : 내부에서 선언하는 변수 , 커서 ,타입 ,예외
BEGIN
    UPDATE employees
    SET salary = salary *1.1
    WHERE employee_id = p_eid;
END;
/

BEGIN
    raise_salary(100);
END;
/
select * from employees where employee_id =100;

CREATE OR REPLACE PROCEDURE test_pro
(p_num IN NUMBER,
 p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    v_sum := p_num + p_result;
    p_result := v_sum;
    
    -- P_NUM :=9876;   매개변수가 상수일때는 값을 변경할 수없다.
END;
/

DECLARE
    v_result NUMBER := 1234;
BEGIN
    test_pro(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('result : ' || v_result);
END;
/

--OUT 매개 변수
CREATE OR REPLACE PROCEDURE select_emp
(p_eid IN employees.employee_id%TYPE,
 p_ename OUT employees.first_name%type,
 p_sal OUT employees.salary%type,
 p_comm OUT employees.commission_pct%type)
IS

BEGIN
    SELECT first_name, salary, commission_pct
    INTO p_ename, p_sal, p_comm
    FROM employees
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_ename VARCHAR2(100 char);
    v_sal NUMBER;
    v_comm NUMBER;
    v_eid NUMBER := &사원번호;
BEGIN
    select_emp(v_eid, v_ename, v_sal, v_comm);
    
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_comm);
END;
/

--in out 매개변수
-- '0539405000' -> '(053)940-5000'
CREATE OR REPLACE PROCEDURE format_phone
(v_phone_no IN OUT VARCHAR2)
IS

BEGIN
    v_phone_no := '('|| SUBSTR(v_phone_no,1,3) ||')' || SUBSTR(v_phone_no,4,3) ||'-'||SUBSTR(v_phone_no,7);
END;
/

VARIABLE g_phone_no VARCHAR2(100);
EXECUTE :g_phone_no :='0539405000';
PRINT g_phone_no;

EXECUTE format_phone(:g_phone_no);
PRINT g_phone_no;

drop PROCEDURE test_pro;

-- 1번 숙제 포로시저 in mode
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
--선언부 : 내부에서 사용할 변수 , 타입, 커서 등 선언
    v_result VARCHAR2(100);
BEGIN
    -- v_result := substr(p_ssn,1,6) || '-'||substr(p_ssn,7,1) || '******';
    v_result := substr(p_ssn,1,6) || '-'||RPAD(substr(p_ssn,7,1),7,'*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('111111777777');

--2번 숙제

CREATE OR REPLACE PROCEDURE test_pro
(p_eid employees.employee_id%type)
IS

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당사원은 없습니다');
    END IF;
END;
/

EXECUTE test_pro(0);

--3번
--입력 : 사원번호 -> 출력 :사원이름 => SELECT
--2) 사원이름 : 정해진 포멧으로 전환
--내가한것
CREATE OR REPLACE PROCEDURE yedam_emp
(v_eid IN employees.employee_id%type)
IS
    v_ename employees.last_name%type;
BEGIN
    --조회 : 사원번호 -> 사원이름
    SELECT last_name 
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE(v_ename || '->' || RPAD(substr(v_ename,1,1),length(v_ename),'*'));
END;
/
EXECUTE yedam_emp(100);

--4번
-- 1) 입력은 부서번호 -?> 출력은 사원번호, 사원이름 =>
-- 2) 예외사항 : 사원이 없는 경우 -> "해당 부서에는 사원이 없습니다.") C출력
CREATE OR REPLACE PROCEDURE get_emp 
(v_deptid IN employees.department_id%type)
IS
    CURSOR v_emp_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = v_deptid;
    
    v_info v_emp_cursor%ROWTYPE;
    
    emp_no EXCEPTION;
BEGIN
    OPEN v_emp_cursor;
    
    LOOP
        FETCH v_emp_cursor INTO v_info;
        EXIT WHEN v_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('사원번호: '||v_info.employee_id ||', 사원이름 : ' ||v_info.last_name);
    END LOOP;
    
    IF v_emp_cursor%ROWCOUNT =0 THEN
        RAISE emp_no;
    END IF;
    
    CLOSE v_emp_cursor;
    
EXCEPTION
    WHEN emp_no THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다');
END;
/

EXECUTE get_emp(800);

--5번
CREATE OR REPLACE PROCEDURE  y_update
    (v_empid IN employees.employee_id%type,
     v_raise IN NUMBER)
IS
 e_no_emp EXCEPTION;
BEGIN
    UPDATE employees SET salary=salary+salary*(v_raise/100) 
    WHERE employee_id = v_empid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
exception
    when e_no_emp then
     DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/
select * from employees where employee_id =200;
EXECUTE y_update(200, 10);


--교수님...
/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
*/

-- 프로시저, IN 매개변수 하나
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
-- 선언부 : 내부에서 사용할 변수, 타입, 커서 등
    v_result VARCHAR2(100);
BEGIN
    -- v_result := SUBSTR(p_ssn, 1, 6) || '-' || SUBSTR(p_ssn, 7, 1) || '******';
    v_result := SUBSTR(p_ssn, 1, 6) || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('0511013689977');

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/

CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
IS 

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 없습니다.');
    END IF;
END;
/

EXECUTE TEST_PRO(0);

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/

-- 1) 입력 : 사원번호  -> 출력 : 사원이름  => SELECT 
-- 2) 사원이름 : 정해진 포맷으로 변환


CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE) -- 입력 : 사원번호 => IN 매개변수
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    -- 조회 : 사원번호 -> 사원이름
    SELECT last_name
    INTO v_ename -- 변수 : VARCHAR2
    FROM employees
    WHERE employee_id = p_eid;
    
    -- 이름 : 첫번째 글자 제외 나머지 글자 *로 변환
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*' ); -- 변수 : VARCHAR2
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
-- 1) 입력 : 부서번호 -> 출력 : 사원번호, 사원이름 => 커서
-- 2) 예외사항 : 사원이 없는 경우 -> "해당 부서에는 사원이 없습니다." 출력

CREATE PROCEDURE get_emp
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_info dept_cursor%ROWTYPE;
    
    e_no_emp EXCEPTION;
BEGIN
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO emp_info;
        EXIT WHEN dept_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(emp_info.employee_id || ', ' || emp_info.last_name);
    END LOOP;
    
    IF dept_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE dept_cursor;    
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
END;
/
EXECUTE get_emp(0);


/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/

-- 1) 입력 : 사원번호, 급여증가치 -> UPDATE
-- 2) 예외사항 : 사원이 없는 경우 ‘No search employee!!’ 출력

CREATE PROCEDURE y_update
( p_eid IN employees.employee_id%TYPE,
  p_raise IN NUMBER )
IS
    e_no_emp EXCEPTION;
BEGIN
    UPDATE employees
    -- SET salary = salary + salary * (p_raise/100)
    SET salary = salary * ( 1 + (p_raise/100) )
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

SELECT * FROM employees WHERE employee_id = 200;

EXECUTE y_update(0, 10);

/*
6.
다음과 같이 테이블을 생성하시오.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
6-1.
부서번호를 입력하면 사원들 중에서 입사년도가 2005년 이전 입사한 사원은 yedam01 테이블에 입력하고,
입사년도가 2005년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.

-- 1) 입력 : 부서번호 -> 조회 : 사원정보(사원번호, 사원이름, 입사일자) => 커서
-- 2) 각 사원의 입사년도를 기준으로 두개의 테이블에 등록 : 조건 - 2005년 이전/ 2005년 포함 이후
--    => IF문 + INSERT문
 
6-2.
1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리
2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
*/

create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));

CREATE PROCEDURE y_proc
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR dept_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_info dept_cursor%ROWTYPE;
    v_deptno departments.department_id%TYPE;
    
    e_no_emp EXCEPTION;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM departments
    WHERE department_id = p_deptno;
    
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO emp_info;
        EXIT WHEN dept_cursor%NOTFOUND;
        
        IF emp_info.hire_date < TO_DATE('05/01/01', 'rr/MM/dd') THEN
            INSERT INTO yedam01
            VALUES (emp_info.employee_id, emp_info.last_name);
        ELSE
            INSERT INTO yedam02
            VALUES (emp_info.employee_id, emp_info.last_name);
        END IF;
       
    END LOOP;
    
    IF dept_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE dept_cursor;   
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
END;
/

