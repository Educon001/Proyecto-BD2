--1. Reporte de platos de mayor demanda
CREATE OR REPLACE PROCEDURE reporte1(tipo_pedido PEDIDO.tipo%type, fechas CALENDARIO,
                                     tipo_plato PLATO.categoria%type, c1 OUT sys_refcursor) IS
    tp1 VARCHAR2(20);
    tp2 VARCHAR2(20);
BEGIN
    tp1 := '%' || UPPER(tipo_pedido) || '%';
    tp2 := '%' || UPPER(tipo_plato) || '%';
    OPEN c1 FOR
        SELECT T.Sucursal,
               T.Plato,
               P.FOTO,
               T.DESCRIPCION,
               T.TIPO,
               "Fecha desde",
               "Fecha hasta",
               cantidad,
               demanda,
               T.PRECIO_UNITARIO
        FROM PLATO P
                 join
             (SELECT DISTINCT S.NOMBRE                                             as Sucursal,
                              P2.NOMBRE                                            as Plato,
                              P2.DESCRIPCION,
                              P.TIPO,
                              fechas.FECHA_INICIO                                  as "Fecha desde",
                              fechas.FECHA_FIN                                     as "Fecha hasta",
                              cant.cantidad                                        as cantidad,
                              ROUND((cant.cantidad / total.total_platos) * 100, 2) as demanda,
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
                             GROUP BY S.ID, PP.CODIGO_PLATO) cant
                            on cant.CODIGO_PLATO = PP.CODIGO_PLATO and cant.ID = S.ID
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
                AND cant.cantidad > 0) T on P.NOMBRE = T.Plato
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
    p_menor := precio_menor;
    p_mayor := precio_mayor;
    if p_menor is null then
        p_menor := 0;
    end if;
    if p_mayor is null then
        p_mayor := 100000;
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
                OR (promo.INICIO_FIN.FECHA_INICIO <= fecha_inicio AND
                    (promo.INICIO_FIN.FECHA_FIN >= fecha_fin OR promo.INICIO_FIN.FECHA_FIN IS NULL)))
              and promo.precio_descuento >= p_menor
              and promo.precio_descuento <= p_mayor;
END;

--4. Reporte de empleados del restaurante por sucursal y su rol
CREATE OR REPLACE procedure reporte4(sucursal SUCURSAL.nombre%type, fechas CALENDARIO,
                                     rol ROL.nombre%type, c4 OUT SYS_REFCURSOR) IS
    S1 VARCHAR2(100);
    R1 VARCHAR2(100);
BEGIN
    S1 := '%' || UPPER(sucursal) || '%';
    R1 := '%' || UPPER(rol) || '%';
    OPEN c4 FOR
        SELECT S.NOMBRE                as Sucursal,
               E.FOTO_CARNET,
               'V' || E.DATOS.CI       as CI,
               E.DATOS.PRIMER_NOMBRE   as Nombre,
               E.DATOS.PRIMER_APELLIDO as Apellido,
               E.FECHA_NACIMIENTO,
               E.SEXO,
               C.FECHAS.FECHA_INICIO   as fecha_desde,
               C.FECHAS.FECHA_FIN      as fecha_hasta,
               C.MOTIVO_EGRESO,
               R.NOMBRE                as rol,
               R.DESCRIPCION
        FROM CONTRATO C
                 join EMPLEADO E on E.ID = C.ID_EMPLEADO
                 join ROL R on R.ID = C.ID_ROL
                 join SUCURSAL S on S.ID = C.ID_SUCURSAL
        WHERE UPPER(S.NOMBRE) LIKE S1
          AND UPPER(R.NOMBRE) LIKE R1
          AND ((C.FECHAS.FECHA_INICIO BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_FIN BETWEEN fechas.FECHA_INICIO AND fechas.FECHA_FIN) OR
               (C.FECHAS.FECHA_INICIO <= FECHAS.FECHA_INICIO AND
                (C.FECHAS.FECHA_FIN >= fechas.FECHA_FIN OR C.FECHAS.FECHA_FIN IS NULL)))
        ORDER BY S.NOMBRE;
end;

--5. Reporte de sucursales del restaurante
create or replace FUNCTION porcentaje_promedio_satisfaccion(id_suc NUMBER)
    RETURN NUMBER IS
    promedio   NUMBER;
    porcentaje NUMBER;
