CREATE OR REPLACE PACKAGE simulacion9_pkg IS
    PROCEDURE mensaje_sucursal(sucursal_seleccionada NUMBER);
    FUNCTION sucursal_random RETURN NUMBER;
    PROCEDURE mensaje_producto(producto_seleccionado NUMBER);
    FUNCTION producto_random(sucursal_parametro NUMBER) RETURN NUMBER;
    --PROCEDURE compra_producto(sucursal_parametro NUMBER, producto_parametro NUMBER);
    FUNCTION plato_random RETURN NUMBER;
    PROCEDURE mensaje_productos_plato(plato_parametro NUMBER);
    PROCEDURE solicitar_plato(sucursal_parametro NUMBER, plato_parametro NUMBER);
    PROCEDURE simulacion9;
END;

CREATE OR REPLACE PACKAGE BODY simulacion9_pkg IS
    PROCEDURE mensaje_sucursal(sucursal_seleccionada NUMBER) IS
        nombre_sucursal SUCURSAL.NOMBRE%type;
    BEGIN
        SELECT NOMBRE
        INTO nombre_sucursal
        FROM SUCURSAL
        WHERE ID = sucursal_seleccionada;

        DBMS_OUTPUT.PUT_LINE('Se ha seleccionado la sucursal "' || nombre_sucursal || '"');
    END;

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

    PROCEDURE mensaje_producto(producto_seleccionado NUMBER) IS
        nombre_producto PRODUCTO.DESCRIPCION%type;
    BEGIN
        SELECT DESCRIPCION
        INTO nombre_producto
        FROM PRODUCTO
        WHERE ID = producto_seleccionado;

        DBMS_OUTPUT.PUT_LINE('Se ha seleccionado el producto "' || nombre_producto || '"');
    END;

    FUNCTION producto_random(sucursal_parametro NUMBER) RETURN NUMBER IS
        producto_id PRODUCTO.ID%type;
    BEGIN
        BEGIN
            SELECT ID_PRODUCTO
            INTO producto_id
            from (select ID_PRODUCTO
                  from INVENTARIO
                  WHERE ID_SUCURSAL = sucursal_parametro
                  order by dbms_random.value)
            where rownum <= 1;
        EXCEPTION
            WHEN no_data_found THEN
                DBMS_OUTPUT.PUT_LINE('ERROR: La sucursal seleccionada no contiene productos en su inventario');
                RETURN -1;
        END;
        mensaje_producto(producto_id);
        RETURN producto_id;
    END;

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
                DBMS_OUTPUT.PUT_LINE(prod.CANTIDAD || ' ' || um_prod || ' de ' || nombre_prod);
            end loop;
    END;

    PROCEDURE solicitar_plato(sucursal_parametro NUMBER, plato_parametro NUMBER) IS
        c1               SYS_REFCURSOR;
        plato_prod_aux   PLATO_PRODUCTO%rowtype;
        cant_producto    NUMBER;
        producto_agotado NUMBER;
    BEGIN
        OPEN c1 FOR
            SELECT ID_PRODUCTO, CANTIDAD, CODIGO_PLATO
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
                END;
                IF cant_producto < plato_prod_aux.CANTIDAD THEN
                    producto_agotado := plato_prod_aux.ID_PRODUCTO;
                    exit;
                end if;
            end loop;
        IF producto_agotado = -1 THEN
            INSERT INTO PEDIDO (ID_SUCURSAL, ID, TIPO, FECHA_HORA, MONTO_TOTAL)
            VALUES (sucursal_parametro, PEDIDO_SEQ.nextval, 'EN LOCAL', SYSDATE, 0);
            INSERT INTO PLATO_PEDIDO (CODIGO_PLATO, ID_PEDIDO, CANTIDAD)
            VALUES (plato_parametro, PEDIDO_SEQ.currval, 1);

        ELSE
            DBMS_OUTPUT.PUT_LINE('Comprar producto');
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

BEGIN
    simulacion9_pkg.simulacion9();
end;

SELECT *
FROM PEDIDO;

SELECT *
FROM PLATO_PEDIDO;

DELETE
FROM PLATO_PEDIDO
WHERE ID_PEDIDO >= 41;

DELETE
FROM PEDIDO
WHERE ID >= 41