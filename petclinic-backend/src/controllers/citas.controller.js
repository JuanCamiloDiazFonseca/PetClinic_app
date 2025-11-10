import { pool } from '../config/db.js';

// Obtener todas las citas del usuario autenticado
export const getCitas = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT c.*, m.nombre AS mascota 
       FROM citas c
       JOIN mascotas m ON c.id_mascota = m.id
       WHERE c.id_usuario = ?`,
      [req.user.id]
    );
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener citas' });
  }
};

// Crear nueva cita
export const createCita = async (req, res) => {
  const { fecha, motivo, id_mascota } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO citas (fecha, motivo, id_mascota, id_usuario) VALUES (?, ?, ?, ?)',
      [fecha, motivo, id_mascota, req.user.id]
    );
    res.json({ message: 'Cita creada correctamente', id: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al crear cita' });
  }
};

// Actualizar cita
export const updateCita = async (req, res) => {
  const { id } = req.params;
  const { fecha, motivo, estado } = req.body;
  try {
    await pool.query(
      'UPDATE citas SET fecha=?, motivo=?, estado=? WHERE id=? AND id_usuario=?',
      [fecha, motivo, estado, id, req.user.id]
    );
    res.json({ message: 'Cita actualizada correctamente' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al actualizar cita' });
  }
};

// Eliminar cita
export const deleteCita = async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM citas WHERE id=? AND id_usuario=?', [id, req.user.id]);
    res.json({ message: 'Cita eliminada correctamente' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al eliminar cita' });
  }
};