begin

    SELECT AVG(PUNTAJE)
    INTO promedio
    FROM PEDIDO P
             JOIN CALIFICACION C
                  ON (P.id = C.id_pedido)
    WHERE P.id_sucursal = id_suc;

    porcentaje := promedio / 5;

    RETURN porcentaje;

end;

create OR REPLACE PROCEDURE REPORTE5(crest OUT sys_refcursor) IS
BEGIN
    OPEN crest
        FOR SELECT S.NOMBRE                               AS Nombre_Sucursal,
                   R.NOMBRE                               AS Nombre_Restaurante,
                   R.LOGO                                 AS Logo_Restaurante,
                   S.DIRECCION.DESCRIPCION                AS Direccion_escrita,
                   S.DIRECCION.LATITUD,
                   S.DIRECCION.LONGITUD,
                   porcentaje_promedio_satisfaccion(S.ID) AS PROMEDIO
            FROM RESTAURANTE R,
                 SUCURSAL S
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
    SELECT COUNT(ID)
    INTO aflu_dia
    FROM PEDIDO
    WHERE UPPER(GETWEEKDAY(FECHA_HORA)) LIKE UPPER(dia_semana || '%')
      AND (FECHA_HORA BETWEEN fecha.FECHA_INICIO AND fecha.FECHA_FIN)
      AND TIPO = 'EN LOCAL'
      AND ID_SUCURSAL = sID;
    RETURN aflu_dia;
end;

CREATE OR REPLACE PROCEDURE reporte6(sucursal SUCURSAL.nombre%type, fechas CALENDARIO, dia_semana VARCHAR2,
                                     c6 OUT SYS_REFCURSOR) IS
    S1       NUMBER;
    aflu_dia NUMBER;

BEGIN
    SELECT ID INTO S1 FROM SUCURSAL WHERE UPPER(NOMBRE) LIKE ('%' || UPPER(sucursal) || '%');
    aflu_dia := afluencia_dia(S1, dia_semana, fechas);
    if aflu_dia > 0 then
        OPEN c6 FOR
            SELECT t1.Sucursal,
                   R.NOMBRE,
                   R.LOGO,
                   t1.Direccion,
                   t1.Horario,
                   t1.Dia,
                   t2.hora,
                   ROUND((t2.total / aflu_dia) * 100, 2) as afluencia
            FROM RESTAURANTE R
                     join
                 (SELECT DISTINCT R.ID,
                                  S.NOMBRE                                                     as Sucursal,
                                  S.DIRECCION.DESCRIPCION                                      as Direccion,
                                  S.HORARIO.GETHORAINICIO() || ' - ' || S.HORARIO.GETHORAFIN() as Horario,
                                  getWeekday(P.FECHA_HORA)                                     as Dia
                  FROM SUCURSAL S
                           join RESTAURANTE R on R.ID = S.ID_RESTAURANTE
                           join PEDIDO P on S.ID = P.ID_SUCURSAL
                  WHERE S.ID = S1) t1 on R.ID = t1.ID
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
               to_char(I.FECHA_INVENTARIO, 'fmMonth YYYY', 'NLS_DATE_LANGUAGE=Spanish')    as fecha_inv,
               P.DESCRIPCION,
               P.FOTO,
               to_char(I.CANTIDAD, 'fm990d00') ||
               CASE WHEN (P.UNIDAD_MEDIDA = 'U') THEN ' Unidades' ELSE P.UNIDAD_MEDIDA END as Cant
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
    WHERE ID_SUCURSAL = sucursal_id
      AND to_char(FECHA_HORA, 'MM-YYYY') = to_char(fecha, 'MM-YYYY');
    IF total IS NULL THEN
        total := 0;
    end if;
    RETURN total;
end;

CREATE OR REPLACE FUNCTION total_egresos(sucursal_id SUCURSAL.id%type, fecha_parametro DATE) RETURN NUMBER IS
    total NUMBER;
BEGIN
    SELECT SUM(MONTO)
    INTO total
    FROM EGRESO
    WHERE ID_SUCURSAL = sucursal_id
      AND to_char(FECHA, 'MM-YYYY') = to_char(fecha_parametro, 'MM-YYYY');
    if total IS NULL THEN
        total := 0;
    end if;
    RETURN total;
end;

