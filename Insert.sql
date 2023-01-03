--RESTAURANTE
INSERT INTO restaurante
VALUES (1, 'Casa dello chef', FILE_TO_BLOB('logo.jpg'));

--PLATOS
--comida
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Pizza', 'Comida', 'Pizza margarita', 10, FILE_TO_BLOB('pizza.jpg'),'Queso mozarella, tomate y masa');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Hamburguesa', 'Comida', 'Hamburguesa con queso', 6, FILE_TO_BLOB('hamburguesa.jpg'),'Pan, Queso, lechuga, tomate y salsas');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Pasta', 'Comida', 'Pasta con carne', 5, FILE_TO_BLOB('pasta.jpg'), 'Pasta y carne');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Pasticho', 'Comida', 'Pasticho', 6, FILE_TO_BLOB('pasticho.jpg'), 'Pasta, jamon, carne y bechamel');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Ensalada', 'Comida', 'Ensalada caprese', 3, FILE_TO_BLOB('ensalada.jpg'), 'Lechuga, tomate y queso mozzarella');
--bebida
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO)
VALUES (PLATO_SEQ.nextval, 'Agua', 'Bebida', 'Agua minalba 600ml', 1, FILE_TO_BLOB('agua.jpg'));
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO)
VALUES (PLATO_SEQ.nextval, 'Coca-cola', 'Bebida', 'Lata 355ml', 1.5, FILE_TO_BLOB('coca-cola.jpg'));
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO)
VALUES (PLATO_SEQ.nextval, 'Cerveza polar', 'Bebida', 'Botella 222ml', 1, FILE_TO_BLOB('cerveza.jpg'));
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO)
VALUES (PLATO_SEQ.nextval, 'Margarita', 'Bebida', 'Margarita', 2, FILE_TO_BLOB('margarita.jpg'));
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO)
VALUES (PLATO_SEQ.nextval, 'Jugo de fresa', 'Bebida', 'Fresa', 1.5, FILE_TO_BLOB('jugo_fresa.jpg'));
--postre
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Torta tres leches', 'Postre', 'Tres leches individual', 2, FILE_TO_BLOB('tres_leches.jpg'), '3 leches');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Helado de mantecado', 'Postre', 'Cono de helado', 1.5, FILE_TO_BLOB('helado.jpg'), 'Barquilla, mantecado');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Marquesa de chocolate', 'Postre', 'Marquesa individual', 2, FILE_TO_BLOB('marquesa.jpg'), 'Marquesa y chocolate');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Brownie con helado', 'Postre', 'Brownie caliente con helado', 2.5, FILE_TO_BLOB('brownie.jpg'), 'Brownie y helado');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Banana split', 'Postre', 'Banana', 3, FILE_TO_BLOB('banana_split.jpg'), 'Cambur y helado');

--SUCURSALES
INSERT INTO SUCURSAL (ID, NOMBRE, ID_RESTAURANTE, DIRECCION, HORARIO)
VALUES (1, 'Altamira', 1,
        DIRECCION(10.502435859483576, -66.84848639020119,
                  'Parada TransChacao 02, Av. Luis Roche, Caracas 1060, Distrito Capital'),
        HORARIO(TO_DSINTERVAL('0 10:00:00'), TO_DSINTERVAL('0 22:00:00')));

INSERT INTO SUCURSAL (ID, NOMBRE, ID_RESTAURANTE, DIRECCION, HORARIO)
VALUES (2, 'La Trinidad', 1,
        DIRECCION(10.43509066988307, -66.86801219999998, 'Avenida Los Guayabitos, Caracas 1080, Miranda'),
        HORARIO(TO_DSINTERVAL('0 10:00:00'), TO_DSINTERVAL('0 22:00:00')));

INSERT INTO SUCURSAL (ID, NOMBRE, ID_RESTAURANTE, DIRECCION, HORARIO)
VALUES (3, 'Los Samanes', 1,
        DIRECCION(10.454732150512212, -66.85715963424968, 'F43V+R5V, Avenida 1, Caracas 1080, Miranda'),
        HORARIO(TO_DSINTERVAL('0 10:00:00'), TO_DSINTERVAL('0 22:00:00')));

