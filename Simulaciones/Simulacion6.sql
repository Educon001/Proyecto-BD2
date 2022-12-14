--SIMULACION #6: Pago de pedido a través de múltiples métodos

CREATE OR REPLACE PACKAGE simulacion6_pkg IS
    FUNCTION tipo_pedido_random RETURN PEDIDO.TIPO%TYPE;
    FUNCTION plato_random RETURN PLATO.CODIGO%TYPE;
    FUNCTION precio_unitario_plato(cod_plato PLATO.CODIGO%TYPE) RETURN PLATO.PRECIO_UNITARIO%TYPE;
    FUNCTION nombre_plato(cod_plato NUMBER) RETURN PLATO.NOMBRE%TYPE;
    FUNCTION monto_total_sin_iva(id_ped pedido.id%type) RETURN FLOAT;
    FUNCTION iva_pedido(id_ped pedido.id%type) RETURN FLOAT;
    FUNCTION ya_esta_plato_en_pedido(cod_plato PLATO.CODIGO%TYPE, id_ped PEDIDO.ID%TYPE) RETURN NUMBER;
    FUNCTION cantidad_puntaje_random RETURN NUMBER;

    PROCEDURE simulacion_6;
END;


CREATE OR REPLACE PACKAGE BODY simulacion6_pkg IS

-- FUNCION PARA SELECCIONAR TIPO DE PEDIDO
FUNCTION tipo_pedido_random
RETURN PEDIDO.TIPO%TYPE IS
tipo NUMBER;
begin
    SELECT ROUND(DBMS_RANDOM.VALUE(1,2)) INTO tipo FROM DUAL;

    IF tipo = 1 THEN
        RETURN 'EN LOCAL';
    end if;
    IF tipo = 2 THEN
        RETURN 'PICK-UP';
    end if;
    IF tipo = 3 THEN
        RETURN 'DELIVERY';
    end if;
end;


-- FUNCION PARA SELECCIONAR UN PLATO ALEATORIAMENTE
FUNCTION plato_random
RETURN PLATO.CODIGO%TYPE IS
cod_plato PLATO.CODIGO%TYPE;
BEGIN
    SELECT codigo_plato
    INTO cod_plato
    from (  select codigo_plato
            from MENU_DIA
            order by dbms_random.value )
    where rownum <= 1;
    RETURN cod_plato;
END;

FUNCTION cantidad_puntaje_random
RETURN NUMBER IS
numero NUMBER;
BEGIN
    SELECT ROUND(DBMS_RANDOM.VALUE(1,5)) INTO NUMERO FROM DUAL;
    RETURN numero;
end;

-- FUNCION PARA OBTENER EL PRECIO UNITARIO DE UN PLATO
FUNCTION precio_unitario_plato(cod_plato PLATO.CODIGO%TYPE)
RETURN PLATO.PRECIO_UNITARIO%TYPE IS
    precio PLATO.PRECIO_UNITARIO%TYPE;
BEGIN
    SELECT PRECIO_UNITARIO INTO precio FROM PLATO WHERE CODIGO = cod_plato;
    RETURN precio;
END;

FUNCTION nombre_plato(cod_plato NUMBER)
RETURN PLATO.NOMBRE%TYPE IS
    nomb_plato PLATO.NOMBRE%TYPE;
BEGIN
    SELECT NOMBRE INTO nomb_plato FROM PLATO WHERE CODIGO = COD_PLATO;
    RETURN nomb_plato;
end;


FUNCTION monto_total_sin_iva(id_ped pedido.id%type)
RETURN FLOAT IS
    monto pedido.monto_total%type;
BEGIN
    SELECT MONTO_TOTAL
    INTO monto
    FROM PEDIDO
    WHERE ID = id_ped;

    RETURN ROUND((monto/1.16),2);
END;

FUNCTION iva_pedido(id_ped pedido.id%type)
RETURN FLOAT IS
    monto pedido.monto_total%type;
BEGIN
    SELECT MONTO_TOTAL
    INTO monto
    FROM PEDIDO
    WHERE ID = id_ped;

    RETURN ROUND((monto/1.16)*0.16,2);
END;

