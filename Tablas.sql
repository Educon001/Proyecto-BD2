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
    precio         FLOAT CHECK ( precio > 0 ),
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
    precio_unitario FLOAT CHECK ( precio_unitario > 0 ),
    foto            BLOB,
    receta          CLOB,
    CONSTRAINT categoria_check CHECK ( categoria IN ('Comida', 'Bebida', 'Postre') )
);

CREATE TABLE plato_producto
(
    codigo_plato NUMBER,
    id_producto  NUMBER,
    cantidad     NUMBER CHECK ( cantidad > 0 ),
    CONSTRAINT plato_producto_pk PRIMARY KEY (codigo_plato, id_producto),
    CONSTRAINT plato_producto_plato_fk FOREIGN KEY (codigo_plato) REFERENCES plato (codigo),
    CONSTRAINT plato_producto_producto_fk FOREIGN KEY (id_producto) REFERENCES producto (id)
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
    id_sucursal  NUMBER,
    fecha        DATE,
    CONSTRAINT menu_dia_pk PRIMARY KEY (codigo_plato, id_sucursal, fecha),
    CONSTRAINT menu_dia_plato_fk FOREIGN KEY (codigo_plato) REFERENCES plato (codigo),
    CONSTRAINT menu_dia_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id)
);

CREATE TABLE rol
(
    id          NUMBER PRIMARY KEY,
    nombre      VARCHAR2(30),
    descripcion VARCHAR2(200)
);

CREATE TABLE empleado
(
    id               NUMBER PRIMARY KEY,
    foto_carnet      BLOB,
    fecha_nacimiento DATE,
    sexo             VARCHAR2(3) CHECK (sexo = 'M' OR sexo = 'F' OR sexo = 'N/A'),
    datos            DATOS_BASICOS
);

CREATE TABLE contrato
(
    id            NUMBER PRIMARY KEY,
    fechas        CALENDARIO,
    motivo_egreso VARCHAR2(200),
    salario       FLOAT,
    id_rol        NUMBER,
    id_empleado   NUMBER,
    id_sucursal   NUMBER,
    CONSTRAINT contrato_rol_fk FOREIGN KEY (id_rol) REFERENCES rol (id),
    CONSTRAINT contrato_empleado_fk FOREIGN KEY (id_empleado) REFERENCES empleado (id),
    CONSTRAINT contrato_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id)
);

CREATE TABLE mesa
(
    id_sucursal NUMBER,
    num_mesa    NUMBER,
    capacidad   INTEGER CHECK (capacidad > 0 AND capacidad <= 12),
    disponible  NUMBER CHECK ( disponible = 0 OR disponible = 1),
    CONSTRAINT mesa_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
    CONSTRAINT mesa_pk PRIMARY KEY (id_sucursal, num_mesa)
);

CREATE TABLE reserva
(
    num_mesa          NUMBER,
    id_sucursal       NUMBER,
    id_cliente        NUMBER,
    id                NUMBER,
    fecha             DATE,
    horario           HORARIO,
    abono_inicial     float,
    cantidad_personas INTEGER CHECK ( cantidad_personas > 0 AND cantidad_personas <= 12 ),
    comentarios       VARCHAR2(200),
    CONSTRAINT reserva_mesa_fk FOREIGN KEY (num_mesa, id_sucursal) REFERENCES mesa (num_mesa, id_sucursal),
    CONSTRAINT reserva_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente (id),
    CONSTRAINT reserva_pk PRIMARY KEY (id)
);

CREATE TABLE pedido
(
    id_sucursal NUMBER,
    id_cliente  NUMBER,
    id          NUMBER,
    tipo        VARCHAR2(8),
    fecha_hora  TIMESTAMP,
    monto_total FLOAT CHECK ( monto_total > 0 ),
    CONSTRAINT formato_tipo_pedido CHECK ( tipo = 'DELIVERY' OR tipo = 'PICK-UP' OR tipo = 'EN LOCAL'),
    CONSTRAINT pedido_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
    CONSTRAINT pedido_cliente_fk FOREIGN KEY (id_cliente) REFERENCES cliente (id),
    CONSTRAINT pedido_pk PRIMARY KEY (id)
);

CREATE TABLE pago_pedido
(
    id          NUMBER,
    id_pedido   NUMBER,
    id_cliente  NUMBER,
    id_sucursal NUMBER,
    monto       FLOAT CHECK (monto > 0),
    tipo_pago   VARCHAR2(15),
    CONSTRAINT formas_pago CHECK ( tipo_pago = 'EFECTIVO' OR tipo_pago = 'POS' OR tipo_pago = 'ZELLE' OR
                                   tipo_pago = 'PIPOL PAY' OR tipo_pago = 'PAYPAL' OR tipo_pago = 'ZINLI' OR
                                   tipo_pago = 'CRIPTOMONEDAS'),
    CONSTRAINT pago_pedido_fk FOREIGN KEY (id_pedido) REFERENCES pedido (id),
    CONSTRAINT pago_pedido_pk PRIMARY KEY (id)
);

