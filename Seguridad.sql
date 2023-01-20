-- CREACIÓN DE ROLES
CREATE ROLE gerente;
CREATE ROLE mesero;
CREATE ROLE chef;

-- PRIVILEGIOS DE GERENTE
GRANT SELECT ON proyecto.calificacion TO gerente;
GRANT SELECT ON proyecto.cliente TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.contrato TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.egreso TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.empleado TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.evento TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.inventario TO gerente;
GRANT SELECT ON proyecto.menu_dia TO gerente;
GRANT SELECT ON proyecto.mesa TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.orden_compra TO gerente;
GRANT SELECT ON proyecto.pago_pedido TO gerente;
GRANT SELECT ON proyecto.pago_reserva TO gerente;
GRANT SELECT ON proyecto.pedido TO gerente;
GRANT SELECT ON proyecto.plato TO gerente;
GRANT SELECT ON proyecto.plato_pedido TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.plato_promocion TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.producto TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.producto_orden TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.promocion TO gerente;
GRANT SELECT ON proyecto.promocion_pedido TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.proveedor TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.proveedor_producto TO gerente;
GRANT SELECT ON proyecto.reserva TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.restaurante TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.rol TO gerente;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.sucursal TO gerente;

-- PRIVILEGIOS DE Chef
GRANT SELECT ON proyecto.calificacion TO chef;
GRANT SELECT ON proyecto.cliente TO chef;
GRANT SELECT ON proyecto.contrato TO chef;
GRANT SELECT ON proyecto.egreso TO chef;
GRANT SELECT ON proyecto.empleado TO chef;
GRANT SELECT ON proyecto.evento TO chef;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.inventario TO chef;
GRANT SELECT ON proyecto.menu_dia TO chef;
GRANT SELECT ON proyecto.mesa TO chef;
GRANT SELECT ON proyecto.orden_compra TO chef;
GRANT SELECT ON proyecto.pago_pedido TO chef;
GRANT SELECT ON proyecto.pago_reserva TO chef;
GRANT SELECT ON proyecto.pedido TO chef;
GRANT INSERT, SELECT, UPDATE, DELETE ON proyecto.plato TO chef;
GRANT SELECT ON proyecto.plato_pedido TO chef;
GRANT SELECT ON proyecto.plato_promocion TO chef;
GRANT SELECT ON proyecto.producto TO chef;
GRANT SELECT ON proyecto.producto_orden TO chef;
GRANT SELECT ON proyecto.promocion TO chef;
GRANT SELECT ON proyecto.promocion_pedido TO chef;
GRANT SELECT ON proyecto.proveedor TO chef;
GRANT SELECT ON proyecto.proveedor_producto TO chef;
GRANT SELECT ON proyecto.reserva TO chef;
GRANT SELECT ON proyecto.restaurante TO chef;
GRANT SELECT ON proyecto.rol TO chef;
GRANT SELECT ON proyecto.sucursal TO chef;

-- PRIVILEGIOS MESEROS
GRANT select, insert, update, delete ON proyecto.CALIFICACION TO Mesero;
GRANT select, insert, update, delete ON proyecto.CLIENTE TO Mesero;
GRANT select ON proyecto.CONTRATO TO Mesero;
GRANT select ON proyecto.EGRESO TO Mesero;
GRANT select ON proyecto.EMPLEADO TO Mesero;
GRANT select ON proyecto.EVENTO TO Mesero;
GRANT select ON proyecto.INVENTARIO TO Mesero;
GRANT select ON proyecto.MENU_DIA TO Mesero;
GRANT select, insert, update, delete ON proyecto.MESA TO Mesero;
GRANT select ON proyecto.ORDEN_COMPRA TO Mesero;
GRANT select, insert, update, delete ON proyecto.PAGO_PEDIDO TO Mesero;
GRANT select, insert, update, delete ON proyecto.PAGO_RESERVA TO Mesero;
GRANT select, insert, update, delete ON proyecto.PEDIDO TO Mesero;
GRANT select ON proyecto.PLATO TO Mesero;
GRANT select, insert, update, delete ON proyecto.PLATO_PEDIDO TO Mesero;
GRANT select ON proyecto.PLATO_PROMOCION TO Mesero;
GRANT select ON proyecto.PRODUCTO TO Mesero;
GRANT select ON proyecto.PRODUCTO_ORDEN TO Mesero;
GRANT select ON proyecto.PROMOCION TO Mesero;
GRANT select, insert, update, delete ON proyecto.PROMOCION_PEDIDO TO Mesero;
GRANT select ON proyecto.PROVEEDOR TO Mesero;
GRANT select ON proyecto.PROVEEDOR_PRODUCTO TO Mesero;
GRANT select, insert, update, delete ON proyecto.RESERVA TO Mesero;
GRANT select ON proyecto.RESTAURANTE TO Mesero;
GRANT select ON proyecto.ROL TO Mesero;
GRANT select ON proyecto.SUCURSAL TO Mesero;

-- PRIVILEGIOS GENERALES
GRANT CONNECT TO MESERO;
GRANT CONNECT TO GERENTE;
GRANT CONNECT TO CHEF;

GRANT CREATE SESSION TO MESERO;
GRANT CREATE SESSION TO GERENTE;
GRANT CREATE SESSION TO CHEF;

GRANT CREATE ROLE TO GERENTE;
GRANT CREATE USER TO GERENTE;
GRANT DROP USER TO GERENTE;

-- USUARIOS
CREATE USER ORIANNA IDENTIFIED BY ORIVAN19 DEFAULT TABLESPACE SYSTEM TEMPORARY TABLESPACE TEMP;
CREATE USER JESUS IDENTIFIED BY JESFER19 DEFAULT TABLESPACE SYSTEM TEMPORARY TABLESPACE TEMP;
CREATE USER EDUARDO IDENTIFIED BY EDUCON19 DEFAULT TABLESPACE SYSTEM TEMPORARY TABLESPACE TEMP;

GRANT CHEF TO ORIANNA;
GRANT MESERO TO JESUS;
GRANT GERENTE TO EDUARDO;


