--dbms ������ ������ �����ϴ°� �׻� ù��°�� �����������
--DECLARE �� ����� ������ END �� �ɶ����� ����ִ�. �̸��� ������ ������ ���� ������� �켱������ ���ȴ�.
set serveroutput on

DECLARE
--<*��������� �̸� Ÿ�� ���� ���� �ְ� �ʹٸ� :�� �ٿ������
    v_sal NUMBER(7,2) := 60000;
    --����� ������ ��� Ÿ���� �Ʒ��� ����ü��ִ�. �̷��� �ݵ�� ����� Ÿ���� �����ؾ���
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
    WHERE employee_id =&�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('��� ��ȣ : ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('��� �̸� :' || v_empname);
END;
/

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE :=0.1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &�����ȣ;
    
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
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�');
    END IF;
    
    UPDATE test_employees
    SET salary =salary *1.1
    WHERE employee_id =&�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�');
    END IF;
    DBMS_OUTPUT.PUT_LINE('������'  || SQL%ROWCOUNT || '�� �����Ǿ����ϴ�.');
END;
/






--1�� ����
--1) ���� ���
DECLARE
    v_empid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_depname departments.department_name%TYPE;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO v_empid, v_name, v_depname
    FROM employees e join departments d
                    on(e.department_id = d.department_id)
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_name);
    DBMS_OUTPUT.PUT_LINE('�μ��̸�' || v_depname);
END;
/

--2)select 2�� ���
DECLARE
    v_empid employees.employee_id%TYPE;
    v_name employees.last_name%TYPE;
    v_depid employees.department_id%TYPE;
    v_depname departments.department_name%TYPE;
BEGIN
    select employee_id, last_name, department_id
    into v_empid, v_name, v_depid
    from employees
    WHERE employee_id = &�����ȣ;
    
    select department_name
    into v_depname
    from departments
    where department_id= v_depid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_name);
    DBMS_OUTPUT.PUT_LINE('�μ��̸�' || v_depname);
END;
/

--2�� ����
--1) SELECT ��
DECLARE
     v_name employees.last_name%TYPE;
     v_sal employees.salary%TYPE;
     v_annual employees.salary%TYPE;
BEGIN
    SELECT last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
    INTO v_name, v_sal, v_annual
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_name);
    DBMS_OUTPUT.PUT_LINE('�޿�' || v_sal);
    DBMS_OUTPUT.PUT_LINE('����' || v_annual);
END;
/
--2)���� ����
DECLARE
    v_ename employees.first_name%TYPE; 
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT first_name, salary, commission_pct
    INTO v_ename, v_sal, v_comm
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    v_annual := v_sal *12 +NVL(v_sal,0) * NVL(v_comm,0) *12;
    
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿�' || v_sal);
    DBMS_OUTPUT.PUT_LINE('����' || v_annual);
END;
/

-- IF ǥ���� ����


BEGIN
    DELETE FROM test_employees
    WHERE employee_id =&�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �������� �ʽ��ϴ�.');
    END IF;
END;
/

--IF ~ ELSE �� :�����
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count
    FROM employees
    WHERE manager_id = &�����ȣ;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ϲݻ���Դϴ�');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('�����Դϴ�');
    END IF;
END;
/

--IF ~ELSE ~ ELSE �� : ����
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    -- �� ���ǿ��� ������ �ִ� �ּڰ��� �ִ��� ���� ����
    IF  v_hdate <1 THEN 
        --1���� ���� �Ǽ� ��
        DBMS_OUTPUT.PUT_LINE('�Ի����� 1�� �̸��Դϴ�');
    ELSIF v_hdate <3 THEN
        --1���� ũ�ų� ���� 3���� ���� �Ǽ� ��
        DBMS_OUTPUT.PUT_LINE('�Ի����� 3�� �̸��Դϴ�');
    ELSIF v_hdate <5 THEN
        --3���� ũ�ų� ���� 5���� ���� �Ǽ� ��
        DBMS_OUTPUT.PUT_LINE('�Ի����� 5�� �̸��Դϴ�');
    ELSE
        -- 5���� ū �Ǽ� ��
        DBMS_OUTPUT.PUT_LINE('�Ի����� 5�� �̻��Դϴ�');
    END IF;
END;
/

--��������1
--�����ȣ�� �Է�(ġȯ�������&) �� ��� �Ի����� 2005�� ����(2005�� ����) �̸� 'New employee' �����̸� 'Career employee' ���
--���� �Ѱ�
DECLARE
    hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO hdate
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    IF to_char(hdate,'YYYY') >= 2005 THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/
--������ �Ѱ�
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
--��������2
--�����ȣ�� �Է�(ġȯ�������&) �� ��� �Ի����� 2005�� ����(2005�� ����) �̸� 'New employee' �����̸� 'Career employee' ���
-- �� DBMS_OUTPUT.PUT_LINE �ϳ��� ���
--���� �Ѱ�
DECLARE
    hdate employees.hire_date%TYPE;
    message VARCHAR2(100);
BEGIN
    SELECT hire_date
    INTO hdate
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    IF to_char(hdate,'YYYY') >= '2005' THEN
        message := 'New employee';
    ELSE
        message := 'Career employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(message);
END;
/
--������ �Ѱ�
/*
3-1.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2005�� ����(2005�� ����)�̸� 'New employee' ���
      2005�� �����̸� 'Career employee' ���
 */
 
DECLARE
    v_empid employees.employee_id%TYPE := &�����ȣ;
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
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2005�� ����(2005�� ����)�̸� 'New employee' ���
      2005�� �����̸� 'Career employee' ���
��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
*/
DECLARE
   v_empid employees.employee_id%TYPE := &�����ȣ;
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

--���� 4��
/* 4. 
�����ȣ�� �Է�(ġȯ����& ���)�� ���
�μ����� �����Ͽ� ������ ���̺� �Է��ϴ� PL/SQL ����� �ۼ��Ͻÿ�.
��, �ش� �μ��� ���� ����� emp00 ���̺� �Է��Ͻÿ�.
   : �μ���ȣ10->emp10, �μ���ȣ20->emp20 ....
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
    empid employees.employee_id%TYPE := &�����ȣ;
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
--������
-- 1) INSERT�� �ݺ�
DECLARE
    v_empid employees.employee_id%TYPE := &�����ȣ;
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


-- 2) ���� ����
DECLARE
    v_empid employees.employee_id%TYPE := &�����ȣ;
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
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�
*/

DECLARE
    v_ename employees.first_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER := 0;
BEGIN
    SELECT first_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('�λ�� �޿� : ' || (v_sal * (1 + v_raise/100)));
     
END;
/