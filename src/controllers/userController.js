// Obtener perfil del usuario autenticado
export const getUserProfile = async (req, res) => {
  try {
    // req.user ya viene del middleware verifyToken
    res.json({
      id: req.user.id,
      nombre: req.user.nombre,
      email: req.user.email,
      rol: req.user.rol,
    });
  } catch (error) {
    console.error('Error al obtener perfil:', error);
    res.status(500).json({ error: 'Error al obtener perfil de usuario' });
  }
};
