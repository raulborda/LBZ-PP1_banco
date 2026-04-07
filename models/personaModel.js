const db = require('../config/db');

const Persona = {
  getAll: async () => {
    const query = `
      SELECT p.id, p.nombre, p.apellido, p.dni, 
             tp.nombre AS producto, ep.nombre AS estado,
             cb.saldo, tc.limite_compra
      FROM Personas p
      LEFT JOIN Productos pr ON p.id = pr.id_persona
      LEFT JOIN Tipos_Producto tp ON pr.id_tipo_producto = tp.id_tipo_producto
      LEFT JOIN Estados_Producto ep ON pr.id_estado_producto = ep.id_estado_producto
      LEFT JOIN Cuentas_Bancarias cb ON pr.id_producto = cb.id_producto
      LEFT JOIN Tarjetas_Credito tc ON pr.id_producto = tc.id_producto;
    `;
    const { rows } = await db.query(query);
    return rows;
  },

  getRoles: async (id) => {
    const query = `
      SELECT r.id_rol, r.nombre_rol, r.descripcion, r.activo
      FROM Roles r
      JOIN Roles_x_Personas rxp ON r.id_rol = rxp.id_rol
      WHERE rxp.id_persona = $1
    `;
    const { rows } = await db.query(query, [id]);
    return rows;
  },

  getProductos: async (id) => {
    const query = `
      SELECT pr.id_producto, tp.nombre AS tipo, ep.nombre AS estado, pr.fecha_alta,
             cb.cbu, cb.alias, cb.moneda, cb.saldo,
             tc.numero_tarjeta, tc.marca, tc.fecha_vencimiento, tc.limite_compra, tc.dia_cierre
      FROM Productos pr
      JOIN Tipos_Producto tp ON pr.id_tipo_producto = tp.id_tipo_producto
      JOIN Estados_Producto ep ON pr.id_estado_producto = ep.id_estado_producto
      LEFT JOIN Cuentas_Bancarias cb ON pr.id_producto = cb.id_producto
      LEFT JOIN Tarjetas_Credito tc ON pr.id_producto = tc.id_producto
      WHERE pr.id_persona = $1
    `;
    const { rows } = await db.query(query, [id]);
    return rows;
  },

  create: async (data) => {
    const { nombre, apellido, dni, email } = data;
    const query = 'INSERT INTO Personas (nombre, apellido, dni, email) VALUES ($1, $2, $3, $4) RETURNING *';
    const { rows } = await db.query(query, [nombre, apellido, dni, email]);
    return rows[0];
  }
};

module.exports = Persona;