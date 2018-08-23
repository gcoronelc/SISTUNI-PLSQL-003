
--SE TUVO 2 CONSIDERACIONES EN LA PRIMERA PREGUNTA
--1.1 EN CASO Q IMPORTE SEA DE LA TABLA CUENTA(DEC_CUENSALDO)
========================================================
CREATE OR REPLACE PROCEDURE SP_TAREA
(P_CURSOR1 OUT NOCOPY SYS_REFCURSOR,P_CURSOR2 OUT NOCOPY SYS_REFCURSOR)
IS
BEGIN
    OPEN P_CURSOR1 FOR
    SELECT M.CHR_MONECODIGO AS CODIGO,M.VCH_MONEDESCRIPCION AS DESCRIPCION, 
       COUNT(*) AS CUENTAS ,SUM(C.DEC_CUENSALDO)AS IMPORTE
    FROM MONEDA M
    JOIN CUENTA C ON M.CHR_MONECODIGO = C.CHR_MONECODIGO
    GROUP BY M.CHR_MONECODIGO,M.VCH_MONEDESCRIPCION
    ORDER BY 1;
    
    OPEN P_CURSOR2 FOR
    SELECT S.CHR_SUCUCODIGO,S.VCH_SUCUNOMBRE,C.CHR_MONECODIGO ,
       COUNT(*) AS CUENTAS ,SUM(C.DEC_CUENSALDO)AS IMPORTE FROM CUENTA C 
    JOIN SUCURSAL S ON S.CHR_SUCUCODIGO = C.CHR_SUCUCODIGO
    GROUP BY S.CHR_SUCUCODIGO,S.VCH_SUCUNOMBRE,C.CHR_MONECODIGO
    ORDER BY 1;
  
END;

DECLARE 
    V_CURSOR1 SYS_REFCURSOR; 
    V_CURSOR2 SYS_REFCURSOR;   
    V_MON_CODIGO MONEDA.CHR_MONECODIGO%TYPE;
    V_MON_DESCRIPCION MONEDA.VCH_MONEDESCRIPCION%TYPE;
    V_CUENTAS NUMBER;
    V_IMPORTE CUENTA.DEC_CUENSALDO%TYPE;
    V_SUCU_CODIGO SUCURSAL.CHR_SUCUCODIGO%TYPE;
    V_SUCU_DESCRIPCION SUCURSAL.VCH_SUCUNOMBRE%TYPE;
BEGIN
    SP_TAREA(V_CURSOR1,V_CURSOR2);
    DBMS_OUTPUT.PUT_LINE('===========RESUMEN POR MONEDA==============='); 
    LOOP
        FETCH V_CURSOR1 INTO V_MON_CODIGO, V_MON_DESCRIPCION,V_CUENTAS, V_IMPORTE;
        EXIT WHEN V_CURSOR1%NOTFOUND;        
            DBMS_OUTPUT.PUT_LINE(V_MON_CODIGO || ' - ' || V_MON_DESCRIPCION || ' - ' || V_CUENTAS|| ' - ' || V_IMPORTE); 
    END LOOP;  
    DBMS_OUTPUT.PUT_LINE('===========RESUMEN POR SUCURSAL==============='); 
    
    LOOP
        FETCH V_CURSOR2 INTO V_SUCU_CODIGO,V_SUCU_DESCRIPCION, V_MON_CODIGO,V_CUENTAS, V_IMPORTE;
        EXIT WHEN V_CURSOR2%NOTFOUND;        
            DBMS_OUTPUT.PUT_LINE(V_SUCU_CODIGO || ' - ' ||V_SUCU_DESCRIPCION|| ' - ' || V_MON_CODIGO || ' - ' || V_CUENTAS|| ' - ' || V_IMPORTE); 
    END LOOP; 
END;
SET SERVEROUTPUT ON;
SELECT * FROM CUENTA;
SELECT * FROM MONEDA;
SELECT * FROM SUCURSAL;

--1.2 EN CASO Q IMPORTE SEA DE LA TABLA MOVIMIENTO(DEC_MOVIIMPORTE)
=========================================================

