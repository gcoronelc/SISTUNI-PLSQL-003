/*clase 02*/
/*Ejercicio 2.1
====================

Desarrollar un procedimiento que permita
registrar un nuevo empleado en esquema VENTAS.
*/

create or replace procedure ventas.usp_nuevo_empleado(
	p_idemp out nocopy ventas.empleado.idemp%type,
	p_nombre in ventas.empleado.nombre%type,
	p_apellido in ventas.empleado.apellido%type,
	p_email in ventas.empleado.email%type,
	p_telefono in ventas.empleado.telefono%type
) as
begin 
	insert into ventas.empleado(idemp,nombre,apellido,
	email,telefono) values(SQ_EMPLEADO.nextval,
	p_nombre, p_apellido, p_email, p_telefono)
	RETURNING idemp INTO p_idemp;
	commit;
exception
	when others then
		rollback;
		raise_application_error(-20000,'Error en el proceso.');
end;


declare
  id number(5);
begin
  ventas.usp_nuevo_empleado(id, 'JUAN', 'VARGAS','JUAN_VARGAS@GMAIL.COM','987654321');
  dbms_output.put_line( 'id = ' || id );
end;

select * from ventas.empleado;
/*
Ejercicio 2.2
====================
Desarrollar un procedimiento que permita
registrar una nueva venta en esquema VENTAS.
*/

create or replace procedure ventas.usp_nueva_venta(
	p_idventa out nocopy ventas.venta.idventa%type,
  p_cliente in ventas.venta.cliente%type,
  p_idemp in ventas.usuario.idemp%type,
	p_fecha in ventas.venta.fecha%type,
	p_importe in ventas.venta.importe%type	
) as
begin 
	insert into ventas.venta(idventa,cliente,idemp,
	fecha,importe) values(SQ_VENTA.nextval,
	p_cliente, p_idemp, p_fecha, p_importe)
	RETURNING idventa INTO p_idventa;
	commit;
exception
	when others then
		rollback;
		raise_application_error(-20000,'Error en el proceso.');
end;

declare
  id number(5);
begin
  ventas.usp_nueva_venta(id, 'MARIA CORNEJO',1002,sysdate,120);
  dbms_output.put_line( 'id = ' || id );
end;
select * from ventas.venta;
/*
Ejercicio 2.3
====================

Desarrollar un procedimiento que permita
registrar una nueva cuenta. Esquema EUREKA.

*/

create or replace procedure eureka.usp_nueva_cuenta(
	p_chr_cuencodigo in eureka.cuenta.chr_cuencodigo%type,
    p_chr_monecodigo in eureka.moneda.chr_monecodigo%type,
    p_chr_sucucodigo in eureka.sucursal.chr_sucucodigo%type,
	p_chr_emplcodigo in eureka.empleado.chr_emplcodigo%type,
	p_chr_cliecodigo in eureka.cliente.chr_cliecodigo%type,	
    p_dec_cuensaldo in eureka.cuenta.dec_cuensaldo%type,
    p_dtt_cuenfechacreacion in eureka.cuenta.dtt_cuenfechacreacion%type,
    p_vch_cuenestado in eureka.cuenta.vch_cuenestado%type,
    p_int_cuencontmov in eureka.cuenta.int_cuencontmov%type,
    p_chr_cuenclave in eureka.cuenta.chr_cuenclave%type
) as
begin 
	insert into eureka.cuenta(chr_cuencodigo,chr_monecodigo,chr_sucucodigo,chr_emplcreacuenta,chr_cliecodigo,
    dec_cuensaldo,dtt_cuenfechacreacion,vch_cuenestado,int_cuencontmov,chr_cuenclave) 
    values(p_chr_cuencodigo,p_chr_monecodigo,p_chr_sucucodigo,p_chr_emplcodigo,p_chr_cliecodigo,p_dec_cuensaldo,
    p_dtt_cuenfechacreacion,p_vch_cuenestado,p_int_cuencontmov,p_chr_cuenclave);
	commit;
exception
	when others then
		DBMS_OUTPUT.PUT_LINE('Error Nro. ORA' || to_char(sqlcode));
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        rollback;
		
end;

execute eureka.usp_nueva_cuenta ('00300003','01','001','0004','00005',500,to_date(sysdate,'yyyy/mm/dd'),'ACTIVO',8,'123456');

select * from eureka.cuenta;

/*clase 03*/

