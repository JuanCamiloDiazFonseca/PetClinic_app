import express from 'express';
import { verifyToken } from '../middleware/auth.js';
import { getUserProfile } from '../controllers/userController.js';

const router = express.Router();

// Ruta para obtener el perfil del usuario logueado
router.get('/me', verifyToken, getUserProfile);

export default router;
