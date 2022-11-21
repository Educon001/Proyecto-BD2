CREATE OR REPLACE TRIGGER insercion_plato_pedido
    AFTER INSERT
    ON PLATO_PEDIDO
    FOR EACH ROW
DECLARE
    monto_plato     FLOAT;
    monto_plato_iva FLOAT;
    iva             FLOAT;
BEGIN
    monto_plato := ROUND(precio_unitario_plato(:new.CODIGO_PLATO) * :new.cantidad, 2);
    iva := ROUND(monto_plato * 0.16, 2);
    monto_plato_iva := monto_plato + iva;
    update PEDIDO
    set MONTO_TOTAL = MONTO_TOTAL + monto_plato_iva
    where ID = :new.ID_PEDIDO;
    DBMS_OUTPUT.PUT(nombre_plato(:new.CODIGO_PLATO) || ': $' || precio_unitario_plato(:new.CODIGO_PLATO) || ' x ' ||
                    :new.CANTIDAD);
    DBMS_OUTPUT.PUT_LINE(' = $' || monto_plato);
end;

CREATE OR REPLACE TRIGGER resta_inventario_plato
    AFTER INSERT
    ON PLATO_PEDIDO
    FOR EACH ROW
DECLARE
    sucursal_id NUMBER;
BEGIN
    SELECT ID_SUCURSAL
    INTO sucursal_id
    FROM PEDIDO
    WHERE ID = :new.ID_PEDIDO;
    FOR prod IN (SELECT CANTIDAD, ID_PRODUCTO
                 FROM PLATO_PRODUCTO
                 WHERE CODIGO_PLATO = :new.CODIGO_PLATO)
        LOOP
            UPDATE INVENTARIO
            SET CANTIDAD=CANTIDAD - prod.CANTIDAD
            WHERE ID_PRODUCTO = prod.ID_PRODUCTO AND ID_SUCURSAL = sucursal_id;
        end loop;
end;