/*
Cursor 1: Resumen por moneda
-----------------------------

CODIGO DESCRIPCION     CUENTAS       IMPORTE
--------------------------------------------------------------
01      	SOLES       	##      	##,###.##
02      	DOLARES     	##      	##,###.##
----------------------------------------------------------------
*/
create or replace procedure eureka.sp_cursor1(
p_cursor out nocopy sys_refcursor
)
as begin
open p_cursor for
select 
a.chr_monecodigo as CODIGO,
a.vch_monedescripcion as DESCRIPCION,
count(b.chr_cuencodigo) as CUENTA,
sum(b.dec_cuensaldo) as IMPORTE 
from eureka.moneda a inner join eureka.cuenta b
on a.chr_monecodigo=b.chr_monecodigo
group by a.chr_monecodigo,a.vch_monedescripcion;
end;

declare
 s_cursor SYS_REFCURSOR;
 s_codigo EUREKA.moneda.chr_monecodigo%type;
 s_descrip EUREKA.moneda.vch_monedescripcion%type;
 s_cuenta EUREKA.cuenta.chr_cuencodigo%TYPE;
 s_importe EUREKA.cuenta.dec_cuensaldo%TYPE;
 begin
 eureka.sp_cursor1(s_cursor);
 loop
  fetch s_cursor into s_codigo, s_descrip, s_cuenta,s_importe;
  exit when s_cursor%NOTFOUND;
  dbms_output.put_line('-----------------------------------------------------------------------------------');
  dbms_output.put_line('CODIGO     -|-    DESCRIPCION    -|-     CUENTA     -|-  IMPORTE ');
  dbms_output.put_line('-----------------------------------------------------------------------------------');
  dbms_output.put_line(s_codigo || ' ' || s_descrip|| ' ' ||  s_cuenta|| ' ' || s_importe);
 end loop;
 close s_cursor;
 dbms_output.put_line('-----------------------------------------------------------------------------------');
end;
/
/*

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
*/

create or replace procedure eureka.sp_cursor2(
p_cursor out nocopy sys_refcursor
)
as begin
open p_cursor for
select 
b.chr_sucucodigo as CODIGO,
a.vch_monedescripcion as DESCRIPCION,
a.chr_monecodigo as MONEDA,
b.chr_cuencodigo as CUENTA,
b.dec_cuensaldo as IMPORTE 
from eureka.moneda a inner join eureka.cuenta b
on a.chr_monecodigo=b.chr_monecodigo;
end;


declare
 s_cursor SYS_REFCURSOR;
 s_codigo eureka.cuenta.chr_sucucodigo%type;
 s_descrip EUREKA.moneda.vch_monedescripcion%type;
 s_moneda eureka.moneda.chr_monecodigo%TYPE;
 s_cuenta EUREKA.cuenta.chr_cuencodigo%TYPE;
 s_importe EUREKA.cuenta.dec_cuensaldo%TYPE;
 begin
 eureka.sp_cursor2(s_cursor);
 loop
  fetch s_cursor into s_codigo, s_descrip, s_moneda, s_cuenta,s_importe;
  exit when s_cursor%NOTFOUND;
  dbms_output.put_line('-----------------------------------------------------------------------------------');
  dbms_output.put_line('CODIGO     -|-    DESCRIPCION     -|-    MONEDA    -|-     CUENTA     -|-  IMPORTE ');
  dbms_output.put_line('-----------------------------------------------------------------------------------');
  dbms_output.put_line(s_codigo || ' ' || s_descrip|| ' ' || s_moneda || ' ' || s_cuenta|| ' ' || s_importe);
 end loop;
 close s_cursor;
 dbms_output.put_line('-----------------------------------------------------------------------------------');
end;
/

/*
  Procedimiento que le pase varios datos en una 
  cadena de los empleados y los registre. (SCOTT)
*/

/*
  Procedimiento que permita hacer un cambio de
  curso matriculado en EDUCA.
*/
create or replace procedure educa.sp_madricula_curso(
p_curso educa.matricula.cur_id%type,
p_alumno educa.matricula.alu_id%type,
p_newcurso educa.matricula.cur_id%type
)
is 
  lts number;
  
begin
  select Count(*) into lts
     from educa.matricula
     where cur_id=p_curso and alu_id = p_alumno;
  if(lts=0) then
    update educa.matricula 
     set cur_id = p_newcurso,mat_fecha=sysdate
     where alu_id = p_alumno and cur_id= p_curso;
    DBMS_OUTPUT.PUT_LINE('se cambio el curso');
  commit;  
  end if;
  exception
	when NO_DATA_FOUND then
		DBMS_OUTPUT.PUT_LINE('el alumno no esta matriculado');
end;

execute educa.sp_madricula_curso(3,3,3);
/


