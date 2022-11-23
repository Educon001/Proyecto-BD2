-- SIMULACION #7: Ganancia obtenida de un día según ingresos y egresos por día en una sucursal

CREATE OR REPLACE PACKAGE simulacion7_pkg IS
    FUNCTION total_pagos_pedidos(sucursal_id SUCURSAL.ID%type, fecha DATE) RETURN FLOAT;
    FUNCTION total_pagos_reservas(sucursal_id SUCURSAL.ID%type, fecha_parametro DATE) RETURN FLOAT;
    FUNCTION total_egresos_dia(sucursal_id SUCURSAL.ID%TYPE, fecha DATE) RETURN FLOAT;

    PROCEDURE mostrar_pagos_pedidos(num NUMBER, id_pago NUMBER, id_pedido NUMBER, monto FLOAT);
    PROCEDURE mostrar_pagos_reservas(num NUMBER, id_pago NUMBER, id_RESERVA NUMBER, monto FLOAT);
    PROCEDURE mostrar_egresos(num NUMBER, motivo egreso.motivo%type, monto egreso.monto%type);
    PROCEDURE simulacion_7;
END;

CREATE OR REPLACE PACKAGE BODY simulacion7_pkg IS

PROCEDURE mostrar_pagos_pedidos(num NUMBER, id_pago NUMBER, id_pedido NUMBER, monto FLOAT)
IS
BEGIN
        DBMS_OUTPUT.PUT_LINE('('||num||') Pago N°'||id_pago||' ||  PEDIDO N°'||id_pedido||' || MONTO = '||monto||'$');
end;

PROCEDURE mostrar_pagos_reservas(num NUMBER, id_pago NUMBER, id_RESERVA NUMBER, monto FLOAT)
IS
BEGIN
        DBMS_OUTPUT.PUT_LINE('('||num||') Pago N°'||id_pago||' ||  RESERVA N°'||id_RESERVA||' || MONTO = '||monto||'$');
end;

FUNCTION total_pagos_pedidos(sucursal_id SUCURSAL.ID%type, fecha DATE)
RETURN FLOAT IS
    total FLOAT;
    num NUMBER;

    CURSOR cppedidos IS
        SELECT PP.ID, PP.ID_PEDIDO, PP.MONTO
        FROM PAGO_PEDIDO PP JOIN PEDIDO P
        ON (PP.ID_PEDIDO = P.ID)
        WHERE PP.ID_SUCURSAL = sucursal_id AND
              EXTRACT(YEAR FROM P.FECHA_HORA) = EXTRACT(YEAR FROM fecha) AND
              EXTRACT(MONTH FROM P.FECHA_HORA) = EXTRACT(MONTH FROM fecha) AND
              EXTRACT(DAY FROM P.FECHA_HORA) = EXTRACT(DAY FROM fecha)
        ORDER BY PP.ID;
    REGISTRO_PAGO_PEDIDO cppedidos%rowtype;

BEGIN
    OPEN cppedidos;
    FETCH cppedidos INTO REGISTRO_PAGO_PEDIDO;
    num:=1; total:=0;
    WHILE cppedidos%FOUND
    LOOP
        mostrar_pagos_pedidos(num,REGISTRO_PAGO_PEDIDO.ID,REGISTRO_PAGO_PEDIDO.ID_PEDIDO,REGISTRO_PAGO_PEDIDO.MONTO);
        total:=total+REGISTRO_PAGO_PEDIDO.MONTO;
        num:=num+1;
        FETCH cppedidos INTO REGISTRO_PAGO_PEDIDO;
    END LOOP;
    CLOSE cppedidos;
    RETURN total;
end;


FUNCTION total_pagos_reservas(sucursal_id SUCURSAL.ID%type, fecha_parametro DATE)
RETURN FLOAT IS
    total FLOAT;
    num NUMBER;

    CURSOR cpreserva IS
        SELECT PR.ID, PR.ID_RESERVA, PR.MONTO
        FROM PAGO_RESERVA PR JOIN RESERVA R
        ON (PR.ID_RESERVA = R.ID)
        WHERE R.ID_SUCURSAL = sucursal_id AND
              CAST(TO_DATE(R.FECHA, 'dd/MM/yyyy') AS DATE) = CAST(TO_DATE(fecha_parametro, 'dd/MM/yyyy') AS DATE)
        ORDER BY PR.ID;
    REGISTRO_PAGO_RESERVA cpreserva%rowtype;