CREATE OR REPLACE PROCEDURE reporte8(sucursal SUCURSAL.nombre%type, fecha_parametro DATE, c8 OUT SYS_REFCURSOR) IS
BEGIN
    if fecha_parametro IS NOT NULL THEN
        OPEN c8 FOR
            SELECT S.NOMBRE,
                   to_char(fecha_parametro, 'fmMonth YYYY', 'NLS_DATE_LANGUAGE=Spanish') as fecha,
                   total_ingresos(S.ID, fecha_parametro)                                 as ingresos,
                   total_egresos(S.ID, fecha_parametro)                                  as egresos
            FROM SUCURSAL S
            WHERE UPPER(S.NOMBRE) LIKE '%' || UPPER(sucursal) || '%';
    end if;
end;

--9. Reporte de satisfacción de calidad de servicio
CREATE OR REPLACE PROCEDURE REPORTE9(fecha_p DATE, sucursal String, c9 OUT sys_refcursor) IS
BEGIN
    OPEN c9
        FOR SELECT s.nombre,
                   to_char(p.fecha_hora, 'fmMonth YYYY', 'NLS_DATE_LANGUAGE=Spanish') as fecha_inv,
                   (SELECT concat(
                                   CAST(CAST((((AVG(c.puntaje) * 1) / 5) * 100) AS DECIMAL(5, 2)) AS varchar2(50)),
                                   CAST('%' as varchar2(5)))
                    FROM sucursal s,
                         pedido p,
                         calificacion c
                    where (s.id = p.id_sucursal)
                      and (p.id = c.id_pedido)
                      and UPPER(s.nombre) LIKE '%' || UPPER(sucursal) || '%'
                      and to_char(p.fecha_hora, 'MM-YYYY')
                        LIKE '%' || to_char(fecha_p, 'MM-YYYY') || '%')               as satisfaccion,
                   c.observaciones
            FROM sucursal s,
                 pedido p,
                 calificacion c
            where (s.id = p.id_sucursal)
              and (p.id = c.id_pedido)
              and (to_char(p.fecha_hora, 'MM-YYYY') LIKE '%' || to_char(fecha_p, 'MM-YYYY') || '%')
              and (UPPER(s.nombre) LIKE '%' || UPPER(sucursal) || '%');
END;

--10. Reporte de recetas o platos estrella del restaurante
CREATE OR REPLACE PROCEDURE REPORTE10(c10 OUT sys_refcursor) IS
BEGIN
    OPEN c10
        FOR
        Select *
        from ((select distinct s.nombre as nombre_sucursal,
                               p.nombre as nombre_plato,
                               p.codigo as codigo_nombre,
                               (select concat(
                                               CAST(CAST((((AVG(pp.puntaje) * 1) / 5) * 100) AS DECIMAL(5, 2)) AS varchar2(50)),
                                               CAST('%' as varchar2(5)))
                                from plato_pedido pp,
                                     plato pla,
                                     sucursal su,
                                     pedido pedi
                                where (pp.codigo_plato = pla.codigo)
                                  and (pla.codigo = p.codigo)
                                  and ((pedi.id_sucursal = s.id))
                                  and (su.id = s.id))
               from sucursal s,
                    plato p,
                    plato_pedido pp,
                    pedido pedi
               where (pedi.id = pp.id_pedido)
                 and (pp.codigo_plato = p.codigo)
                 and (pedi.id_sucursal = s.id)
                 and ((select CAST((((AVG(pp.puntaje) * 1) / 5) * 100) AS DECIMAL(5, 2))
                       from plato_pedido pp,
                            plato pla,
                            sucursal su,
                            pedido pedi
                       where (pp.codigo_plato = pla.codigo)
                         and (pla.codigo = p.codigo)
                         and (su.id = s.id)
                         and ((pedi.id_sucursal = s.id))) >= 85))) nombres
                 inner join
             (select pla.foto as foto_plato, pla.codigo as codigo_plato, pla.receta from plato pla) fotos
             on codigo_plato = codigo_nombre;
END;

