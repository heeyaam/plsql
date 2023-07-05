SET SERVEROUTPUT ON
DECLARE
--1)정의를 해주고
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0) NOT NULL :=100,
         ename employees.first_name%TYPE,
         sal employees.salary%TYPE);
--2)선언을 해줘야 사용가능
    emp_info emp_record_type;
    emp_record emp_record_type;
BEGIN

    SELECT employee_id, first_name, salary
    INTO emp_info
    FROM employees
    WHERE employee_id=&사원번호;

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || emp_info.empno);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || emp_info.ename);
    DBMS_OUTPUT.PUT_LINE('급여 :' || emp_info.sal);
    
    SELECT department_id, job_id, salary
    INTO emp_info
    FROM employees
    WHERE employee_id=&사원번호;

    DBMS_OUTPUT.PUT('사원번호 : ' || emp_info.empno);
    DBMS_OUTPUT.PUT('사원이름 : ' || emp_info.ename);
    DBMS_OUTPUT.PUT_LINE('급여 :' || emp_info.sal);

END;
/

DECLARE
    emp_record employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_record
    FROM employees
    WHERE employee_id =&사원번호;

    DBMS_OUTPUT.PUT_LINE(emp_record.employee_id);
    DBMS_OUTPUT.PUT_LINE(emp_record.last_name);
    DBMS_OUTPUT.PUT_LINE(emp_record.job_id );
END;
/


--TABLED
DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
        num_info num_table_type;
BEGIN
--index는 0부터라는 개념이 없다.
    num_info(10) := 1000;
    DBMS_OUTPUT.PUT_LINE(num_info(10));
    
    FOR idx IN 1..10 LOOP
        num_info(TRUNC(idx/2)) := idx;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(num_info(0));
END;
/


DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
        
    num_table num_table_type;
    v_total NUMBER(2,0);
BEGIN
--정수 1~50사이에 존재하는 2의 배수를 따로 NUM_TABLE 에 담고 총 몇개인지 출력
    FOR idx IN 1..50 LOOP
        IF MOD(idx, 2) <>0 THEN
            CONTINUE;
        END IF;
        
        num_table(idx):=idx;
    END LOOP;
    v_total :=num_table.COUNT;
    DBMS_OUTPUT.PUT_LINE(v_total);
    
--2)실제로 num_table 내에 존재하는 모든숫자를 출력
    FOR idx IN num_table.FIRST .. num_table.LAST LOOP
        IF num_table.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(num_table(idx));
        END IF;
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('============================');
     
--3의 배수 삭제
-- 내가 한것
    FOR idx IN num_table.FIRST .. num_table.LAST LOOP
        IF num_table.EXISTS(idx) THEN
            IF MOD(num_table(idx),3)=0 THEN
            num_table.DELETE(idx);
            ELSE
            DBMS_OUTPUT.PUT_LINE(num_table(idx));
            END IF;
        END IF;
    END LOOP;
    v_total :=num_table.COUNT;
     DBMS_OUTPUT.PUT_LINE('============================');
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

DECLARE
    v_min employees.employee_id%TYPE; -- 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원 번호
    v_result NUMBER(1,0);             -- 사원의 존재 유무를 확인
    emp_record employees%ROWTYPE;     -- employees 테이블의 한행에 대응 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    --최소사원번호 와 최대 사원번호가 필요
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;
    END LOOP;
    
    FOR eid IN emp_table.FIRST..emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id ||',');
            DBMS_OUTPUT.PUT(emp_table(eid).first_name ||',');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).hire_date);
        END IF;
    END LOOP;
END;
/

--CURSOR
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees;
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor;
    
    FETCH emp_cursor INTO v_eid, v_ename;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || ',' ||v_ename);

    CLOSE emp_cursor;
END;
/

DECLARE
    v_min employees.employee_id%TYPE; -- 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원 번호
    v_result NUMBER(1,0);             -- 사원의 존재 유무를 확인
    emp_record employees%ROWTYPE;     -- employees 테이블의 한행에 대응 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    --최소사원번호 와 최대 사원번호가 필요
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;
    END LOOP;
    
    FOR eid IN emp_table.FIRST..emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id ||',');
            DBMS_OUTPUT.PUT(emp_table(eid).first_name ||',');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).hire_date);
        END IF;
    END LOOP;
END;
/

--CURSOR
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees;
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_eid, v_ename;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_eid || ',' ||v_ename);
    END LOOP;
    --커서는 더이상 내려갈 곳이 없기에 돌지 않고 마지막 행을 계속 출력함 
        FETCH emp_cursor INTO v_eid, v_ename;
         DBMS_OUTPUT.PUT_LINE(v_eid || ',' ||v_ename);
    --커서 끝나고 더 출력하고 마지막행 출력이 반복되도 ROWCOUNT에는 영향을 주지 않음
    DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
    CLOSE emp_cursor;
END;
/

