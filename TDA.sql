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
CREATE OR REPLACE TYPE HORARIO AS OBJECT(hora NUMBER);