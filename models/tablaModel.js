const db = require('../config/db');

const tablas = [
  'Personas',
  'Roles',
  'Roles_x_Personas',
  'Tipos_Producto',
  'Estados_Producto',
  'Productos',
  'Cuentas_Bancarias',
  'Tarjetas_Credito',
];

const TablaModel = {};

tablas.forEach((tabla) => {
  TablaModel[tabla] = {
    getAll: async () => {
      const { rows } = await db.query(`SELECT * FROM ${tabla}`);
      return rows;
    },
  };
});

module.exports = TablaModel;
