create database Mundial_PrograWebDos;
use Mundial_PrograWebDos;
 
-- Base dedatos Mundial_PrograWebDos

CREATE TABLE Rol (
    id_rol INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del rol (usuario = 1, admin = 2)',
    nombre VARCHAR(20) NOT NULL UNIQUE COMMENT 'Nombre del rol (usuario y admin, por el momento)',
    descripcion VARCHAR(255) COMMENT 'Descripción de los permisos del rol'
) COMMENT = 'Tabla de roles del sistema';

-- Se insertan los valores de la tabla-glosario roles
INSERT INTO Rol (nombre, descripcion) VALUES 
('usuario', 'Usuario normal del sistema'),
('admin', 'Administrador del sistema');


CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del usuario (PK)',
    nombre VARCHAR(50) NOT NULL COMMENT 'Nombres del usuario',
    apellido VARCHAR(50) NOT NULL COMMENT 'Apellidos del usuario',
    fecha_nacimiento DATE NOT NULL COMMENT 'Fecha de nacimiento del usuario',
    correo VARCHAR(100) UNIQUE NOT NULL COMMENT 'Correo electrónico único del usuario',
    contra VARCHAR(255) NOT NULL COMMENT 'Contraseña hasheada del usuario',
    id_rol INT NOT NULL DEFAULT 1 COMMENT 'Rol del usuario (FK a Rol) por default com usuario normal',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de registro',
    activo TINYINT DEFAULT 1 COMMENT '1 = activo, 0 = inactivo',
    FOREIGN KEY (id_rol) REFERENCES Rol(id_rol) ON DELETE RESTRICT
) COMMENT = 'Tabla de usuarios del sistema';

CREATE TABLE Grupo (
    id_grupo INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del grupo (PK)',
    letra_grupo CHAR(1) UNIQUE NOT NULL COMMENT 'Letra del grupo (A, B, C, etc.)',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro'
) COMMENT = 'Catálogo de grupos para la fase de grupos';

-- Insertar grupos base tomando en cunta la foto del grupo de whatsapp
INSERT INTO Grupo (letra_grupo) VALUES 
('A'),
('B'),
('C'),
('D'),
('E'),
('F'),
('G'),
('H');

CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del equipo (PK)',
    nombre VARCHAR(50) NOT NULL COMMENT 'Nombre oficial del equipo',
    nombre_completo_pais VARCHAR(100) COMMENT 'Nombre completo del equipo',
    bandera VARCHAR(255) COMMENT 'URL o ruta de la imagen de la bandera del equipo',
    informacion TEXT COMMENT 'Descripción e información general del equipo',
    siglas_equipo VARCHAR(3) UNIQUE NOT NULL COMMENT 'Abreviación del equipo (ej: ARG, BRA, ESP)',
    id_grupo INT COMMENT 'Grupo asignado en la fase de grupos (FK a Grupo)',
    ranking_fifa INT COMMENT 'Posición en el ranking FIFA',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro',
    FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo) ON DELETE SET NULL
) COMMENT = 'Tabla de equipos participantes en el mundial';

CREATE TABLE Jugador (
    id_jugador INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del jugador (PK)',
    nombre VARCHAR(50) NOT NULL COMMENT 'Nombre del jugador',
    apellido VARCHAR(50) NOT NULL COMMENT 'Apellido del jugador',
    fecha_nacimiento DATE NOT NULL COMMENT 'Fecha de nacimiento del jugador',
    numero_camiseta TINYINT COMMENT 'Número de camiseta del jugador (1-99)',
    posicion ENUM('portero', 'defensa', 'mediocampista', 'delantero') COMMENT 'Posición principal del jugador',
    equipo_id INT NOT NULL COMMENT 'ID del equipo al que pertenece (FK a Equipo)',
    UNIQUE KEY unique_jugador_equipo (nombre, apellido, equipo_id) COMMENT 'Evita jugadores duplicados en el mismo equipo',
    UNIQUE KEY unique_jugador_mundial (nombre, apellido, fecha_nacimiento) COMMENT 'Evita que un jugador esté en múltiples equipos',
    FOREIGN KEY (equipo_id) REFERENCES Equipo(id_equipo) ON DELETE CASCADE
) COMMENT = 'Tabla de jugadores por equipo';

CREATE TABLE Catalogo_Estado_Partido (
    id_estado INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del estado (PK)',
    codigo VARCHAR(20) UNIQUE NOT NULL COMMENT 'Código único del estado',
    nombre VARCHAR(50) NOT NULL COMMENT 'Nombre descriptivo del estado',
    descripcion VARCHAR(255) COMMENT 'Descripción detallada del estado',
    orden TINYINT COMMENT 'Orden para visualización',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro'
) COMMENT = 'Catálogo de estados posibles de un partido';

