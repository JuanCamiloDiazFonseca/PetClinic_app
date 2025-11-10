import { pool } from '../config/db.js';

export const getCategorias = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM categorias');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener categorías' });
  }
};

export const createCategoria = async (req, res) => {
  const { nombre, descripcion } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)',
      [nombre, descripcion]
    );
    res.json({ message: 'Categoría creada', id: result.insertId });
  } catch (error) {
    res.status(500).json({ error: 'Error al crear categoría' });
  }
};

export const updateCategoria = async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion } = req.body;
  try {
    await pool.query('UPDATE categorias SET nombre=?, descripcion=? WHERE id=?', [
      nombre,
      descripcion,
      id,
    ]);
    res.json({ message: 'Categoría actualizada' });
  } catch (error) {
    res.status(500).json({ error: 'Error al actualizar categoría' });
  }
};

export const deleteCategoria = async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM categorias WHERE id=?', [id]);
    res.json({ message: 'Categoría eliminada' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar categoría' });
  }
};
