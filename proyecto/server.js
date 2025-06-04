import express from 'express';
import { json } from 'body-parser';
import { errorHandler } from './middlewares/errorHandler.middleware.js';
import ticketsRoutes from './routes/tickets.routes.js';
import usuariosRoutes from './routes/usuarios.routes.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(json());

app.use('/api/tickets', ticketsRoutes);
app.use('/api/usuarios', usuariosRoutes);

app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`El servidor está corriendo en el puerto ${PORT}`);
});