--1) 모든사원 번호, 이름 , 부서이름 출력
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, department_name
        FROM employees e join departments d
                            on (e.department_id = d.department_id);
    v_eid employees.employee_id%type;
    v_ename employees.first_name%type;
    v_dept_name departments.department_name%type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_eid,v_ename, v_dept_name;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(v_eid || ',' || v_ename || ',' ||v_dept_name);
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

--2) 부서 번호 50, 80인 사원 이름. 급여 연봉 출력
DECLARE
    CURSOR emp_cursor IS
        SELECT first_name, 
                salary,
                NVL(salary,0)*12 + NVL(salary,0) * NVL(commission_pct,0)*12 as annual 
        FROM employees
        WHERE  department_id IN(50,80);
    emp_info emp_cursor%ROWTYPE;

BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(emp_info.first_name || ',' || emp_info.salary || ',' ||emp_info.annual);
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

--2)사원이름 , 급여 커미션으로 제한
DECLARE
    CURSOR emp_cursor IS
        SELECT first_name, salary, commission_pct
        FROM employees
        WHERE department_id IN(50,80);
        
        ename employees.first_name%type;
        sal employees.salary%type;
        comm employees.commission_pct%type;
        annual sal%TYPE;
BEGIN
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO ename, sal, comm;
            EXIT WHEN emp_cursor%NOTFOUND;
            
            annual :=  NVL(sal,0)*12 + NVL(sal,0) * NVL(comm,0)*12;
            DBMS_OUTPUT.PUT_LINE('이름'||ename||', 월급'||sal ||', 연봉'||annual);
        END LOOP;
    
    CLOSE emp_cursor;
END;
/

--  커서 FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees;
    
    CURSOR DEPT_EMP_CURSOR IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id ||','|| emp_record.last_name);
    END LOOP;
    --  DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
    
    FOR emp_info IN dept_emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(dept_emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE(emp_info.employee_id ||','|| emp_info.last_name);
    END LOOP;
END;
/

--10)모든 사원의 사원번호, 이름, 부서이름 출력
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, department_name
        FROM employees e join departments d
                        ON(e.department_id = d.department_id);
BEGIN
    FOR emp_record IN  emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id ||','||emp_record.last_name ||','||emp_record.department_name);
    END LOOP;
END;
/
--2. 부서번호가 50이거나 80인 사람의 이름 급여 연봉
DECLARE
    CURSOR emp_cursor IS
        SELECT first_name, 
                salary,
                NVL(salary,0)*12 + NVL(salary,0) * NVL(commission_pct,0)*12 as annual 
        FROM employees
        WHERE  department_id IN(50,80);
BEGIN
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.first_name ||','|| emp_record.salary||','|| emp_record.annual);
    END LOOP;
END;
/

BEGIN
    FOR emp_info IN (SELECT last_name FROM employees) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
    END LOOP;
END;
/

DECLARE
    CURSOR emp_cursor 
    (p_mgr employees.manager_id%TYPE)IS
        SELECT *
        FROM employees
        WHERE manager_id = p_mgr;
        
        emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor(100);--매개변수가 가지는 값을 오픈할때만 같이 주어야함 
    
    LOOP 
        FETCH emp_cursor  INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id ||','|| emp_record.first_name);
    END LOOP;
    CLOSE emp_cursor ;
    
    DBMS_OUTPUT.PUT_LINE('===================================');
    
    --for 에서 매개변수를 범위로 주면 됨
    FOR emp_info IN emp_cursor(149) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_info.employee_id ||','|| emp_info.first_name);
    END LOOP;
END;
/

--FOR UPDATE, WHERE CURRENT OF
DECLARE
    CURSOR sal_emp_cursor IS
        SELECT salary, commission_pct
        FROM employees
        WHERE department_id = 30
        FOR UPDATE NOWAIT;
BEGIN
    FOR sal_emp IN sal_emp_cursor LOOP
        IF sal_emp.commission_pct IS NULL THEN
            UPDATE employees
            SET salary = sal_emp.salary *1.1
            WHERE CURRENT OF sal_emp_cursor;
        ELSE
            UPDATE employees
            SET salary =sal_emp.salary + sal_emp.salary * sal_emp.commission_pct
            WHERE CURRENT OF sal_emp_cursor;
        END IF;
    END LOOP;

END;
/

--커서를 사용해서 employees 에 있는모든 정보를 한변수에 담기
DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;
      emp_record emp_cursor%ROWTYPE;
      
      TYPE emp_table_type IS TABLE OF emp_cursor%ROWTYPE
        INDEX BY PLS_INTEGER;
        
    emp_table_info emp_table_type;
BEGIN
    OPEN emp_cursor;
        LOOP 
            FETCH emp_cursor  INTO emp_record;
             EXIT WHEN emp_cursor%NOTFOUND;
             
             emp_table_info(emp_record.employee_id) := emp_record;
        END LOOP ;
    
    CLOSE emp_cursor;
    DBMS_OUTPUT.PUT_LINE(emp_table_info.COUNT);
    FOR idx IN emp_table_info.FIRST..emp_table_info.LAST LOOP
        IF NOT 
        emp_table_info.EXISTS(idx) THEN
            CONTINUE;
        END IF;
        
        emp_record :=emp_table_info(idx);
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id || ','|| emp_record.first_name);
    END LOOP;