--CLIENTES
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4241927374',DATOS_BASICOS(1,'Jesús','Daniel','Velazquez','Fernández'),DIRECCION(10.436210191840155, -66.84365777624929,'Avenida Sur 11, Caracas 1083, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4241837954',DATOS_BASICOS(2,'María','Alejandra','Farez','Suárez'),DIRECCION(10.482056, -66.860498,'EDIF. QUEIPA, Av. La Trinidad, Caracas 1080, Distrito Capital, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4249403571',DATOS_BASICOS(3,'José','Miguel','Cuesta','Rosa'),DIRECCION(10.43831118787361, -66.8913454072681,'El Rosal Edificio Cascadas, Avenida Alameda, Caracas, Distrito Capital, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4168902647',DATOS_BASICOS(4,'Manuel','Javier','Peña','Barreto'),DIRECCION(10.430839, -66.859916,'Calle Altagracia, Caracas 1080, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4160986371',DATOS_BASICOS(5,'Angela','Estefania','Garriga','Lamura'),DIRECCION(10.430528232815599, -66.88609881890437,'Edificio CIMARU A, Residencias Cimaru A, Caracas 1080, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4129183746',DATOS_BASICOS(6,'Orianna','Arianna','Venegas','González'),DIRECCION(10.469120767772775, -66.84033498247886,'Residencias Oasis, Av. Principal San Luis, Caracas 1061, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4149204716',DATOS_BASICOS(7,'Gilberto','Gabriel','Casas','Palacios'),DIRECCION(10.469120767772775, -66.84033498247886,'F5J5+HVX, Caracas 1061, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4149204245',DATOS_BASICOS(8,'Aaaron','Marco','Noguera','Álvarez'),DIRECCION(10.44015975562321, -66.83777463579197,'Av. El Paují, Caracas 1083, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4169025212',DATOS_BASICOS(9,'Mario','Daniel','Gil','Andarcia'),DIRECCION(10.453453, -66.922653,'Calle La Floresta, Caracas 1090, Distrito Capital, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'2128791273',DATOS_BASICOS(10,'Daniela','Fatima','Fernandes','Arteaga'),DIRECCION(10.48903742907594, -66.95562706971029,'Bella Vista, Caracas 1020, Capital District, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4129933442',DATOS_BASICOS(11,'Ludibia','María','Betancur','Tovar'),DIRECCION(10.471107,-66.875285,'Calle T, Caracas 1080, Distrito Capital, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'2149933551',DATOS_BASICOS(12,'Armando','Manuel','Casas','Guaz'),DIRECCION(10.203077156338898, -71.31196219511452,'Campo Elías, Cd Ojeda 4019, Zulia, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'2149933551',DATOS_BASICOS(13,'Mónica','Karina','Pérez','Cabello'),DIRECCION(10.343533171145806, -67.04071665277675,'C. Miquilén, Los Teques 1201, Miranda, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'2149933551',DATOS_BASICOS(14,'Pedro','Rafael','Arteaga','Manfredonia'),DIRECCION(10.498768, -66.887164,'Av. Colón, Caracas 1050, Distrito Capital, Venezuela'));
INSERT INTO CLIENTE (ID, TELEFONO, DATOS, DIRECCION)
VALUES (CLIENTE_SEQ.nextval,'4143982736',DATOS_BASICOS(15,'Robert','Alfredo','Galarga','Hurtado'),DIRECCION(10.500139, -66.877966,'Av. Los Samanes, Caracas 1050, Distrito Capital, Venezuela'));

--PEDIDOS
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (1,1,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('12/11/2022 10:35','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (1,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,PEDIDO_SEQ.currval,3);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (1,2,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('12/11/2022 11:00','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (1,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,1);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (1,3,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('12/11/2022 14:33','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (1,4,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('19/11/2022 10:45','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (1,5,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('14/11/2022 12:00','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (6,PEDIDO_SEQ.currval,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,PEDIDO_SEQ.currval,1);

--Pedidos sucursal 2
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (2,6,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('18/11/2022 15:12','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,PEDIDO_SEQ.currval,3);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (2,7,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('14/11/2022 19:26','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,1);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (2,8,PEDIDO_SEQ.nextval,'DELIVERY',TO_DATE('13/11/2022 13:13','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (2,9,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('07/11/2022 17:11','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (8,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (2,10,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('21/11/2022 17:27','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (9,PEDIDO_SEQ.currval,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,PEDIDO_SEQ.currval,1);

--PEDIDOS SUCURSAL 3
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (3,11,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('15/11/2022 14:23','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,PEDIDO_SEQ.currval,3);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (3,12,PEDIDO_SEQ.nextval,'DELIVERY',TO_DATE('16/11/2022 11:00','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,1);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (3,13,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('22/11/2022 18:40','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (3,14,PEDIDO_SEQ.nextval,'PICK-UP',TO_DATE('13/11/2022 19:00','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (8,PEDIDO_SEQ.currval,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,PEDIDO_SEQ.currval,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID_CLIENTE,ID,TIPO,FECHA_HORA,MONTO_TOTAL) VALUES (3,15,PEDIDO_SEQ.nextval,'EN LOCAL',TO_DATE('19/11/2022 16:52','dd/MM/yyyy hh24:mi'),0);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,PEDIDO_SEQ.currval,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (9,PEDIDO_SEQ.currval,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,PEDIDO_SEQ.currval,1);

DECLARE
    puntaje_random INTEGER;
BEGIN
    FOR I IN (SELECT * FROM PLATO_PEDIDO)
    LOOP
        SELECT DBMS_RANDOM.VALUE(1,5) INTO puntaje_random FROM DUAL;
        UPDATE PLATO_PEDIDO SET PUNTAJE=puntaje_random WHERE ID_PEDIDO=I.ID_PEDIDO AND CODIGO_PLATO=I.CODIGO_PLATO;
    end loop;
end;

--PAGOS
DECLARE
BEGIN
    FOR I IN (SELECT * FROM PEDIDO)
    LOOP
        INSERT INTO PAGO_PEDIDO (ID, ID_PEDIDO, ID_CLIENTE, ID_SUCURSAL, MONTO, TIPO_PAGO)
        VALUES (PAGO_PEDIDO_SEQ.nextval,I.ID,I.ID_CLIENTE,I.ID_SUCURSAL,I.MONTO_TOTAL,'POS');
    end loop;
end;

--PRODUCTOS
-- INGREDIENTES PARA PIZZA
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Masa','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Tomate','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Queso mozarella','Kg');

-- INGREDIENTES PARA HAMBURGUESA
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Pan','U');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Carne molida','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Queso americano','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Lechuga','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Salsa','L');

-- INGREDIENTES PASTA
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Spaghetti','Kg');

-- INGREDIENTES PASTA
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Jamon','Kg');

-- BEBIDAS
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Agua minalba 600ml','U');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Coca-Cola Lata 355ml','U');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Cerveza Polar botella 222ml','U');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Margarita','U');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Fresa','Kg');

-- POSTRES
-- TRES LECHES
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Leche condensada','L');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Leche entera','L');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Leche evaporada','L');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Huevo','U');
-- Helado de mantecado
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Helado mantecado','L');
-- Marquesa de chocolate
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Mantequilla','Kg');
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Chocolate','Kg');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Banana','Kg');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Pasta lasaña','Kg');

INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES (PRODUCTO_SEQ.nextval,'Harina','Kg');

-- PLATO_PRODUCTO
-- PIZZA
--MASA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (1,1,0.25);
-- TOMATE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (1,2,0.25);
-- QUESO MOZARELLA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (1,3,0.25);

-- HAMBURGUESA
-- Pan
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,4,1);
-- TOMATE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,2,0.08);
-- LECHUGA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,7,0.08);
-- QUESO AMERICANO
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,6,0.1);
-- SALSA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,8,0.05);
-- CARNE MOLIDA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (2,5,0.25);

-- PASTA
-- SPAGHETTI
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (3,9,0.15);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (3,5,0.2);

-- PASTICHO
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (4,24,0.2);
-- TOMATE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (4,2,0.2);
-- LECHE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (4,17,0.1);
-- CARNE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (4,5,0.15);


-- ENSALADA
-- TOMATE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (5,2,0.3);
-- LECHUGA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (5,7,0.3);
-- QUESO MOZARELLA
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (5,3,0.3);

-- BEBIDAS
-- Agua
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (6,11,1);
-- Coca-Cola
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (7,12,1);
-- Cerveza Polar
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (8,13,1);
-- Margarita
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (9,14,1);
-- Jugo de fresa
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (10,15,0.1);


-- POSTRES
-- TRES LECHES
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (11,17,1);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (11,18,1);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (11,19,2);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (11,16,0.25);

-- Helado de mantecado
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (12,20,0.25);

-- MARQUESA DE CHOCOLATE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (13,18,0.01);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (13,19,1);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (13,21,0.25);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (13,22,0.2);

-- BROWNIE
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,18,0.01);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,19,1);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,21,0.25);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,22,0.2);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,25,0.2);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (14,20,0.25);

-- BANANA SPLIT
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (15,23,0.2);
INSERT INTO PLATO_PRODUCTO (CODIGO_PLATO, ID_PRODUCTO, CANTIDAD)
VALUES (15,20,0.25);



--EMPLEADOS
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Walter.jpg'), '7-sep-1958', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(1234567), 'Walter', NULL, 'Blanco', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Jesse.jpg'), '10-sep-1984', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(4234568), 'José', 'Miguel', 'Rosas', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Saul.jpg'), '12-nov-1960', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(2234567), 'Saul', NULL, 'Bueno', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Jaisenber.jpg'), '7-sep-1958', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(1234568), 'Jaisenber', NULL, 'Blanco', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Skyler.jpg'), '8-nov-1970', 'F',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(6531272), 'Cielo', NULL, 'Blanco', 'Lambert'));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Marie.jpg'), '15-jun-1972', 'F',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(6831272), 'María', NULL, 'Navarro', 'Lambert'));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Hank.jpg'), '19-mar-1966', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(5673468), 'Henry', NULL, 'Navarro', 'Lambert'));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('WaltJr.jpg'), '8-jul-1993', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(12345762), 'Walter Jr', NULL, 'Blanco', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Gustavo.jpg'), '24-jan-1958', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(1235794), 'Gustavo', NULL, 'Cortés', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Lydia.jpg'), '27-may-1975', 'F',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(8726452), 'Lidia', NULL, 'Barrera', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Mike.jpg'), '31-jan-1942', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(1093020), 'Mario', NULL, 'Arboleda', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Nacho.jpg'), '9-dec-1971', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(8452152), 'Ignacio', NULL, 'Varga', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Lalo.jpg'), '12-aug-1960', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(8452152), 'Eduardo', NULL, 'Salamanca', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Kim.jpg'), '13-feb-1968', 'F',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(7260984), 'Kimberly', NULL, 'Wexler', NULL));
INSERT INTO EMPLEADO (ID, FOTO_CARNET, FECHA_NACIMIENTO, SEXO, DATOS)
VALUES (EMPLEADO_SEQ.nextval, FILE_TO_BLOB('Dwight.jpg'), '20-jan-1970', 'M',
        DATOS_BASICOS(DATOS_BASICOS.VALIDARCI(9230142), 'Dwight', NULL, 'Schrute', NULL));