CREATE OR REPLACE PROCEDURE SP_TAREA
(P_CURSOR1 OUT NOCOPY SYS_REFCURSOR,P_CURSOR2 OUT NOCOPY SYS_REFCURSOR)
IS
BEGIN
    OPEN P_CURSOR1 FOR
    SELECT MO.CHR_MONECODIGO AS CODIGO,MO.VCH_MONEDESCRIPCION AS DESCRIPCION, 
    COUNT(*) AS CUENTAS ,SUM(M.DEC_MOVIIMPORTE)AS IMPORTE
    FROM MONEDA MO
    JOIN CUENTA C ON MO.CHR_MONECODIGO = C.CHR_MONECODIGO
    JOIN MOVIMIENTO M ON C.CHR_CUENCODIGO=M.CHR_CUENCODIGO
    GROUP BY MO.CHR_MONECODIGO,MO.VCH_MONEDESCRIPCION
    ORDER BY 1;
    
    OPEN P_CURSOR2 FOR
    SELECT S.CHR_SUCUCODIGO,S.VCH_SUCUNOMBRE,C.CHR_MONECODIGO,COUNT(*),SUM(M.DEC_MOVIIMPORTE) FROM SUCURSAL S
    JOIN CUENTA C ON C.CHR_SUCUCODIGO = S.CHR_SUCUCODIGO
    JOIN MOVIMIENTO M ON C.CHR_CUENCODIGO=M.CHR_CUENCODIGO
    GROUP BY S.CHR_SUCUCODIGO,S.VCH_SUCUNOMBRE,C.CHR_MONECODIGO
    ORDER BY 1;
  
END;

DECLARE 
    V_CURSOR1 SYS_REFCURSOR; 
    V_CURSOR2 SYS_REFCURSOR;   
    V_MON_CODIGO MONEDA.CHR_MONECODIGO%TYPE;
    V_MON_DESCRIPCION MONEDA.VCH_MONEDESCRIPCION%TYPE;
    V_CUENTAS NUMBER;
    V_IMPORTE MOVIMIENTO.DEC_MOVIIMPORTE%TYPE;
    V_SUCU_CODIGO SUCURSAL.CHR_SUCUCODIGO%TYPE;
    V_SUCU_DESCRIPCION SUCURSAL.VCH_SUCUNOMBRE%TYPE;
BEGIN
    SP_TAREA(V_CURSOR1,V_CURSOR2);
    DBMS_OUTPUT.PUT_LINE('===========RESUMEN POR MONEDA==============='); 
    LOOP
        FETCH V_CURSOR1 INTO V_MON_CODIGO, V_MON_DESCRIPCION,V_CUENTAS, V_IMPORTE;
        EXIT WHEN V_CURSOR1%NOTFOUND;        
            DBMS_OUTPUT.PUT_LINE(V_MON_CODIGO || ' - ' || V_MON_DESCRIPCION || ' - ' || V_CUENTAS|| ' - ' || V_IMPORTE); 
    END LOOP;  
    DBMS_OUTPUT.PUT_LINE('===========RESUMEN POR SUCURSAL==============='); 
    
    LOOP
        FETCH V_CURSOR2 INTO V_SUCU_CODIGO,V_SUCU_DESCRIPCION, V_MON_CODIGO,V_CUENTAS, V_IMPORTE;
        EXIT WHEN V_CURSOR2%NOTFOUND;        
            DBMS_OUTPUT.PUT_LINE(V_SUCU_CODIGO || ' - ' ||V_SUCU_DESCRIPCION|| ' - ' || V_MON_CODIGO || ' - ' || V_CUENTAS|| ' - ' || V_IMPORTE); 
    END LOOP; 
END;

--2 Procedimiento que le pase varios datos en una 
  cadena de los empleados y los registre. (SCOTT)
=============================================================
 create or replace procedure SP_INSERT_EMP( p_str in varchar2 ,p_msg OUT NOCOPY VARCHAR2)
is

type array_p is table of varchar2(4000) index by binary_integer;
l_data array_p;

l_str long;
l_n number;
l_n1 number; 
--
v_empno varchar2(50);
v_ename varchar2(50);
v_job varchar2(50);
v_mgr varchar2(50);
v_hiredate varchar2(50);
v_sal varchar2(50);
v_comm varchar2(50);
v_deptno varchar2(50);
begin
l_data.delete;
l_n := instr( p_str, ']' );
l_str:=SUBSTR(p_str, 2, l_n-2);
l_str:= l_str || ',';
loop
l_n := instr( l_str, ',',1,8);
exit when nvl(l_n,0) = 0;
l_data( l_data.count+1 ) := substr( l_str, 1, l_n-1 );
l_str := substr( l_str, l_n+1 );
end loop;