END;
/
/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.
입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
1-1) 명시적 커서 + 기본 LOOP 사용
1-2) 커서 FOR LOOP 사용
*/
CREATE TABLE test01
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;
	
CREATE TABLE test02
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;

-- 문제1-1)
DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;
    emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_record;
        IF to_char(emp_record.hire_date,'yyyy') < '2005' THEN
            INSERT INTO test01 VALUES(emp_record.employee_id, emp_record.first_name,emp_record.hire_date);
        ELSE
            INSERT INTO test02 VALUES(emp_record.employee_id, emp_record.first_name,emp_record.hire_date);
        END IF;
        EXIT WHEN emp_cursor%NOTFOUND;
    END LOOP;
         CLOSE emp_cursor;
END;
/
SELECT * FROM test01 order by hire_date;
SELECT * FROM test02 order by hire_date;
DELETE FROM test02;

--문제1-2)
DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;
        
BEGIN
    FOR emp_record IN emp_cursor LOOP
    FETCH emp_cursor INTO emp_record;
        IF to_char(emp_kind.hire_date,'yyyy') < '2005' THEN
            INSERT INTO test01 VALUES(emp_kind.employee_id, emp_kind.first_name,emp_kind.hire_date);
        ELSE
            INSERT INTO test02 VALUES(emp_kind.employee_id, emp_kind.first_name,emp_kind.hire_date);
        END IF;
    END LOOP;
END;
/
/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
(단, cursor 사용)
*/


  


--교수님 답안
/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.
입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력

*/
CREATE TABLE test01
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;
	
CREATE TABLE test02
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;

-- 1-1) 명시적 커서 + 기본 LOOP 사용
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, hire_date
        FROM employees;
    
    emp_record emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        -- 커서가 가리키는 한행을 기준으로 실행하고자 하는 부분  
        IF TO_CHAR(emp_record.hire_date, 'yyyy') <= '2005' THEN
            INSERT INTO test01 ( employee_id, first_name, hire_date )
            VALUES ( emp_record.employee_id, emp_record.first_name, emp_record.hire_date );
        ELSE
            INSERT INTO test02
            VALUES emp_record;
        END IF;  
    END LOOP;
    
    CLOSE emp_cursor;

END;
/


-- 1-2) 커서 FOR LOOP 사용
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, hire_date
        FROM employees;

BEGIN
    FOR emp_record IN emp_cursor LOOP        
       IF TO_CHAR(emp_record.hire_date, 'yyyy') <= '2005' THEN
            INSERT INTO test01 ( employee_id, first_name, hire_date )
            VALUES ( emp_record.employee_id, emp_record.first_name, emp_record.hire_date );
        ELSE
            INSERT INTO test02
            VALUES emp_record;
        END IF;  
    END LOOP;
END;
/
SELECT * FROM test01;
SELECT * FROM test02;

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
(단, cursor 사용)
*/

-- 기본 LOOP
DECLARE
    v_deptid departments.department_id%TYPE := &부서번호;
    
    CURSOR dept_emp_cursor IS
        SELECT first_name, hire_date, department_name
        FROM employees e JOIN departments d
          ON e.department_id = d.department_id
        WHERE e.department_id = v_deptid;
   
   emp_info dept_emp_cursor%ROWTYPE;       
BEGIN
    OPEN dept_emp_cursor;
    
    DBMS_OUTPUT.PUT_LINE('========' || v_deptid || '========');
    LOOP
        FETCH dept_emp_cursor INTO emp_info;
        EXIT WHEN dept_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_info.first_name);
        DBMS_OUTPUT.PUT(', 입사일자 : ' || TO_CHAR(emp_info.hire_date, 'yyyy"년"MM"월"dd"일"'));
        DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || emp_info.department_name);
    END LOOP;
    
    CLOSE dept_emp_cursor;
END;
/

-- 커서 FOR LOOP
DECLARE
    v_deptid departments.department_id%TYPE := &부서번호;
    
    CURSOR dept_emp_cursor IS
    
        SELECT first_name, hire_date, department_name
        FROM employees e JOIN departments d
          ON e.department_id = d.department_id
        WHERE e.department_id = v_deptid;  
BEGIN
    DBMS_OUTPUT.PUT_LINE('========' || v_deptid || '========');
    FOR emp_info IN dept_emp_cursor LOOP     
        DBMS_OUTPUT.PUT('사원이름 : ' || emp_info.first_name);
        DBMS_OUTPUT.PUT(', 입사일자 : ' || TO_CHAR(emp_info.hire_date, 'yyyy"년"MM"월"dd"일"'));
        DBMS_OUTPUT.PUT_LINE(', 부서명 : ' || emp_info.department_name);
    END LOOP;
END;
/