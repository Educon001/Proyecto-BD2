--1. Reporte de platos de mayor demanda
CREATE OR REPLACE PROCEDURE reporte1(tipo_pedido PEDIDO.tipo%type, fechas CALENDARIO,
                                     tipo_plato PLATO.categoria%type, c1 OUT sys_refcursor) IS
BEGIN
    OPEN c1 FOR
        SELECT T.Sucursal, T.Plato, P.FOTO,T.DESCRIPCION, T.TIPO, "Fecha desde", "Fecha hasta", cantidad, demanda, T.PRECIO_UNITARIO
        FROM PLATO P join
        (SELECT DISTINCT
               S.NOMBRE as Sucursal,
               P2.NOMBRE as Plato,
               P2.DESCRIPCION,
               P.TIPO,
               fechas.FECHA_INICIO as "Fecha desde",
               fechas.FECHA_FIN as "Fecha hasta",
               cant.cantidad as cantidad,
               ROUND((cant.cantidad/total.total_platos)*100,2) as demanda,
               P2.PRECIO_UNITARIO
        FROM SUCURSAL S
                 join PEDIDO P on S.ID = P.ID_SUCURSAL
                 join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                 join PLATO P2 on P2.CODIGO = PP.CODIGO_PLATO
                 join (SELECT S.ID, PP.CODIGO_PLATO, SUM(PP.CANTIDAD) as cantidad
                       FROM PEDIDO P
                                join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                                join PLATO P2 on PP.CODIGO_PLATO = P2.CODIGO
                                join SUCURSAL S on P.ID_SUCURSAL = S.ID
                       WHERE P.TIPO = tipo_pedido
                         AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
                         AND P2.CATEGORIA = tipo_plato
                       GROUP BY S.ID, PP.CODIGO_PLATO) cant on cant.CODIGO_PLATO = PP.CODIGO_PLATO and cant.ID = S.ID
                 join (SELECT S.ID, SUM(PP.CANTIDAD) as total_platos
                       FROM PEDIDO P
                                join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                                join PLATO P2 on PP.CODIGO_PLATO = P2.CODIGO
                                join SUCURSAL S on P.ID_SUCURSAL = S.ID
                       WHERE P.TIPO = tipo_pedido
                         AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
                         AND P2.CATEGORIA = tipo_plato
                       GROUP BY S.ID) total on total.ID = S.ID
        WHERE P.TIPO = tipo_pedido
          AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
          AND P2.CATEGORIA = tipo_plato
          AND cant.cantidad > 0
        ORDER BY S.NOMBRE, demanda desc) T on P.NOMBRE=T.Plato;
END;

--4. Reporte de empleados del restaurante por sucursal y su rol
CREATE OR REPLACE procedure reporte4(sucursal SUCURSAL.nombre%type, fechas CALENDARIO,
                                     rol ROL.nombre%type, c4 OUT SYS_REFCURSOR) IS
    S1 VARCHAR2(100);
    R1 VARCHAR2(100);
BEGIN
    S1:= '%' || sucursal || '%';
    R1:= '%' || rol || '%';
    if sucursal IS NULL then
        S1:='%';
    end if;
    if rol IS NULL then
        R1:='%';
    end if;
    OPEN c4 FOR
        SELECT S.NOMBRE as Sucursal,
               E.FOTO_CARNET,
               'V' || E.DATOS.CI as CI,
               E.DATOS.PRIMER_NOMBRE as Nombre,
               E.DATOS.PRIMER_APELLIDO as Apellido,
               E.FECHA_NACIMIENTO,
               E.SEXO,
               C.FECHAS.FECHA_INICIO as fecha_desde,
               C.FECHAS.FECHA_FIN as fecha_hasta,
               C.MOTIVO_EGRESO,
               R.NOMBRE as rol,
               R.DESCRIPCION
        FROM CONTRATO C
                 join EMPLEADO E on E.ID = C.ID_EMPLEADO
                 join ROL R on R.ID = C.ID_ROL
                 join SUCURSAL S on S.ID = C.ID_SUCURSAL
        WHERE S.NOMBRE LIKE S1
          AND R.NOMBRE LIKE R1
          AND ((C.FECHAS.FECHA_INICIO BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_FIN BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN))
        ORDER BY S.NOMBRE;
end;

--5. Reporte de sucursales del restaurante
create or replace FUNCTION porcentaje_promedio_satisfaccion(id_suc NUMBER)
RETURN NUMBER IS
promedio NUMBER;
porcentaje NUMBER;
begin

    SELECT AVG(PUNTAJE) INTO promedio
    FROM PEDIDO P JOIN CALIFICACION C
    ON (P.id = C.id_pedido)
    WHERE P.id_sucursal = id_suc;

    porcentaje := promedio/5;

    RETURN porcentaje;

end;

create PROCEDURE REPORTE5 (crest OUT sys_refcursor) IS
BEGIN
    OPEN crest
    FOR SELECT S.NOMBRE AS Nombre_Sucursal, R.NOMBRE AS Nombre_Restaurante,
               R.LOGO AS Logo_Restaurante, S.DIRECCION.DESCRIPCION AS Direccion_escrita,
               S.DIRECCION.LATITUD, S.DIRECCION.LONGITUD, porcentaje_promedio_satisfaccion(S.ID) AS PROMEDIO
    FROM RESTAURANTE R, SUCURSAL S
    ORDER BY S.ID;
END;