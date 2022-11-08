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

CREATE TABLE plato
(
    codigo    NUMBER PRIMARY KEY,
    nombre    VARCHAR2(50),
    categoria VARCHAR2(6),
    descripcion VARCHAR2(200),
    precio_unitario NUMBER,
    foto BLOB,
    receta CLOB,
    CONSTRAINT categoria_check CHECK ( categoria IN ('Comida', 'Bebida', 'Postre') )
);

CREATE TABLE cliente
(
    id NUMBER PRIMARY KEY ,
    telefono VARCHAR2(10),
    datos DATOS_BASICOS,
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

