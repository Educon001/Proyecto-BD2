CREATE OR REPLACE PACKAGE simulacion3_pkg IS
    FUNCTION generar_fecha_reserva RETURN DATE;
    FUNCTION validar_fecha_reserva(fecha_solicitada DATE) RETURN NUMBER;
    FUNCTION verificar_capacidad_mesas_actual(sucursal_id mesa.id_sucursal%type, num_personas NUMBER) RETURN NUMBER;
    FUNCTION verificar_capacidad_mesas_futuro(fecha_reserva DATE, horario_sol HORARIO, sucursal_id mesa.id_sucursal%type, num_personas NUMBER) RETURN NUMBER;
    FUNCTION generar_horario_reserva RETURN HORARIO;
    FUNCTION validar_horario_reserva(sucursal_id NUMBER, horario_sol HORARIO) RETURN NUMBER;
    FUNCTION calcular_abono_inicial(horario_reserva HORARIO, capacidad_mesa NUMBER) RETURN NUMBER;
    FUNCTION capacidad_mesa(sucursal_id NUMBER, numero NUMBER) RETURN NUMBER;

    PROCEDURE disponibilidad_mesas (sucursal_seleccionada NUMBER);
    PROCEDURE mensaje_reserva_exitosa(id_reserva NUMBER);
    PROCEDURE simulacion_3;
END;

CREATE OR REPLACE PACKAGE BODY simulacion3_pkg IS

-- PROCEDIMIENTO PARA ASIGNAR DISPONIBILIDAD ALEATORIAMENTE A LAS MESAS DE LA SUCURSAL
PROCEDURE disponibilidad_mesas (sucursal_seleccionada NUMBER) IS

CURSOR cursor_mesas IS
SELECT *
FROM mesa
WHERE ID_SUCURSAL = sucursal_seleccionada;

registro_mesa mesa%rowtype;
disponibilidad mesa.disponible%type;
disp VARCHAR2(15);
BEGIN

    OPEN cursor_mesas;
    FETCH cursor_mesas INTO registro_mesa;

    WHILE cursor_mesas%FOUND
        LOOP

            SELECT ROUND(DBMS_RANDOM.VALUE(0,1)) INTO disponibilidad FROM dual;

            UPDATE MESA
            SET DISPONIBLE = disponibilidad
            WHERE NUM_MESA = registro_mesa.num_mesa AND
                  ID_SUCURSAL = sucursal_seleccionada;

            IF registro_mesa.DISPONIBLE = 0 THEN
                disp := 'DISPONIBLE';
            ELSE
                disp := 'NO DISPONIBLE';
            end if;

            DBMS_OUTPUT.PUT_LINE('MESA N°' || registro_mesa.NUM_MESA || ': ' || disp);

            FETCH cursor_mesas INTO registro_mesa;
        END LOOP;

END;

-- FUNCION PARA GENERAR FECHA VALIDA RESERVA
FUNCTION generar_fecha_reserva
RETURN DATE IS
fecha DATE;
BEGIN
    SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(
                        TO_CHAR(CURRENT_DATE,'J'),
                        TO_CHAR(CURRENT_DATE+30,'J'))),'J')
    INTO fecha
    FROM DUAL;

    RETURN fecha;
END;

FUNCTION validar_fecha_reserva(fecha_solicitada DATE)
RETURN NUMBER IS
begin
    IF fecha_solicitada-CURRENT_DATE > 7 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    end if;
end;


-- FUNCION PARA VERIFICAR MESA CON CAPACIDAD DISPONIBLE EN LA HORA DE RESERVA
FUNCTION verificar_capacidad_mesas_actual(sucursal_id mesa.id_sucursal%type, num_personas NUMBER)
RETURN NUMBER IS
numero_mesa mesa.num_mesa%type;
begin

    -- SE VERIFICA SI HAY MESAS ACTUALMENTE DISPONIBLES PARA EL NUMERO DE PERSONAS
    SELECT COUNT(*)
    INTO numero_mesa
    FROM MESA
    WHERE ID_SUCURSAL = sucursal_id AND
          (CAPACIDAD-num_personas <= 2) AND
          DISPONIBLE = 1;

    -- NOTA: CHECK QUE EL NUMERO DE MESA SEA MAYOR A CERO
    if numero_mesa > 0 then
        -- SI HAY SE RETORNA EL NUMERO DE LA MESA
        SELECT NUM_MESA
        INTO numero_mesa
        FROM
            (SELECT NUM_MESA
             FROM MESA
             WHERE ID_SUCURSAL = sucursal_id AND
                (CAPACIDAD-num_personas <= 2) AND
                DISPONIBLE = 1
             ORDER BY CAPACIDAD ASC)
        WHERE ROWNUM <=1;
    end if;

    RETURN numero_mesa;
