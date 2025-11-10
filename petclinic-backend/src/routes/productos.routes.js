import { Router } from "express";
import { upload } from "../middleware/upload.js";
import {
  getProductos,
  createProducto,
  updateProducto,
  deleteProducto,
} from "../controllers/productos.controller.js";
import { verifyToken } from "../middleware/auth.js";


const router = Router();

router.get("/", verifyToken, getProductos);
router.post("/", verifyToken, upload.single("imagen"), createProducto);
router.put("/:id", verifyToken, upload.single("imagen"), updateProducto);
router.delete("/:id", verifyToken, deleteProducto);

export default router;
