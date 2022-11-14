--comida
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Pizza', 'Comida', 'Pizza margarita', 10, FILE_TO_BLOB('pizza.jpg'),'Queso mozarella, tomate y masa');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Hamburguesa', 'Comida', 'Hamburguesa con queso', 6, FILE_TO_BLOB('hamburguesa.jpg'),
        'Pan, Queso, lechuga, tomate y salsas');
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
VALUES (PLATO_SEQ.nextval, 'Helado de mantecacdo', 'Postre', 'Cono de helado', 1.5, FILE_TO_BLOB('helado.jpg'), 'Barquilla, mantecado');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Marquesa de chocolate', 'Postre', 'Marquesa individual', 2, FILE_TO_BLOB('marquesa.jpg'), 'Marquesa y chocolate');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Brownie con helado', 'Postre', 'Brownie caliente con helado', 2.5, FILE_TO_BLOB('brownie.jpg'), 'Brownie y helado');
INSERT INTO plato (CODIGO, NOMBRE, CATEGORIA, DESCRIPCION, PRECIO_UNITARIO, FOTO, RECETA)
VALUES (PLATO_SEQ.nextval, 'Banana split', 'Postre', 'Banana', 3, FILE_TO_BLOB('banana_split.jpg'), 'Cambur y helado');