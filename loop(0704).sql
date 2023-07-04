SET SERVEROUTPUT ON

--기본 LOOP
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
-- FOR 임시변수 IN [REVERSE] 최소범위..최대범위 LOOP END LOOP
BEGIN
    FOR num IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/
--거꾸로
BEGIN
    FOR num IN  REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/
--정수값 더하기
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

-- 별 만들기
--내가 한것
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
--교수님 한것(기본 LOOP)
DECLARE
    v_tree  VARCHAR2(5 CHAR) :=''; --각 줄에 출력할 *
    v_count NUMBER(1,0) :=1; --LOOP문 종료조건에 사용할 변수
BEGIN
    LOOP
        v_tree:=v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        v_count := v_count+1;
        EXIT WHEN v_count>5;
    END LOOP;
END;
/
--교수님 한것(FOR LOOP)  
BEGIN
    FOR counter IN 1..5 LOOP
        FOR i IN 1..counter LOOP
        DBMS_OUTPUT.PUT('*');  --PUT으로만 끝나면 줄바꿈안일어남
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

--2번 문제
--while loop문
DECLARE
    f_num NUMBER(2,0) :=&몇단;
    b_num NUMBER(2,0) := 0;
BEGIN
    WHILE b_num < 9 LOOP
        b_num:= b_num+1;
       DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
    END LOOP;
END;
/
--기본 loop
DECLARE
    f_num NUMBER(2,0) :=&몇단;
    b_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
        b_num:= b_num+1;
        EXIT WHEN b_num>9;
    END LOOP;
END;
/
--for loop문
DECLARE
    f_num NUMBER(2,0) :=&몇단;
BEGIN
    FOR b_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
    END LOOP;
END;
/
--3번 (LOOP LOOP)
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
--3번(FOR FOR)
BEGIN
    FOR f_num IN 2..9 LOOP
        FOR b_num IN 1..9 LOOP
             DBMS_OUTPUT.PUT_LINE(f_num ||'*'||b_num||'='||(f_num*b_num));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
--3번(WHILE WHILE)
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

--4번
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
--교수님
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