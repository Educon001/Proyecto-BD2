/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-----------------------------------------------------------------------SIMULACIÓN 1------------------------------------------------------------------------------

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE OR REPLACE PROCEDURE Simulacion_1 IS

    cliente_aleatorio number;
    sede_random number;
    monto_random number;

    BEGIN
        DBMS_OUTPUT.PUT_LINE('-------------- SIMULACIÓN #1: SE REALIZA UN PEDIDO POR DELIVERY ------------------');

        DBMS_OUTPUT.PUT_LINE('Se elige una sucursal y un cliente aleatoriamente...');

        cliente_aleatorio:=CLIENTE_RANDOM();
        sede_random:=SUCURSAL_RANDOM();
        select ROUND(((99 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into monto_random from DUAL;

        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('La sucursal es la #' || to_char(sede_random));
        DBMS_OUTPUT.PUT_LINE('El cliente es el #'|| to_char(cliente_aleatorio));
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Se asigna un monto aleatorio y la fecha actual');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('El monto es: $' || to_char(monto_random));
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Se realiza un pedido de tipo Delivery');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');

        insert into pedido values(sede_random, cliente_aleatorio, pedido_seq.nextval, 'DELIVERY', CURRENT_TIMESTAMP, monto_random);
    END;

CREATE OR REPLACE TRIGGER Delivery_Lejos AFTER INSERT ON PEDIDO FOR EACH ROW
    DECLARE
    latitud1_aux sucursal.direccion.latitud%type;
    longitud1_aux sucursal.direccion.longitud%type;
    latitud2_aux sucursal.direccion.latitud%type;
    longitud2_aux sucursal.direccion.longitud%type;
        aux_tipo_pago number;
        BEGIN
            IF (:NEW.tipo = 'DELIVERY') THEN
                select S.direccion.LATITUD into latitud1_aux from sucursal S WHERE S.ID = :new.ID_SUCURSAL;
                select S.direccion.LONGITUD into longitud1_aux from sucursal S where S.ID = :new.ID_SUCURSAL;
                select Cl.direccion.LATITUD into latitud2_aux from cliente Cl where Cl.ID = :new.ID_CLIENTE;
                select Cl.direccion.LONGITUD into longitud2_aux from cliente Cl where Cl.ID = :new.ID_CLIENTE;
              IF CALCULAR_DISTANCIA (latitud1_aux,longitud1_aux,latitud2_aux,longitud2_aux)>15 THEN
                   RAISE_APPLICATION_ERROR(-20005, 'La distancia entre la sucursal y el cliente es mayor a 15km, no se puede tomar el pedido');
              END IF;
              IF CALCULAR_DISTANCIA (latitud1_aux,longitud1_aux,latitud2_aux,longitud2_aux)<=15 THEN

                   DBMS_OUTPUT.PUT_LINE('Pedido realizado exitosamente');
                   DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                   DBMS_OUTPUT.PUT_LINE(' ');
                   DBMS_OUTPUT.PUT_LINE('Procedemos a realizar el pago de manera aleatoria');
                    select ROUND(((7 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into aux_tipo_pago from DUAL;
                    DBMS_OUTPUT.PUT_LINE('');

                    IF (aux_tipo_pago=1) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: EFECTIVO');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal, :new.monto_total,'EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');
                    END IF;

                    IF (aux_tipo_pago=2) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: POS');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'POS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: POS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=3) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZELLE');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'ZELLE');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZELLE');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=4) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PIPOL PAY');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=5) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PAYPAL');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=6) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZINLI');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'ZINLI');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZINLI');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=7) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: CRIPTOMONEDAS');

                        insert into pago_pedido values(pago_pedido_seq.nextval,:new.id,:new.id_cliente,:new.id_sucursal,:new.monto_total,'CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || :new.id_cliente);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || :new.id_sucursal);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || :new.monto_total);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

              END IF;
            END IF;
        END;
