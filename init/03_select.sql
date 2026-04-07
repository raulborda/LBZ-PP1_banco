SELECT 
    p.nombre, 
    p.apellido, 
    tp.nombre AS producto, 
    ep.nombre AS estado,
    COALESCE(cb.saldo, 0) AS saldo_cuenta,
    tc.limite_compra AS limite_tarjeta
FROM Personas p
JOIN Productos pr ON p.id = pr.id_persona
JOIN Tipos_Producto tp ON pr.id_tipo_producto = tp.id_tipo_producto
JOIN Estados_Producto ep ON pr.id_estado_producto = ep.id_estado_producto
LEFT JOIN Cuentas_Bancarias cb ON pr.id_producto = cb.id_producto
LEFT JOIN Tarjetas_Credito tc ON pr.id_producto = tc.id_producto;