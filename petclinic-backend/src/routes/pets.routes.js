import express from 'express';
import multer from 'multer';
import path from 'path';
import { getPets, createPet, updatePet, deletePet } from '../controllers/pets.controller.js';
import { verifyToken } from '../middleware/auth.js';

const router = express.Router();

// Configuración de almacenamiento
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'src/uploads/pets/');
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + path.extname(file.originalname);
    cb(null, uniqueName);
  },
});

const upload = multer({ storage });

// Rutas protegidas
router.get('/', verifyToken, getPets);
router.post('/', verifyToken, upload.single('imagen'), createPet); // 👈 con imagen
router.put('/:id', verifyToken, upload.single('imagen'), updatePet); // 👈 con imagen opcional
router.delete('/:id', verifyToken, deletePet);

export default router;
