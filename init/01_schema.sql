-- 1. TABLAS MAESTRAS (Reemplazan a los ENUM)
CREATE TABLE IF NOT EXISTS Tipos_Producto (
    id_tipo_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL -- 'CAJA_AHORRO', 'TARJETA_CREDITO', etc.
);

CREATE TABLE IF NOT EXISTS Estados_Producto (
    id_estado_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL -- 'ACTIVO', 'BLOQUEADO', etc.
);

-- 2. TABLA DE PERSONAS
CREATE TABLE IF NOT EXISTS Personas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(50),
    fecha_nac DATE
);

-- 3. TABLA DE ROLES
CREATE TABLE IF NOT EXISTS Roles (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABLA INTERMEDIA ROLES_X_PERSONAS
CREATE TABLE IF NOT EXISTS Roles_x_Personas (
    id_persona INTEGER NOT NULL,
    id_rol INTEGER NOT NULL,
    PRIMARY KEY (id_persona, id_rol),
    FOREIGN KEY (id_persona) REFERENCES Personas(id) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE CASCADE
);

-- 5. TABLA MAESTRA DE PRODUCTOS (Ahora usa Foreign Keys en vez de ENUM)
CREATE TABLE IF NOT EXISTS Productos (
    id_producto SERIAL PRIMARY KEY,
    id_persona INTEGER NOT NULL,
    id_tipo_producto INTEGER NOT NULL,
    id_estado_producto INTEGER NOT NULL,
    fecha_alta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_persona) REFERENCES Personas(id),
    FOREIGN KEY (id_tipo_producto) REFERENCES Tipos_Producto(id_tipo_producto),
    FOREIGN KEY (id_estado_producto) REFERENCES Estados_Producto(id_estado_producto)
);

-- 6. TABLA DE CUENTAS BANCARIAS
CREATE TABLE IF NOT EXISTS Cuentas_Bancarias (
    id_cuenta SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL UNIQUE,
    cbu VARCHAR(22) UNIQUE NOT NULL,
    alias VARCHAR(50) UNIQUE,
    moneda VARCHAR(10) DEFAULT 'ARS',
    saldo DECIMAL(15, 2) DEFAULT 0.00,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- 7. TABLA DE TARJETAS DE CRÉDITO
CREATE TABLE IF NOT EXISTS Tarjetas_Credito (
    id_tarjeta SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL UNIQUE,
    numero_tarjeta VARCHAR(16) UNIQUE NOT NULL,
    marca VARCHAR(50),
    fecha_vencimiento DATE NOT NULL,
    limite_compra DECIMAL(15, 2) NOT NULL,
    dia_cierre INTEGER CHECK (dia_cierre BETWEEN 1 AND 31),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- 8. POBLAR TABLAS MAESTRAS (Datos iniciales)
INSERT INTO Tipos_Producto (nombre) VALUES ('CAJA_AHORRO'), ('CUENTA_CORRIENTE'), ('TARJETA_CREDITO');
INSERT INTO Estados_Producto (nombre) VALUES ('ACTIVO'), ('BLOQUEADO'), ('CERRADO');