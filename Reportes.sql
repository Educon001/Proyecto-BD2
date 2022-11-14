CREATE OR REPLACE PROCEDURE reporte1(tipo_entrega PEDIDO.tipo%type, fechas CALENDARIO,
                                     tipo_plato PLATO.categoria%type, c1 OUT sys_refcursor) IS
BEGIN
    OPEN c1 FOR
        SELECT S.NOMBRE,
               P2.NOMBRE,
               P2.FOTO,
               P2.DESCRIPCION,
               P.TIPO,
               fechas.FECHA_INICIO,
               fechas.FECHA_FIN,
               P2.PRECIO_UNITARIO
        FROM SUCURSAL S
                 join PEDIDO P on S.ID = P.ID_SUCURSAL
                 join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                 join PLATO P2 on P2.CODIGO = PP.CODIGO_PLATO
        WHERE P.TIPO = tipo_entrega
          AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
          AND P2.CATEGORIA = tipo_plato;
END;
