 create or replace procedure scott.prc_calc_promedio
 (
	 p_n1 in number,
	 p_n2 in number,
	 p_n3 in number,
	 p_n4 in number,
	 p_nota_menor out number,
	 p_promedio   out number,
	 p_condicion  out varchar2
 )
 is 
	 v_min number;
	 v_promedio number;
	 v_cond varchar2(30);
 begin
 
  v_min := p_n1;
  
  -- Corregir
  if (p_n2 < v_min) then
    v_min := p_n2;
  elsif(p_n3 < v_min) then
	v_min := p_n3;
  elsif(p_n4 < v_min) then
	v_min := p_n4;
  end if;
  
  v_promedio := (p_n1 + p_n2 +p_n3+p_n4-v_min)/3;
  
  if (v_promedio > 10.5)then
	v_cond := 'aprobado';
  else
	v_cond := 'desaprobado';
  end if;

  
  p_nota_menor := v_min;
  p_promedio := v_promedio;
  p_condicion := v_cond;
  
end;



declare

	v_n1 number;
	v_n2 number;
	v_n3 varchar2(30);

begin

	scott.prc_calc_promedio(12,10,5,15, v_n1, v_n2, v_n3);
	DBMS_OUTPUT.PUT_LINE('nota menor: ' || v_n1);
	DBMS_OUTPUT.PUT_LINE('nota promedio: ' || v_n2);
	DBMS_OUTPUT.PUT_LINE('condicion: ' || v_n3);

end;
