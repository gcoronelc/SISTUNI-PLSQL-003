--Pregunta 1
------------------------------------
Desarrollar un SP que permita consultar
lo siguiente:

Cursor 1: Resumen por moneda
-----------------------------

CODIGO  DESCRIPCION CUENTAS IMPORTE
--------------------------------------
01      SOLES       ##      ##,###.##
02      DOLARES     ##      ##,###.##
---------------------------------------

Cursor 2: Resumen por SUCURSAL
-------------------------------

CODIGO  DESCRIPCION MONEDA CUENTAS IMPORTE
---------------------------------------------
001     Aaaaaa      01     ##      ##,###.##
001     Aaaaaa      02     ##      ##,###.##
002     Aaaaaa      01     ##      ##,###.##
002     Aaaaaa      02     ##      ##,###.##
003     Aaaaaa      01     ##      ##,###.##
004     Aaaaaa      02     ##      ##,###.##
...
---------------------------------------------

--Solucion

create or replace procedure sp_consultar(
  p_cursor1 out nocopy sys_refcursor,
  p_cursor2 out nocopy sys_refcursor)
as begin
 open p_cursor1 for
  select 
   c.chr_monecodigo,
   m.vch_monedescripcion,
   count(c.chr_cuencodigo),
   sum(c.dec_cuensaldo)
  from cuenta c, moneda m
  where c.chr_monecodigo = m.chr_monecodigo
  group by c.chr_monecodigo, m.vch_monedescripcion;
 open p_cursor2 for
  select
   c.chr_sucucodigo,
   s.vch_sucunombre,
   c.chr_monecodigo,
   count(chr_cuencodigo),
   sum(c.dec_cuensaldo)
  from cuenta c, sucursal s
  where c.chr_sucucodigo = s.chr_sucucodigo
  group by c.chr_sucucodigo, s.vch_sucunombre, c.chr_monecodigo; 
end;


declare
 v_cursor1 SYS_REFCURSOR;
 v_cursor2 SYS_REFCURSOR;

 v_codigo cuenta.chr_monecodigo%TYPE;
 v_descripcion moneda.vch_monedescripcion%TYPE;
 v_cuentas NUMBER;
 v_importe NUMBER;

 v_codigo2 cuenta.chr_sucucodigo%TYPE;
 v_descripcion2 sucursal.vch_sucunombre%TYPE;
 v_moneda cuenta.chr_monecodigo%TYPE;
 v_cuentas2 NUMBER;
 v_importe2 NUMBER;
begin
 sp_consultar(v_cursor1,v_cursor2);
 loop
  fetch v_cursor1 into v_codigo, v_descripcion, v_cuentas, v_importe;
  exit when v_cursor1%NOTFOUND;
  dbms_output.put_line(v_codigo || ' | ' || v_descripcion|| ' | ' || v_cuentas || ' | ' || v_importe);
 end loop;
 close v_cursor1;
  dbms_output.put_line('================================================================================');
 loop
  fetch v_cursor2 into v_codigo2, v_descripcion2, v_moneda, v_cuentas2, v_importe2;
  exit when v_cursor2%NOTFOUND;
  dbms_output.put_line(v_codigo2 || ' | ' || v_descripcion2 || ' | ' || v_moneda || ' | ' || v_cuentas2|| ' | ' ||v_importe2);
 end loop;
 close v_cursor2;
end;

-------------------------------------------------------------------------------------------------------
--PREGUNTA 2
--Procedimiento que le pase varios datos en una cadena de los empleados y los registre. (SCOTT)

-------------------------------------------------------------------------------------------------------
--PREGUNTA 3
--Procedimiento que permita hacer un cambio de curso matriculado en EDUCA.

--Solucion

CREATE OR REPLACE PROCEDURE SP_MATRICULA(
curso matricula.cur_id%TYPE,
alumno matricula.alu_id%TYPE,
cursoNuevo matricula.cur_id%TYPE
)
IS 
  Cont NUMBER;
BEGIN
  SELECT Count(*) Into Cont 
     FROM matricula
     WHERE cur_id=curso and alu_id = alumno;
  if(Cont =0)then
     RAISE NO_DATA_FOUND;
  end if;
  UPDATE matricula 
     SET cur_id = cursoNuevo
     WHERE alu_id = alumno and cur_id= curso;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE(' PROCESO CORRECTO ');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO HAY ALUMNO MATRICULADO.');
END;

call SP_MATRICULA(1,5,3);