--11. Reporte de control de despacho vía Delivery
CREATE OR REPLACE PROCEDURE reporte11(destino VARCHAR2, tipo_comida PLATO.CATEGORIA%type, c11 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c11 FOR
        SELECT S.NOMBRE                                                        as sucursal,
               PL.CATEGORIA                                                    as tipo_plato,
               PL.NOMBRE                                                       as plato,
               PL.FOTO,
               SUBSTR(P.TIPO, 1, 1) || LOWER(SUBSTR(P.TIPO, 2))                as tipo_pedido,
               C.DATOS.PRIMER_NOMBRE                                           as nombre_cliente,
               C.DATOS.PRIMER_APELLIDO                                         as apellido_cliente,
               '0' || SUBSTR(C.TELEFONO, 1, 3) || '-' || SUBSTR(C.TELEFONO, 4) as telefono,
               C.DIRECCION.DESCRIPCION                                         as direccion
        FROM PEDIDO P
                 join SUCURSAL S on S.ID = P.ID_SUCURSAL
                 join CLIENTE C on C.ID = P.ID_CLIENTE
                 join PLATO_PEDIDO PP on P.ID = PP.ID_PEDIDO
                 join PLATO PL on PL.CODIGO = PP.CODIGO_PLATO
        WHERE P.TIPO = 'DELIVERY'
          AND UPPER(PL.CATEGORIA) LIKE '%' || UPPER(tipo_comida) || '%'
          AND UPPER(C.DIRECCION.DESCRIPCION) LIKE '%' || UPPER(destino) || '%';
end;

-- REPORTE 12: INGRESOS POR TIPO DE PAGO DE UNA SUCURSAL DENTRO UN RANGO DE FECHAS
CREATE OR REPLACE FUNCTION ingreso_tipo_pago(nombre_suc sucursal.nombre%type, fecha_pedido varchar2,
                                             tp pago_pedido.tipo_pago%type, tipo_pedido pedido.tipo%type)
    RETURN NUMBER IS
    total  number;
    id_suc SUCURSAL.id%type;
BEGIN
    SELECT ID INTO ID_SUC FROM SUCURSAL WHERE NOMBRE = nombre_suc;

    SELECT SUM(PP.MONTO)
    INTO total
    FROM PEDIDO P
             JOIN PAGO_PEDIDO PP on P.ID = PP.ID_PEDIDO
    WHERE to_char(P.FECHA_HORA, 'DD/MM/YYYY') = fecha_pedido
      AND P.ID_SUCURSAL = ID_SUC
      AND PP.TIPO_PAGO = tp
      AND P.TIPO = tipo_pedido;

    IF TOTAL IS NULL THEN
        TOTAL := 0;
    end if;
    RETURN TOTAL;
end;

CREATE OR REPLACE FUNCTION ingreso_tipo_total(nombre_suc sucursal.nombre%type, fecha_pedido varchar2,
                                              tipo_pedido pedido.tipo%type)
    RETURN NUMBER IS
    total  number;
    id_suc SUCURSAL.id%type;
BEGIN
    SELECT ID INTO ID_SUC FROM SUCURSAL WHERE NOMBRE = nombre_suc;

    SELECT SUM(PP.MONTO)
    INTO total
    FROM PEDIDO P
             JOIN PAGO_PEDIDO PP on P.ID = PP.ID_PEDIDO
    WHERE to_char(P.FECHA_HORA, 'DD/MM/YYYY') = fecha_pedido
      AND P.ID_SUCURSAL = ID_SUC
      AND P.TIPO = tipo_pedido;

    IF TOTAL IS NULL THEN
        TOTAL := 0;
    end if;
    RETURN TOTAL;
end;

CREATE OR REPLACE FUNCTION porcentaje_tipo_pago(nombre_suc sucursal.nombre%type, fecha_pedido varchar2,
                                                tp PAGO_PEDIDO.tipo_pago%type, tipo_pedido pedido.tipo%type)
    RETURN NUMBER IS
    PORCENTAJE number;
BEGIN
    PORCENTAJE := (INGRESO_TIPO_PAGO(nombre_suc, fecha_pedido, tp, tipo_pedido) /
                   INGRESO_TIPO_TOTAL(nombre_suc, fecha_pedido, tipo_pedido)) * 100;
    RETURN PORCENTAJE;
end;

CREATE OR REPLACE PROCEDURE reporte12(fechas CALENDARIO, nom_sucursal SUCURSAL.NOMBRE%TYPE, c12 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c12 FOR
        SELECT NOMBRE,
               TIPO,
               fecha_ped,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'EFECTIVO', TIPO)                                   AS EFECTIVO,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'POS', TIPO)                                        AS POS,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'ZELLE', TIPO)                                      AS ZELLE,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'PIPOL PAY', TIPO)                                  AS PIPOL_PAY,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'PAYPAL', TIPO)                                     AS PAYPAL,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'ZINLI', TIPO)                                      AS ZINLI,
               INGRESO_TIPO_PAGO(nombre, fecha_ped, 'CRIPTOMONEDAS', TIPO)                              AS CRIPTOMONEDAS,
               to_char('$' || INGRESO_TIPO_TOTAL(nombre, fecha_ped, TIPO))                              AS SUMA_INGRESOS,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'EFECTIVO', TIPO), 2) || '%')      AS PEFECTIVO,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'POS', TIPO), 2) || '%')           AS PPOS,
               to_char(trunc(porcentaje_tipo_pago(nombre, fecha_ped, 'ZELLE', TIPO), 2) || '%')         AS PZELLE,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'PIPOL PAY', TIPO), 2) || '%')     AS PPIPOL_PAY,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'PAYPAL', TIPO), 2) || '%')        AS PPAYPAL,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'ZINLI', TIPO), 2) || '%')         AS PZINLI,
               to_char(TRUNC(porcentaje_tipo_pago(nombre, fecha_ped, 'CRIPTOMONEDAS', TIPO), 2) ||
                       '%')                                                                             AS PCRIPTOMONEDAS
        from (SELECT NOMBRE, TIPO, fecha_ped
              from (SELECT S.NOMBRE, P.TIPO, to_char(P.FECHA_HORA, 'DD/MM/YYYY') AS fecha_ped
                    FROM SUCURSAL S
                             JOIN PEDIDO P on S.ID = P.ID_SUCURSAL
                    WHERE UPPER(S.NOMBRE) LIKE ('%' || UPPER(nom_sucursal) || '%')
                      AND P.FECHA_HORA BETWEEN FECHAS.FECHA_INICIO AND FECHAS.FECHA_FIN)
              GROUP BY NOMBRE, TIPO, fecha_ped);
