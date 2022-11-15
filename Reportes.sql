--Reporte de platos de mayor demanda
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

--Reporte de empleados del restaurante por sucursal y su rol
CREATE OR REPLACE procedure reporte4(sucursal SUCURSAL.nombre%type, fechas CALENDARIO,
                                     rol ROL.nombre%type, c4 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c4 FOR
        SELECT S.NOMBRE as Sucursal,
               E.FOTO_CARNET,
               'V' || E.DATOS.CI,
               E.DATOS.PRIMER_NOMBRE,
               E.DATOS.PRIMER_APELLIDO,
               E.FECHA_NACIMIENTO,
               E.SEXO,
               C.FECHAS.FECHA_INICIO,
               C.FECHAS.FECHA_FIN,
               C.MOTIVO_EGRESO,
               R.NOMBRE as rol,
               R.DESCRIPCION
        FROM CONTRATO C
                 join EMPLEADO E on E.ID = C.ID_EMPLEADO
                 join ROL R on R.ID = C.ID_ROL
                 join SUCURSAL S on S.ID = C.ID_SUCURSAL
        WHERE S.NOMBRE = sucursal
          AND R.NOMBRE = rol
          AND ((C.FECHAS.FECHA_INICIO BETWEEN fechas.FECHA_FIN AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_FIN BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN));
end;