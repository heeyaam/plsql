SET SERVEROUTPUT ON

--�⺻ LOOP
DECLARE
    v_num NUMBER(2,0) :=1;
    v_result NUMBER(2,0) :=0;
BEGIN
    
    LOOP 
        v_result:= v_result +v_num;
        v_num := v_num+1;
        EXIT WHEN v_num >10;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_result);
    
END;
/

--FOR LOOP
-- FOR �ӽú��� IN [REVERSE] �ּҹ���..�ִ���� LOOP END LOOP
BEGIN
    FOR num IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/
--�Ųٷ�
BEGIN
    FOR num IN  REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/
--������ ���ϱ�
DECLARE
    v_result NUMBER(2,0) :=0;
BEGIN
    FOR num IN 1..10 LOOP
    v_result := v_result+num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/


--WHILE LOOOP
DECLARE
    v_num NUMBER(2,0) :=0;
    v_result NUMBER(2,0) :=0;
BEGIN
    WHILE v_num <10 LOOP
        v_num := v_num+1;
        v_result := v_result+ v_num;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

-- �� �����
--���� �Ѱ�
DECLARE    
    v_num NUMBER(2,0) :=0;
    v_star VARCHAR2(10) :='';
BEGIN
    WHILE v_num<5 LOOP
        v_num :=v_num+1;
        v_star := v_star || '*';         
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/
--������ �Ѱ�(�⺻ LOOP)
DECLARE
    v_tree  VARCHAR2(5 CHAR) :=''; --�� �ٿ� ����� *
    v_count NUMBER(1,0) :=1; --LOOP�� �������ǿ� ����� ����
BEGIN
    LOOP
        v_tree:=v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        v_count := v_count+1;
        EXIT WHEN v_count>5;
    END LOOP;
END;
/
--������ �Ѱ�(FOR LOOP)  
BEGIN
    FOR counter IN 1..5 LOOP
        FOR i IN 1..counter LOOP
        DBMS_OUTPUT.PUT('*');  --PUT���θ� ������ �ٹٲ޾��Ͼ
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

--2�� ����
--while loop��
DECLARE
    f_num NUMBER(2,0) :=&���;
    b_num NUMBER(2,0) := 0;
BEGIN
    WHILE b_num < 9 LOOP
        b_num:= b_num+1;
       DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
    END LOOP;
END;
/
--�⺻ loop
DECLARE
    f_num NUMBER(2,0) :=&���;
    b_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
        b_num:= b_num+1;
        EXIT WHEN b_num>9;
    END LOOP;
END;
/
--for loop��
DECLARE
    f_num NUMBER(2,0) :=&���;
BEGIN
    FOR b_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
    END LOOP;
END;
/
--3�� (LOOP LOOP)
DECLARE
    f_num NUMBER(3,0) := 2;
    b_num NUMBER(3,0) := 1;
BEGIN
    LOOP
        b_num:=1;
        LOOP
            DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
            b_num := b_num+1;
        EXIT WHEN b_num >9;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('');
        f_num := f_num+1;     
    EXIT WHEN f_num >9;
    END LOOP;
END;
/
--3��(FOR FOR)
BEGIN
    FOR f_num IN 2..9 LOOP
        FOR b_num IN 1..9 LOOP
             DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
--3��(WHILE WHILE)
DECLARE
    f_num NUMBER(3,0) := 2;
    b_num NUMBER(3,0) := 1;
BEGIN
    WHILE f_num < 10 LOOP
        b_num:=1;
        WHILE b_num <10 LOOP
            DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
            b_num := b_num+1;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('');
        f_num := f_num+1;
    END LOOP;
END;
/

--4��
DECLARE
    f_num NUMBER(3,0) := 1;
BEGIN
    WHILE f_num <10 LOOP
        IF MOD(f_num,2) = 1 THEN
            FOR b_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
            END LOOP;
        END IF;
    f_num := f_num+1;
    END LOOP;
END;
/
--������
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan,2) <> 1 THEN
        CONTINUE;
        END IF;
        
        FOR v_num IN 1..9 LOOP
           DBMS_OUTPUT.PUT_LINE(v_dan ||'*'||v_num||'='||(v_dan*v_num));
        END LOOP;
            
    END LOOP;
END;
/