--INVENTARIO
DECLARE
    cap NUMBER;
    porcentaje_random NUMBER;
    um VARCHAR2(3);
begin
    FOR I IN(SELECT *
             FROM PRODUCTO)
    LOOP

        SELECT MAX(CANTIDAD)*20
        INTO cap
        FROM PLATO_PRODUCTO PP, PRODUCTO PR, PLATO PL
        WHERE PP.id_producto=PR.ID AND PP.CODIGO_PLATO=PL.CODIGO AND PR.ID = I.ID;

        IF cap IS null THEN
            cap:= 10;
        END IF;

        SELECT UNIDAD_MEDIDA
        INTO um
        FROM PRODUCTO
        WHERE ID=I.ID;

        FOR J IN (SELECT ID FROM SUCURSAL)
        LOOP
            SELECT ROUND(DBMS_RANDOM.VALUE(0,0.5),2) INTO porcentaje_random FROM DUAL;
            IF um='U' THEN
                INSERT INTO INVENTARIO (ID_PRODUCTO,ID_SUCURSAL,FECHA_INVENTARIO,CAPACIDAD_MAXIMA,CANTIDAD) VALUES
                (I.ID,J.ID,CURRENT_DATE,cap,ROUND(cap*porcentaje_random));
            else
                INSERT INTO INVENTARIO (ID_PRODUCTO,ID_SUCURSAL,FECHA_INVENTARIO,CAPACIDAD_MAXIMA,CANTIDAD) VALUES
                (I.ID,J.ID,CURRENT_DATE,cap,cap*porcentaje_random);
            end if;
        END LOOP;
    END LOOP;
