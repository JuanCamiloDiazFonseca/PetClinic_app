import { pool } from '../config/db.js';

// Obtener todas las mascotas del usuario autenticado
export const getPets = async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM mascotas WHERE id_usuario = ?',
      [req.user.id]
    );
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener las mascotas' });
  }
};

// Crear mascota 
export const createPet = async (req, res) => {
  const { nombre, especie, raza, edad } = req.body;
  const imagen = req.file ? `/uploads/pets/${req.file.filename}` : null;

  try {
    const [result] = await pool.query(
      'INSERT INTO mascotas (nombre, especie, raza, edad, imagen, id_usuario) VALUES (?, ?, ?, ?, ?, ?)',
      [nombre, especie, raza, edad, imagen, req.user.id]
    );

    res.json({ message: 'Mascota registrada', id: result.insertId, imagen });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al registrar mascota' });
  }
};

// Actualizar mascota
export const updatePet = async (req, res) => {
  const { id } = req.params;
  const { nombre, especie, raza, edad } = req.body;
  const imagen = req.file ? `/uploads/pets/${req.file.filename}` : null;

  try {
    let query = 'UPDATE mascotas SET nombre=?, especie=?, raza=?, edad=?';
    const params = [nombre, especie, raza, edad];

    if (imagen) {
      query += ', imagen=?';
      params.push(imagen);
    }

    query += ' WHERE id=? AND id_usuario=?';
    params.push(id, req.user.id);

    await pool.query(query, params);
    res.json({ message: 'Mascota actualizada', imagen });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al actualizar mascota' });
  }
};

// Eliminar mascota
export const deletePet = async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM mascotas WHERE id=? AND id_usuario=?', [
      id,
      req.user.id,
    ]);
    res.json({ message: 'Mascota eliminada' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al eliminar mascota' });
  }
};
