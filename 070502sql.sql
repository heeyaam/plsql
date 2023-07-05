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