-- Insertar estados 
INSERT INTO Catalogo_Estado_Partido (codigo, nombre, descripcion, orden) VALUES 
('PROGRAMADO', 'Programado', 'Partido programado para jugarse', 1),
('EN_JUEGO', 'En juego', 'Partido en curso', 2),
('FINALIZADO', 'Finalizado', 'Partido finalizado', 3),
('APLAZADO', 'Aplazado', 'Partido aplazado para otra fecha', 4),
('SUSPENDIDO', 'Suspendido', 'Partido suspendido temporalmente', 5),
('CANCELADO', 'Cancelado', 'Partido cancelado definitivamente', 6);

CREATE TABLE Catalogo_Fases (
    id_fase INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único de la fase (PK)',
    codigo VARCHAR(20) UNIQUE NOT NULL COMMENT 'Código único de la fase',
    nombre VARCHAR(50) NOT NULL COMMENT 'Nombre descriptivo de la fase',
    descripcion VARCHAR(255) COMMENT 'Descripción detallada de la fase',
    es_eliminacion_directa TINYINT DEFAULT 0 COMMENT '1=eliminación directa, 0=fase de grupos',
    orden TINYINT NOT NULL COMMENT 'Orden en el torneo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro'
) COMMENT = 'Catálogo de fases del torneo';

-- Insertar fases del mundial
INSERT INTO Catalogo_Fases (codigo, nombre, descripcion, es_eliminacion_directa, orden) VALUES 
('FASE_GRUPOS', 'Fase de Grupos', 'Fase inicial con grupos', 0, 1),
('OCTAVOS', 'Octavos de Final', 'Ronda de 16 equipos', 1, 2),
('CUARTOS', 'Cuartos de Final', 'Ronda de 8 equipos', 1, 3),
('SEMIFINAL', 'Semifinal', 'Ronda de 4 equipos', 1, 4),
('TERCER_PUESTO', 'Tercer Puesto', 'Partido por el tercer lugar', 1, 5),
('FINAL', 'Final', 'Partido final del torneo', 1, 6);



CREATE TABLE Partido (
    id_partido INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único del partido (PK)',
    equipo_a_id INT NOT NULL COMMENT 'ID del primer equipo (FK a Equipo)',
    equipo_b_id INT NOT NULL COMMENT 'ID del segundo equipo (FK a Equipo)',
    goles_equipo_a INT DEFAULT 0 COMMENT 'Número de goles del equipo A',
    goles_equipo_b INT DEFAULT 0 COMMENT 'Número de goles del equipo B',
    fecha DATETIME NOT NULL COMMENT 'Fecha y hora del partido',
    estadio VARCHAR(100) NOT NULL COMMENT 'Nombre del estadio donde se juega el partido',
    ciudad VARCHAR(100) NOT NULL COMMENT 'Ciudad donde se juega el partido',
    id_estado INT NOT NULL DEFAULT 1 COMMENT 'Estado actual del partido (FK a Catalogo_Estado_Partido)',
    id_fase INT NOT NULL COMMENT 'Fase del torneo (FK a Catalogo_Fase_Torneo)',
    id_grupo INT COMMENT 'Grupo correspondiente (solo para fase de grupos, FK a Grupo)',
    arbitro_principal VARCHAR(100) COMMENT 'Nombre del árbitro principal',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del registro',
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de última actualización',
    FOREIGN KEY (equipo_a_id) REFERENCES Equipo(id_equipo) ON DELETE CASCADE,
    FOREIGN KEY (equipo_b_id) REFERENCES Equipo(id_equipo) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES Grupo(id_grupo) ON DELETE SET NULL,
    FOREIGN KEY (id_estado) REFERENCES Catalogo_Estado_Partido(id_estado) ON DELETE RESTRICT,
    FOREIGN KEY (id_fase) REFERENCES Catalogo_Fases(id_fase) ON DELETE RESTRICT,
    CHECK (equipo_a_id != equipo_b_id),
    CHECK (goles_equipo_a >= 0),
    CHECK (goles_equipo_b >= 0)
) COMMENT = 'Tabla de partidos del mundial';

CREATE TABLE Usuario_Favorito (
    usuario_id INT NOT NULL COMMENT 'ID del usuario (FK a Usuario)',
    partido_id INT NOT NULL COMMENT 'ID del partido (FK a Partido)',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha en que se marcó como favorito',
    PRIMARY KEY (usuario_id, partido_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (partido_id) REFERENCES Partido(id_partido) ON DELETE CASCADE
) COMMENT = 'Relación de partidos favoritos por usuario';

CREATE TABLE Usuario_Equipo_Favorito (
    usuario_id INT NOT NULL COMMENT 'ID del usuario (FK a Usuario)',
    equipo_id INT NOT NULL COMMENT 'ID del equipo (FK a Equipo)',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha en que se marcó como favorito',
    PRIMARY KEY (usuario_id, equipo_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (equipo_id) REFERENCES Equipo(id_equipo) ON DELETE CASCADE
) COMMENT = 'Relación de equipos favoritos por usuario';


 
 