for i in 1..l_data.count loop
l_str:=l_data(i);
l_n := instr( l_str, '}' );
l_str:=SUBSTR(l_str, 2, l_n-2);
l_str:= l_str || ',';
--obteniendo empno  
l_str:=SUBSTR(l_str, 10); 
l_n1 := instr( l_str, ',');
v_empno:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 ); 
--obteniendo mame 
l_str:=SUBSTR(l_str, 13); 
l_n1 := instr( l_str, ',');
v_ename:=SUBSTR(l_str, 1,l_n1-2);
l_str := substr( l_str, l_n1+1 ); 
--obteniendo job 
l_str:=SUBSTR(l_str, 12); 
l_n1 := instr( l_str, ',');
v_job:=SUBSTR(l_str, 1,l_n1-2);
l_str := substr( l_str, l_n1+1 );  
--obteniendo mgr
l_str:=SUBSTR(l_str, 11); 
l_n1 := instr( l_str, ',');
v_mgr:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 ); 
--obteniendo hiredate
l_str:=SUBSTR(l_str, 16); 
l_n1 := instr( l_str, ',');
v_hiredate:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 );  
--obteniendo sal
l_str:=SUBSTR(l_str, 11); 
l_n1 := instr( l_str, ',');
v_sal:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 );  
--obteniendo comm
l_str:=SUBSTR(l_str, 12); 
l_n1 := instr( l_str, ',');
v_comm:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 ); 
--obteniendo deptno
l_str:=SUBSTR(l_str, 14); 
l_n1 := instr( l_str, ',');
v_deptno:=SUBSTR(l_str, 1,l_n1-1);
l_str := substr( l_str, l_n1+1 ); 
  INSERT INTO EMP VALUES (TO_NUMBER(v_empno),v_ename,v_job,TO_NUMBER(v_empno),to_date(v_hiredate,'dd-mm-yyyy'),TO_NUMBER(v_sal),TO_NUMBER(v_comm),TO_NUMBER(v_deptno));
end loop;
p_msg:='INSERCION OK';
  commit;
EXCEPTION
  WHEN OTHERS THEN
  p_msg:='HUBO ERRORES';
  rollback;
end;
 
 
DECLARE 
V_CADENA VARCHAR2(1000);
V_MSG VARCHAR2(100);
BEGIN
V_CADENA:='[{"emp_id":9939,"emp_name":"juan","emp_job":"MANAGER","emp_mgr":7777,"emp_hiredate":17/12/87,"emp_sal":800,"emp_comm":300,"emp_deptno":20},{"emp_id":9940,"emp_name":"alfredo","emp_job":"MANAGER","emp_mgr":7777,"emp_hiredate":17/12/87,"emp_sal":800,"emp_comm":300,"emp_deptno":20}]';
SP_INSERT_EMP(V_CADENA,V_MSG);
dbms_output.put_line(V_MSG);
END;
--SE LE PUEDE AÑADIR O QUITAR EL REGISTRO DE UN EMPLEADO DEL JSON
--IGUAL SE INSERTARA
SELECT * FROM EMP;

--3 Procedimiento que permita hacer un cambio de
  curso matriculado en EDUCA.
==============================================================
CREATE OR REPLACE PROCEDURE SP_CAMBIO_CURSO_MATRICULADO(P_ALU_ID MATRICULA.ALU_ID%TYPE,P_CURMAT_ID MATRICULA.CUR_ID%TYPE,P_CURNUE_ID MATRICULA.CUR_ID%TYPE)
IS
  CONT1 NUMBER;
  CONT2 NUMBER;
  EXCEP1 EXCEPTION;
  EXCEP2 EXCEPTION;
BEGIN
 SELECT COUNT(1) INTO CONT1
  FROM MATRICULA WHERE ALU_ID = P_ALU_ID;
  IF(CONT1= 0)THEN
    RAISE EXCEP1;
  END IF;
  
  SELECT COUNT(1) INTO CONT2
  FROM MATRICULA WHERE CUR_ID = P_CURMAT_ID AND ALU_ID = P_ALU_ID;
  IF(CONT2= 0)THEN
    RAISE EXCEP2;
  END IF;
  
 UPDATE MATRICULA SET CUR_ID=P_CURNUE_ID WHERE ALU_ID=P_ALU_ID AND CUR_ID=P_CURMAT_ID;
 IF SQL%NOTFOUND THEN
  DBMS_OUTPUT.PUT_LINE('No se pudo realizar el cambio');
 ELSE
  commit;
  DBMS_OUTPUT.PUT_LINE('SE HA REALIZADO EL CAMBIO');
 END IF;
EXCEPTION 
  WHEN EXCEP1 THEN
   dbms_output.put_line( 'CODIGO DEL ALUMNO NO EXISTE');
  WHEN EXCEP2 THEN
   dbms_output.put_line( 'EL ALUMNO NO ESTA MATRICULADO EN ESE CURSO');
  WHEN OTHERS THEN
   dbms_output.put_line( 'UPSS HUBO ERRORES');
END;

SELECT * FROM MATRICULA;
SET SERVEROUTPUT ON;
--REALIZANDO EL CAMBIO
CALL SP_CAMBIO_CURSO_MATRICULADO(7,3,1); 