end;

--MESAS
DECLARE
    numero_de_mesas NUMBER;
    nmesa NUMBER;
    cap NUMBER;
BEGIN
    FOR I IN (SELECT ID
              FROM SUCURSAL)
    LOOP
        SELECT ROUND(DBMS_RANDOM.VALUE(5,20)) INTO numero_de_mesas FROM DUAL;
        nmesa := 1;
        WHILE numero_de_mesas != 0
        LOOP
            SELECT ROUND(DBMS_RANDOM.VALUE(1,12)) INTO cap FROM DUAL;
            INSERT INTO MESA (ID_SUCURSAL, NUM_MESA, CAPACIDAD, DISPONIBLE)
            VALUES (I.ID,nmesa,cap,1);
            nmesa:=nmesa+1;
            numero_de_mesas := numero_de_mesas - 1;
        end loop;

    end loop;
END;

--PROMOCIONES
insert into promocion values(1,PROMO_SEQ.nextval,'2x1',CALENDARIO(to_date('2022-11-09','yyyy-mm-dd'),to_date('2022-11-12','yyyy-mm-dd')),3,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (2,PROMO_SEQ.currval,1);
insert into promocion values(2,PROMO_SEQ.nextval,'Postre a 2$',CALENDARIO(to_date('2022-11-09','yyyy-mm-dd'),to_date('2022-11-15','yyyy-mm-dd')),2,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (15,PROMO_SEQ.currval,1);
insert into promocion values(3,PROMO_SEQ.nextval,'Postre a 1$',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-11-07','yyyy-mm-dd')),1,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (13,PROMO_SEQ.currval,1);
insert into promocion values(1,PROMO_SEQ.nextval,'Bebida a 1$',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-11-18','yyyy-mm-dd')),1,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (7,PROMO_SEQ.currval,1);
insert into promocion values(2,PROMO_SEQ.nextval,'Bebida a 0.5$',CALENDARIO(to_date('2022-10-01','yyyy-mm-dd'),to_date('2022-11-01','yyyy-mm-dd')),0.5,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (6,PROMO_SEQ.currval,1);
insert into promocion values(3,PROMO_SEQ.nextval,'Plato principal a 5$',CALENDARIO(to_date('2022-10-01','yyyy-mm-dd'),to_date('2022-10-10','yyyy-mm-dd')),5,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (4,PROMO_SEQ.currval,1);
insert into promocion values(1,PROMO_SEQ.nextval,'Descuento de 30%',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-12-01','yyyy-mm-dd')),7,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (1,PROMO_SEQ.currval,1);
insert into promocion values(2,PROMO_SEQ.nextval,'Descuento de 10%',CALENDARIO(to_date('2022-10-30','yyyy-mm-dd'),to_date('2022-11-22','yyyy-mm-dd')),4.5,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (3,PROMO_SEQ.currval,1);
insert into promocion values(3,PROMO_SEQ.nextval,'Descuento de 15%',CALENDARIO(to_date('2022-11-03','yyyy-mm-dd'),to_date('2022-12-03','yyyy-mm-dd')),8.5,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (1,PROMO_SEQ.currval,1);
insert into promocion values(1,PROMO_SEQ.nextval,'Descuento de 50%',CALENDARIO(to_date('2022-11-20','yyyy-mm-dd'),to_date('2022-11-25','yyyy-mm-dd')),1.50,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (5,PROMO_SEQ.currval,1);
insert into promocion values(2,PROMO_SEQ.nextval,'Descuento de 5%',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-12-01','yyyy-mm-dd')),5.7,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (4,PROMO_SEQ.currval,1);
insert into promocion values(3,PROMO_SEQ.nextval,'Descuento de 20%',CALENDARIO(to_date('2022-11-20','yyyy-mm-dd'),to_date('2022-11-30','yyyy-mm-dd')),8,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (1,PROMO_SEQ.currval,1);
insert into promocion values(1,PROMO_SEQ.nextval,'Descuento de 20%',CALENDARIO(to_date('2022-11-20','yyyy-mm-dd'),to_date('2022-11-30','yyyy-mm-dd')),1.6,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (11,PROMO_SEQ.currval,1);
insert into promocion values(2,PROMO_SEQ.nextval,'Descuento de 20%',CALENDARIO(to_date('2022-11-20','yyyy-mm-dd'),to_date('2022-11-30','yyyy-mm-dd')),1.6,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (9,PROMO_SEQ.currval,1);
insert into promocion values(3,PROMO_SEQ.nextval,'Descuento de 20%',CALENDARIO(to_date('2022-11-20','yyyy-mm-dd'),to_date('2022-11-30','yyyy-mm-dd')),4,'COMBO',10);
    INSERT INTO PLATO_PROMOCION VALUES (3,PROMO_SEQ.currval,1);

--ROLES
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Cocinero', 'Se encarga de preparar los platos');
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Asistente de cocina', 'Ayuda al cocinero a preparar los platos');
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Gerente', 'Administrar la sucursal');
insert into rol values(rol_seq.nextval,'Mesero','Atiende al cliente y facilita el servicio al mismo');
insert into rol values(rol_seq.nextval,'Recepcionista','Atiende al cliente al entrar y le asigna una mesa');
insert into rol values(rol_seq.nextval,'Parquero','Atiende al cliente al llegar al local y se encarga de estacionar sus carros');
insert into rol values(rol_seq.nextval,'Vigilante','Se encarga de vigilar los carros de los clientes');
insert into rol values(rol_seq.nextval,'Guardia','Se encarga de la seguridad dentro y fuera del local');
insert into rol values(rol_seq.nextval,'Manager','Se encarga de manejar las redes sociales del local');
insert into rol values(rol_seq.nextval,'Servicio al cliente','Coordina pedidos de tipo pick-up y delivery con el cliente');
insert into rol values(rol_seq.nextval,'Delivery','Se encarga de trasladar los pedidos desde el local hasta la dirección del cliente');
insert into rol values(rol_seq.nextval,'Pick-up','Se encarga de entregar los pedidos hechos por pick-up en el local');
insert into rol values(rol_seq.nextval,'Lava-platos','Se encarga de la limpieza e higiene de los utencilios de cocina');
insert into rol values(rol_seq.nextval,'Limpieza','Se encarga de la higiene y limpieza del local');
insert into rol values(rol_seq.nextval,'Cajero','Se encarga de cobrar las cuentas a los clientes');
insert into rol values(rol_seq.nextval,'Contador','Se encarga de las finanzas del local');
insert into rol values(rol_seq.nextval,'Recreador','Se encarga de la coordinación de eventos y actividades en el local');
insert into rol values(rol_seq.nextval,'Catador de vinos','Se encarga de seleccionar y abastecer el local de vinos');

--CONTRATOS
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO,SALARIO, ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('5-dec-2021', '7-sep-2022'),'Fallecimiento',200, 1, 1, 1);
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO, SALARIO,ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('18-jan-2022', null), null,150, 2, 2, 1);
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO,SALARIO, ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('1-mar-2022', null), null,400, 3, 3, 1);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-09-08','yyyy-mm-dd'),null),'',150,1,4,2);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',80,5,5,2);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',50,6,6,3);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',50,7,7,1);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',90,8,8,2);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',500,3,9,2);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',70,10,10,1);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',60,11,11,2);
insert into contrato values(CONTRATO_SEQ.nextval,CALENDARIO(to_date('2022-01-01','yyyy-mm-dd'),null),'',400,3,14,3);

--Calificaciones sucursal 1
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (1, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (2, CALIFICACION_SEQ.nextval, 2, 'Mediocre servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (3, CALIFICACION_SEQ.nextval, 5, 'Excelente servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (4, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (5, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');

-- CALIFICACIONES SUCURSAL 2
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (6, CALIFICACION_SEQ.nextval, 1, 'Pésimo servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (7, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (8, CALIFICACION_SEQ.nextval, 2, 'Mediocre servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (9, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (10, CALIFICACION_SEQ.nextval, 2, 'La ensalada no me gustó');

-- CALIFICACIONES SUCURSAL 3
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (11, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (12, CALIFICACION_SEQ.nextval, 2, 'La pasta estaba medio cruda');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (13, CALIFICACION_SEQ.nextval, 1, 'Pésimo servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (14, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (15, CALIFICACION_SEQ.nextval, 3, 'Margarita muy fuerte');

--PROVEEDORES
INSERT INTO PROVEEDOR (RIF, NOMBRE) VALUES ('J172361298','Los pollos hermanos');
INSERT INTO PROVEEDOR (RIF, NOMBRE) VALUES ('J235435671','Alimentos alimenticios®');
INSERT INTO PROVEEDOR (RIF, NOMBRE) VALUES ('J002354128','Comestibles la Guaira');
INSERT INTO PROVEEDOR (RIF, NOMBRE) VALUES ('J232404302','Comida caracas');
INSERT INTO PROVEEDOR (RIF, NOMBRE) VALUES ('J968270235','Alimentos Perez');

--PROVEEDOR_PRODUCTO
DECLARE
    disponibilidad_random INTEGER;
    precio_random FLOAT;
BEGIN
    FOR I IN (SELECT * FROM PROVEEDOR)
    LOOP
        FOR J IN (SELECT * FROM PRODUCTO)
        LOOP
            SELECT DBMS_RANDOM.VALUE(0,1) INTO disponibilidad_random FROM DUAL;
            SELECT ROUND(DBMS_RANDOM.VALUE(1,10),2) INTO precio_random FROM DUAL;
            INSERT INTO PROVEEDOR_PRODUCTO (RIF_PROVEEDOR, ID_PRODUCTO, DISPONIBILIDAD, PRECIO)
            VALUES (I.RIF,J.ID,disponibilidad_random,precio_random);
        end loop;
    end loop;
end;

--MENU_DIA
DECLARE
    fecha_inicio NUMBER;
    fecha_fin    NUMBER;
    random       NUMBER;
    aux          NUMBER;
    um           VARCHAR2(3);
BEGIN
    fecha_inicio := to_number(to_char(to_date('2022-11-15', 'yyyy-MM-dd'), 'j'));
    fecha_fin := to_number(to_char(to_date('2022-11-20', 'yyyy-MM-dd'), 'j'));
    FOR I IN (SELECT * FROM SUCURSAL)
        LOOP
            FOR J IN fecha_inicio..fecha_fin
                LOOP
                    FOR K IN (SELECT * FROM INVENTARIO WHERE ID_SUCURSAL = I.ID)
                        LOOP
                            SELECT ROUND(DBMS_RANDOM.VALUE(0, 0.5),2) INTO random FROM DUAL;
                            SELECT UNIDAD_MEDIDA
                            INTO um
                            FROM PRODUCTO
                            WHERE ID=K.ID_PRODUCTO;
                            IF um='U' THEN
                                UPDATE INVENTARIO
                                SET CANTIDAD=ROUND(CAPACIDAD_MAXIMA * random)
                                WHERE ID_SUCURSAL = K.ID_SUCURSAL AND ID_PRODUCTO = K.ID_PRODUCTO;
                            else
                                UPDATE INVENTARIO
                                SET CANTIDAD=CAPACIDAD_MAXIMA * random
                                WHERE ID_SUCURSAL = K.ID_SUCURSAL AND ID_PRODUCTO = K.ID_PRODUCTO;
                            end if;
                        end loop;
                    aux := SIMULACION2_PKG.SELECCIONAR_PLATOS((to_date(J, 'j')), I.ID);
                end loop;
        END LOOP;
end;

COMMIT;