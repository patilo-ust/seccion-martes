export function obtenerUsuarios(req, res) {
  // Lógica para obtener todos los usuarios de la base de datos
  res.status(200).json({ mensaje: 'Lista de usuarios' });
}

export function crearUsuario(req, res) {
  // Lógica para crear un nuevo usuario en la base de datos
  const { nombre, edad } = req.body;
  // Se asume que el usuario se crea exitosamente
  res.status(201).json({ mensaje: 'Usuario creado', usuario: { nombre, edad } });
}

export function actualizarUsuario(req, res) {
  const { id } = req.params;
  // Lógica para actualizar la información del usuario en la base de datos
  res.status(200).json({ mensaje: `Usuario con id ${id} actualizado` });
}

export function eliminarUsuario(req, res) {
  const { id } = req.params;
  // Lógica para eliminar el usuario de la base de datos
  res.status(200).json({ mensaje: `Usuario con id ${id} eliminado` });
}