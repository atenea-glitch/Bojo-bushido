-- BORRAR TABLAS SI EXISTEN (orden correcto por claves foráneas)
DROP TABLE IF EXISTS detalles;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

-- =========================
-- TABLA CLIENTES
-- =========================
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(50) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(35) NOT NULL,
    segundo_apellido VARCHAR(35),
    telefono VARCHAR(30),
    codigo_postal VARCHAR(10) NOT NULL,
    provincia VARCHAR(30) NOT NULL,
    pueblo VARCHAR(35) NOT NULL,
    calle VARCHAR(50) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    puerta VARCHAR(10) NOT NULL
);

-- =========================
-- TABLA PRODUCTOS
-- =========================
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(55) NOT NULL,
    descripcion VARCHAR(2000) NOT NULL,
    existentes INT NOT NULL DEFAULT 0,
    precio DECIMAL(6,2) NOT NULL CHECK (precio > 0)
);

-- =========================
-- TABLA PEDIDOS
-- =========================
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente)
        ON DELETE CASCADE
);

-- =========================
-- TABLA DETALLES
-- =========================
CREATE TABLE detalles (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY (id_pedido) 
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE,
    FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto)
);

-- =========================
-- añadimos algunos clientes para darle realismo al proyecto 
-- y que no aparezcan tablas vacías
-- =========================
INSERT INTO clientes 
(correo, pais, nom, primer_apellido, segundo_apellido, telefono, codigo_postal, provincia, pueblo, calle, numero, puerta)
VALUES 
('hulk.aplasta@avengers.jp', 'EEUU', 'Hulk', 'Banner', NULL, '+1 202-555-0101', '10001', 'New York', 'Manhattan', 'Av. Vengadores', '7-A', '1'),
('gizmo.mogwai@rules.jp', 'Japón', 'Gizmo', 'Magwai', NULL, '+81 90-1111-2222', '150-0042', 'Tokyo', 'Shibuya', 'Dogenzaka', '302', '2'),
('asuka.eva02@nerv.jp', 'Japón', 'Asuka', 'Langley', NULL, '+81 80-5555-4444', '250-0601', 'Kanagawa', 'Hakone', 'Sengokuhara', '02', '3');

INSERT INTO productos (nombre, descripcion, existentes, precio)
VALUES 
('Kimono de Gala para Gatos', 'Para que tu michi sea el más elegante del barrio.', 5, 45.00),
('Gorra "No molestar, programando"', 'Ideal para bibliotecas y salas de estudio.', 20, 15.95),
('Zapatillas Ninja Silenciosas', 'Para llegar tarde a clase sin que el profesor te oiga.', 12, 55.50),
('Palillos Eléctricos Anti-Deslave', 'Grip de alta tecnología para Ramen resbaladizo.', 30, 12.00),
('Sudadera "Sobreviví al examen"', 'Edición limitada para valientes.', 40, 29.99),
('Taza Térmica "Error 404: Café not found"', 'Mantiene el té caliente por 8 horas.', 25, 18.50),
('Abanico Manual Anti-Calor Extremo', 'Estilo samurái para el verano de Tokyo.', 50, 8.00),
('Calcetines de Sushi (Salmón)', 'Cuidado, no se comen.', 100, 6.50),
('Libreta de Apuntes Invisibles', 'Ideal para espías o estudiantes que no estudian.', 15, 9.90),
('Bolígrafo con forma de Katana', 'Escribe con el honor de un guerrero.', 60, 4.50),
('Mochila Cohete Espacial', 'Para ir a clase a la velocidad de la luz.', 10, 85.00),
('Paraguas con Luz Neón', 'Para no perderte en el cruce de Shibuya.', 20, 35.00),
('Almohada con forma de Onigiri', 'Suave, blandita y no mancha de arroz.', 18, 22.00),
('Llavero Totoro Gigante', 'Ocupa más que tus llaves, pero es adorable.', 45, 7.25),
('Gafas de Sol para Perros', 'Porque ellos también tienen estilo.', 8, 14.00),
('Póster "Keep Calm and Learn SQL"', 'Decoración motivacional para tu cuarto.', 35, 12.99),
('Mini Ventilador USB para Nariz', 'Refresco directo para momentos de estrés.', 15, 10.50),
('Cuaderno de Caligrafía Pro', 'Papel de seda que absorbe la tinta mágicamente.', 25, 19.00),
('Reloj de Arena de 5 minutos', 'Para controlar tus descansos (o tus siestas).', 30, 11.00),
('Set de Pegatinas de Gatitos Programadores', 'Decora tu portátil con estilo.', 200, 3.50); 

-- PEDIDO 1: Gizmo compra utiles para no mojarse 

INSERT INTO pedidos (id_cliente, fecha) VALUES (2, NOW());
INSERT INTO detalles (id_pedido, id_producto, cantidad) 
VALUES (1, 12, 1), (1, 8, 3), (1, 13, 1); -- Paraguas Neón, Calcetines Sushi y Almohada Onigiri

-- PEDIDO 2: Asuka compra equipo de estudio y un regalo para su gato

INSERT INTO pedidos (id_cliente, fecha) VALUES (3, NOW());
INSERT INTO detalles (id_pedido, id_producto, cantidad) 
VALUES (2, 1, 1), (2, 10, 2), (2, 18, 1); -- Kimono Gato, Bolis Katana y Cuaderno Caligrafía

=====================
-- CONSULTAS FINALES: Une las tablas para mostrar nombres,
-- productos y cálculos, incluyendo el total del pedido.

SELECT 
    p.id_pedido, 
    c.nom AS Nombre_Cliente, 
    prod.nombre AS Producto,
    d.cantidad, 
    (d.cantidad * prod.precio) AS Subtotal
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN detalles d ON p.id_pedido = d.id_pedido
JOIN productos prod ON d.id_producto = prod.id_producto;

SELECT 
    p.id_pedido,
    c.nom,
    SUM(d.cantidad * prod.precio) AS total_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN detalles d ON p.id_pedido = d.id_pedido
JOIN productos prod ON d.id_producto = prod.id_producto
GROUP BY p.id_pedido, c.nom;

-- consulta un poco más compleja 
-- ============================

SELECT 
    c.nom AS nombre_cliente,
    SUM(d.cantidad * prod.precio) AS total_gastado,
    COUNT(DISTINCT p.id_pedido) AS numero_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN detalles d ON p.id_pedido = d.id_pedido
JOIN productos prod ON d.id_producto = prod.id_producto
WHERE p.fecha >= '2024-01-01'
GROUP BY c.id_cliente, c.nom
HAVING COUNT(DISTINCT p.id_pedido) > 2
ORDER BY total_gastado DESC;