end;

-- REPORTE 13: Reporte de reservas realizadas en el restaurante
CREATE OR REPLACE PROCEDURE reporte13(fechas CALENDARIO, nomb_sucursal sucursal.nombre%type, c13 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c13 FOR
        SELECT S.NOMBRE,
               S.DIRECCION.LATITUD,
               S.DIRECCION.LONGITUD,
               to_char(R.FECHA, 'DD/MM/YYYY')  AS FECHA_RESERVA,
               R.CANTIDAD_PERSONAS,
               to_char('$' || R.ABONO_INICIAL) AS ABONO
        FROM SUCURSAL S
                 JOIN RESERVA R ON S.ID = R.ID_SUCURSAL
        WHERE UPPER(S.NOMBRE) LIKE '%' || UPPER(nomb_sucursal) || '%'
          AND R.FECHA BETWEEN FECHAS.FECHA_INICIO AND FECHAS.FECHA_FIN;
end;

--REPORTE 14: Grupos musicales contratados para la sucursal del restaurante (Parametrizado por ubicación de la sucursal y fecha)
CREATE OR REPLACE PROCEDURE reporte14(fechas CALENDARIO, nombre_sucursal sucursal.nombre%type, c14 OUT SYS_REFCURSOR) IS
BEGIN
    OPEN c14 FOR
        SELECT S.NOMBRE,
               to_char(E.FECHA, 'DD/MM/YYYY')                                       AS FECHA_EVENTO,
               E.NOMBRE,
               E.GRUPO_MUSICAL,
               E.CONDICIONES,
               to_char(EXTRACT(HOUR FROM E.HORARIO.HORA_INICIO) || ':' ||
                       to_char(EXTRACT(MINUTE FROM E.HORARIO.HORA_INICIO), 'fm00')) AS HORA_DE_INICIO,
               to_char(EXTRACT(HOUR FROM E.HORARIO.HORA_FIN) || ':' ||
                       to_char(EXTRACT(MINUTE FROM E.HORARIO.HORA_FIN), 'fm00'))    AS HORA_DE_FIN
        FROM SUCURSAL S
                 JOIN EVENTO E ON S.ID = E.ID_SUCURSAL
        WHERE UPPER(S.NOMBRE) LIKE '%' || upper(nombre_sucursal) || '%'
          AND E.FECHA BETWEEN FECHAS.FECHA_INICIO AND FECHAS.FECHA_FIN;
end;

