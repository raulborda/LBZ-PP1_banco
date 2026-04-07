const Persona = require('../models/personaModel');

exports.obtenerPersonas = async (req, res) => {
  try {
    const personas = await Persona.getAll();
    res.json(personas);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.obtenerRoles = async (req, res) => {
  try {
    const roles = await Persona.getRoles(req.params.id);
    if (roles.length === 0) return res.status(404).json({ error: 'Persona no encontrada o sin roles' });
    res.json(roles);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.obtenerProductos = async (req, res) => {
  try {
    const productos = await Persona.getProductos(req.params.id);
    if (productos.length === 0) return res.status(404).json({ error: 'Persona no encontrada o sin productos' });
    res.json(productos);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.crearPersona = async (req, res) => {
  try {
    const nuevaPersona = await Persona.create(req.body);
    res.status(201).json(nuevaPersona);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};