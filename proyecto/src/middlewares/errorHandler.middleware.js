export function errorHandler(err, req, res, next) {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Error Interno del Servidor';

  res.status(statusCode).json({
    estado: 'error',
    codigoEstado: statusCode,
    mensaje: message,
  });
}