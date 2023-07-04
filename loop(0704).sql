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

/*
2. 치환변수(&)를 사용하면 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
예) 2 입력시
2 * 1 = 2
2 * 2 = 4
2 * 3 = 6
2 * 4 = 8
2 * 5 = 10
2 * 6 = 12
2 * 7 = 14
2 * 8 = 16
2 * 9 = 18
*/

-- 기본 LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR number IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || number || ' = ' || ( v_dan * number ));
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num < 10 LOOP        
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
        v_num := v_num + 1;
    END LOOP;
END;
/


/*
3. 구구단 2~9단까지 출력되도록 하시오.
*/
-- FOR LOOP
BEGIN
    FOR v_dan IN 2..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
             DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
-- WHILE LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num < 10 LOOP  -- 특정 단의 1~9까지 곱하는 LOOP문
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
            DBMS_OUTPUT.PUT(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ) || ' ');
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 기본 LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP -- 단
        v_num := 1;
        LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
    
END;
/

/*
4. 구구단 1~9단까지 출력되도록 하시오.
   (단, 홀수단 출력)
*/

-- FOR LOOP + IF문
BEGIN
    FOR v_dan IN 1..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        IF MOD(v_dan, 2) <> 0 THEN
            FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF문
BEGIN
    FOR v_dan IN 1..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        IF MOD(v_dan, 2) = 0 THEN 
            CONTINUE;
        END IF;
        
        FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 기본 LOOP
DECLARE
    v_dan NUMBER(2,0) := 1;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP -- 단
        v_num := 1;
        LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        v_dan := v_dan + 2;
        EXIT WHEN v_dan > 9;
    END LOOP;    
END;
/