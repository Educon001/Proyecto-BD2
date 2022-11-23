/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-----------------------------------------------------------------------SIMULACIÓN 4------------------------------------------------------------------------------

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE TABLE contrato_vencido
(
    id_contrato_vencido NUMBER PRIMARY KEY,
    id_contrato NUMBER,
    CONSTRAINT contrato_vencido_contrato_fk FOREIGN KEY (id_contrato) REFERENCES contrato (id)
);

create sequence contrato_vencido_seq;

CREATE OR REPLACE PROCEDURE Simulacion_4 IS
    numero_contrato_random number;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--------------- SIMULACIÓN #4: SE DESPIDE Y CONTRATA A UN EMPLEADO ------------------');

        DBMS_OUTPUT.PUT_LINE('Se elige un contrato aleatorio para vencer debido a despido');

        SELECT id
        INTO numero_contrato_random
        from (  select *
                from CONTRATO
                WHERE MOTIVO_EGRESO IS NULL
                order by dbms_random.value )
        where rownum <= 1;

        DBMS_OUTPUT.PUT_LINE('El empleado a despedir es el del contrato #' || to_char(numero_contrato_random));

        insert into contrato_vencido values(contrato_vencido_seq.nextval,numero_contrato_random);
    END;

CREATE OR REPLACE TRIGGER Despedir_empleado AFTER INSERT ON contrato_vencido FOR EACH ROW
    DECLARE
        rol_aux rol.id%type;
        salario_aux contrato.salario%type;
        sucursal_aux contrato.id_sucursal%type;
        id_empleado_aux contrato.id_empleado%type;
        contar_empleado number;
        nombre_empleado varchar(50);
        nombre2_empleado varchar(50);
        rol_nombre rol.nombre%type;
        sucursal_nombre sucursal.nombre%type;
    BEGIN
        select count(*) into contar_empleado from empleado e where not exists
                    (select 1 from contrato c where c.id_empleado = e.id);
        select c.id_empleado into id_empleado_aux from contrato c where c.id=:new.id_contrato;
        select c.id_rol into rol_aux from contrato c  where c.id=:new.id_contrato;
        select c.salario into salario_aux from contrato c where c.id=:new.id_contrato;
        select c.id_sucursal into sucursal_aux from contrato c where c.id=:new.id_contrato;


               update contrato c set c.motivo_egreso='Despedido',
                                    c.fechas=CALENDARIO(c.fechas.FECHA_INICIO,SYSDATE)
                                where c.id_empleado=id_empleado_aux and c.id=:new.id_contrato;
               DBMS_OUTPUT.PUT_LINE(' ');
               DBMS_OUTPUT.PUT_LINE('Se ha actualizado el estado del contrato a Despedido');

                if contar_empleado<=0 then
                    RAISE_APPLICATION_ERROR(-20006,'No existen empleados sin contrato, no se puede recontratar y por ende tampoco se despide');
                end if;
               if contar_empleado>0 then
                   select e.datos.primer_nombre into nombre_empleado from empleado e where not exists
                                                (select 1 from contrato c where c.id_empleado = e.id) and ROWNUM=1;
                   select e.datos.primer_apellido into nombre2_empleado from empleado e where not exists
                                               (select 1 from contrato c where c.id_empleado = e.id) and ROWNUM=1;
                   insert into contrato  values(CONTRATO_SEQ.nextval, CALENDARIO(to_date(SYSDATE), null), '', salario_aux, rol_aux,
                                                (select e.id from empleado e where not exists
                                                (select 1 from contrato c where c.id_empleado = e.id) and ROWNUM=1),
                                                 sucursal_aux);
                    select rol.nombre into rol_nombre from rol where rol.id=rol_aux;
                    select sucursal.nombre into sucursal_nombre from sucursal where sucursal.id=sucursal_aux;
                    DBMS_OUTPUT.PUT_LINE(' ');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un nuevo contrato con el empleado '|| nombre_empleado || ' ' || nombre2_empleado
                                                 || ' con el rol de ' || rol_nombre
                                                 || ' en la sucursal ' || sucursal_nombre);

                end if;

    END;