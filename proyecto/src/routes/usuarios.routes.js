import { Router } from 'express';
import {
  obtenerUsuarios,
  crearUsuario,
  actualizarUsuario,
  eliminarUsuario
} from '../controllers/usuarios.controller.js';
import { authMiddleware } from '../middlewares/auth.middleware.js';

const router = Router();

// GET /api/usuarios - Obtener todos los usuarios
router.get('/', authMiddleware, obtenerUsuarios);

// POST /api/usuarios - Crear un nuevo usuario
router.post('/', authMiddleware, crearUsuario);

// PUT /api/usuarios/:id - Actualizar un usuario por ID
router.put('/:id', authMiddleware, actualizarUsuario);

// DELETE /api/usuarios/:id - Eliminar un usuario por ID
router.delete('/:id', authMiddleware, eliminarUsuario);

export default router;