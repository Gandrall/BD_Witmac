## Base De Datos

-- TABLA EMPRESA
CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL
);

-- TABLA ADMINISTRADOR
CREATE TABLE administrador (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    empresa_id INT REFERENCES empresa(id)
);

-- TABLA EMPLEADO
CREATE TABLE empleado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    empresa_id INT REFERENCES empresa(id)
);

-- TABLA CENTRAL
CREATE TABLE central (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    empresa_id INT REFERENCES empresa(id)
);

-- TABLA OLT
CREATE TABLE olt (
    id SERIAL PRIMARY KEY,
    frame VARCHAR(50) NOT NULL,
    puertos_ocupados TEXT,
    slots_ocupados TEXT,
    central_id INT REFERENCES central(id)
);

-- TABLA ODF
CREATE TABLE odf (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tamano VARCHAR(50),
    puerto TEXT,
    olt_id INT REFERENCES olt(id)
);

-- TABLA TRONCAL
CREATE TABLE troncal (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    coordenadas geometry(Point,4326) NOT NULL,
    odf_id INT REFERENCES odf(id)
);

-- TABLA SUB_TRONCAL
CREATE TABLE sub_troncal (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    coordenadas geometry(Point,4326) NOT NULL,
    troncal_id INT REFERENCES troncal(id)
);

-- TABLA CAJA EMPALME
CREATE TABLE caja_empalme (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    coordenadas geometry(Point,4326) NOT NULL,
    disminucion_buffers TEXT,
    buffers_restantes INT,
    troncal_id INT REFERENCES troncal(id),
    sub_troncal_id INT REFERENCES sub_troncal(id)
);

-- TABLA SANGRADO
CREATE TABLE sangrado (
    id SERIAL PRIMARY KEY,
    coordenadas geometry(Point,4326) NOT NULL,
    buffer_color VARCHAR(50) NOT NULL,
    hilos_disponibles TEXT,
    troncal_id INT REFERENCES troncal(id),
    sub_troncal_id INT REFERENCES sub_troncal(id)
);

-- TABLA SUB_SANGRADO
CREATE TABLE sub_sangrado (
    id SERIAL PRIMARY KEY,
    coordenadas geometry(Point,4326) NOT NULL,
    hilo_color VARCHAR(50) NOT NULL,
    sangrado_id INT REFERENCES sangrado(id)
);

-- TABLA CAJA NAT
CREATE TABLE caja_nat (
    id SERIAL PRIMARY KEY,
    coordenadas geometry(Point,4326) NOT NULL,
    hilo_color VARCHAR(50) NOT NULL,
    troncal_id INT REFERENCES troncal(id),
    sub_troncal_id INT REFERENCES sub_troncal(id),
    sangrado_id INT REFERENCES sangrado(id),
    sub_sangrado_id INT REFERENCES sub_sangrado(id)
);

-- TABLA SPLITER PRINCIPAL
CREATE TABLE spliter_principal (
    id SERIAL PRIMARY KEY,
    hilo_color VARCHAR(50) NOT NULL,
    tipo_conexion VARCHAR(50),
    hilo_retorno VARCHAR(50),
    hilo_usado INT,
    caja_nat_id INT REFERENCES caja_nat(id)
);

-- TABLA SPLITER SECUNDARIO
CREATE TABLE spliter_secundario (
    id SERIAL PRIMARY KEY,
    hilo_conectado INT NOT NULL,
    hilo_ocupado INT NOT NULL,
    caja_nat_id INT REFERENCES caja_nat(id),
    spliter_principal_id INT REFERENCES spliter_principal(id)
);

-- TABLA SPLITER CLIENTE
CREATE TABLE spliter_cliente (
    id SERIAL PRIMARY KEY,
    hilo_conectado INT NOT NULL,
    clientes_activos INT NOT NULL,
    caja_nat_id INT REFERENCES caja_nat(id),
    spliter_principal_id INT REFERENCES spliter_principal(id)
);



DROP TABLE IF EXISTS spliter_cliente;
DROP TABLE IF EXISTS spliter_secundario;
DROP TABLE IF EXISTS spliter_principal;
DROP TABLE IF EXISTS caja_nat;
DROP TABLE IF EXISTS sub_sangrado;
DROP TABLE IF EXISTS sangrado;
DROP TABLE IF EXISTS caja_empalme;
DROP TABLE IF EXISTS sub_troncal;
DROP TABLE IF EXISTS troncal;
DROP TABLE IF EXISTS odf;
DROP TABLE IF EXISTS olt;
DROP TABLE IF EXISTS central;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS administrador;
DROP TABLE IF EXISTS empresa;

