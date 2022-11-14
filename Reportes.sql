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
               ROUND((cant.cantidad/total.total_platos)*100,2) || '%' as demanda,
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

DECLARE
    c1        SYS_REFCURSOR;
    suc       VARCHAR2(100);
    pla       VARCHAR2(100);
    fot       BLOB;
    descri    VARCHAR2(200);
    tipo      VARCHAR2(100);
    fecha_ini DATE;
    fecha_fin DATE;
    cant      NUMBER;
    demanda   VARCHAR2(6);
    pu        NUMBER;
BEGIN
    reporte1('EN LOCAL', CALENDARIO(TO_DATE('10/11/2022', 'DD/MM/YYYY'), TO_DATE('20/11/2022', 'DD/MM/YYYY')), 'Comida',
             c1);
    FETCH c1 INTO suc,pla,fot,descri,tipo,fecha_ini,fecha_fin,cant,demanda,pu;
    WHILE c1%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE(suc || ' | ' || pla || ' | ' || descri || ' | ' || tipo || ' | ' ||
                                 fecha_ini || ' | ' || fecha_fin || ' | ' || cant || ' | ' || demanda || ' | ' || pu);
            FETCH c1 INTO suc,pla,fot,descri,tipo,fecha_ini,fecha_fin,cant,demanda,pu;
        end loop;
end;