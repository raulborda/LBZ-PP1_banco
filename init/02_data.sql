-- 1. POBLAR ROLES
INSERT INTO Roles (nombre_rol, descripcion) VALUES 
('Cliente Premium', 'Usuarios con beneficios y límites altos'),
('Cliente Regular', 'Usuarios estándar del banco'),
('Empleado', 'Personal administrativo del banco');

-- 3. POBLAR PERSONAS
INSERT INTO Personas (nombre, apellido, dni, direccion, email, telefono, fecha_nac) VALUES 
('Juan', 'Pérez', '35123456', 'Calle Falsa 123', 'juan.perez@email.com', '1144556677', '1990-05-15'),
('María', 'García', '28999888', 'Av. Siempre Viva 742', 'm.garcia@email.com', '1122334455', '1982-10-20'),
('Ricardo', 'Fort', '20111222', 'Miami Beach 100', 'elcomandante@email.com', '1100112233', '1968-11-25');

-- 4. ASIGNAR ROLES (Roles_x_Personas)
INSERT INTO Roles_x_Personas (id_persona, id_rol) VALUES 
(1, 2), -- Juan es Regular
(2, 2), -- María es Regular
(3, 1); -- Ricardo es Premium

-- 5. CREAR PRODUCTOS (Contratos)
-- Asociamos tipos y estados a las personas
INSERT INTO Productos (id_persona, id_tipo_producto, id_estado_producto) VALUES 
(1, 1, 1), -- Juan: Caja de Ahorro Activa (ID Producto 1)
(2, 2, 1), -- María: Cuenta Corriente Activa (ID Producto 2)
(3, 1, 1), -- Ricardo: Caja de Ahorro Activa (ID Producto 3)
(3, 3, 1); -- Ricardo: Tarjeta de Crédito Activa (ID Producto 4)

-- 6. DETALLES DE CUENTAS BANCARIAS
-- El id_producto debe coincidir con los creados arriba
INSERT INTO Cuentas_Bancarias (id_producto, cbu, alias, moneda, saldo) VALUES 
(1, '0000003100012345678901', 'JUAN.PESOS.APP', 'ARS', 15000.50),
(2, '0000003100098765432102', 'MARIA.CORRIENTE', 'ARS', 450000.00),
(3, '0000003100011122233303', 'BASTA.CHICOS', 'USD', 99999.99);

-- 7. DETALLES DE TARJETAS DE CRÉDITO
INSERT INTO Tarjetas_Credito (id_producto, numero_tarjeta, marca, fecha_vencimiento, limite_compra, dia_cierre) VALUES 
(4, '4507123456789012', 'Visa', '2030-12-01', 2500000.00, 20);