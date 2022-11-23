CREATE OR REPLACE PACKAGE simulacion9_pkg IS
    FUNCTION plato_random RETURN NUMBER;
    PROCEDURE mensaje_productos_plato(plato_parametro NUMBER);
    FUNCTION proveedor_random(producto_parametro NUMBER) RETURN VARCHAR2;
    PROCEDURE generar_orden(sucursal_parametro NUMBER, producto_parametro NUMBER);
    PROCEDURE solicitar_plato(sucursal_parametro NUMBER, plato_parametro NUMBER);
    PROCEDURE simulacion9;
END;

CREATE OR REPLACE PACKAGE BODY simulacion9_pkg IS

    FUNCTION plato_random RETURN NUMBER IS
        plato_id     PLATO.CODIGO%type;
        nombre_plato PLATO.NOMBRE%type;
    BEGIN
        SELECT CODIGO, NOMBRE
        INTO plato_id, nombre_plato
        from (select CODIGO, NOMBRE
              from PLATO
              order by dbms_random.value)
        where rownum <= 1;
        DBMS_OUTPUT.PUT_LINE('El plato seleccionado es "' || nombre_plato || '"');
        RETURN plato_id;
    END;

    PROCEDURE mensaje_productos_plato(plato_parametro NUMBER) IS
        nombre_prod PRODUCTO.DESCRIPCION%type;
        um_prod     PRODUCTO.UNIDAD_MEDIDA%type;
    BEGIN
        FOR prod IN (SELECT ID_PRODUCTO, CANTIDAD
                     FROM PLATO_PRODUCTO
                     WHERE CODIGO_PLATO = plato_parametro)
            LOOP
                SELECT DESCRIPCION, UNIDAD_MEDIDA
                INTO nombre_prod, um_prod
                FROM PRODUCTO
                WHERE ID = prod.ID_PRODUCTO;
                DBMS_OUTPUT.PUT_LINE(TO_CHAR(prod.CANTIDAD, 'fm990D99') || ' ' || um_prod || ' de ' || nombre_prod);
            end loop;
    END;

    FUNCTION proveedor_random(producto_parametro NUMBER) RETURN VARCHAR2 IS
        proveedor_rif    PROVEEDOR.RIF%type;
        proveedor_nombre PROVEEDOR.NOMBRE%type;
    BEGIN
        BEGIN
            SELECT RIF, NOMBRE
            INTO proveedor_rif, proveedor_nombre
            from (select P.RIF, P.NOMBRE
                  from PROVEEDOR P
                           join PROVEEDOR_PRODUCTO PP on P.RIF = PP.RIF_PROVEEDOR
                  WHERE PP.DISPONIBILIDAD = 1
                    AND PP.ID_PRODUCTO = producto_parametro
                  order by dbms_random.value)
            where rownum <= 1;
        EXCEPTION
            WHEN no_data_found THEN
                DBMS_OUTPUT.PUT_LINE('ERROR: No existen proveedores con el producto disponible, no se ha podido generar la orden');
                RETURN '-1';
        END;
        DBMS_OUTPUT.PUT_LINE('El proveedor seleccionado es "' || proveedor_nombre || '"');
        RETURN proveedor_rif;
    END;

    PROCEDURE generar_orden(sucursal_parametro NUMBER, producto_parametro NUMBER) IS
        cant_prod              NUMBER;
        proveedor_seleccionado PROVEEDOR.RIF%type;
        n_orden NUMBER;
        cap NUMBER;
    BEGIN
        proveedor_seleccionado := proveedor_random(producto_parametro);
        IF proveedor_seleccionado = '-1' THEN
            RETURN;
        end if;

        SELECT (CAPACIDAD_MAXIMA - CANTIDAD) as cant
        INTO cant_prod
        FROM INVENTARIO
        WHERE ID_PRODUCTO = producto_parametro AND ID_SUCURSAL=sucursal_parametro;

        n_orden:=ORDEN_SEQ.nextval;
        INSERT INTO ORDEN_COMPRA (ID, MONTO_TOTAL, COMPLETA, ID_SUCURSAL)
        VALUES (n_orden, 0, 0, sucursal_parametro);
        INSERT INTO PRODUCTO_ORDEN (CANTIDAD, ID_PRODUCTO, RIF_PROVEEDOR, ID_ORDEN)
        VALUES (cant_prod, producto_parametro, proveedor_seleccionado, n_orden);
        UPDATE ORDEN_COMPRA SET COMPLETA=1 WHERE ID = n_orden;
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(RPAD('Orden generada:  |', 18) || RPAD(' N° Orden |', 11) ||
                             RPAD(' Producto solicitado |',22) || RPAD(' Cantidad solicitada |', 22));
        DBMS_OUTPUT.PUT_LINE(LPAD('|', 18) || RPAD(' ' || n_orden, 10) || '|' ||
                             RPAD(' ' || NOMBRE_PRODUCTO(producto_parametro), 21) || '|' ||
                             RPAD(' ' || cant_prod, 21) || '|');
    END;

    PROCEDURE solicitar_plato(sucursal_parametro NUMBER, plato_parametro NUMBER) IS
        c1               SYS_REFCURSOR;
        plato_prod_aux   PLATO_PRODUCTO%rowtype;
        cant_producto    NUMBER;
        producto_agotado NUMBER;
    BEGIN
        OPEN c1 FOR
            SELECT *
            FROM PLATO_PRODUCTO
            WHERE CODIGO_PLATO = plato_parametro;
        producto_agotado := -1;
        FETCH c1 INTO plato_prod_aux;
        WHILE c1%FOUND
            LOOP
                BEGIN
                    SELECT CANTIDAD
                    INTO cant_producto
                    FROM INVENTARIO
                    WHERE ID_SUCURSAL = sucursal_parametro
                      AND ID_PRODUCTO = plato_prod_aux.ID_PRODUCTO;
                EXCEPTION
                    when no_data_found THEN
                        DBMS_OUTPUT.PUT_LINE('ERROR: El plato seleccionado no está disponible en la sucursal seleccionada');
                        RETURN;
                END;
                DBMS_OUTPUT.PUT(nombre_producto(plato_prod_aux.ID_PRODUCTO) || ' disponible: ' ||
                                TO_CHAR(cant_producto, 'fm990d99'));
                IF cant_producto < plato_prod_aux.CANTIDAD THEN
                    DBMS_OUTPUT.PUT_LINE(' (agotado)');
                    producto_agotado := plato_prod_aux.ID_PRODUCTO;
                    exit;
                end if;
                DBMS_OUTPUT.PUT_LINE(' ');
                FETCH c1 INTO plato_prod_aux;
            end loop;
        IF producto_agotado = -1 THEN
            DBMS_OUTPUT.PUT_LINE('Se genera un pedido');
            DBMS_OUTPUT.PUT_LINE(' ');
            INSERT INTO PEDIDO (ID_SUCURSAL, ID, TIPO, FECHA_HORA, MONTO_TOTAL)
            VALUES (sucursal_parametro, PEDIDO_SEQ.nextval, 'EN LOCAL', SYSDATE, 0);
            DBMS_OUTPUT.DISABLE();
            INSERT INTO PLATO_PEDIDO (CODIGO_PLATO, ID_PEDIDO, CANTIDAD)
            VALUES (plato_parametro, PEDIDO_SEQ.currval, 1);
            DBMS_OUTPUT.ENABLE();
            solicitar_plato(sucursal_parametro, plato_parametro);
        ELSE
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Como existe un producto agotado se escoge un provedor aleatorio para realizar una orden de compra para reponer dicho producto');
            generar_orden(sucursal_parametro, producto_agotado);
        end if;
    END;

    PROCEDURE simulacion9 IS
        sucursal_seleccionada NUMBER;
        plato_seleccionado    NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('------------   SIMULACION #9: SE ACABA UN PRODUCTO   ------------');
        DBMS_OUTPUT.PUT_LINE(' ');

        -- Se elige una sucursal aleatoria
        DBMS_OUTPUT.PUT_LINE('Se escoge una sucursal aleatoriamente');
        sucursal_seleccionada := sucursal_random;
        DBMS_OUTPUT.PUT_LINE(' ');

        -- Se elige un plato aleatorio
        DBMS_OUTPUT.PUT_LINE('Se escoge un plato aleatoriamente');
        plato_seleccionado := plato_random;
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Los productos necesarios para el plato son: ');
        mensaje_productos_plato(plato_seleccionado);
        DBMS_OUTPUT.PUT_LINE(' ');

        --Se solicita el plato hasta que se acabe alguno de sus productos
        DBMS_OUTPUT.PUT_LINE('Se generan pedidos con el plato seleccionado hasta que se agote alguno de los productos necesarios');
        solicitar_plato(sucursal_seleccionada, plato_seleccionado);
    END;
END;
