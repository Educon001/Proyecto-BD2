--Simulacion 1: Delivery muy lejos
BEGIN
    SIMULACION_1();
end;

--Simulación 2: Generación de menú del día
BEGIN
    SIMULACION2_PKG.SIMULACION2();
end;

--Simulación 3: Modulo de reserva
BEGIN
    SIMULACION3_PKG.SIMULACION_3();
end;

--Simulación 4: Se despide y contrata un empleado
BEGIN

end;

--Simulación 5: Recomendación del plato del día según calificaciones
BEGIN
    SIMULACION5_PKG.SIMULACION5();
end;

--Simulación 6: Pago a través de multiples métodos
BEGIN
    SIMULACION6_PKG.SIMULACION_6();
end;

--Simulación 7: Ganancias obtenidas un día según ingresos y egresos de una sucursal
BEGIN
    SIMULACION7_PKG.SIMULACION_7();
end;

--Simulación 8: Pedido de una promoción
BEGIN

end;

--Simulación 9: Se acaba un producto
BEGIN
    SIMULACION9_PKG.SIMULACION9();
end;

SELECT * FROM PEDIDO