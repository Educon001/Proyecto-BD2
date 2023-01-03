--1. Reporte de platos de mayor demanda
CREATE OR REPLACE PROCEDURE reporte1(tipo_pedido PEDIDO.tipo%type, fechas CALENDARIO,
                                     tipo_plato PLATO.categoria%type, c1 OUT sys_refcursor) IS
    tp1 VARCHAR2(20);
    tp2 VARCHAR2(20);
BEGIN
    tp1:='%' || UPPER(tipo_pedido) || '%';
    tp2:='%' || UPPER(tipo_plato) || '%';
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
                       WHERE UPPER(P.TIPO) LIKE tp1
                         AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
                         AND UPPER(P2.CATEGORIA) LIKE tp2
                       GROUP BY S.ID, PP.CODIGO_PLATO) cant on cant.CODIGO_PLATO = PP.CODIGO_PLATO and cant.ID = S.ID
                 join (SELECT S.ID, SUM(PP.CANTIDAD) as total_platos
                       FROM PEDIDO P
                                join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                                join PLATO P2 on PP.CODIGO_PLATO = P2.CODIGO
                                join SUCURSAL S on P.ID_SUCURSAL = S.ID
                       WHERE UPPER(P.TIPO) LIKE tp1
                         AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
                         AND UPPER(P2.CATEGORIA) LIKE tp2
                       GROUP BY S.ID) total on total.ID = S.ID
        WHERE UPPER(P.TIPO) LIKE tp1
          AND (P.FECHA_HORA BETWEEN fechas.FECHA_INICIO and fechas.FECHA_FIN)
          AND UPPER(P2.CATEGORIA) LIKE tp2
          AND cant.cantidad > 0) T on P.NOMBRE=T.Plato
        ORDER BY T.Sucursal, demanda desc;
END;

--2. Reporte de menú del día
CREATE OR REPLACE PROCEDURE REPORTE2(sucursal_p SUCURSAL.NOMBRE%type, fecha_p DATE, c2 OUT sys_refcursor) is
BEGIN
    OPEN c2 FOR
        SELECT M.fecha, P.categoria, P.nombre, P.foto, P.descripcion, P.precio_unitario
        FROM menu_dia M
                 join PLATO P on P.CODIGO = M.CODIGO_PLATO
                 join SUCURSAL S on S.ID = M.ID_SUCURSAL
        WHERE CAST(to_date(M.fecha, 'yyyy-mm-dd') as DATE) = CAST(to_date(fecha_p, 'yyyy-mm-dd') AS DATE)
          AND UPPER(S.NOMBRE) LIKE UPPER('%' || sucursal_p || '%');
END;

--3. Reporte de histórico de promociones
CREATE OR REPLACE PROCEDURE REPORTE3(fecha_inicio DATE, fecha_fin DATE, precio_menor FLOAT,
                                     precio_mayor FLOAT, cursor OUT sys_refcursor) IS
    p_menor FLOAT;
    p_mayor FLOAT;
BEGIN
    p_menor:=precio_menor;
    p_mayor:=precio_mayor;
    if p_menor is null then
        p_menor:=0;
    end if;
    if p_mayor is null then
        p_mayor:=100000;
    end if;
    OPEN cursor
        FOR SELECT promo.inicio_fin.FECHA_INICIO,                           --fecha inicio
                   promo.inicio_fin.FECHA_FIN,                              --fecha fin
                   promo.descripcion,                                       --descripcion
                   pla.nombre,                                              --nombre
                   pla.foto,                                                -- foto
                   1 - ((promo.precio_descuento * 1) / pla.precio_unitario),--descuento
                   pla.precio_unitario,                                     --precio unitario
                   promo.precio_descuento                                   --precio final
            FROM promocion promo
                join plato_promocion pla_promo on promo.ID = pla_promo.ID_PROMOCION
                join plato pla on pla.codigo = pla_promo.codigo_plato
            where ((promo.INICIO_FIN.FECHA_INICIO BETWEEN FECHA_INICIO AND FECHA_FIN) OR
                   (promo.INICIO_FIN.FECHA_FIN BETWEEN FECHA_INICIO AND FECHA_FIN)
                OR (promo.INICIO_FIN.FECHA_INICIO <= fecha_inicio AND (promo.INICIO_FIN.FECHA_FIN >= fecha_fin OR promo.INICIO_FIN.FECHA_FIN IS NULL)))
              and promo.precio_descuento >= p_menor
              and promo.precio_descuento <= p_mayor;