end;

FUNCTION verificar_capacidad_mesas_futuro(fecha_reserva DATE, horario_sol HORARIO, sucursal_id mesa.id_sucursal%type, num_personas NUMBER)
RETURN NUMBER IS
hay_mesa NUMBER;
numero_mesa NUMBER;
begin
    -- NUMERO DE MESAS CON LA CAPACIDAD ADECUADA QUE NO ESTAN RESERVADAS ENTRE EL HORARIO

    SELECT COUNT(*)
    INTO hay_mesa
    FROM MESA M
    WHERE M.NUM_MESA NOT IN(
        SELECT ME.NUM_MESA
        FROM MESA ME join RESERVA R
        ON (ME.ID_SUCURSAL = R.ID_SUCURSAL)
        WHERE ME.ID_SUCURSAL = sucursal_id AND
              R.FECHA = fecha_reserva AND
              (R.HORARIO.HORA_INICIO BETWEEN horario_sol.HORA_INICIO AND horario_sol.HORA_FIN OR
              R.HORARIO.HORA_FIN BETWEEN horario_sol.HORA_INICIO AND horario_sol.HORA_FIN) AND
              (ME.CAPACIDAD - 2<=2)
        ) AND
        M.ID_SUCURSAL = sucursal_id;

    IF hay_mesa = 0 THEN
        numero_mesa := 0;
    else
        SELECT M.NUM_MESA
        INTO numero_mesa
        FROM MESA M
        WHERE M.NUM_MESA NOT IN(
            SELECT ME.NUM_MESA
            FROM MESA ME join RESERVA R
            ON (ME.ID_SUCURSAL = R.ID_SUCURSAL)
            WHERE ME.ID_SUCURSAL = sucursal_id AND
              R.FECHA = fecha_reserva AND
              (R.HORARIO.HORA_INICIO BETWEEN horario_sol.HORA_INICIO AND horario_sol.HORA_FIN OR
              R.HORARIO.HORA_FIN BETWEEN horario_sol.HORA_INICIO AND horario_sol.HORA_FIN) AND
              (ME.CAPACIDAD - 2<=2)
            ) AND
        M.ID_SUCURSAL = sucursal_id AND
        ROWNUM <= 1
        ORDER BY CAPACIDAD ASC;
    end if;
    RETURN numero_mesa;
end;

-- GENERAR UN HORARIO DE RESERVA ALEATORIAMENTE
FUNCTION generar_horario_reserva
RETURN HORARIO IS

hora interval day to second;
horario_solicitado HORARIO;
diez_min NUMBER;

begin
    select floor(dbms_random.value(0, 1) * 24*60) * interval '1' minute
    into hora
    from dual;

    select DBMS_RANDOM.VALUE(0,1)
    into diez_min
    from dual;

    IF diez_min = 0 THEN
        horario_solicitado := HORARIO(hora,hora + interval '15' minute);
    ELSE
        horario_solicitado := HORARIO(hora,hora + interval '10' minute);
    end if;

    RETURN horario_solicitado;
end;

FUNCTION validar_horario_reserva(sucursal_id NUMBER, horario_sol HORARIO)
RETURN NUMBER IS
horario_sucursal HORARIO;
BEGIN
    SELECT S.HORARIO
    INTO horario_sucursal
    FROM SUCURSAL S
    WHERE S.ID = sucursal_id;

    IF (horario_sol.HORA_INICIO BETWEEN horario_sucursal.HORA_INICIO AND horario_sucursal.HORA_FIN) AND
       (horario_sol.HORA_FIN BETWEEN horario_sucursal.HORA_INICIO AND horario_sucursal.HORA_FIN) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    end if;