FUNCTION ya_esta_plato_en_pedido(cod_plato PLATO.CODIGO%TYPE, id_ped PEDIDO.ID%TYPE)
RETURN NUMBER IS
    esta NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO esta
    FROM PLATO_PEDIDO
    WHERE CODIGO_PLATO = cod_plato AND ID_PEDIDO = id_ped;
    RETURN esta;
end;

PROCEDURE simulacion_6 IS
    sucursal_id NUMBER;
    cliente_id NUMBER;
    tipo_pedido PEDIDO.tipo%type;
    id_ped PEDIDO.ID%type;
    numero_platos NUMBER;
    monto_no_pagado FLOAT;
    monto_a_pagar FLOAT;
    plato_cod plato.CODIGO%type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------   SIMULACION #6: PAGO A TRAVES DE MULTIPLES METODOS   ------------');
    DBMS_OUTPUT.PUT_LINE(' ');
    -- SE ELIJE UNA SUCURSAL ALEATORIAMENTE
    DBMS_OUTPUT.PUT_LINE('Paso N°1: Generar un pedido');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
    sucursal_id := SUCURSAL_RANDOM();
    cliente_id := CLIENTE_RANDOM();
    DBMS_OUTPUT.PUT_LINE('ID del cliente: '||cliente_id);
    tipo_pedido := tipo_pedido_random();
    DBMS_OUTPUT.PUT_LINE('Tipo de pedido: '||tipo_pedido);
    DBMS_OUTPUT.PUT_LINE(' ');

    -- GENERACION DEL PEDIDO
    -- NOTA: SE CAMBIO EL CHECK DEL MONTO TOTAL EN EL PEDIDO
    id_ped := PEDIDO_SEQ.nextval;
    INSERT INTO PEDIDO (ID_SUCURSAL, ID_CLIENTE, ID, TIPO, FECHA_HORA,MONTO_TOTAL)
    VALUES (sucursal_id,cliente_id,id_ped,tipo_pedido, CURRENT_TIMESTAMP,0);
    DBMS_OUTPUT.PUT_LINE('PEDIDO REGISTRADO');

    SELECT ROUND(DBMS_RANDOM.VALUE(1,4)) into numero_platos from dual;

    WHILE numero_platos != 0
    LOOP
        -- SELECCIONAR ALEATORIAMENTE UN PLATO PARA EL PEDIDO, SI YA ESTA EN EL PEDIDO, SE BUSCA OTRO
        plato_cod := plato_random();
        if ya_esta_plato_en_pedido(plato_cod,id_ped)=0 THEN
            INSERT INTO PLATO_PEDIDO (CODIGO_PLATO, ID_PEDIDO, CANTIDAD, PUNTAJE)
            VALUES (plato_cod,id_ped,cantidad_puntaje_random(),cantidad_puntaje_random());
        end if;
        numero_platos := numero_platos -1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Monto: '||monto_total_sin_iva(id_ped)||'$');
    DBMS_OUTPUT.PUT_LINE('+ IVA: '||iva_pedido(id_ped)||'$');
    DBMS_OUTPUT.PUT_LINE('--------------');

    SELECT MONTO_TOTAL INTO monto_no_pagado FROM PEDIDO WHERE ID = id_ped;

    DBMS_OUTPUT.PUT_LINE('TOTAL: '||monto_no_pagado||'$');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°2: Generar pagos a través de múltiples métodos');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------');
    WHILE monto_no_pagado != 0
    loop
        IF monto_no_pagado <=2 THEN
            monto_a_pagar := monto_no_pagado;
        ELSE
            SELECT ROUND(DBMS_RANDOM.VALUE(1,monto_no_pagado),2) INTO monto_a_pagar FROM DUAL;
        end if;
        insert into PAGO_PEDIDO (ID, ID_PEDIDO, ID_CLIENTE, ID_SUCURSAL, MONTO, TIPO_PAGO)
        VALUES (PAGO_PEDIDO_SEQ.nextval,id_ped,cliente_id,sucursal_id,monto_a_pagar,ESCOGER_TIPO_PAGO());
        monto_no_pagado := monto_no_pagado - monto_a_pagar;
    end loop;
END;

END; -- FIN PAQUETE
