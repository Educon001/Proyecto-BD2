CREATE OR REPLACE PACKAGE simulacion5_pkg IS
    FUNCTION sucursal_random RETURN NUMBER;
    FUNCTION disponible(sucursal_parametro NUMBER, plato_parametro NUMBER) RETURN BOOLEAN;
    FUNCTION plato_recomendado(sucursal_parametro NUMBER) RETURN NUMBER;
    PROCEDURE simulacion5;
END;

CREATE OR REPLACE PACKAGE BODY simulacion5_pkg IS

    FUNCTION sucursal_random
        RETURN NUMBER IS
        id_sucursal SUCURSAL.ID%type;
    BEGIN

        SELECT id
        INTO id_sucursal
        from (select id
              from SUCURSAL
              order by dbms_random.value)
        where rownum <= 1;
        mensaje_sucursal(id_sucursal);
        RETURN id_sucursal;

    END;

    FUNCTION disponible(sucursal_parametro NUMBER, plato_parametro NUMBER) RETURN BOOLEAN IS
        c1               SYS_REFCURSOR;
        cant_aux         NUMBER;
        cant_producto    NUMBER;
        producto_agotado NUMBER;
        producto_id      NUMBER;
    BEGIN
        OPEN c1 FOR
            SELECT CANTIDAD, ID_PRODUCTO
            FROM PLATO_PRODUCTO
            WHERE CODIGO_PLATO = plato_parametro;
        producto_agotado := -1;
        FETCH c1 INTO cant_aux, producto_id;
        WHILE c1%FOUND
            LOOP
                BEGIN
                    SELECT CANTIDAD
                    INTO cant_producto
                    FROM INVENTARIO
                    WHERE ID_SUCURSAL = sucursal_parametro
                      AND ID_PRODUCTO = producto_id;
                EXCEPTION
                    when no_data_found THEN
                        RETURN FALSE;
                END;
                IF cant_producto < cant_aux THEN
                    RETURN FALSE;
                end if;
                FETCH c1 INTO cant_aux, producto_id;
            END LOOP;
        RETURN TRUE;
    end;

    FUNCTION plato_recomendado(sucursal_parametro NUMBER) RETURN NUMBER IS
        primero NUMBER;
    BEGIN
        primero:= 1;
        FOR I IN (SELECT PP.CODIGO_PLATO, P2.NOMBRE, AVG(PP.PUNTAJE) calificacion
                  FROM PLATO_PEDIDO PP
                           join PEDIDO P on P.ID = PP.ID_PEDIDO
                           join PLATO P2 on P2.CODIGO = PP.CODIGO_PLATO
                  WHERE ID_SUCURSAL = 1
                  GROUP BY P2.NOMBRE, PP.CODIGO_PLATO
                  ORDER BY calificacion)
            LOOP
                IF primero = 1 THEN
                    primero := 0;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Se selecciona el siguiente plato');
                end if;
                DBMS_OUTPUT.PUT_LINE('Plato con mayor puntaje: ' || I.NOMBRE || ' (' || ROUND(I.calificacion, 2) || ')');
                IF disponible(sucursal_parametro, I.CODIGO_PLATO) THEN
                    RETURN I.CODIGO_PLATO;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('El plato seleccionado no está disponible');
                    DBMS_OUTPUT.PUT_LINE(' ');
                end if;
            end loop;
        RETURN -1;
    END;

    PROCEDURE simulacion5 IS
        sucursal_seleccionada NUMBER;
        plato_seleccionado    NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('------------   SIMULACION #5: Recomendación de plato del día según calificaciones   ------------');
        DBMS_OUTPUT.PUT_LINE(' ');

        --Se selecciona una sucursal
        DBMS_OUTPUT.PUT_LINE('Se escoge una sucursal aleatoriamente');
        sucursal_seleccionada := sucursal_random();
        DBMS_OUTPUT.PUT_LINE(' ');

        --Se selecciona el plato recomendado
        DBMS_OUTPUT.PUT_LINE('Se selecciona el plato con mayor puntaje en dicha sucursal');
        plato_seleccionado := plato_recomendado(sucursal_seleccionada);
        IF plato_seleccionado = -1 THEN
            DBMS_OUTPUT.PUT_LINE('No se ha podido seleccionar un plato');
            RETURN;
        end if;
        DBMS_OUTPUT.PUT_LINE(' ');

        --Se despliega el plato recomendado
        DBMS_OUTPUT.PUT_LINE('El plato recomendado para el ' || TO_CHAR(CURRENT_DATE, 'dd/MM/yyyy') ||
                             ' en la sucursal "' || nombre_sucursal(sucursal_seleccionada) || '" es: ' ||
                             NOMBRE_PLATO(plato_seleccionado));
    END;
END;
