--DIRECCION
CREATE OR REPLACE TYPE direccion AS OBJECT
(
    latitud     NUMBER,
    longitud    NUMBER,
    descripcion VARCHAR2(200),
    STATIC FUNCTION validar_latitud(latitud NUMBER) RETURN NUMBER,
    STATIC FUNCTION validar_longitud(longitud NUMBER) RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY direccion AS
    STATIC FUNCTION validar_latitud(latitud NUMBER) RETURN NUMBER IS
    BEGIN
        IF (latitud BETWEEN -90 AND 90) THEN
            RETURN latitud;
        ELSE
            RAISE_APPLICATION_ERROR(-20000, 'La latitud debe estar comprendida entre -90 y 90 grados');
        END IF;
    END;

    STATIC FUNCTION validar_longitud(longitud NUMBER) RETURN NUMBER IS
    BEGIN
        IF (longitud BETWEEN -180 AND 180) THEN
            RETURN longitud;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'La longitud debe estar comprendida entre -180 y 180 grados');
        END IF;
    END;
END;

--DATOS BASICOS
CREATE OR REPLACE TYPE DATOS_BASICOS AS OBJECT
(
    ci               INTEGER,
    primer_nombre    VARCHAR2(20),
    segundo_nombre   VARCHAR2(20),
    primer_apellido  VARCHAR2(30),
    segundo_apellido VARCHAR2(30),
    STATIC FUNCTION validarCI(ci INTEGER) RETURN INTEGER
);

CREATE OR REPLACE TYPE BODY DATOS_BASICOS AS
    STATIC FUNCTION validarCI(ci INTEGER) RETURN INTEGER
        IS
    BEGIN
        IF (ci > 0 AND ci < 99999999) THEN
            RETURN ci;
        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Número de cédula inválido');
        END IF;
    END;
END;

--HORARIO
CREATE OR REPLACE TYPE HORARIO AS OBJECT
(
    hora_inicio   interval day to second,
    hora_fin      interval day to second,
    CONSTRUCTOR FUNCTION horario(hora_inicio interval day to second, hora_fin interval day to second) RETURN SELF AS RESULT
);

CREATE OR REPLACE TYPE BODY HORARIO AS
    CONSTRUCTOR FUNCTION horario(hora_inicio interval day to second, hora_fin interval day to second) RETURN SELF AS RESULT
        IS
    BEGIN
        IF (hora_fin >= hora_inicio OR hora_fin IS null) THEN
            SELF.hora_inicio := hora_inicio;
            SELF.hora_fin := hora_fin;
        ELSE
            RAISE_APPLICATION_ERROR(-20003, 'La hora fin debe ser mayor o igual a la hora de inicio');
        END IF;
        RETURN;
    END;
END;

--CALENDARIO
CREATE OR REPLACE TYPE CALENDARIO AS OBJECT
(
    fecha_inicio DATE,
    fecha_fin    DATE,
    CONSTRUCTOR FUNCTION calendario(fecha_inicio DATE, fecha_fin DATE) RETURN SELF AS RESULT
);

CREATE OR REPLACE TYPE BODY CALENDARIO AS
    CONSTRUCTOR FUNCTION calendario(fecha_inicio DATE, fecha_fin DATE) RETURN SELF AS RESULT
        IS
    BEGIN
        IF (fecha_fin >= fecha_inicio OR fecha_fin IS null) THEN
            SELF.fecha_inicio := fecha_inicio;
            SELF.fecha_fin := fecha_fin;
        ELSE
            RAISE_APPLICATION_ERROR(-20004, 'Fecha fin debe ser mayor o igual a fecha de inicio');
        END IF;
        RETURN;
    END;
END;
