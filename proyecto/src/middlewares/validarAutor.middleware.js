// filepath: rest-api-project/src/middlewares/validarAutor.middleware.js
/**
 * Middleware para validar los datos de un autor antes de crearlo o actualizarlo.
 * 
 * Este código verifica que la información del autor sea válida antes de
 * guardarla en la base de datos.
 */
export function validarAutor(req, res, next) {
  // Extraemos el nombre y la edad de los datos enviados por el usuario
  const { name, age } = req.body;

  // Verificamos que se haya proporcionado tanto el nombre como la edad
  // Si falta alguno, devolvemos un error
  if (!name || !age)
    return res.status(400).json({ error: 'Nombre y edad son requeridos' });

  // Comprobamos que el nombre tenga una longitud adecuada
  // Si es demasiado corto o demasiado largo, devolvemos un error
  if (name.length < 20 || name.length > 100)
    return res.status(400).json({ error: 'Nombre debe tener entre 20 y 100 caracteres' });

  // Verificamos que la edad esté dentro de un rango razonable
  // Si la edad es menor de 10 o mayor de 100, devolvemos un error
  if (age < 10 || age > 100)
    return res.status(400).json({ error: 'Edad debe estar entre 10 y 100 años' });

  // Si todos los datos son válidos, permitimos que la solicitud continúe
  // hacia el siguiente paso en el proceso
  next();
}