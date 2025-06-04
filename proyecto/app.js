import express from 'express';
import ticketsRoutes from './routes/tickets.routes.js';
import usuariosRoutes from './routes/usuarios.routes.js';
import errorHandler from './middlewares/errorHandler.middleware.js';
import authMiddleware from './middlewares/auth.middleware.js';

const app = express();

app.use(express.json());

app.use('/api/tickets', ticketsRoutes);
app.use('/api/usuarios', authMiddleware, usuariosRoutes);

app.use(errorHandler);

export default app;