import express from "express";
import { verifyToken } from "../middleware/auth.js";
import {
  getCategorias,
  createCategoria,
  updateCategoria,
  deleteCategoria,
} from "../controllers/categorias.controller.js";

const router = express.Router();

// Rutas CRUD de categorías
router.get("/", verifyToken, getCategorias);
router.post("/", verifyToken, createCategoria);
router.put("/:id", verifyToken, updateCategoria);
router.delete("/:id", verifyToken, deleteCategoria);

export default router;
