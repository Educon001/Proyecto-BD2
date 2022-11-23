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
            WHERE ID_PRODUCTO = prod.ID_PRODUCTO
              AND ID_SUCURSAL = sucursal_id;
        end loop;
end;

CREATE OR REPLACE TRIGGER insercion_producto_orden
    AFTER INSERT
    ON PRODUCTO_ORDEN
    FOR EACH ROW
DECLARE
    monto_orden     FLOAT;
    precio_producto FLOAT;
BEGIN
    SELECT PRECIO
    INTO precio_producto
    FROM PROVEEDOR_PRODUCTO
    WHERE ID_PRODUCTO = :new.ID_PRODUCTO
      AND RIF_PROVEEDOR = :new.RIF_PROVEEDOR;

    monto_orden := ROUND(precio_producto * :new.cantidad, 2);
    update ORDEN_COMPRA
    set MONTO_TOTAL = MONTO_TOTAL + monto_orden
    where ID = :new.ID_ORDEN;
end;

CREATE OR REPLACE TRIGGER orden_completada
    AFTER UPDATE OF COMPLETA
    ON ORDEN_COMPRA
    FOR EACH ROW
DECLARE
    cant NUMBER;
BEGIN
    IF :new.COMPLETA = 1 THEN
        INSERT INTO EGRESO (ID, FECHA, MOTIVO, MONTO, ID_SUCURSAL, ID_ORDEN)
        VALUES (EGRESO_SEQ.nextval, CURRENT_DATE, 'Reposicón de inventario', :new.MONTO_TOTAL, :new.ID_SUCURSAL,
                :new.ID);
        FOR prod IN (SELECT ID_PRODUCTO, CANTIDAD
                     FROM PRODUCTO_ORDEN
                     WHERE ID_ORDEN = :new.ID)
            LOOP
                UPDATE INVENTARIO
                SET CANTIDAD=CANTIDAD+prod.CANTIDAD,
                    FECHA_INVENTARIO=CURRENT_DATE
                WHERE ID_PRODUCTO = prod.ID_PRODUCTO
                  AND ID_SUCURSAL = :new.ID_SUCURSAL;
            end loop;
    end if;
end;

-- TRIGGER INSERCION DE RESERVA (GENERAR PAGO DEL ABONO INICIAL DESPUES DE REALIZAR RESERVA)
CREATE OR REPLACE TRIGGER insercion_reserva
AFTER INSERT ON RESERVA FOR EACH ROW
DECLARE
BEGIN
    insert into PAGO_RESERVA VALUES (PAGO_RESERVA_SEQ.nextval,:new.ID,:new.abono_inicial,escoger_tipo_pago());
end;

CREATE OR REPLACE TRIGGER insercion_pago_reserva
AFTER INSERT ON PAGO_RESERVA FOR EACH ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('PAGO DE RESERVA REGISTRADO');
    DBMS_OUTPUT.PUT_LINE('__________________________');
    DBMS_OUTPUT.PUT_LINE('N° de reserva: '||:new.ID_RESERVA);
    DBMS_OUTPUT.PUT_LINE('Monto: $'||:new.monto);
    DBMS_OUTPUT.PUT_LINE('Tipo de pago: '||:new.TIPO_PAGO);
end;

CREATE OR REPLACE TRIGGER insercion_pago_pedido
AFTER INSERT ON PAGO_PEDIDO FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('N° FACTURA: '||:new.ID_PEDIDO||'     ||     Monto:'||:new.MONTO||'$     ||     Método de pago: '||:new.TIPO_PAGO);
END;