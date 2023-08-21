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

-- 1�� ���� ���ν��� in mode
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
--����� : ���ο��� ����� ���� , Ÿ��, Ŀ�� �� ����
    v_result VARCHAR2(100);
BEGIN
    -- v_result := substr(p_ssn,1,6) || '-'||substr(p_ssn,7,1) || '******';
    v_result := substr(p_ssn,1,6) || '-'||RPAD(substr(p_ssn,7,1),7,'*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_ju('111111777777');

--2�� ����

CREATE OR REPLACE PROCEDURE test_pro
(p_eid employees.employee_id%type)
IS

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�');
    END IF;
END;
/

EXECUTE test_pro(0);

--3��
--�Է� : �����ȣ -> ��� :����̸� => SELECT
--2) ����̸� : ������ �������� ��ȯ
--�����Ѱ�
CREATE OR REPLACE PROCEDURE yedam_emp
(v_eid IN employees.employee_id%type)
IS
    v_ename employees.last_name%type;
BEGIN
    --��ȸ : �����ȣ -> ����̸�
    SELECT last_name 
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE(v_ename || '->' || RPAD(substr(v_ename,1,1),length(v_ename),'*'));
END;
/
EXECUTE yedam_emp(100);

--4��
-- 1) �Է��� �μ���ȣ -?> ����� �����ȣ, ����̸� =>
-- 2) ���ܻ��� : ����� ���� ��� -> "�ش� �μ����� ����� �����ϴ�.") C���
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
        
        DBMS_OUTPUT.PUT_LINE('�����ȣ: '||v_info.employee_id ||', ����̸� : ' ||v_info.last_name);
    END LOOP;
    
    IF v_emp_cursor%ROWCOUNT =0 THEN
        RAISE emp_no;
    END IF;
    
    CLOSE v_emp_cursor;
    
EXCEPTION
    WHEN emp_no THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�');
END;
/

EXECUTE get_emp(800);

--5��
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


--������...
/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
*/

-- ���ν���, IN �Ű����� �ϳ�
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
-- ����� : ���ο��� ����� ����, Ÿ��, Ŀ�� ��
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
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/

CREATE PROCEDURE test_pro
(p_eid employees.employee_id%TYPE)
IS 

BEGIN
    DELETE FROM test_employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�.');
    END IF;
END;
/

EXECUTE TEST_PRO(0);

/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
*/

-- 1) �Է� : �����ȣ  -> ��� : ����̸�  => SELECT 
-- 2) ����̸� : ������ �������� ��ȯ


CREATE PROCEDURE yedam_emp
(p_eid IN employees.employee_id%TYPE) -- �Է� : �����ȣ => IN �Ű�����
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    -- ��ȸ : �����ȣ -> ����̸�
    SELECT last_name
    INTO v_ename -- ���� : VARCHAR2
    FROM employees
    WHERE employee_id = p_eid;
    
    -- �̸� : ù��° ���� ���� ������ ���� *�� ��ȯ
    v_result := RPAD(SUBSTR(v_ename, 1, 1), LENGTH(v_ename), '*' ); -- ���� : VARCHAR2
    
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

/*
4.
�μ���ȣ�� �Է��� ��� 
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name)�� ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
*/
-- 1) �Է� : �μ���ȣ -> ��� : �����ȣ, ����̸� => Ŀ��
-- 2) ���ܻ��� : ����� ���� ��� -> "�ش� �μ����� ����� �����ϴ�." ���

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
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
END;
/
EXECUTE get_emp(0);


/*
5.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/

-- 1) �Է� : �����ȣ, �޿�����ġ -> UPDATE
-- 2) ���ܻ��� : ����� ���� ��� ��No search employee!!�� ���

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
������ ���� ���̺��� �����Ͻÿ�.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
6-1.
�μ���ȣ�� �Է��ϸ� ����� �߿��� �Ի�⵵�� 2005�� ���� �Ի��� ����� yedam01 ���̺� �Է��ϰ�,
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� yedam02 ���̺� �Է��ϴ� y_proc ���ν����� �����Ͻÿ�.

-- 1) �Է� : �μ���ȣ -> ��ȸ : �������(�����ȣ, ����̸�, �Ի�����) => Ŀ��
-- 2) �� ����� �Ի�⵵�� �������� �ΰ��� ���̺� ��� : ���� - 2005�� ����/ 2005�� ���� ����
--    => IF�� + INSERT��
 
6-2.
1. ��, �μ���ȣ�� ���� ��� "�ش�μ��� �����ϴ�" ����ó��
2. ��, �ش��ϴ� �μ��� ����� ���� ��� "�ش�μ��� ����� �����ϴ�" ����ó��
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
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
END;
/

