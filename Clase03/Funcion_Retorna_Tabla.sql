-- ============================================
-- Funcion que retorna una resultado
-- ============================================

Create Type mytype As Object(
       field1 Number,
       field2 Varchar2(50)
);

Create Type mytypelist As Table Of mytype;

Create Or Replace Function fn_demo_01
Return mytypelist Pipelined
Is
  v_mytype mytype;
Begin
     For r In (Select * From emp) Loop
         v_mytype := mytype( r.empno, r.ename );
         Pipe Row (v_mytype);
     End Loop;
     Return;
End fn_demo_01;

Create Or Replace Function fn_demo_02
( coddept Number )
Return mytypelist Pipelined
Is
  v_mytype mytype;
Begin
     For r In (Select * From emp Where deptno = coddept) Loop
         v_mytype := mytype( r.empno, r.ename );
         Pipe Row (v_mytype);
     End Loop;
     Return;
End fn_demo_02;

Select * From Table(fn_demo_01);

Select * From Table(fn_demo_02(10));

