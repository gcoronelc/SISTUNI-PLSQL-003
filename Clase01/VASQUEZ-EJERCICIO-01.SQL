create or replace procedure scott.sp_cal_Prom
 (p_n1 in number,p_n2 in number,p_n3 in number,p_n4 in number)
is 
v_prom number; v_ntMenor number; v_msg varchar2(30);
begin
 --proceso
 v_ntMenor:=least(p_n1,p_n2,p_n3,p_n4);
 v_prom := (p_n1 + p_n2 + p_n3 + p_n4-v_ntMenor)/3;
 if(v_prom>14) then 
 v_msg:='aprobado';
 elsif(v_prom<=14) then 
 v_msg:='desaprobado';
 else
 v_msg:='error';
 end if;
 --reporte
  dbms_output.put_line('promedio:' || v_prom);
  dbms_output.put_line('nota menor:' || v_ntMenor);
  dbms_output.put_line('condicion:' || v_msg);
end;
 
 
call scott.sp_cal_Prom(14,15,12,10);
