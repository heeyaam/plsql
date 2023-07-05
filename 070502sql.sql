SET SERVEROUTPUT ON

--�̹� ���� �Ǿ��ְ� �̸��� �����ϴ� ���ܻ�Ȳ
DECLARE
    v_ename employees.first_name%TYPE;
BEGIN
    SELECT first_name
    INTO v_ename
    FROM employees
    WHERE department_id =&�μ���ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �������� �ʽ��ϴ�.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� �������� ����� �����մϴ�');
        DBMS_OUTPUT.PUT_LINE('����� ����Ǿ����ϴ�');
    
END;
/

--�̹� ���Ǵ� �Ǿ������� �̸��� �������� �ʴ� ���
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('�ٸ� ���̺��� ����ϰ� �ֽ��ϴ�');
END;
/

--����� ���� ����
DECLARE
    e_dept_del_fail EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id =&�μ���ȣ;

    IF SQL%ROWCOUNT =0 THEN
        RAISE e_dept_del_fail;
    END IF;
EXCEPTION
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ� �μ���ȣ�� Ȯ���� �ּ���');
END;
/


--���� Ʈ�� �Լ�
DECLARE
    e_too_many EXCEPTION;
    
    v_ex_code NUMBER;
    v_ex_mag VARCHAR2(1000);
    emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info
    FROM employees
    WHERE department_id =&�μ���ȣ;
    
    IF emp_info.salary < (emp_info.salary * emp_info.commission_pct +10000) THEN
        RAISE e_too_many;
    END IF;
EXCEPTION
    WHEN e_too_many THEN
        DBMS_OUTPUT.PUT_LINE('����� ���� ���� �߻�');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_mag := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('ORA' ||  v_ex_code);
        DBMS_OUTPUT.PUT_LINE('-' ||  v_ex_mag);
END;
/

--���� 1) test_employees ���̺��� ����Ͽ� ���õ� ����� �����ϴ� �� �ۼ�
--���� 1) ġȯ���� ���
--���� 2) ����� ���� ��� '�ش����� �����ϴ�' �޼��� ��� -> ����� ���� ���ܻ���

DECLARE
    e_emp_no_found exception; 
  
BEGIN
    DELETE FROM test_employees
    WHERE employee_id = &�����ȣ;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_no_found;
    END IF;
EXCEPTION
    WHEN e_emp_no_found THEN
    DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�');
END;
/

-- IN ���
--���ν����� ���밡�� �ϱ⿡ �̸��� �־����
--���ν����� is �� ����鼭 DECLARE ��� ��õǴ� �κ��� ����
CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE)
IS 
--����� : ���ο��� �����ϴ� ���� , Ŀ�� ,Ÿ�� ,����
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
    
    -- P_NUM :=9876;   �Ű������� ����϶��� ���� ������ ������.
END;
/

DECLARE
    v_result NUMBER := 1234;
BEGIN
    test_pro(1000, v_result);
    DBMS_OUTPUT.PUT_LINE('result : ' || v_result);
END;
/

--OUT �Ű� ����
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
    v_eid NUMBER := &�����ȣ;
BEGIN
    select_emp(v_eid, v_ename, v_sal, v_comm);
    
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    DBMS_OUTPUT.PUT_LINE(v_sal);
    DBMS_OUTPUT.PUT_LINE(v_comm);
END;
/

--in out �Ű�����
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