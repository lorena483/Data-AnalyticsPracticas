USE Ventas_Tech_DB;

-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Unificar datos relacionados de distintas tablas y facilitar el análisis de la operatoria de la empresa.

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Los accesorios son la categoría con mayor rotación, con 17 productos vendidos.


-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Identificar clientes que nunca compraron para que CRM se contacte y les ofrezca un descuento adicional.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: la consulta está vacía, es decir que todos los clientes realizaron al menos una compra.


-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Detectar productos que no se hayan vendido para que el área de producto evalúe discontinuarlos.

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v
ON p.id_producto = v.id_producto
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- Hallazgo: La consulta está vacía, es decir que no hay productos sin ventas.


-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Propósito: Comparar el importe de ventas entre dos períodos distintos para detectar patrones de comportamiento de clientes.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primera etapa (05 al 10/03)' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segunda etapa (11 al 15/03)' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-11' AND '2024-03-15'

) AS consolidado
GROUP BY canal;

-- Hallazgo: Las ventas son mayores en la primera etapa del mes.