CREATE TABLE pago_reserva
(
    id         NUMBER,
    id_reserva NUMBER,
    monto      FLOAT CHECK (monto > 0),
    tipo_pago  VARCHAR2(15),
    CONSTRAINT formas_pago_reserva CHECK ( tipo_pago = 'EFECTIVO' OR tipo_pago = 'POS' OR tipo_pago = 'ZELLE' OR
                                           tipo_pago = 'PIPOL PAY' OR tipo_pago = 'PAYPAL' OR tipo_pago = 'ZINLI' OR
                                           tipo_pago = 'CRIPTOMONEDAS'),
    CONSTRAINT pago_reserva_fk FOREIGN KEY (id_reserva) REFERENCES reserva (id),
    CONSTRAINT pago_reserva_pk PRIMARY KEY (id, id_reserva)
);

CREATE TABLE calificacion
(
    id_pedido     NUMBER,
    codigo        NUMBER,
    puntaje       INTEGER,
    observaciones VARCHAR2(200),
    CONSTRAINT puntaje_valido CHECK ( puntaje >= 1 OR puntaje <= 5 ),
    CONSTRAINT calificacion_pedido_fk FOREIGN KEY (id_pedido) REFERENCES pedido (id),
    CONSTRAINT calificacion_pk PRIMARY KEY (id_pedido, codigo)
);

CREATE TABLE plato_pedido
(
    codigo_plato NUMBER,
    id_pedido    NUMBER,
    cantidad     NUMBER,
    puntaje      INTEGER,
    CONSTRAINT puntaje_valido_plato CHECK ( puntaje >= 1 OR puntaje <= 5 ),
    CONSTRAINT plato_del_pedido_fk FOREIGN KEY (codigo_plato) REFERENCES plato (codigo),
    CONSTRAINT pedido_del_plato_fk FOREIGN KEY (id_pedido) REFERENCES pedido (id),
    CONSTRAINT plato_pedido_pk PRIMARY KEY (codigo_plato, id_pedido)
);

CREATE TABLE promocion
(
    id_sucursal      NUMBER,
    id               NUMBER,
    descripcion      VARCHAR2(200),
    inicio_fin       CALENDARIO,
    precio_descuento FLOAT,
    tipo             VARCHAR2(30),
    limite_pedido    NUMBER,
    CONSTRAINT promocion_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
    CONSTRAINT promocion_pk PRIMARY KEY (id)
);

CREATE TABLE plato_promocion
(
    codigo_plato NUMBER,
    id_promocion NUMBER,
    cantidad     FLOAT CHECK (cantidad > 0),
    CONSTRAINT plato_promocion_plato_fk FOREIGN KEY (codigo_plato) REFERENCES plato (codigo),
    CONSTRAINT plato_promocion_promocion_fk FOREIGN KEY (id_promocion) REFERENCES promocion (id),
    CONSTRAINT plato_promocion_pk PRIMARY KEY (codigo_plato, id_promocion)
);

CREATE TABLE promocion_pedido
(
    id_promocion NUMBER,
    id_pedido    NUMBER,
    cantidad     NUMBER CHECK (cantidad > 0),
    CONSTRAINT promocion_pedido_promocion_fk FOREIGN KEY (id_promocion) REFERENCES promocion (id),
    CONSTRAINT promocion_pedido_plato_fk FOREIGN KEY (id_pedido) REFERENCES pedido (id),
    CONSTRAINT promocion_pedido_pk PRIMARY KEY (id_promocion, id_pedido)
);

CREATE TABLE orden_compra
(
    id          NUMBER PRIMARY KEY,
    monto_total FLOAT,
    completa    NUMBER CHECK ( completa in (0, 1))
);

CREATE TABLE producto_orden
(
    cantidad      INTEGER,
    id_producto   NUMBER,
    rif_proveedor VARCHAR2(10),
    id_orden      NUMBER,
    CONSTRAINT producto_orden_pk PRIMARY KEY (id_producto, id_orden, rif_proveedor),
    CONSTRAINT producto_orden_producto_fk FOREIGN KEY (id_producto) REFERENCES producto (id),
    CONSTRAINT producto_orden_orden_fk FOREIGN KEY (id_orden) REFERENCES orden_compra (id),
    CONSTRAINT producto_orden_proveedor_fk FOREIGN KEY (rif_proveedor) REFERENCES proveedor (rif)
);

CREATE TABLE egreso
(
    id          NUMBER,
    fecha       DATE,
    motivo      VARCHAR2(200),
    monto       FLOAT,
    id_sucursal NUMBER,
    id_orden    NUMBER,
    CONSTRAINT egreso_pk PRIMARY KEY (id, id_sucursal),
    CONSTRAINT egreso_sucursal_fk FOREIGN KEY (id_sucursal) REFERENCES sucursal (id),
    CONSTRAINT egreso_orden_fk FOREIGN KEY (id_orden) REFERENCES orden_compra (id)
);

--Secuencias
CREATE SEQUENCE plato_seq;
CREATE SEQUENCE pedido_seq;
CREATE SEQUENCE empleado_seq;
CREATE SEQUENCE rol_seq;
CREATE SEQUENCE contrato_seq;
CREATE SEQUENCE calificacion_seq;