USE Ventas_Tech_DB;

-- CONSULTA 1: RESUMEN EJECUTIVO MENSUAL
SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM dbo.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: RANKING DE PRODUCTOS
SELECT TOP 5 id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM dbo.ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- CONSULTA 3: CLIENTES RECURRENTES
SELECT id_cliente,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- CONSULTA 4: PRODUCTOS POR ENCIMA/POR DEBAJO DEL PROMEDIO DE FACTURACION POR PRODUCTO
WITH facturacion_producto AS (
SELECT id_producto,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
)

SELECT id_producto, total_facturado,
CASE 
WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_producto
) THEN 'Por encima'
ELSE 'Por debajo'
END AS comparacion
FROM facturacion_producto
ORDER BY total_facturado DESC;

-- COMENTARIOS
-- EL PRODUCTO 1 LIDERA AMPLIAMENTE EL RANKING, DEMOSTRANDO GRAN CONCENTRACION DE INGRESOS EN UN SOLO PRODUCTO. 
-- LOS 5 CLIENTES REALIZARON MAS DE UNA COMPRA EN EL PERIODO, ES DECIR QUE SON CLIENTES RECURRENTES.
-- EL PRODUCTO 2 ES EL MAS VENDIDO EN CANTIDAD PERO GENERA BAJO INGRESO.