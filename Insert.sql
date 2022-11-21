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

--PEDIDOS
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (1,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (1,1,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,1,3);
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (1,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (1,2,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,2,1);
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (1,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,3,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,3,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (1,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,4,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,4,2);
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (1, PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,5,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (6,5,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,5,1);

--Pedidos sucursal 2
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (2,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,21,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,21,3);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (21, CALIFICACION_SEQ.nextval, 1, 'Pésimo servicio');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (2,PEDIDO_SEQ.nextval,'DELIVERY',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,22,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,22,1);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (22, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (2,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,23,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,23,2);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (23, CALIFICACION_SEQ.nextval, 2, 'Mediocre servicio');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (2,PEDIDO_SEQ.nextval,'PICK-UP',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (8,24,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,24,2);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (24, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (2, PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,25,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (9,25,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,25,1);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (25, CALIFICACION_SEQ.nextval, 2, 'La ensalada no me gustó');

--PEDIDOS SUCURSAL 3
INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (3,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,26,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (2,26,3);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (26, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (3,PEDIDO_SEQ.nextval,'DELIVERY',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (3,27,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,27,1);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (27, CALIFICACION_SEQ.nextval, 2, 'La pasta estaba medio cruda');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (3,PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,28,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,28,2);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (28, CALIFICACION_SEQ.nextval, 1, 'Pésimo servicio');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (3,PEDIDO_SEQ.nextval,'PICK-UP',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (8,29,3);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (4,29,2);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (29, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');

INSERT INTO PEDIDO (ID_SUCURSAL,ID,TIPO,FECHA_HORA) VALUES (3, PEDIDO_SEQ.nextval,'EN LOCAL',SYSDATE);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (5,30,2);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (9,30,1);
    INSERT INTO PLATO_PEDIDO (codigo_plato, id_pedido, cantidad) VALUES (7,30,1);
    INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (30, CALIFICACION_SEQ.nextval, 3, 'Margarita muy fuerte');



INSERT INTO PEDIDO (id, fecha_hora) VALUES (100,to_date('15/11/2022 9:00:00', 'dd/mm/yyyy hh:mi:ss'));
INSERT INTO PEDIDO (id, fecha_hora) VALUES (101,to_date('15/11/2022 9:30:00', 'dd/mm/yyyy hh:mi:ss'));
INSERT INTO PEDIDO (id, fecha_hora) VALUES (102,to_date('15/11/2022 10:00:00', 'dd/mm/yyyy hh:mi:ss'));
INSERT INTO PEDIDO (id, fecha_hora) VALUES (103,to_date('15/11/2022 10:30:00', 'dd/mm/yyyy hh:mi:ss'));
INSERT INTO PEDIDO (id, fecha_hora) VALUES (104,to_date('15/11/2022 11:00:00', 'dd/mm/yyyy hh:mi:ss'));
INSERT INTO PEDIDO (id, fecha_hora) VALUES (105,to_date('15/11/2022 2:00:00', 'dd/mm/yyyy hh:mi:ss'));

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
--ROLES
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Cocinero', 'Cocinar');
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Asistente de cocina', 'Asistir en la cocina');
INSERT INTO ROL (ID, NOMBRE, DESCRIPCION) VALUES (ROL_SEQ.nextval, 'Abogado', 'Representar a la empresa en problemas legales');
--CONTRATOS
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO, ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('5-dec-2021', '7-sep-2022'), 'Fallecimiento', 1, 1, 1);
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO, ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('18-jan-2022', null), null, 2, 2, 1);
INSERT INTO CONTRATO (ID, FECHAS, MOTIVO_EGRESO, ID_ROL, ID_EMPLEADO, ID_SUCURSAL)
VALUES (CONTRATO_SEQ.nextval, CALENDARIO('1-mar-2022', null), null, 3, 3, 1);

--Menu_dia
insert into menu_dia values(1,1,to_date('2022-11-15', 'yyyy-mm-dd'));
insert into menu_dia values(2,1,to_date('2022-11-12', 'yyyy-mm-dd'));
insert into MENU_DIA (CODIGO_PLATO, ID_SUCURSAL, FECHA) values (4,1,sysdate);
insert into MENU_DIA (CODIGO_PLATO, ID_SUCURSAL, FECHA) values (5,1,sysdate);

--promos
insert into promocion values(1,1,'2x1',CALENDARIO(to_date('2022-11-09','yyyy-mm-dd'),to_date('2022-11-12','yyyy-mm-dd')),3,'promoción',10);
insert into plato_promocion values(3,1,10);

--Calificaciones sucursal 1
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (1, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (2, CALIFICACION_SEQ.nextval, 2, 'Mediocre servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (3, CALIFICACION_SEQ.nextval, 5, 'Excelente servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (4, CALIFICACION_SEQ.nextval, 4, 'Buen servicio');
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (5, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');

-- CALIFICACIONES SUCURSAL 2
INSERT INTO CALIFICACION (ID_PEDIDO, CODIGO, PUNTAJE, OBSERVACIONES) VALUES (5, CALIFICACION_SEQ.nextval, 5, 'Muy sabrosa la comida');
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

-- insert promocion reporte 3

insert into promocion values(1,2,'2x1',CALENDARIO(to_date('2022-11-09','yyyy-mm-dd'),to_date('2022-11-12','yyyy-mm-dd')),2.5,'promoción',10);
insert into promocion values(1,3,'Postre a 2$',CALENDARIO(to_date('2022-11-09','yyyy-mm-dd'),to_date('2022-11-15','yyyy-mm-dd')),2,'promoción',10);
insert into promocion values(1,4,'Postre a 1$',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-11-07','yyyy-mm-dd')),1,'promoción',10);
insert into promocion values(1,5,'Bebida a 1$',CALENDARIO(to_date('2022-11-01','yyyy-mm-dd'),to_date('2022-11-18','yyyy-mm-dd')),1,'promoción',10);
insert into promocion values(1,6,'Bebida a 0.5$',CALENDARIO(to_date('2022-10-01','yyyy-mm-dd'),to_date('2022-11-01','yyyy-mm-dd')),1,'promoción',10);
insert into promocion values(1,7,'Plato principal a 5$',CALENDARIO(to_date('2022-10-01','yyyy-mm-dd'),to_date('2022-10-10','yyyy-mm-dd')),5,'promoción',10);

-- promociones de octubre y noviembre
insert into plato_promocion values(7,6,1);
insert into plato_promocion values(9,6,1);
insert into plato_promocion values(10,6,1);
insert into plato_promocion values(14,3,1);
insert into plato_promocion values(13,3,1);
insert into plato_promocion values(15,3,1);
insert into plato_promocion values(1,7,1);
insert into plato_promocion values(2,7,1);
insert into plato_promocion values(4,7,1);
insert into plato_promocion values(9,5,1);
insert into plato_promocion values(10,5,1);

--Producto
INSERT INTO PRODUCTO (ID, DESCRIPCION, UNIDAD_MEDIDA) VALUES (1, 'Papa', 'Kg');

COMMIT;
