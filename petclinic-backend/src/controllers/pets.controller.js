import { pool } from '../config/db.js';

// 🐾 Obtener todas las mascotas del usuario autenticado
export const getPets = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM mascotas WHERE id_usuario = ?', [req.user.id]);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener las mascotas' });
  }
};

// 🐾 Crear una nueva mascota
export const createPet = async (req, res) => {
  const { nombre, especie, raza, edad } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO mascotas (nombre, especie, raza, edad, id_usuario) VALUES (?, ?, ?, ?, ?)',
      [nombre, especie, raza, edad, req.user.id]
    );
    res.json({ message: 'Mascota registrada', id: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al registrar mascota' });
  }
};

// 🐾 Actualizar una mascota
export const updatePet = async (req, res) => {
  const { id } = req.params;
  const { nombre, especie, raza, edad } = req.body;
  try {
    await pool.query(
      'UPDATE mascotas SET nombre=?, especie=?, raza=?, edad=? WHERE id=? AND id_usuario=?',
      [nombre, especie, raza, edad, id, req.user.id]
    );
    res.json({ message: 'Mascota actualizada' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al actualizar mascota' });
  }
};

// 🐾 Eliminar una mascota
export const deletePet = async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM mascotas WHERE id=? AND id_usuario=?', [id, req.user.id]);
    res.json({ message: 'Mascota eliminada' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al eliminar mascota' });
  }
};
