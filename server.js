import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { pool } from './src/config/db.js';

// 🔹 Importar rutas
import authRoutes from './src/routes/auth.routes.js';
import petsRoutes from './src/routes/pets.routes.js';
import citasRoutes from './src/routes/citas.routes.js';
import categoriasRoutes from './src/routes/categorias.routes.js';
import productosRoutes from './src/routes/productos.routes.js';
import userRoutes from './src/routes/userRoutes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// 🔹 Middlewares globales
app.use(cors({
  origin: "*", // Permite acceso desde Flutter, web y todos los dominios
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"]
}));

app.use(express.json());
app.use("/uploads", express.static("src/uploads")); // Servir imágenes estáticas

// 🔹 Rutas API
app.use('/api/auth', authRoutes);
app.use('/api/pets', petsRoutes);
app.use('/api/citas', citasRoutes);
app.use('/api/categorias', categoriasRoutes);
app.use('/api/productos', productosRoutes);
app.use('/api/users', userRoutes);

// 🔹 Probar conexión MySQL
pool.getConnection()
  .then(conn => {
    console.log('✅ Conexión a MySQL exitosa');
    conn.release();
  })
  .catch(err => {
    console.error('❌ Error al conectar a MySQL:', err);
  });

// 🔹 Render ignora tu IP local. Solo inicia el servidor.
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en el puerto ${PORT}`);
  console.log(`👉 Backend listo para usar en Flutter (Render):`);
  console.log(`   https://tu-backend.onrender.com`);
});
