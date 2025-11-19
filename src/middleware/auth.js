import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import { pool } from '../config/db.js';

dotenv.config();

export const verifyToken = async (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1]; //token obtenido del login
  if (!token) return res.status(403).json({ error: 'Token requerido' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Consultar el usuario autenticado en la base de datos
    const [rows] = await pool.query('SELECT id, nombre, email, rol FROM usuarios WHERE id = ?', [decoded.id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    req.user = rows[0]; // Guardamos el usuario en la request
    next();
  } catch (error) {
    console.error('Error al verificar token:', error);
    return res.status(401).json({ error: 'Token inválido o expirado' });
  }
};
