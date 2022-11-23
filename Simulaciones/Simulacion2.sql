CREATE OR REPLACE PACKAGE simulacion2_pkg IS
    FUNCTION generar_fecha_random RETURN DATE;
    FUNCTION validar_fecha_menu_dia(fecha_parametro DATE, sucursal_id NUMBER) RETURN NUMBER;
    FUNCTION seleccionar_platos(fecha_parametro DATE, sucursal_id NUMBER) RETURN NUMBER;
    PROCEDURE Simulacion2;
END;

CREATE OR REPLACE PACKAGE BODY simulacion2_pkg IS

--Función que genera una fecha aleatoria
    FUNCTION generar_fecha_random
        RETURN DATE IS
        fecha DATE;
    BEGIN
        SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                TO_CHAR(CURRENT_DATE, 'J'),
                TO_CHAR(CURRENT_DATE + 30, 'J'))), 'J')
        INTO fecha
        FROM DUAL;

        RETURN fecha;
    END;

    FUNCTION validar_fecha_menu_dia(fecha_parametro DATE, sucursal_id NUMBER) RETURN NUMBER IS
        total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO total
        FROM MENU_DIA
        WHERE FECHA = fecha_parametro
          AND ID_SUCURSAL = sucursal_id;

        IF total = 0 THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    end;

    FUNCTION seleccionar_platos(fecha_parametro DATE, sucursal_id NUMBER) RETURN NUMBER IS
        c1                  SYS_REFCURSOR;
        plato_aux           PLATO%rowtype;
        cant_temp           NUMBER;
        disponible          NUMBER;
        total_seleccionados NUMBER;
    BEGIN
        total_seleccionados := 0;
        OPEN c1 FOR
            SELECT * FROM PLATO;
        DBMS_OUTPUT.PUT_LINE(RPAD('Plato seleccionado',40) || '|' || RPAD(' Disponibilidad',16) || '|');
        DBMS_OUTPUT.PUT_LINE('————————————————————————————————————————|————————————————|');
        FETCH c1 INTO plato_aux;
        WHILE c1%FOUND
            LOOP
                DBMS_OUTPUT.PUT(RPAD(plato_aux.NOMBRE,40) || '|');
                disponible := 1;
                FOR prod IN (SELECT ID_PRODUCTO, CANTIDAD FROM PLATO_PRODUCTO WHERE CODIGO_PLATO = plato_aux.CODIGO)
                    LOOP
                        SELECT CANTIDAD INTO cant_temp FROM INVENTARIO WHERE ID_PRODUCTO = prod.ID_PRODUCTO AND ID_SUCURSAL=sucursal_id;
                        IF cant_temp < prod.CANTIDAD then
                            disponible := 0;
                            EXIT;
                        end if;
                    end loop;
                IF disponible = 1 THEN
                    DBMS_OUTPUT.PUT_LINE(RPAD('       SI',16) || '|');
                    INSERT INTO MENU_DIA(CODIGO_PLATO, ID_SUCURSAL, FECHA)
                    VALUES (plato_aux.CODIGO, sucursal_id, fecha_parametro);
                    total_seleccionados := total_seleccionados + 1;
                ELSE
                    DBMS_OUTPUT.PUT_LINE(RPAD('       NO',16) || '|');
                end if;
                FETCH c1 INTO plato_aux;
            end loop;
        DBMS_OUTPUT.PUT_LINE('—————————————————————————————————————————————————————————');
        RETURN total_seleccionados;
    end;

    PROCEDURE Simulacion2 IS
        sucursal_seleccionada NUMBER;
        fecha_seleccionada    DATE;
        valido                NUMBER;
        platos_seleccionados  NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('------------   SIMULACION #2: GENERACIÓN DEL MENÚ DEL DÍA   ------------');
        DBMS_OUTPUT.PUT_LINE(' ');

        -- Se elige una sucursal aleatoria
        DBMS_OUTPUT.PUT_LINE('Se escoge una sucursal aleatoriamente');
        sucursal_seleccionada := sucursal_random;
        DBMS_OUTPUT.PUT_LINE(' ');

        -- Se elige una fecha aleatoria
        DBMS_OUTPUT.PUT_LINE('Se escoje una fecha aleatoria en la cual el menú del día no haya sido generado previamente');
        valido := 0;
        WHILE valido = 0
            LOOP
                fecha_seleccionada := generar_fecha_random();
                valido := validar_fecha_menu_dia(fecha_seleccionada, sucursal_seleccionada);
            end loop;
        DBMS_OUTPUT.PUT_LINE('La fecha seleccionada es: ' || TO_CHAR(fecha_seleccionada, 'dd/MM/yyyy'));
        DBMS_OUTPUT.PUT_LINE(' ');

        --Se seleccionan los platos y se agregan al menú del día en el caso de estar disponibles
        DBMS_OUTPUT.PUT_LINE('Se comprueba la disponibilidad de los productos requeridos para cada plato');
        DBMS_OUTPUT.PUT_LINE(' ');
        platos_seleccionados := seleccionar_platos(fecha_seleccionada, sucursal_seleccionada);
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Se han insertado ' || platos_seleccionados || ' platos en el menú del ' ||
                             to_char(fecha_seleccionada, 'dd/MM/yyyy') || ': ');
        FOR pla IN (SELECT P.NOMBRE
                    FROM PLATO P
                             JOIN MENU_DIA MD on P.CODIGO = MD.CODIGO_PLATO
                    WHERE MD.FECHA = fecha_seleccionada
                      AND MD.ID_SUCURSAL = sucursal_seleccionada)
            LOOP
                DBMS_OUTPUT.PUT_LINE(pla.NOMBRE);
            END LOOP;
    end;
END;