END;

--4. Reporte de empleados del restaurante por sucursal y su rol
CREATE OR REPLACE procedure reporte4(sucursal SUCURSAL.nombre%type, fechas CALENDARIO,
                                     rol ROL.nombre%type, c4 OUT SYS_REFCURSOR) IS
    S1 VARCHAR2(100);
    R1 VARCHAR2(100);
BEGIN
    S1:= '%' || UPPER(sucursal) || '%';
    R1:= '%' || UPPER(rol) || '%';
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
        WHERE UPPER(S.NOMBRE) LIKE S1
          AND UPPER(R.NOMBRE) LIKE R1
          AND ((C.FECHAS.FECHA_INICIO BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_FIN BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_INICIO <= FECHAS.FECHA_INICIO AND (C.FECHAS.FECHA_FIN >= fechas.FECHA_FIN OR C.FECHAS.FECHA_FIN IS NULL)))
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

create OR REPLACE PROCEDURE REPORTE5 (crest OUT sys_refcursor) IS
BEGIN
    OPEN crest
    FOR SELECT S.NOMBRE AS Nombre_Sucursal, R.NOMBRE AS Nombre_Restaurante,
               R.LOGO AS Logo_Restaurante, S.DIRECCION.DESCRIPCION AS Direccion_escrita,
               S.DIRECCION.LATITUD, S.DIRECCION.LONGITUD, porcentaje_promedio_satisfaccion(S.ID) AS PROMEDIO
    FROM RESTAURANTE R, SUCURSAL S
    ORDER BY S.ID;
END;

--6. Reporte de horarios de mayor y menor afluencia por restaurante y sucursal
CREATE OR REPLACE FUNCTION getWeekday(fecha DATE) return VARCHAR2 IS
BEGIN
    RETURN TO_CHAR(fecha, 'Day', 'NLS_DATE_LANGUAGE = SPANISH');
end;

create or replace FUNCTION afluencia_dia(sID NUMBER, dia_semana VARCHAR2, fecha CALENDARIO)
RETURN NUMBER IS
aflu_dia NUMBER;
BEGIN
    SELECT COUNT(ID) INTO aflu_dia
    FROM PEDIDO
    WHERE UPPER(GETWEEKDAY(FECHA_HORA)) LIKE UPPER(dia_semana || '%')
      AND (FECHA_HORA BETWEEN fecha.FECHA_INICIO AND fecha.FECHA_FIN)
      AND TIPO = 'EN LOCAL'
      AND ID_SUCURSAL = sID;
    RETURN aflu_dia;
end;

CREATE OR REPLACE PROCEDURE reporte6(sucursal SUCURSAL.nombre%type, fechas CALENDARIO, dia_semana VARCHAR2,
                                     c6 OUT SYS_REFCURSOR) IS
    S1 NUMBER;
    aflu_dia NUMBER;

