import { Router } from 'express';
import {
  obtenerTickets,
  crearTicket,
  actualizarTicket,
  eliminarTicket
} from '../controllers/tickets.controller.js';
import { authMiddleware } from '../middlewares/auth.middleware.js';

const router = Router();

router.get('/api/tickets', authMiddleware, obtenerTickets);
router.post('/api/tickets', authMiddleware, crearTicket);
router.put('/api/tickets/:id', authMiddleware, actualizarTicket);
router.delete('/api/tickets/:id', authMiddleware, eliminarTicket);

export default router;