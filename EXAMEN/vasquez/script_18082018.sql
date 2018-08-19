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

execute eureka.usp_nueva_cuenta ('00300002','01','001','0004','00005',500,
sysdate,'ACTIVO',8,'123456');

select * from eureka.cuenta;
select * from eureka.moneda;

/*clase 03*/
/*
  Procedimiento que le pase varios datos en una 
  cadena de los empleados y los registre. (SCOTT)
*/

/*
  Procedimiento que permita hacer un cambio de
  curso matriculado en EDUCA.
*/
