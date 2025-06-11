-- Bueno, primero vamos a crear la base de datos si no existe y seleccionarla para trabajar ahí
CREATE DATABASE IF NOT EXISTS sistema_tickets;
USE sistema_tickets;


-- Ahora, a crear las tablas. Vamos a hacerlas con auto_increment para que no tengas que andar poniendo los IDs a mano.
-- Además, ponemos restricciones para que no se repitan nombres donde no deben repetirse.

-- Tabla para guardar los estados posibles de los tickets
CREATE TABLE estado_ticket (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla para las prioridades (alta, media, baja, etc.)
CREATE TABLE prioridad (
    id_prioridad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Categorías para organizar los tickets (software, hardware, redes...)
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Roles para los usuarios, para saber si es admin, técnico o cliente
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Aquí guardamos los usuarios con su correo, contraseña, rol y fechas de creación/actualización
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_rol INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- Esta es la tabla principal para los tickets
CREATE TABLE ticket (
    id_ticket INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre DATETIME NULL,
    id_estado INT NOT NULL,
    id_prioridad INT NOT NULL,
    id_categoria INT NOT NULL,
    id_usuario INT NOT NULL,
    id_tecnico INT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estado) REFERENCES estado_ticket(id_estado),
    FOREIGN KEY (id_prioridad) REFERENCES prioridad(id_prioridad),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_tecnico) REFERENCES usuario(id_usuario)
);

-- Para llevar un registro de cómo han ido cambiando los estados de los tickets
CREATE TABLE historial_estado (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_estado_anterior INT NOT NULL,
    id_estado_nuevo INT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket),
    FOREIGN KEY (id_estado_anterior) REFERENCES estado_ticket(id_estado),
    FOREIGN KEY (id_estado_nuevo) REFERENCES estado_ticket(id_estado)
);

-- Notificaciones para avisarle a los usuarios sobre cambios o noticias
CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    mensaje TEXT NOT NULL,
    leido TINYINT(1) DEFAULT 0,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Los comentarios que van dejando técnicos y clientes sobre cada ticket
CREATE TABLE comentario (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_usuario INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Archivos adjuntos que se suben para ayudar a describir el problema o solución
CREATE TABLE adjunto (
    id_adjunto INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket INT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket)
);

-- Logs para saber quién hizo qué y cuándo, muy útil para auditorías
CREATE TABLE log_sistema (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion VARCHAR(255) NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- Y finalmente las tareas que se asignan a técnicos relacionadas con tickets
CREATE TABLE tarea (
    id_tarea INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_tecnico INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(50) NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket),
    FOREIGN KEY (id_tecnico) REFERENCES usuario(id_usuario)
);


-- Bueno, ahora que ya están las tablas, vamos a poner algunos datos para que tengas con qué probar.

-- Estados típicos para un ticket
INSERT INTO estado_ticket (nombre) VALUES
('Nuevo'),
('Asignado'),
('Resuelto'),
('Cerrado');

-- Prioridades de ejemplo
INSERT INTO prioridad (nombre) VALUES
('Crítica'),
('Alta'),
('Normal'),
('Baja');

-- Categorías comunes para tickets
INSERT INTO categoria (nombre) VALUES
('Aplicaciones'),
('Infraestructura'),
('Soporte Técnico');

-- Roles que usan los usuarios
INSERT INTO rol (nombre) VALUES
('Administrador'),
('Técnico Soporte'),
('Cliente Final');

-- Usuarios: un admin, un técnico y un cliente para empezar
INSERT INTO usuario (correo, contrasena, nombre, id_rol) VALUES
('admin@sistema.com', 'passAdmin123', 'Administrador Principal', 1),
('soporte1@sistema.com', 'passSoporte123', 'Soporte Técnico 1', 2),
('cliente1@sistema.com', 'passCliente123', 'Cliente Ejemplo', 3);

-- Creando un ticket de prueba para la impresora que no funciona
INSERT INTO ticket (titulo, descripcion, fecha_creacion, id_estado, id_prioridad, id_categoria, id_usuario, id_tecnico) VALUES
('Problema con la impresora', 'La impresora no responde al imprimir. Ya intenté apagarla y encenderla.', NOW(), 1, 2, 2, 3, 2);

-- Vamos a registrar que el estado cambió de Nuevo a Asignado
INSERT INTO historial_estado (id_ticket, id_estado_anterior, id_estado_nuevo, fecha_cambio) VALUES
(1, 1, 2, NOW());

-- Notificación para el cliente, porque su ticket ya tiene técnico asignado
INSERT INTO notificacion (id_usuario, mensaje, leido, fecha) VALUES
(3, 'Tu ticket ya fue asignado a un técnico, pronto tendrás novedades.', 0, NOW());

-- Comentarios con un toque más humano y cercano
INSERT INTO comentario (id_ticket, id_usuario, contenido, fecha) VALUES
(1, 2, 'Hola, ya estamos viendo qué puede estar pasando con la impresora, te aviso pronto.', NOW()),
(1, 3, 'Gracias, quedo atento a cualquier novedad. ¡Saludos!', NOW()),
(1, 2, 'Probamos reiniciar el servidor de impresión, pero sigue sin funcionar. Seguimos investigando.', NOW()),
(1, 3, 'Perfecto, gracias por la rápida respuesta. Espero solución pronto.', NOW());

-- Archivos que acompañan el ticket, para que el técnico vea qué está pasando
INSERT INTO adjunto (id_ticket, nombre_archivo, ruta_archivo, fecha_subida) VALUES
(1, 'foto_impresora.jpg', '/uploads/foto_impresora.jpg', NOW());

-- Un log para dejar registro de quién hizo qué
INSERT INTO log_sistema (id_usuario, accion, fecha) VALUES
(1, 'Creó un ticket para la impresora que no funciona.', NOW());

