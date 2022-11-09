
CREATE TABLE restaurante
(
    id     NUMBER PRIMARY KEY,
    nombre VARCHAR2(15),
    logo   BLOB,
    CONSTRAINT unico_id CHECK (id = 1)
);

CREATE TABLE proveedor
(
    rif       VARCHAR2(10) PRIMARY KEY,
    direccion DIRECCION,
    nombre    VARCHAR2(50),
    CONSTRAINT formato_rif CHECK (REGEXP_LIKE(rif, '^[J]{1}[0-9]+$'))
);

CREATE TABLE producto
(
    id            NUMBER PRIMARY KEY,
    descripcion   VARCHAR2(200),
    unidad_medida VARCHAR2(2),
    foto          BLOB,
    CONSTRAINT unidad_medida_check CHECK ( unidad_medida IN ('Kg', 'L', 'U') )
);

CREATE TABLE proveedor_producto
(
    rif_proveedor  VARCHAR2(10),
    id_producto    NUMBER,
    disponibilidad NUMBER,
    precio         NUMBER CHECK ( precio > 0 ),
    CONSTRAINT proveedor_producto_pk PRIMARY KEY (rif_proveedor, id_producto),
    CONSTRAINT proveedor_producto_proveedor_fk FOREIGN KEY (rif_proveedor) REFERENCES proveedor (rif),
    CONSTRAINT proveedor_producto_producto_fk FOREIGN KEY (id_producto) REFERENCES producto (id)
);

CREATE TABLE plato
(
    codigo          NUMBER PRIMARY KEY,
    nombre          VARCHAR2(50),
    categoria       VARCHAR2(6),
    descripcion     VARCHAR2(200),
    precio_unitario NUMBER CHECK ( precio_unitario > 0 ),
    foto            BLOB,
    receta          CLOB,
    CONSTRAINT categoria_check CHECK ( categoria IN ('Comida', 'Bebida', 'Postre') )
);

CREATE TABLE plato_producto
(
    codigo_plato NUMBER,
    id_producto  NUMBER,
    cantidad     NUMBER CHECK ( cantidad > 0 ),
    CONSTRAINT plato_producto_pk PRIMARY KEY (codigo_plato,id_producto),
    CONSTRAINT plato_producto_plato_fk FOREIGN KEY (codigo_plato) REFERENCES plato(codigo),
    CONSTRAINT plato_producto_producto_fk FOREIGN KEY (id_producto) REFERENCES producto(id)
);

CREATE TABLE cliente
(
    id        NUMBER PRIMARY KEY,
    telefono  VARCHAR2(10),
    datos     DATOS_BASICOS,
    direccion DIRECCION,
    CONSTRAINT formato_telefono CHECK ( REGEXP_LIKE(telefono, '[1-9]{1}[0-9]{9}') )
);

CREATE TABLE sucursal
(
    id             NUMBER PRIMARY KEY,
    direccion      DIRECCION,
    nombre         VARCHAR2(20),
    horario        HORARIO,
    id_restaurante NUMBER,
    CONSTRAINT sucursal_restaurante_fk FOREIGN KEY (id_restaurante) REFERENCES restaurante (id)
);

CREATE TABLE evento
(
    codigo        NUMBER,
    nombre        VARCHAR2(50),
    fecha         DATE,
    grupo_musical VARCHAR2(50),
    condiciones   VARCHAR2(200),
    horario       HORARIO,
    id_sucursal   NUMBER,
    CONSTRAINT evento_pk PRIMARY KEY (codigo, id_sucursal),
    CONSTRAINT evento_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id)
);

CREATE TABLE inventario
(
    id_producto      NUMBER,
    id_sucursal      NUMBER,
    cantidad         NUMBER CHECK ( cantidad >= 0 ),
    fecha_inventario DATE,
    capacidad_maxima NUMBER CHECK ( capacidad_maxima > 0 ),
    CONSTRAINT cantidad_capacidad_check CHECK ( cantidad < capacidad_maxima ),
    CONSTRAINT inventario_pk PRIMARY KEY (id_producto, id_sucursal),
    CONSTRAINT inventario_plato_fk FOREIGN KEY (id_producto) REFERENCES producto (id),
    CONSTRAINT inventario_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id)
);

CREATE TABLE menu_dia
(
    codigo_plato NUMBER,
    id_sucursal NUMBER,
    fecha DATE,
    CONSTRAINT menu_dia_pk PRIMARY KEY (codigo_plato,id_sucursal,fecha),
    CONSTRAINT menu_dia_plato_fk FOREIGN KEY (codigo_plato) REFERENCES plato(codigo),
    CONSTRAINT menu_dia_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
);