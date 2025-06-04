# 📄 Flujo de creación de un ticket

## 🧩 Funcionalidad representada
Este documento describe el flujo de eventos y el diagrama de secuencia para la funcionalidad **crear un nuevo ticket** desde el frontend, utilizando el modelo MVC implementado en el backend.

---

## 🔁 Flujo de eventos (nivel general)

1. El usuario accede al formulario de creación de tickets en `index.html`.
2. El frontend (archivo JS) realiza una petición `fetch POST` al endpoint `/api/tickets`, enviando los datos del nuevo ticket.
3. La petición es recibida por el archivo de rutas `src/routes/tickets.routes.js`.
4. El controlador `crearTicketController` (ubicado en `src/controllers/tickets.controller.js`) se encarga de procesar la solicitud.
5. El controlador llama al caso de uso `crearTicket()` ubicado en `src/usecases/crearTicket.js`.
6. El caso de uso llama al repositorio `ticketsRepository` (`src/repositories/ticketsRepository.js`) para guardar el ticket en la base de datos.
7. El repositorio utiliza el modelo `Ticket` (`src/models/Ticket.js`) para ejecutar la operación en la base de datos.
8. Se devuelve una respuesta JSON al frontend confirmando la creación del ticket.

---

## 🔄 Representación gráfica del flujo

```plaintext
Usuario
  ↓
Formulario HTML (index.html)
  ↓
JS (fetch POST /api/tickets)
  ↓
Ruta: routes/tickets.routes.js
  ↓
Controlador: controllers/tickets.controller.js
  ↓
Caso de uso: usecases/crearTicket.js
  ↓
Repositorio: repositories/ticketsRepository.js
  ↓
Modelo: models/Ticket.js
  ↓
Base de datos
  ↑
Respuesta JSON al frontend
