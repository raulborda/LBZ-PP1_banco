const express = require('express');
const app = express();
const personaController = require('./controllers/personaController');
const tablaController = require('./controllers/tablaController');

app.use(express.json());

// Endpoints con joins
app.get('/api/personas', personaController.obtenerPersonas);
app.get('/api/personas/:id/roles', personaController.obtenerRoles);
app.get('/api/personas/:id/productos', personaController.obtenerProductos);
app.post('/api/personas', personaController.crearPersona);

// Endpoints sin joins (tablas crudas)
app.get('/api/tablas/:tabla', tablaController.obtenerTabla);

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT}`));