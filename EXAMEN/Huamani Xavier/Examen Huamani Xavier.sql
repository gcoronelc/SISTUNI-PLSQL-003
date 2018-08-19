-- -----------------------------------------------------------------------------
--Huamani Xavier
-- Caso 1     eureka
--------------------------------------------------------------------------------
create or replace procedure Ejercicio0011(
p_result1 OUT  SYS_REFCURSOR,
  p_Result2 OUT  SYS_REFCURSOR)
as 
begin
   
  open p_result1 for
  select c.chr_monecodigo as moneda, m.vch_monedescripcion as des, count(*) as cant, sum(c.dec_cuensaldo) as importe
  from cuenta c
  inner join moneda m on c.chr_monecodigo = m.chr_monecodigo
  group by c.chr_monecodigo, m.vch_monedescripcion
  order by c.chr_monecodigo asc;
  
  open p_result2 for
  select s.CHR_SUCUCODIGO AS CODI, s.VCH_SUCUNOMBRE AS DES, c.chr_monecodigo AS MONEDA, 
  count(c.chr_cuencodigo) AS CANT, sum(c.dec_cuensaldo) AS IMP
  from cuenta c
  inner join sucursal s on s.CHR_SUCUCODIGO = c.chr_sucucodigo
  group by s.CHR_SUCUCODIGO, s.VCH_SUCUNOMBRE, c.chr_monecodigo
  order by s.CHR_SUCUCODIGO asc;
end;
-- --------------------------------------------------
declare
  p_1  SYS_REFCURSOR := null;
  p_2  SYS_REFCURSOR := null;
  v_moneda char(3);
  v_descripcion varchar2(100);
  v_cantidad number;
  v_importe decimal(18,2);
  v_codigo char(3);
begin
  Ejercicio0011(p_1, p_2);
  dbms_output.put_line(' Resumen por moneda');
    dbms_output.put_line('----------------------------------------------');
  loop
    fetch p_1 into v_moneda, v_descripcion, v_cantidad, v_importe;
    EXIT WHEN p_1%NOTFOUND;
    dbms_output.put_line(v_moneda ||' - '|| v_descripcion ||' - '|| v_cantidad ||' - '|| v_importe);
  end loop;
  close p_1;
  dbms_output.put_line(' Resumen por sucursal');
  dbms_output.put_line('----------------------------------------------');
  loop
    fetch p_2 into v_codigo, v_descripcion, v_moneda, v_cantidad, v_importe;
    exit when p_2%notfound;
    dbms_output.put_line(v_codigo ||' - '|| v_descripcion ||' - '|| v_moneda ||' - '|| v_cantidad ||' - '|| v_importe);
  end loop;
  close p_2;
end;

-- ----------------------------------------------------------------------------------
-- Caso 2    eureka
-- ----------------------------------------------------------------------------------
/*procedimiento que le pase varios datos en un cadena 
   de los empleados y lo registre.*/
create or replace procedure prc_reg_empleado(
       p_resultado out sys_refcursor,
       p_texto in varchar2,
       p_msg out varchar2
)
as
v_cadena clob;
v_identificador varchar2(20);
v_tmp           varchar2(4000);
v_pos           number;
v_contador      number;
v_validador1    number;
v_id_empleado   char(4);
v_salida        number := 0;
v_insert        varchar2(3000);
begin
    v_contador := 0;
    v_cadena := p_texto;
    loop

      v_contador := v_contador + 1;
      v_identificador := 'row'||v_contador;

      v_pos := instr(v_cadena,v_identificador);

      if v_pos = 0 then
        v_salida := 1;
        p_msg := 'No existe datos a registrar.';
        exit;
      end if;
      
      v_tmp := substr(v_cadena, 1, v_pos -1 );
      v_cadena := substr(v_cadena, v_pos + length(v_identificador)+1,length(v_cadena));

      v_validador1 := length(v_tmp) - length(replace(v_tmp,'|')) ;

      if v_validador1 <> 6 then
        continue;
      end if;

      v_tmp := replace(v_tmp,'|',', ');

      --Generaciòn de codigo
      select lpad(max(chr_emplcodigo)+1,4,0)
      into v_id_empleado
      from empleado
      where chr_emplcodigo <> '9999';

      v_tmp := ' '''|| v_id_empleado ||''', '|| v_tmp;
      v_insert := ' insert into empleado values ( '|| v_tmp || ')';
      
      execute immediate v_insert;
      commit;

    end loop;
    
    if v_salida = 0 then
      p_msg := 'Se registro exitosamente los datos de empleados.';
      open p_resultado for
      select 'ok' from dual;
    end if;
    
    exception
      when others then
        dbms_output.put_line('cadena a ejecutar: '||v_insert);
           rollback;
           raise;
  end;

  -- cadena de prueba para caso 2
  /*
  'TORRES'|'LARA'|'JOSE'|'JOSE'|'AV. LIMA 123'|'JTORRES'|'123456'row1
'FLORES'|'REVILLA'|'MARIA'|'SUSAN'|'AV. PERU 123'|'MFLORES'|'123456'row2
'LUNA'|'CASTRO'|'INGRIT'|'ROSA'|'AV. LAS FLORES 123'|'ICASTRO'|'123456'row3
'MERINO'|'MOSTES'|'FABIOLA'|'LIZBETH'|'AV. LOS PACAES 123'|'FMERINO'|'123456'row4
'TADEO'|'CABALLERO'|'RUBEN'|NULL|'AV. LOS CEREZOS 123'|'RTADEO'|'123456'row5
  */  
 -- ------------------------------------------------------------------------------
 -- caso 3   educa
 -- ------------------------------------------------------------------------------
  
 create or replace procedure prc_cam_mat
(
   p_id_alumno in number,
   p_id_curso_old  in number,
   p_id_curso_new in number
 )
 as
 v_nota number := 0;
 v_vacante number :=0;
 begin

   select mat_nota
   into v_nota
   from matricula
   where cur_id = p_id_curso_old
   and alu_id = p_id_alumno;

   if nvl(v_nota,0) <> 15 then
     raise_application_error(-20001,'No se puede realizar cambio de curso, ya tiene nota final.');
   end if;

   select cur_vacantes - cur_matriculados
   into v_vacante
   from curso where cur_id = p_id_curso_new for update;

   if v_vacante = 0 then
     raise_application_error(-20000,'No hay vacante.');
   end if;

   update curso set cur_matriculados = cur_matriculados + 1
   where cur_id = p_id_curso_new;

   update curso set cur_matriculados = cur_matriculados -1
   where cur_id = p_id_curso_old;

   update matricula set cur_id = p_id_curso_new
   where alu_id = p_id_alumno and cur_id = p_id_curso_old;

   commit;

   exception
    when others then
      dbms_output.put_line('error nro ora:' || to_char(sqlcode));
      dbms_output.put_line(sqlerrm);
      rollback;

   end;
