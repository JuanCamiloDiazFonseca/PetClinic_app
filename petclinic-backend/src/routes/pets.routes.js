import express from 'express';
import { getPets, createPet, updatePet, deletePet } from '../controllers/pets.controller.js';
import { verifyToken } from '../middleware/auth.middleware.js';

const router = express.Router();

// Rutas protegidas con token
router.get('/', verifyToken, getPets);
router.post('/', verifyToken, createPet);
router.put('/:id', verifyToken, updatePet);
router.delete('/:id', verifyToken, deletePet);

export default router;