END;

-- FUNCION PARA CALCULAR EL ABONO INICIAL
FUNCTION calcular_abono_inicial(horario_reserva HORARIO, capacidad_mesa NUMBER)
RETURN NUMBER IS
abono NUMBER;
BEGIN
     abono := ((EXTRACT(MINUTE FROM horario_reserva.HORA_FIN)-EXTRACT(MINUTE FROM horario_reserva.HORA_INICIO))*capacidad_mesa)/10;
     if abono < 0 then
         abono := -abono;
     end if;
     return abono;
end;

-- FUNCION PARA ENCONTRAR CAPACIDAD DE LA MESA DE UNA SUCURSAL
FUNCTION capacidad_mesa(sucursal_id NUMBER, numero NUMBER)
RETURN NUMBER IS
capa NUMBER;
BEGIN
    SELECT CAPACIDAD
    INTO capa
    FROM MESA
    WHERE ID_SUCURSAL = sucursal_id AND
          NUM_MESA = numero;
    RETURN capa;
end;

-- PROCEDIMIENTO MENSAJE DE RESERVA EXITOSA Y PAGO
PROCEDURE mensaje_reserva_exitosa(id_reserva NUMBER) IS
hora_ini VARCHAR2(5);
hora_fin VARCHAR2(5);
BEGIN
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('¡Reserva exitosa!');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Datos de la reserva ');
    DBMS_OUTPUT.PUT_LINE('__________________________________________');

    FOR I IN
        (SELECT S.NOMBRE,
                R.FECHA, R.HORARIO, R.ABONO_INICIAL, R.NUM_MESA, R.CANTIDAD_PERSONAS,
                C.DATOS.PRIMER_NOMBRE AS PRIMER_NOMBRE, C.DATOS.PRIMER_APELLIDO AS PRIMER_APELLIDO, C.ID
         FROM CLIENTE C, RESERVA R, SUCURSAL S
         WHERE C.ID = R.ID_CLIENTE AND
               S.ID = R.ID_SUCURSAL AND
               R.ID = id_reserva)
    LOOP
        hora_ini := substr(TO_CHAR(I.HORARIO.HORA_INICIO),5,5);
        hora_fin := substr(TO_CHAR(I.HORARIO.HORA_FIN),5,5);
        DBMS_OUTPUT.PUT_LINE('Sucursal: '|| I.NOMBRE);
        DBMS_OUTPUT.PUT_LINE('N° de mesa: '|| I.NUM_MESA);
        DBMS_OUTPUT.PUT_LINE('Cantidad de personas: '|| I.CANTIDAD_PERSONAS);
        DBMS_OUTPUT.PUT_LINE('Fecha de reserva: '|| I.FECHA);
        DBMS_OUTPUT.PUT_LINE('Horario de reserva: '|| hora_ini || ' - ' || hora_fin );
        DBMS_OUTPUT.PUT_LINE('Cliente: '|| I.PRIMER_NOMBRE || ' ' || I.PRIMER_APELLIDO || '  ||  ID: '||I.ID);
        DBMS_OUTPUT.PUT_LINE('Abono inicial: $'|| I.ABONO_INICIAL);
    end loop;

end;

-- PROCEDIMIENTO SIMULACION 3 (MODULO DE RESERVA)
PROCEDURE simulacion_3 IS
id_sucursal SUCURSAL.ID%type;
cliente_seleccionado CLIENTE.ID%type;
fecha_reserva reserva.fecha%type;
horario_reserva reserva.horario%type;
num_personas mesa.capacidad%type;
num_mesa NUMBER;

