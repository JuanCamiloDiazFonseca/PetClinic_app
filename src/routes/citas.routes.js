import express from 'express';
import { getCitas, createCita, updateCita, deleteCita } from '../controllers/citas.controller.js';
import { verifyToken } from '../middleware/auth.js';

const router = express.Router();

router.get('/', verifyToken, getCitas);
router.post('/', verifyToken, createCita);
router.put('/:id', verifyToken, updateCita);
router.delete('/:id', verifyToken, deleteCita);

export default router;
