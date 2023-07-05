SET SERVEROUTPUT ON
DECLARE
--1)���Ǹ� ���ְ�
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6,0) NOT NULL :=100,
         ename employees.first_name%TYPE,
         sal employees.salary%TYPE);
--2)������ ����� ��밡��
    emp_info emp_record_type;
    emp_record emp_record_type;
BEGIN

    SELECT employee_id, first_name, salary
    INTO emp_info
    FROM employees
    WHERE employee_id=&�����ȣ;

    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || emp_info.empno);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || emp_info.ename);
    DBMS_OUTPUT.PUT_LINE('�޿� :' || emp_info.sal);
    
    SELECT department_id, job_id, salary
    INTO emp_info
    FROM employees
    WHERE employee_id=&�����ȣ;

    DBMS_OUTPUT.PUT('�����ȣ : ' || emp_info.empno);
    DBMS_OUTPUT.PUT('����̸� : ' || emp_info.ename);
    DBMS_OUTPUT.PUT_LINE('�޿� :' || emp_info.sal);

END;
/

DECLARE
    emp_record employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_record
    FROM employees
    WHERE employee_id =&�����ȣ;

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
--index�� 0���Ͷ�� ������ ����.
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
--���� 1~50���̿� �����ϴ� 2�� ����� ���� NUM_TABLE �� ��� �� ����� ���
    FOR idx IN 1..50 LOOP
        IF MOD(idx, 2) <>0 THEN
            CONTINUE;
        END IF;
        
        num_table(idx):=idx;
    END LOOP;
    v_total :=num_table.COUNT;
    DBMS_OUTPUT.PUT_LINE(v_total);
    
--2)������ num_table ���� �����ϴ� �����ڸ� ���
    FOR idx IN num_table.FIRST .. num_table.LAST LOOP
        IF num_table.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(num_table(idx));
        END IF;
    END LOOP;
     DBMS_OUTPUT.PUT_LINE('============================');
     
--3�� ��� ����
-- ���� �Ѱ�
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
    v_min employees.employee_id%TYPE; -- �����ȣ
    v_MAX employees.employee_id%TYPE; -- �ִ� ��� ��ȣ
    v_result NUMBER(1,0);             -- ����� ���� ������ Ȯ��
    emp_record employees%ROWTYPE;     -- employees ���̺��� ���࿡ ���� 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    --�ּһ����ȣ �� �ִ� �����ȣ�� �ʿ�
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
    v_min employees.employee_id%TYPE; -- �����ȣ
    v_MAX employees.employee_id%TYPE; -- �ִ� ��� ��ȣ
    v_result NUMBER(1,0);             -- ����� ���� ������ Ȯ��
    emp_record employees%ROWTYPE;     -- employees ���̺��� ���࿡ ���� 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    --�ּһ����ȣ �� �ִ� �����ȣ�� �ʿ�
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
    --Ŀ���� ���̻� ������ ���� ���⿡ ���� �ʰ� ������ ���� ��� ����� 
        FETCH emp_cursor INTO v_eid, v_ename;
         DBMS_OUTPUT.PUT_LINE(v_eid || ',' ||v_ename);
    --Ŀ�� ������ �� ����ϰ� �������� ����� �ݺ��ǵ� ROWCOUNT���� ������ ���� ����
    DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
    CLOSE emp_cursor;
END;
/

--1) ����� ��ȣ, �̸� , �μ��̸� ���
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

--2) �μ� ��ȣ 50, 80�� ��� �̸�. �޿� ���� ���
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

--2)����̸� , �޿� Ŀ�̼����� ����
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
            DBMS_OUTPUT.PUT_LINE('�̸�'||ename||', ����'||sal ||', ����'||annual);
        END LOOP;
    
    CLOSE emp_cursor;
END;
/

--  Ŀ�� FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees;
    
    CURSOR DEPT_EMP_CURSOR IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = &�μ���ȣ;
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

--10)��� ����� �����ȣ, �̸�, �μ��̸� ���
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
--2. �μ���ȣ�� 50�̰ų� 80�� ����� �̸� �޿� ����
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
    OPEN emp_cursor(100);--�Ű������� ������ ���� �����Ҷ��� ���� �־���� 
    
    LOOP 
        FETCH emp_cursor  INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(emp_record.employee_id ||','|| emp_record.first_name);
    END LOOP;
    CLOSE emp_cursor ;
    
    DBMS_OUTPUT.PUT_LINE('===================================');
    
    --for ���� �Ű������� ������ �ָ� ��
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

--Ŀ���� ����ؼ� employees �� �ִ¸�� ������ �Ѻ����� ���
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
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬���� 
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է�
1-1) ����� Ŀ�� + �⺻ LOOP ���
1-2) Ŀ�� FOR LOOP ���
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

-- ����1-1)
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

--����1-2)
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
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
(��, cursor ���)
*/


  


--������ ���
/*
1.
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬���� 
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է�

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

-- 1-1) ����� Ŀ�� + �⺻ LOOP ���
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
        -- Ŀ���� ����Ű�� ������ �������� �����ϰ��� �ϴ� �κ�  
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


-- 1-2) Ŀ�� FOR LOOP ���
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
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
(��, cursor ���)
*/

-- �⺻ LOOP
DECLARE
    v_deptid departments.department_id%TYPE := &�μ���ȣ;
    
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
        
        DBMS_OUTPUT.PUT('����̸� : ' || emp_info.first_name);
        DBMS_OUTPUT.PUT(', �Ի����� : ' || TO_CHAR(emp_info.hire_date, 'yyyy"��"MM"��"dd"��"'));
        DBMS_OUTPUT.PUT_LINE(', �μ��� : ' || emp_info.department_name);
    END LOOP;
    
    CLOSE dept_emp_cursor;
END;
/

-- Ŀ�� FOR LOOP
DECLARE
    v_deptid departments.department_id%TYPE := &�μ���ȣ;
    
    CURSOR dept_emp_cursor IS
    
        SELECT first_name, hire_date, department_name
        FROM employees e JOIN departments d
          ON e.department_id = d.department_id
        WHERE e.department_id = v_deptid;  
BEGIN
    DBMS_OUTPUT.PUT_LINE('========' || v_deptid || '========');
    FOR emp_info IN dept_emp_cursor LOOP     
        DBMS_OUTPUT.PUT('����̸� : ' || emp_info.first_name);
        DBMS_OUTPUT.PUT(', �Ի����� : ' || TO_CHAR(emp_info.hire_date, 'yyyy"��"MM"��"dd"��"'));
        DBMS_OUTPUT.PUT_LINE(', �μ��� : ' || emp_info.department_name);
    END LOOP;
END;
/