BEGIN
    SELECT ID INTO S1 FROM SUCURSAL WHERE UPPER(NOMBRE) LIKE ('%' || UPPER(sucursal) || '%');
    aflu_dia:=afluencia_dia(S1, dia_semana, fechas);
    if aflu_dia>0 then
    OPEN c6 FOR
        SELECT t1.Sucursal,
               R.NOMBRE,
               R.LOGO,
               t1.Direccion,
               t1.Horario,
               t1.Dia,
               t2.hora,
               ROUND((t2.total/aflu_dia)*100,2) as afluencia
        FROM RESTAURANTE R
                 join
             (SELECT DISTINCT R.ID,
                              S.NOMBRE as Sucursal,
                              S.DIRECCION.DESCRIPCION as Direccion,
                              S.HORARIO.GETHORAINICIO() || ' - ' || S.HORARIO.GETHORAFIN() as Horario,
                              getWeekday(P.FECHA_HORA) as Dia
              FROM SUCURSAL S
                       join RESTAURANTE R on R.ID = S.ID_RESTAURANTE
                       join PEDIDO P on S.ID = P.ID_SUCURSAL
              WHERE S.ID=S1) t1 on R.ID = t1.ID
                 join
             (SELECT GETWEEKDAY(FECHA_HORA) dia, EXTRACT(HOUR FROM FECHA_HORA) hora, COUNT(*) total
              FROM PEDIDO
              WHERE UPPER(GETWEEKDAY(FECHA_HORA)) LIKE UPPER(dia_semana || '%')
                AND TIPO = 'EN LOCAL'
                AND ID_SUCURSAL = S1
                AND (FECHA_HORA BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN)
              GROUP BY GETWEEKDAY(FECHA_HORA), EXTRACT(HOUR FROM FECHA_HORA), EXTRACT(HOUR FROM FECHA_HORA)
              ORDER BY hora) t2 on t1.dia = t2.dia;
    end if;
END;

--7. Reporte de control de inventario de mercancía
CREATE OR REPLACE PROCEDURE reporte7(sucursal SUCURSAL.nombre%type, fecha DATE, c7 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c7 FOR
        SELECT S.NOMBRE,
               to_char(I.FECHA_INVENTARIO, 'fmMonth YYYY', 'NLS_DATE_LANGUAGE=Spanish') as fecha_inv,
               P.DESCRIPCION,
               P.FOTO,
               to_char(I.CANTIDAD, 'fm990d00') || CASE WHEN (P.UNIDAD_MEDIDA='U') THEN ' Unidades' ELSE P.UNIDAD_MEDIDA END as Cant
        FROM SUCURSAL S
                 JOIN INVENTARIO I on S.ID = I.ID_SUCURSAL
                 JOIN PRODUCTO P on P.ID = I.ID_PRODUCTO
        WHERE UPPER(S.NOMBRE) LIKE '%' || UPPER(sucursal) || '%'
          AND to_char(I.FECHA_INVENTARIO, 'MM-YYYY') LIKE '%' || to_char(fecha, 'MM-YYYY') || '%';
end;

--8. Reporte de ingresos y egresos por sucursal de restaurante
CREATE OR REPLACE FUNCTION total_ingresos(sucursal_id SUCURSAL.id%type, fecha DATE) RETURN NUMBER IS
    total NUMBER;
BEGIN
    SELECT SUM(MONTO_TOTAL)
    INTO total
    FROM PEDIDO
    WHERE ID_SUCURSAL=sucursal_id AND to_char(FECHA_HORA, 'MM-YYYY') = to_char(fecha, 'MM-YYYY');
    RETURN total;
end;

CREATE OR REPLACE FUNCTION total_egresos(sucursal_id SUCURSAL.id%type, fecha_parametro DATE) RETURN NUMBER IS
    total NUMBER;
BEGIN
    SELECT SUM(MONTO)
    INTO total
    FROM EGRESO
    WHERE ID_SUCURSAL=sucursal_id AND to_char(FECHA, 'MM-YYYY') = to_char(fecha_parametro, 'MM-YYYY');
    RETURN total;
end;

CREATE OR REPLACE PROCEDURE reporte8(sucursal SUCURSAL.nombre%type, fecha_parametro DATE, c8 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c8 FOR
        SELECT S.NOMBRE,
               to_char(fecha_parametro, 'fmMonth YYYY', 'NLS_DATE_LANGUAGE=Spanish') as fecha,
               total_ingresos(S.ID, fecha_parametro) as ingresos,
               total_egresos(S.ID, fecha_parametro) as egresos
        FROM SUCURSAL S
        WHERE UPPER(S.NOMBRE) LIKE '%' || UPPER(sucursal) || '%';
end;