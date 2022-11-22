CREATE DIRECTORY BLOBS AS 'C:\BLOBS';

CREATE OR REPLACE FUNCTION file_to_blob(p_file_name VARCHAR2) RETURN BLOB AS
    dest_loc BLOB  := empty_blob();
    src_loc  BFILE := BFILENAME('BLOBS', p_file_name);
BEGIN
    DBMS_LOB.OPEN(src_loc, DBMS_LOB.LOB_READONLY);

    DBMS_LOB.CREATETEMPORARY(
            lob_loc => dest_loc
        , cache => true
        , dur => dbms_lob.session
        );

    DBMS_LOB.OPEN(dest_loc, DBMS_LOB.LOB_READWRITE);

    DBMS_LOB.LOADFROMFILE(
            dest_lob => dest_loc
        , src_lob => src_loc
        , amount => DBMS_LOB.getLength(src_loc));

    DBMS_LOB.CLOSE(dest_loc);
    DBMS_LOB.CLOSE(src_loc);

    RETURN dest_loc;
END file_to_blob;

CREATE OR REPLACE FUNCTION calcular_distancia(lat1 NUMBER, lon1 NUMBER, lat2 NUMBER, lon2 NUMBER) RETURN NUMBER IS
    distancia NUMBER;
BEGIN
    SELECT sdo_geom.sdo_distance( --  longitud,  Latitud
                   sdo_geometry(2001, 4326, sdo_point_type(lon1, lat1, null), null, null),
                   sdo_geometry(2001, 4326, sdo_point_type(lon2, lat2, null), null, null),
                   0.01,
                   'unit=KM'
               )
    INTO distancia
    from dual;
    RETURN distancia;
END;

CREATE OR REPLACE FUNCTION precio_unitario_plato(cod_plato PLATO.CODIGO%TYPE)
RETURN PLATO.PRECIO_UNITARIO%TYPE IS
    precio PLATO.PRECIO_UNITARIO%TYPE;
BEGIN
    SELECT PRECIO_UNITARIO INTO precio FROM PLATO WHERE CODIGO = cod_plato;
    RETURN precio;
END;

CREATE OR REPLACE FUNCTION nombre_plato(cod_plato NUMBER)
RETURN PLATO.NOMBRE%TYPE IS
    nomb_plato PLATO.NOMBRE%TYPE;
BEGIN
    SELECT NOMBRE INTO nomb_plato FROM PLATO WHERE CODIGO = COD_PLATO;
    RETURN nomb_plato;
end;

CREATE OR REPLACE FUNCTION nombre_producto(producto_id NUMBER) RETURN VARCHAR2 IS
    nombre_producto VARCHAR2(100);
BEGIN
    SELECT DESCRIPCION
    INTO nombre_producto
    FROM PRODUCTO
    WHERE ID=producto_id;
    RETURN nombre_producto;
end;

CREATE OR REPLACE FUNCTION nombre_sucursal(sucursal_id NUMBER) RETURN VARCHAR2 IS
    nombre_sucursal VARCHAR2(100);
BEGIN
    SELECT NOMBRE
    INTO nombre_sucursal
    FROM SUCURSAL
    WHERE ID=sucursal_id;
    RETURN nombre_sucursal;
end;