hora_inicio VARCHAR2(5);
hora_fin VARCHAR2(5);
valido NUMBER;
ahora NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------------   SIMULACION #3: MODULO DE RESERVA   ------------');
    DBMS_OUTPUT.PUT_LINE(' ');
    -- SE ELIJE UNA SUCURSAL ALEATORIAMENTE
    DBMS_OUTPUT.PUT_LINE('Paso N°1: Elegir una sucursal aleatoriamente');
    id_sucursal := sucursal_random;

    -- SE ASIGNA ALEATORIAMENTE A LAS MESAS DE LA SUCURSAL
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°2: Se le asigna aleatoriamente disponibilidad actual a las mesas de la sucursal');
    disponibilidad_mesas(id_sucursal);

    -- SE GENERAN ALEATORIAMENTE LOS DATOS DE LA RESERVA
    -- SE SELECCIONA ALEATORIAMENTE A UN CLIENTE
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°3: Se escoge aleatoriamente a un cliente para la reserva');
    cliente_seleccionado := cliente_random;
    DBMS_OUTPUT.PUT_LINE('Se ha selccionado a cliente de ID N°'||cliente_seleccionado);

    -- SE GENERA UNA FECHA DE RESERVA HASTA QUE SEA VALIDA
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°4: Se genera una fecha de reserva hasta que sea válida');
    valido := 0;

    -- SE ESCOGE SI HACER RESERVA AHORA O DESPUES
    WHILE valido = 0
        LOOP

            fecha_reserva := generar_fecha_reserva();
            valido := validar_fecha_reserva(fecha_reserva);

            IF valido = 0 THEN
                DBMS_OUTPUT.PUT_LINE('La fecha de reserva solicitada ('||fecha_reserva||') ha sido rechazada.');
            end if;
        end loop;
    DBMS_OUTPUT.PUT_LINE('La fecha de reserva solicitada ('||fecha_reserva||') ha sido aceptada.');

    -- SE GENERA UN HORARIO DE RESERVA HASTA QUE SEA VALIDO
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°5: Se genera un horario de reserva hasta que sea válido');
    valido := 0;
    WHILE valido = 0
        LOOP
            horario_reserva := generar_horario_reserva();
            hora_inicio := substr(TO_CHAR(horario_reserva.HORA_INICIO),5,5);
            hora_fin := substr(TO_CHAR(horario_reserva.HORA_FIN),5,5);
            valido := validar_horario_reserva(id_sucursal,horario_reserva);
            IF valido = 0 THEN
                DBMS_OUTPUT.PUT_LINE('El horario de reserva solicitado ('|| hora_inicio ||'-'||hora_fin||') ha sido rechazado.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('El horario de reserva solicitado ('|| hora_inicio ||'-'||hora_fin||') ha sido aceptado.');
            end if;
        end loop;

    -- SE GENERA UN NUMERO ALEATORIO DE PERSONAS Y SE VERIFICA SI HAY UNA MESA CAPACITADA
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Paso N°6: Se se escoge un numero aleatorio de personas y se verifica la disponibilidad de las mesas');
    select round(dbms_random.value(1,12)) into num_personas from dual;
    DBMS_OUTPUT.PUT_LINE('N° de personas:' || num_personas);

    IF fecha_reserva = CURRENT_DATE AND
        (EXTRACT(HOUR FROM horario_reserva.HORA_INICIO) BETWEEN (EXTRACT(HOUR FROM CURRENT_TIMESTAMP)-4) AND (EXTRACT(HOUR FROM CURRENT_TIMESTAMP)-3)) THEN
        DBMS_OUTPUT.PUT_LINE('El ahora de reserva es pronto. Revisando disponibilidad actual de mesas...');
        num_mesa := verificar_capacidad_mesas_actual(id_sucursal,num_personas);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Revisando mesas no reservadas...');
        num_mesa := verificar_capacidad_mesas_futuro(fecha_reserva,horario_reserva,id_sucursal,num_personas);
    end if;

    IF num_mesa > 0 THEN
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Mesa N°'||num_mesa||' disponible.');
        DBMS_OUTPUT.PUT_LINE('Registrando reserva...');
        insert into RESERVA
                    values (num_mesa,ID_SUCURSAL,cliente_seleccionado,RESERVA_SEQ.nextval,fecha_reserva,horario_reserva,
                            calcular_abono_inicial(horario_reserva,capacidad_mesa(id_sucursal,num_mesa)),
                            num_personas,'RESERVA');
        mensaje_reserva_exitosa(RESERVA_SEQ.currval);
    ELSE
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('No se ha encontrado una mesa disponible para '||num_personas||' personas a la hora y fecha planteada.');
        DBMS_OUTPUT.PUT_LINE('Intentar más tarde o reservar dentro de otro horario.');
    end if;
END;
END;

