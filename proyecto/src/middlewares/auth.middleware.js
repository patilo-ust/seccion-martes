export function authMiddleware(req, res, next) {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(401).json({ error: 'Acceso denegado. Se requiere autenticación.' });
  }

  // Aquí se puede agregar la lógica para verificar el token, por ejemplo, usando JWT
  // const decoded = jwt.verify(token, process.env.JWT_SECRET);
  // req.user = decoded;

  next();
}