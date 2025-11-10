import { pool } from "../config/db.js";
import path from "path";
import fs from "fs";

// Obtener todos los productos (con su categoría)
export const getProductos = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT p.*, c.nombre AS categoria
      FROM productos p
      LEFT JOIN categorias c ON p.id_categoria = c.id
    `);
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener productos" });
  }
};

// Crear producto (con imagen opcional)
export const createProducto = async (req, res) => {
  const { nombre, descripcion, precio, stock, tipo_animal, id_categoria } = req.body;
  const imagen = req.file ? req.file.filename : null;

  try {
    const [result] = await pool.query(
      `INSERT INTO productos (nombre, descripcion, precio, stock, tipo_animal, id_categoria, imagen)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nombre, descripcion, precio, stock, tipo_animal, id_categoria, imagen]
    );
    res.json({ message: "Producto creado correctamente", id: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al crear producto" });
  }
};

// Actualizar producto (con imagen opcional)
export const updateProducto = async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion, precio, stock, tipo_animal, id_categoria } = req.body;
  const imagen = req.file ? req.file.filename : null;

  try {
    // Si hay una nueva imagen, eliminar la anterior del servidor
    if (imagen) {
      const [old] = await pool.query("SELECT imagen FROM productos WHERE id=?", [id]);
      if (old.length > 0 && old[0].imagen) {
        const oldPath = path.join("src", "uploads", old[0].imagen);
        if (fs.existsSync(oldPath)) fs.unlinkSync(oldPath);
      }

      await pool.query(
        `UPDATE productos 
         SET nombre=?, descripcion=?, precio=?, stock=?, tipo_animal=?, id_categoria=?, imagen=? 
         WHERE id=?`,
        [nombre, descripcion, precio, stock, tipo_animal, id_categoria, imagen, id]
      );
    } else {
      await pool.query(
        `UPDATE productos 
         SET nombre=?, descripcion=?, precio=?, stock=?, tipo_animal=?, id_categoria=? 
         WHERE id=?`,
        [nombre, descripcion, precio, stock, tipo_animal, id_categoria, id]
      );
    }

    res.json({ message: "Producto actualizado correctamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar producto" });
  }
};

// Eliminar producto (y su imagen si existe)
export const deleteProducto = async (req, res) => {
  const { id } = req.params;
  try {
    // Eliminar imagen del servidor
    const [rows] = await pool.query("SELECT imagen FROM productos WHERE id=?", [id]);
    if (rows.length > 0 && rows[0].imagen) {
      const imagePath = path.join("src", "uploads", rows[0].imagen);
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }

    await pool.query("DELETE FROM productos WHERE id=?", [id]);
    res.json({ message: "Producto eliminado correctamente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al eliminar producto" });
  }
};
