# API Ejemplo Banco — Práctica Profesional 1

API REST construida con **Node.js + Express** y base de datos **PostgreSQL**, que modela un sistema bancario simple con personas, productos financieros, cuentas bancarias y tarjetas de crédito.

---

## Índice

1. [Esquema de la base de datos](#esquema-de-la-base-de-datos)
2. [Diagrama de entidad-relación (DER)](#diagrama-de-entidad-relación-der)
3. [Cómo levantar la base de datos](#cómo-levantar-la-base-de-datos)
4. [Datos de ejemplo](#datos-de-ejemplo)
5. [Endpoints](#endpoints)

---

## Esquema de la base de datos

El esquema está definido en `init/01_schema.sql`. Se compone de **8 tablas**:

### Tablas maestras (lookup)

**`Tipos_Producto`** — Tipos de producto financiero disponibles.

| Columna          | Tipo        | Descripción                                               |
| ---------------- | ----------- | ---------------------------------------------------------- |
| id_tipo_producto | SERIAL PK   | Identificador                                              |
| nombre           | VARCHAR(50) | `CAJA_AHORRO`, `CUENTA_CORRIENTE`, `TARJETA_CREDITO` |

**`Estados_Producto`** — Estados posibles de un producto.

| Columna            | Tipo        | Descripción                           |
| ------------------ | ----------- | -------------------------------------- |
| id_estado_producto | SERIAL PK   | Identificador                          |
| nombre             | VARCHAR(50) | `ACTIVO`, `BLOQUEADO`, `CERRADO` |

---

### Entidades principales

**`Personas`** — Clientes del banco.

| Columna   | Tipo         | Restricción    |
| --------- | ------------ | --------------- |
| id        | SERIAL PK    |                 |
| nombre    | VARCHAR(255) | NOT NULL        |
| apellido  | VARCHAR(255) | NOT NULL        |
| dni       | VARCHAR(20)  | UNIQUE NOT NULL |
| direccion | VARCHAR(255) |                 |
| email     | VARCHAR(255) |                 |
| telefono  | VARCHAR(50)  |                 |
| fecha_nac | DATE         |                 |

**`Roles`** — Roles que puede tener una persona.

| Columna        | Tipo         | Descripción                  |
| -------------- | ------------ | ----------------------------- |
| id_rol         | SERIAL PK    |                               |
| nombre_rol     | VARCHAR(100) | Ej:`Cliente Premium`        |
| descripcion    | VARCHAR(255) |                               |
| activo         | BOOLEAN      | Default `TRUE`              |
| fecha_creacion | TIMESTAMP    | Default `CURRENT_TIMESTAMP` |

**`Roles_x_Personas`** — Tabla intermedia N:M entre personas y roles.

| Columna    | Tipo    | FK a              |
| ---------- | ------- | ----------------- |
| id_persona | INTEGER | `Personas(id)`  |
| id_rol     | INTEGER | `Roles(id_rol)` |

**`Productos`** — Contrato entre una persona y un producto financiero.

| Columna            | Tipo      | FK a                                     |
| ------------------ | --------- | ---------------------------------------- |
| id_producto        | SERIAL PK |                                          |
| id_persona         | INTEGER   | `Personas(id)`                         |
| id_tipo_producto   | INTEGER   | `Tipos_Producto(id_tipo_producto)`     |
| id_estado_producto | INTEGER   | `Estados_Producto(id_estado_producto)` |
| fecha_alta         | TIMESTAMP | Default `CURRENT_TIMESTAMP`            |

---

### Productos específicos

**`Cuentas_Bancarias`** — Extiende un `Producto` de tipo cuenta.

| Columna     | Tipo           | Descripción       |
| ----------- | -------------- | ------------------ |
| id_cuenta   | SERIAL PK      |                    |
| id_producto | INTEGER UNIQUE | FK →`Productos` |
| cbu         | VARCHAR(22)    | UNIQUE NOT NULL    |
| alias       | VARCHAR(50)    | UNIQUE             |
| moneda      | VARCHAR(10)    | Default `ARS`    |
| saldo       | DECIMAL(15,2)  | Default `0.00`   |

**`Tarjetas_Credito`** — Extiende un `Producto` de tipo tarjeta.

| Columna           | Tipo           | Descripción       |
| ----------------- | -------------- | ------------------ |
| id_tarjeta        | SERIAL PK      |                    |
| id_producto       | INTEGER UNIQUE | FK →`Productos` |
| numero_tarjeta    | VARCHAR(16)    | UNIQUE NOT NULL    |
| marca             | VARCHAR(50)    | Ej:`Visa`        |
| fecha_vencimiento | DATE           | NOT NULL           |
| limite_compra     | DECIMAL(15,2)  | NOT NULL           |
| dia_cierre        | INTEGER        | Entre 1 y 31       |

---

## Diagrama de entidad-relación (DER)

Para visualizar el DER podés importar el script `init/01_schema.sql` en **[drawdb.app](https://drawdb.app)**:

1. Abrí [drawdb.app](https://drawdb.app)
2. Hacé clic en **Import SQL**
3. Seleccioná el DBMS: **PostgreSQL**
4. Pegá el contenido de `init/01_schema.sql`
5. El diagrama se genera automáticamente

### Relaciones clave

```
Personas ──< Roles_x_Personas >── Roles
Personas ──< Productos
Productos >── Tipos_Producto
Productos >── Estados_Producto
Productos ──o Cuentas_Bancarias   (1:1)
Productos ──o Tarjetas_Credito    (1:1)
```

---

## Cómo levantar la base de datos

### Requisitos

- Node.js >= 18
- PostgreSQL >= 14

### Configuración

Creá un archivo `.env` en la raíz del proyecto:

```env
DATABASE_URL=postgres://postgres:admin123@localhost:5432/banco_db
```

### Instalación

```bash
npm install
```

### Crear la base de datos y ejecutar los scripts

Conectate a PostgreSQL y ejecutá los scripts en orden:

```bash
# Crear la base de datos
psql -U postgres -c "CREATE DATABASE banco_db;"

# Ejecutar el schema (tablas + datos maestros)
psql -U postgres -d banco_db -f init/01_schema.sql

# Cargar los datos de ejemplo
psql -U postgres -d banco_db -f init/02_data.sql
```

### Levantar el servidor

```bash
node app.js
# Servidor en http://localhost:3001
```

---

## Datos de ejemplo

Los datos de ejemplo están definidos en `init/02_data.sql`.

### Roles cargados

| id_rol | nombre_rol      | descripción                             |
| ------ | --------------- | ---------------------------------------- |
| 1      | Cliente Premium | Usuarios con beneficios y límites altos |
| 2      | Cliente Regular | Usuarios estándar del banco             |
| 3      | Empleado        | Personal administrativo del banco        |

### Personas cargadas

| id | nombre  | apellido | DNI      | Email                  | Rol             |
| -- | ------- | -------- | -------- | ---------------------- | --------------- |
| 1  | Juan    | Pérez   | 35123456 | juan.perez@email.com   | Cliente Regular |
| 2  | María  | García  | 28999888 | m.garcia@email.com     | Cliente Regular |
| 3  | Ricardo | Fort     | 20111222 | elcomandante@email.com | Cliente Premium |

### Productos asignados

| id_producto | Persona | Tipo             | Estado | Detalle                     |
| ----------- | ------- | ---------------- | ------ | --------------------------- |
| 1           | Juan    | CAJA_AHORRO      | ACTIVO | Saldo ARS $15.000,50        |
| 2           | María  | CUENTA_CORRIENTE | ACTIVO | Saldo ARS $450.000,00       |
| 3           | Ricardo | CAJA_AHORRO      | ACTIVO | Saldo USD $99.999,99        |
| 4           | Ricardo | TARJETA_CREDITO  | ACTIVO | Visa, límite $2.500.000,00 |

### Resultado de la consulta principal (`init/03_select.sql`)

| nombre  | apellido | producto         | estado | saldo_cuenta | limite_tarjeta |
| ------- | -------- | ---------------- | ------ | ------------ | -------------- |
| Juan    | Pérez   | CAJA_AHORRO      | ACTIVO | 15000.50     | null           |
| María  | García  | CUENTA_CORRIENTE | ACTIVO | 450000.00    | null           |
| Ricardo | Fort     | CAJA_AHORRO      | ACTIVO | 99999.99     | null           |
| Ricardo | Fort     | TARJETA_CREDITO  | ACTIVO | 0.00         | 2500000.00     |

---

## Endpoints

**Base URL:** `http://localhost:3001/api`

---

### GET /api/personas

Retorna todas las personas con sus productos, saldos y límites de tarjeta.

**Request**

```http
GET /api/personas
```

**Ejemplo con curl**

```bash
curl http://localhost:3001/api/personas
```

**Ejemplo con JavaScript (fetch)**

```js
const res = await fetch('http://localhost:3001/api/personas');
const personas = await res.json();
console.log(personas);
```

**Response exitoso — `200 OK`**

```json
[
  {
    "id": 1,
    "nombre": "Juan",
    "apellido": "Pérez",
    "dni": "35123456",
    "producto": "CAJA_AHORRO",
    "estado": "ACTIVO",
    "saldo": "15000.50",
    "limite_compra": null
  },
  {
    "id": 2,
    "nombre": "María",
    "apellido": "García",
    "dni": "28999888",
    "producto": "CUENTA_CORRIENTE",
    "estado": "ACTIVO",
    "saldo": "450000.00",
    "limite_compra": null
  },
  {
    "id": 3,
    "nombre": "Ricardo",
    "apellido": "Fort",
    "dni": "20111222",
    "producto": "CAJA_AHORRO",
    "estado": "ACTIVO",
    "saldo": "99999.99",
    "limite_compra": null
  },
  {
    "id": 3,
    "nombre": "Ricardo",
    "apellido": "Fort",
    "dni": "20111222",
    "producto": "TARJETA_CREDITO",
    "estado": "ACTIVO",
    "saldo": null,
    "limite_compra": "2500000.00"
  }
]
```

**Response de error — `500 Internal Server Error`**

```json
{
  "error": "mensaje de error de la base de datos"
}
```

---

### POST /api/personas

Crea una nueva persona en la base de datos.

**Request**

```http
POST /api/personas
Content-Type: application/json
```

**Body**

| Campo    | Tipo   | Requerido | Descripción         |
| -------- | ------ | --------- | -------------------- |
| nombre   | string | Si        | Nombre de la persona |
| apellido | string | Si        | Apellido             |
| dni      | string | Si        | DNI único           |
| email    | string | No        | Email de contacto    |

**Ejemplo con curl**

```bash
curl -X POST http://localhost:3001/api/personas \
  -H "Content-Type: application/json" \
  -d '{"nombre": "Laura", "apellido": "Martínez", "dni": "41000000", "email": "laura.m@email.com"}'
```

**Ejemplo con JavaScript (fetch)**

```js
const res = await fetch('http://localhost:3001/api/personas', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    nombre: 'Laura',
    apellido: 'Martínez',
    dni: '41000000',
    email: 'laura.m@email.com'
  })
});
const nuevaPersona = await res.json();
console.log(nuevaPersona);
```

**Response exitoso — `201 Created`**

```json
{
  "id": 4,
  "nombre": "Laura",
  "apellido": "Martínez",
  "dni": "41000000",
  "direccion": null,
  "email": "laura.m@email.com",
  "telefono": null,
  "fecha_nac": null
}
```

**Response de error — `500 Internal Server Error`** (ej: DNI duplicado)

```json
{
  "error": "duplicate key value violates unique constraint \"personas_dni_key\""
}
```

---

### GET /api/tablas/:tabla

Retorna todos los registros de una tabla sin joins. Útil para inspeccionar datos crudos.

**Tablas disponibles**

| `:tabla`            | Tabla DB           |
|---------------------|--------------------|
| `personas`          | Personas           |
| `roles`             | Roles              |
| `roles_x_personas`  | Roles_x_Personas   |
| `tipos_producto`    | Tipos_Producto     |
| `estados_producto`  | Estados_Producto   |
| `productos`         | Productos          |
| `cuentas_bancarias` | Cuentas_Bancarias  |
| `tarjetas_credito`  | Tarjetas_Credito   |

**Ejemplo con curl**

```bash
curl http://localhost:3001/api/tablas/productos
```

**Response exitoso — `200 OK`**

```json
[
  { "id_producto": 1, "id_persona": 1, "id_tipo_producto": 1, "id_estado_producto": 1, "fecha_alta": "2024-01-01T00:00:00.000Z" },
  { "id_producto": 2, "id_persona": 2, "id_tipo_producto": 2, "id_estado_producto": 1, "fecha_alta": "2024-01-01T00:00:00.000Z" },
  { "id_producto": 3, "id_persona": 3, "id_tipo_producto": 1, "id_estado_producto": 1, "fecha_alta": "2024-01-01T00:00:00.000Z" },
  { "id_producto": 4, "id_persona": 3, "id_tipo_producto": 3, "id_estado_producto": 1, "fecha_alta": "2024-01-01T00:00:00.000Z" }
]
```

**Response de error — `404 Not Found`** (tabla no válida)

```json
{
  "error": "Tabla 'foo' no encontrada"
}
```

---

## Estructura del proyecto

```
.
├── app.js                  # Entry point, definición de rutas
├── config/
│   └── db.js               # Conexión a PostgreSQL (Pool)
├── controllers/
│   └── personaController.js
├── models/
│   └── personaModel.js     # Queries SQL
├── routes/
│   └── personaRoutes.js
├── init/
│   ├── 01_schema.sql       # DDL: creación de tablas
│   ├── 02_data.sql         # DML: datos de ejemplo
│   └── 03_select.sql       # Query de consulta principal
└── .env                    # Variables de entorno (no commitear)
```

---

## Ejemplos con Bruno y Postman

### Bruno

[Bruno](https://www.usebruno.com/) es un cliente REST open source que guarda las colecciones como archivos en tu proyecto.

#### GET /api/personas

Creá un archivo `requests/get_personas.bru` dentro de tu colección:

```
meta {
  name: Obtener Personas
  type: http
  seq: 1
}

get {
  url: http://localhost:3001/api/personas
  body: none
  auth: none
}
```

#### POST /api/personas

Creá un archivo `requests/crear_persona.bru`:

```
meta {
  name: Crear Persona
  type: http
  seq: 2
}

post {
  url: http://localhost:3001/api/personas
  body: json
  auth: none
}

body:json {
  {
    "nombre": "Laura",
    "apellido": "Martínez",
    "dni": "41000000",
    "email": "laura.m@email.com"
  }
}
```

---

### Postman

#### Importar como colección

Podés importar el siguiente JSON en Postman desde **File → Import → Raw text**:

```json
{
  "info": {
    "name": "API Banco",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Obtener Personas",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://localhost:3001/api/personas",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3001",
          "path": ["api", "personas"]
        }
      }
    },
    {
      "name": "Crear Persona",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"nombre\": \"Laura\",\n  \"apellido\": \"Martínez\",\n  \"dni\": \"41000000\",\n  \"email\": \"laura.m@email.com\"\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://localhost:3001/api/personas",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3001",
          "path": ["api", "personas"]
        }
      }
    }
  ]
}
```

#### Usando variables de entorno en Postman

Para no hardcodear la URL base, podés crear un **Environment** en Postman con la variable `base_url`:

| Variable   | Value                     |
|------------|---------------------------|
| `base_url` | `http://localhost:3001`   |

Y usar las URLs así:

```
GET  {{base_url}}/api/personas
POST {{base_url}}/api/personas
GET  {{base_url}}/api/tablas/productos
GET  {{base_url}}/api/tablas/cuentas_bancarias
GET  {{base_url}}/api/tablas/tarjetas_credito
```
# LBZ-PP1_banco
