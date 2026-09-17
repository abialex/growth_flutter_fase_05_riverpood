-- 20 eventos deportivos de prueba. Pega este script en Supabase → SQL Editor → Run
-- (después de 001-esquema-bd.sql, 002-politicas-rls.sql y
-- 003-trigger-usuarios.sql).
-- Se corre desde el SQL Editor porque `eventos` no tiene política de insert
-- para clientes (solo lectura pública vía eventos_select_public).
--
-- NOTA: si ya corriste una versión anterior de este script y los acentos/ñ
-- quedaron mal guardados (ej. "Bogotá" como "BogotÃ¡"), este script primero
-- vacía la tabla para evitar duplicados con datos corruptos.

truncate table public.eventos restart identity cascade;

insert into public.eventos
  (nombre, deporte, fecha, hora, ciudad, lugar, cupos_totales, cupos_disponibles, descripcion, estado)
values
  ('Copa Barrios Bogotá - Semifinal', 'futbol', '2026-08-10', '16:00', 'Bogotá', 'Cancha El Salitre', 22, 4, 'Semifinal del torneo barrial de fútbol 11.', 'abierto'),
  ('Liga Amateur de Baloncesto - Jornada 5', 'baloncesto', '2026-08-12', '18:30', 'Medellín', 'Coliseo Iván de Bedout', 20, 20, 'Jornada regular de la liga amateur de baloncesto.', 'abierto'),
  ('Torneo de Vóleibol Playa', 'voleibol', '2026-08-14', '17:00', 'Cali', 'Playa Club Náutico', 16, 10, 'Torneo relámpago de vóley playa 2v2.', 'abierto'),
  ('10K Nocturna del Malecón', 'running', '2026-08-16', '06:00', 'Barranquilla', 'Malecón del Río', 200, 150, 'Carrera nocturna de 10 kilómetros junto al río.', 'abierto'),
  ('Ruta Cicloturística Mesa de Ruitoque', 'ciclismo', '2026-08-18', '07:00', 'Bucaramanga', 'Parque San Pío', 80, 80, 'Recorrido grupal en bicicleta de ruta.', 'abierto'),
  ('Copa Cartagena de Tenis - Individual', 'tenis', '2026-08-20', '15:00', 'Cartagena', 'Club de Tenis Cartagena', 32, 12, 'Cuadro individual, eliminación directa.', 'abierto'),
  ('Torneo Interclubes de Natación', 'natacion', '2026-08-22', '09:00', 'Pereira', 'Piscina Olímpica Pereira', 40, 0, 'Cupos agotados — lista de espera en el club.', 'abierto'),
  ('Torneo Relámpago de Pádel', 'padel', '2026-08-24', '19:00', 'Bogotá', 'Padel Club Chicó', 16, 6, 'Formato americano, parejas mixtas.', 'abierto'),
  ('Media Maratón de Medellín', 'atletismo', '2026-08-26', '07:30', 'Medellín', 'Parque Norte', 500, 320, 'Recorrido de 21K por la ciudad.', 'abierto'),
  ('Copa Valle de Rugby 7s', 'rugby', '2026-08-28', '14:00', 'Cali', 'Canchas auxiliares Pascual Guerrero', 30, 18, 'Torneo de rugby seven, formato relámpago.', 'abierto'),
  ('Liga Local de Fútbol 5 - Final', 'futbol', '2026-09-02', '20:00', 'Barranquilla', 'Polideportivo Norte', 20, 20, 'Gran final de la liga de fútbol 5.', 'abierto'),
  ('Torneo 3x3 Streetball', 'baloncesto', '2026-09-05', '18:00', 'Bucaramanga', 'Parque de los Niños', 24, 9, 'Formato callejero 3 contra 3.', 'abierto'),
  ('Subida al Nevado del Ruiz (tramo)', 'ciclismo', '2026-09-08', '06:30', 'Pereira', 'Salida Parque Olaya Herrera', 60, 45, 'Ascenso grupal en bicicleta de montaña.', 'abierto'),
  ('Vóley Playa Bocagrande', 'voleibol', '2026-09-10', '17:30', 'Cartagena', 'Playa Bocagrande', 12, 2, 'Últimos cupos disponibles.', 'abierto'),
  ('5K Solidaria Parque Simón Bolívar', 'running', '2026-09-12', '06:00', 'Bogotá', 'Parque Simón Bolívar', 300, 300, 'Carrera solidaria a beneficio de fundaciones locales.', 'abierto'),
  ('Copa Antioquia de Tenis Juvenil', 'tenis', '2026-09-15', '16:00', 'Medellín', 'Club Campestre', 24, 24, 'Categoría juvenil sub-18.', 'abierto'),
  ('Copa Panamericana Aguas Abiertas (Clasificatorio Local)', 'natacion', '2026-09-18', '08:00', 'Cali', 'Lago Calima', 50, 10, 'Clasificatorio local para el circuito panamericano.', 'abierto'),
  ('Amistoso Barrio Cuba vs Barrio Centenario', 'futbol', '2026-08-06', '15:00', 'Pereira', 'Cancha Cuba', 22, 22, 'Inscripciones cerradas, cupos ya asignados.', 'cerrado'),
  ('Torneo Interbarrios de Baloncesto - Ronda 1', 'baloncesto', '2026-07-20', '19:00', 'Bogotá', 'Coliseo El Campín', 20, 0, 'Evento ya finalizado.', 'finalizado'),
  ('Carrera de las Murallas 8K', 'atletismo', '2026-08-30', '07:00', 'Cartagena', 'Centro Histórico', 400, 275, 'Recorrido de 8K por el centro histórico amurallado.', 'abierto');
