DROP TABLE IF EXISTS detalles;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id_cliente        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    correo            VARCHAR(100) NOT NULL UNIQUE,
    pais              VARCHAR(50) NOT NULL,
    nom               VARCHAR(50) NOT NULL,
    primer_apellido   VARCHAR(35) NOT NULL,
    segundo_apellido  VARCHAR(35),
    telefono          VARCHAR(30),
    codigo_postal     VARCHAR(10) NOT NULL,
    provincia         VARCHAR(30) NOT NULL,
    pueblo            VARCHAR(35) NOT NULL,
    calle             VARCHAR(50) NOT NULL,
    numero            VARCHAR(4) NOT NULL,
    puerta            VARCHAR(9) NOT NULL
);

CREATE TABLE productos (
    id_producto  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre       VARCHAR(55) NOT NULL,
    descripcion  VARCHAR(2000) NOT NULL,
    existentes   INT NOT NULL DEFAULT 0 CHECK (existentes >= 0),
    precio       DECIMAL(5,2) NOT NULL CHECK (precio > 0 AND precio < 1000)
);

CREATE TABLE pedidos (
    id_pedido   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id_cliente  INT NOT NULL,
    fecha       DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalles (
    id_detalle   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    id_pedido    INT NOT NULL,
    id_producto  INT NOT NULL,
    cantidad     INTEGER NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY(id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY(id_producto) REFERENCES productos(id_producto)
);
