DO $$
DECLARE
    empresa_id INT;
    central_id INT;
    olt_id INT;
    odf_id INT;
    troncal_id INT;
    sub_troncal_id INT;
    caja_empalme_id INT;
    sangrado_id INT;
    sub_sangrado_id INT;
    caja_nat_id INT;
    spliter_principal_id INT;
    spliter_secundario_id INT;
    spliter_cliente_id INT;
BEGIN
    -- 1. EMPRESA
    INSERT INTO empresa (nombre, direccion)
    VALUES ('WitMac', 'Av. Tecnológica 123')
    RETURNING id INTO empresa_id;

-- ADMINISTRADOR
	INSERT INTO administrador (nombre, correo, contrasena, empresa_id)
    VALUES ('jUANDO', 'adsad', '123f', empresa_id)
    RETURNING id INTO administrador_id;

   -- EMPLEADO
	INSERT INTO  empleado (nombre, correo, contrasena, empresa_id)
    VALUES ('Otis', 'qwwsd', '2467', empresa_id)
    RETURNING id INTO empleado_id;

    -- 2. CENTRAL
    INSERT INTO central (nombre, direccion, empresa_id)
    VALUES ('Central Norte', 'Calle Central 45', empresa_id)
    RETURNING id INTO central_id;

    -- 3. OLT
    INSERT INTO olt (frame, puertos_ocupados, slots_ocupados, central_id)
    VALUES ('Frame-01', '1,2,3', 'A,B', central_id)
    RETURNING id INTO olt_id;

    -- 4. ODF
    INSERT INTO odf (nombre, tamano, puerto, olt_id)
    VALUES ('ODF_1', '48', 'P1', olt_id)
    RETURNING id INTO odf_id;

    -- 5. TRONCAL
    INSERT INTO troncal (nombre, tipo, coordenadas, odf_id)
    VALUES ('Troncal_1', 'Fibra', ST_SetSRID(ST_MakePoint(-98.203, 19.043), 4326), odf_id)
    RETURNING id INTO troncal_id;

    -- 6. SUB TRONCAL
    INSERT INTO sub_troncal (nombre, tipo, coordenadas, troncal_id)
    VALUES ('Sub_Troncal_1', 'Fibra', ST_SetSRID(ST_MakePoint(-98.210, 19.050), 4326), troncal_id)
    RETURNING id INTO sub_troncal_id;

    -- 7. CAJA EMPALME
    INSERT INTO caja_empalme (nombre, coordenadas, disminucion_buffers, buffers_restantes, troncal_id, sub_troncal_id)
    VALUES ('Caja_1', ST_SetSRID(ST_MakePoint(-98.215, 19.052), 4326), '12→8', 8, troncal_id, sub_troncal_id)
    RETURNING id INTO caja_empalme_id;

    -- 8. SANGRADO
    INSERT INTO sangrado (coordenadas, buffer_color, hilos_disponibles, troncal_id, sub_troncal_id)
    VALUES (ST_SetSRID(ST_MakePoint(-98.220, 19.055), 4326), 'Rojo', 'Azul,Verde,Amarillo', troncal_id, sub_troncal_id)
    RETURNING id INTO sangrado_id;

    -- 9. SUB SANGRADO
    INSERT INTO sub_sangrado (coordenadas, hilo_color, sangrado_id)
    VALUES (ST_SetSRID(ST_MakePoint(-98.225, 19.060), 4326), 'Azul', sangrado_id)
    RETURNING id INTO sub_sangrado_id;

    -- 10. CAJA NAT
    INSERT INTO caja_nat (coordenadas, hilo_color, troncal_id, sub_troncal_id, sangrado_id, sub_sangrado_id)
    VALUES (ST_SetSRID(ST_MakePoint(-98.230, 19.065), 4326), 'Azul', troncal_id, sub_troncal_id, sangrado_id, sub_sangrado_id)
    RETURNING id INTO caja_nat_id;

    -- 11. SPLITER PRINCIPAL
    INSERT INTO spliter_principal (hilo_color, tipo_conexion, hilo_retorno, hilo_usado, caja_nat_id)
    VALUES ('Azul', 'Principal', NULL, 1, caja_nat_id)
    RETURNING id INTO spliter_principal_id;

    -- 12. SPLITER SECUNDARIO
    INSERT INTO spliter_secundario (hilo_conectado, hilo_ocupado, caja_nat_id, spliter_principal_id)
    VALUES (1, 1, caja_nat_id, spliter_principal_id)
    RETURNING id INTO spliter_secundario_id;

    -- 13. SPLITER CLIENTE
    INSERT INTO spliter_cliente (hilo_conectado, clientes_activos, caja_nat_id, spliter_principal_id)
    VALUES (2, 5, caja_nat_id, spliter_principal_id)
    RETURNING id INTO spliter_cliente_id;

END $$;

-- Centrales de la empresa
SELECT c.id, c.nombre AS central, e.nombre AS empresa
FROM central c
JOIN empresa e ON c.empresa_id = e.id;

-- OLT en su central
SELECT o.id, o.frame, o.puertos_ocupados, c.nombre AS central
FROM olt o
JOIN central c ON o.central_id = c.id;

-- Troncal a que OLT esta conectada
SELECT t.id, t.nombre, t.tipo, o.nombre AS odf
FROM troncal t
JOIN odf o ON t.odf_id = o.id;

-- Cajas Nat conectadas a un sangrado
SELECT cn.id, cn.hilo_color, s.buffer_color
FROM caja_nat cn
JOIN sangrado s ON cn.sangrado_id = s.id
WHERE s.buffer_color = 'Rojo';



SELECT e.nombre AS empresa,
       c.nombre AS central,
       o.frame AS olt_frame,
       odf.nombre AS odf,
       t.nombre AS troncal,
       st.nombre AS sub_troncal,
       ce.nombre AS caja_empalme,
       s.buffer_color,
       ss.hilo_color,
       cn.hilo_color AS hilo_caja_nat
FROM caja_nat cn
JOIN sub_sangrado ss ON cn.sub_sangrado_id = ss.id
JOIN sangrado s ON ss.sangrado_id = s.id
JOIN sub_troncal st ON cn.sub_troncal_id = st.id
JOIN troncal t ON st.troncal_id = t.id
JOIN odf ON t.odf_id = odf.id
JOIN olt o ON odf.olt_id = o.id
JOIN central c ON o.central_id = c.id
JOIN empresa e ON c.empresa_id = e.id
LEFT JOIN caja_empalme ce ON ce.troncal_id = t.id AND ce.sub_troncal_id = st.id;

SELECT t.nombre AS troncal, COUNT(cn.id) AS total_cajas_nat
FROM caja_nat cn
JOIN troncal t ON cn.troncal_id = t.id
GROUP BY t.nombre;

SELECT e.nombre AS empresa, SUM(sc.clientes_activos) AS clientes_totales
FROM empresa e
JOIN central c ON c.empresa_id = e.id
JOIN olt o ON o.central_id = c.id
JOIN odf ON odf.olt_id = o.id
JOIN troncal t ON t.odf_id = odf.id
JOIN sub_troncal st ON st.troncal_id = t.id
JOIN caja_nat cn ON cn.sub_troncal_id = st.id
JOIN spliter_cliente sc ON sc.caja_nat_id = cn.id
GROUP BY e.nombre;


