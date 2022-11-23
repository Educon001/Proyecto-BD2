/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-----------------------------------------------------------------------SIMULACIÓN 8------------------------------------------------------------------------------

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/


CREATE OR REPLACE PROCEDURE Simulacion_8 IS
        promocion_random promocion.id%type;
        cantidad_random promocion_pedido.cantidad%type;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-------------- SIMULACIÓN #8: SE REALIZA UN PEDIDO DE UNA PROMOCION ------------------');

        DBMS_OUTPUT.PUT_LINE('Se elige una promocion y una cantidad a pedir de la misma aleatoreamente...');

        SELECT id
        INTO promocion_random
        from (  select *
                from PROMOCION
                order by dbms_random.value )
        where rownum <= 1;

        select ROUND(((10 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into cantidad_random from DUAL;

        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('La promocion es la #' || to_char(promocion_random));
        DBMS_OUTPUT.PUT_LINE('La cantidad a pedir es de '|| to_char(cantidad_random));
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE(' ');

        insert into promocion_pedido values(promocion_random,PEDIDO_SEQ.nextval,cantidad_random);
    END;


CREATE OR REPLACE TRIGGER Pedir_Promocion AFTER INSERT ON promocion_pedido FOR EACH ROW
    DECLARE
        tipo_promocion_aux pedido.tipo%type;
        sucursal_aleatoria sucursal.id%type;
        cliente_aleatorio cliente.id%type;
        aux_tipo_pedido number;
        monto_final_promo float;
        aux_plato_promocion_id plato_promocion.codigo_plato%type;
        precio_con_descuento float;
        precio_plato_aux float;
        aux_tipo_pago number;
        aux_id_pago number;
    BEGIN

        select p.tipo into tipo_promocion_aux from promocion p where p.id= :new.id_promocion;

        IF (tipo_promocion_aux='DESCUENTO') THEN

                DBMS_OUTPUT.PUT_LINE('La promoción a pedir es de tipo DESCUENTO');
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('--------------------------------------');

                cliente_aleatorio:=CLIENTE_RANDOM();
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El cliente que realizará el pedido es el #' || to_char(cliente_aleatorio));

                sucursal_aleatoria:=SUCURSAL_RANDOM();
                DBMS_OUTPUT.PUT_LINE('La sucursal a la cual se realizará el pedido es la #' || to_char(sucursal_aleatoria));

                select ROUND(((3 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into aux_tipo_pedido from DUAL;

                select codigo_plato into aux_plato_promocion_id from plato_promocion pp where pp.id_promocion=:new.id_promocion;
                select precio_unitario into precio_plato_aux from plato p where p.codigo=aux_plato_promocion_id;
                select (precio_plato_aux-((precio_plato_aux)*(p.precio_descuento))) into precio_con_descuento from promocion p where p.id=:new.id_promocion;
                select ((precio_con_descuento)*(:NEW.cantidad)) into monto_final_promo from promocion p where p.id=:new.id_pedido;

                DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El monto final por el pedido de las promociones es de $' || to_char(monto_final_promo));
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El tipo de pedido se seleccionará de manera aleatorea:');
                DBMS_OUTPUT.PUT_LINE('');

                IF (aux_tipo_pedido=1) THEN

                        DBMS_OUTPUT.PUT_LINE('El pedido es de tipo EN LOCAL');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'EN LOCAL',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                END IF;

                IF (aux_tipo_pedido=2) THEN

                        DBMS_OUTPUT.PUT_LINE('El pedido es de tipo DELIVERY');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'DELIVERY',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                END IF;

                IF (aux_tipo_pedido=3) THEN

                         DBMS_OUTPUT.PUT_LINE('El pedido es de tipo PICK-UP');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'PICK-UP',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                END IF;

                DBMS_OUTPUT.PUT_LINE('Procedemos a realizar el pago de manera aleatorea');
                    select ROUND(((7 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into aux_tipo_pago from cliente;
                    DBMS_OUTPUT.PUT_LINE('');

                    IF (aux_tipo_pago=1) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: EFECTIVO');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');
                    END IF;

                    IF (aux_tipo_pago=2) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: POS');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'POS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: POS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=3) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZELLE');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'ZELLE');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZELLE');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=4) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PIPOL PAY');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=5) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PAYPAL');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=6) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZINLI');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'ZINLI');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZINLI');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=7) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: CRIPTOMONEDAS');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;
        END IF;


        IF (tipo_promocion_aux='COMBO') THEN

                DBMS_OUTPUT.PUT_LINE('La promoción a pedir es de tipo COMBO');
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('--------------------------------------');

                select id into cliente_aleatorio from cliente where rownum=1 order by dbms_random.value;
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El cliente que realizará el pedido es el #' || to_char(cliente_aleatorio));

                select id into sucursal_aleatoria from sucursal where rownum=1 order by dbms_random.value;
                DBMS_OUTPUT.PUT_LINE('La sucursal a la cual se realizará el pedido es la #' || to_char(sucursal_aleatoria));

                select ROUND(((3 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into aux_tipo_pedido from DUAL;

                select ((p.precio_descuento)*(:new.cantidad)) into monto_final_promo from promocion p where p.id=:new.id_promocion;
                DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------');
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El monto final por el pedido de las promociones es de $' || to_char(monto_final_promo));
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('El tipo de pedido se seleccionará de manera aleatorea:');
                DBMS_OUTPUT.PUT_LINE('');

                IF (aux_tipo_pedido=1) THEN

                        DBMS_OUTPUT.PUT_LINE('El pedido es de tipo EN LOCAL');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'EN LOCAL',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                END IF;

                IF (aux_tipo_pedido=2) THEN

                        DBMS_OUTPUT.PUT_LINE('El pedido es de tipo DELIVERY');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'DELIVERY',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                END IF;

                IF (aux_tipo_pedido=3) THEN

                         DBMS_OUTPUT.PUT_LINE('El pedido es de tipo PICK-UP');
                         insert into pedido values(sucursal_aleatoria,cliente_aleatorio,:new.id_pedido,'PICK-UP',
                    SYSTIMESTAMP,monto_final_promo);
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                    DBMS_OUTPUT.PUT_LINE('Se ha generado un pedido exitosamente con los datos anteriormente señalados');
                    DBMS_OUTPUT.PUT_LINE('');

                END IF;

                DBMS_OUTPUT.PUT_LINE('Procedemos a realizar el pago de manera aleatorea');
                    select ROUND(((7 - 1) * DBMS_RANDOM.VALUE() + 1), 0) into aux_tipo_pago from DUAL;
                    DBMS_OUTPUT.PUT_LINE('');

                    IF (aux_tipo_pago=1) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: EFECTIVO');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: EFECTIVO');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');
                    END IF;

                    IF (aux_tipo_pago=2) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: POS');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'POS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: POS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=3) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZELLE');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'ZELLE');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZELLE');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=4) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PIPOL PAY');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PIPOL PAY');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=5) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: PAYPAL');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: PAYPAL');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=6) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: ZINLI');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'ZINLI');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: ZINLI');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;

                    IF (aux_tipo_pago=7) THEN

                    DBMS_OUTPUT.PUT_LINE('El tipo de pago es: CRIPTOMONEDAS');

                        insert into pago_pedido values(PAGO_PEDIDO_SEQ.nextval,:new.id_pedido,cliente_aleatorio,sucursal_aleatoria,monto_final_promo,'CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Se ha generado un pago exitosamente');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('FACTURA');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('Número de pedido: ' || :new.id_pedido);
                        DBMS_OUTPUT.PUT_LINE('Número de cliente: ' || cliente_aleatorio);
                        DBMS_OUTPUT.PUT_LINE('Número de sucursal: ' || sucursal_aleatoria);
                        DBMS_OUTPUT.PUT_LINE('Monto: ' || monto_final_promo);
                        DBMS_OUTPUT.PUT_LINE('Tipo de pago: CRIPTOMONEDAS');
                        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
                        DBMS_OUTPUT.PUT_LINE('');
                        DBMS_OUTPUT.PUT_LINE('Gracias por su compra');

                    END IF;
        END IF;

    END;