-- Y una tarea asignada para diagnosticar el problema de la impresora
INSERT INTO tarea (id_ticket, id_tecnico, titulo, descripcion, estado, fecha_inicio) VALUES
(1, 2, 'Diagnosticar impresora', 'Verificar conexión y estado del dispositivo', 'Asignado', NOW());


-- Ahora, para que sea más fácil obtener toda la info junta, vamos a crear una vista que junte los datos más importantes
CREATE OR REPLACE VIEW vista_detalle_ticket AS
SELECT
    t.id_ticket,
    t.titulo,
    t.descripcion,
    t.fecha_creacion,
    t.fecha_cierre,
    et.nombre AS estado,
    p.nombre AS prioridad,
    c.nombre AS categoria,
    u_cliente.nombre AS nombre_cliente,
    u_tecnico.nombre AS nombre_tecnico
FROM
    ticket t
    JOIN estado_ticket et ON t.id_estado = et.id_estado
    JOIN prioridad p ON t.id_prioridad = p.id_prioridad
    JOIN categoria c ON t.id_categoria = c.id_categoria
    JOIN usuario u_cliente ON t.id_usuario = u_cliente.id_usuario
    LEFT JOIN usuario u_tecnico ON t.id_tecnico = u_tecnico.id_usuario;


-- Para terminar, aquí algunos select para que puedas ver cómo jalar los datos y hacer consultas:
SELECT * FROM vista_detalle_ticket;

SELECT * FROM ticket;

SELECT * FROM usuario;

SELECT * FROM historial_estado;

SELECT * FROM comentario;

SELECT * FROM tarea;

SELECT * FROM notificacion;

SELECT * FROM adjunto;

SELECT * FROM log_sistema;




-- TRIGGERS:



-- Trigger 1: Cuando se crea un nuevo ticket, registramos en el log_sistema que alguien lo hizo.
DELIMITER //
CREATE TRIGGER trg_log_creacion_ticket
AFTER INSERT ON ticket
FOR EACH ROW
BEGIN
    INSERT INTO log_sistema (id_usuario, accion, fecha)
    VALUES (
        NEW.id_usuario,
        CONCAT('Creó un nuevo ticket: ', NEW.titulo),
        NOW()
    );
END;
//
DELIMITER ;

-- Trigger 2: Cuando se actualiza el estado de un ticket, guardamos el cambio en historial_estado
DELIMITER //
CREATE TRIGGER trg_historial_estado_ticket
BEFORE UPDATE ON ticket
FOR EACH ROW
BEGIN
    -- Solo si el estado cambió
    IF NEW.id_estado <> OLD.id_estado THEN
        INSERT INTO historial_estado (id_ticket, id_estado_anterior, id_estado_nuevo, fecha_cambio)
        VALUES (
            OLD.id_ticket,
            OLD.id_estado,
            NEW.id_estado,
            NOW()
        );
    END IF;
END;
//
DELIMITER ;

-- Trigger 3: Cuando se asigna un técnico a un ticket, se genera una notificación automática
DELIMITER //
CREATE TRIGGER trg_notificacion_tecnico_asignado
AFTER UPDATE ON ticket
FOR EACH ROW
BEGIN
    -- Solo si el técnico fue asignado y no estaba antes
    IF OLD.id_tecnico IS NULL AND NEW.id_tecnico IS NOT NULL THEN
        INSERT INTO notificacion (id_usuario, mensaje, leido, fecha)
        VALUES (
            NEW.id_usuario,
            CONCAT('Tu ticket "', NEW.titulo, '" fue asignado a un técnico.'),
            0,
            NOW()
        );
    END IF;
END;
//
DELIMITER ;




-- Procedimiento almacenado para crear un usuario validando el correo duplicado
DELIMITER //
CREATE PROCEDURE sp_crear_usuario (
    IN p_correo VARCHAR(100),
    IN p_contrasena VARCHAR(100),
    IN p_nombre VARCHAR(100),
    IN p_id_rol INT
)
BEGIN
    DECLARE user_count INT DEFAULT 0;

    -- Verificar si ya existe un usuario con ese correo
    SELECT COUNT(*) INTO user_count
    FROM usuario
    WHERE correo = p_correo;

    IF user_count > 0 THEN
        -- Si existe, se devuelve un error personalizado
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El correo ya está registrado.';
    ELSE
        -- Si no existe, se inserta el nuevo usuario
        INSERT INTO usuario (correo, contrasena, nombre, id_rol)
        VALUES (p_correo, p_contrasena, p_nombre, p_id_rol);
    END IF;
END;
//
DELIMITER ;

# Crear usuarios con sus contraseñas
CREATE USER 'patrick'@'%' IDENTIFIED BY 'cliente123';
CREATE USER 'leonardo'@'%' IDENTIFIED BY 'tecnico123';
CREATE USER 'martin'@'%' IDENTIFIED BY 'admin123';
CREATE USER 'pepe'@'%' IDENTIFIED BY 'lector123';

# Otorgar permisos según el rol

# Cliente: Patrick puede ver, crear y actualizar registros
GRANT SELECT, INSERT, UPDATE ON sistema_tickets.* TO 'patrick'@'%';

# Técnico: Leonardo puede ver, crear y actualizar registros
GRANT SELECT, INSERT, UPDATE ON sistema_tickets.* TO 'leonardo'@'%';

# Administrador: Martín tiene todos los privilegios sobre la base de datos
GRANT ALL PRIVILEGES ON sistema_tickets.* TO 'martin'@'%';

# Lector: Pepe solo puede consultar datos
GRANT SELECT ON sistema_tickets.* TO 'pepe'@'%';

# Aplicar los cambios de permisos
FLUSH PRIVILEGES;