BEGIN
    OPEN cpreserva;
    FETCH cpreserva INTO REGISTRO_PAGO_RESERVA;
    num:=1; total:=0;
    WHILE cpreserva%FOUND
    LOOP
        mostrar_pagos_reservas(num,REGISTRO_PAGO_RESERVA.ID,REGISTRO_PAGO_RESERVA.ID_RESERVA,REGISTRO_PAGO_RESERVA.MONTO);
        total:=total+REGISTRO_PAGO_RESERVA.MONTO;
        num:=num+1;
        FETCH cpreserva INTO REGISTRO_PAGO_RESERVA;
    END LOOP;
    CLOSE cpreserva;
    RETURN total;
end;

PROCEDURE mostrar_egresos(num NUMBER, motivo egreso.motivo%type, monto egreso.monto%type) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('('||num||') MOTIVO: '||motivo||' || MONTO = '||monto||'$');
END;

FUNCTION total_egresos_dia(sucursal_id SUCURSAL.ID%TYPE, fecha DATE)
RETURN FLOAT IS
    total FLOAT;
    num NUMBER;

    CURSOR cegreso IS
        SELECT E.MOTIVO, E.MONTO
        FROM EGRESO E
        WHERE E.ID_SUCURSAL = sucursal_id AND
              E.FECHA = fecha;
    REGISTRO_EGRESO cegreso%rowtype;

BEGIN
    OPEN cegreso;
    FETCH cegreso INTO REGISTRO_EGRESO;
    num:=1; total:=0;
    WHILE cegreso%FOUND
    LOOP
        mostrar_egresos(num,REGISTRO_EGRESO.MOTIVO,REGISTRO_EGRESO.MONTO);
        total:=total+REGISTRO_EGRESO.MONTO;
        num:=num+1;
        FETCH cegreso INTO REGISTRO_EGRESO;
    END LOOP;
    CLOSE cegreso;
    RETURN total;
end;

PROCEDURE simulacion_7 IS
    sucursal_id SUCURSAL.ID%TYPE;
    fecha DATE;
    valido NUMBER;
    total_ingresos_ped FLOAT;
    total_ingresos_res FLOAT;
    total_ingresos FLOAT;
    total_egresos FLOAT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------     SIMULACIÓN #7: GANANCIA OBTENIDA EN UN DÍA     ----------');
    DBMS_OUTPUT.PUT_LINE('------------      SEGÚN INGRESOS Y EGRESOS DE UNA SUCURSAL     -----------');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°1: Se selecciona aleatoriamente una sucursal.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    sucursal_id := SUCURSAL_RANDOM();

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°2: Se ingresa una fecha para consultar pagos y gastos.');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
    valido := 0;
    while valido = 0
    LOOP
        SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                        TO_CHAR(CURRENT_DATE-7,'J'),
                        TO_CHAR(CURRENT_DATE+7,'J'))),'J')
        INTO fecha
        FROM DUAL;

        IF fecha BETWEEN (CURRENT_DATE-7) AND CURRENT_DATE THEN
            valido := 1;
            DBMS_OUTPUT.PUT_LINE('La fecha seleccionada ('|| fecha ||') es válida.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('La fecha seleccionada ('|| fecha ||') no es válida.');
        end if;
    end loop;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°3: INGRESOS');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('INGRESOS POR PAGOS DE PEDIDOS');
    total_ingresos_ped:= TOTAL_PAGOS_PEDIDOS(sucursal_id,fecha);
    DBMS_OUTPUT.PUT_LINE('TOTAL EN INGRESOS POR PEDIDOS: '||total_ingresos_ped||'$');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('INGRESOS POR PAGOS DE RESERVAS');
    total_ingresos_res:= TOTAL_PAGOS_RESERVAS(sucursal_id,fecha);
    DBMS_OUTPUT.PUT_LINE('TOTAL EN INGRESOS POR RESERVAS: '||total_ingresos_res||'$');
    total_ingresos := total_ingresos_ped + total_ingresos_res;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('TOTAL EN INGRESOS: '||total_ingresos||'$');

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°4: EGRESOS');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    total_egresos:=TOTAL_EGRESOS_DIA(sucursal_id,fecha);
    DBMS_OUTPUT.PUT_LINE('TOTAL EN EGRESOS: '||total_egresos||'$');

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°5: GANANCIA');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('GANANCIA: '||(total_ingresos-total_egresos)||'$');
end;

END; -- FIN PAQUETE