# Market

Aplicación web de comercialización de productos (frutas, verduras, abarrotes,
bebidas, limpieza y cuidado personal) con carrito de compras, gestión de
proveedores, historial de administrador y panel de usuario.

Aplicación Java/Jakarta EE 8 (Servlets 4.0 + JSP) desplegada sobre Apache
Tomcat 9. Originalmente usaba MySQL/MariaDB; esta versión usa **PostgreSQL**
(alojada en Supabase) mediante JDBC.

## Estructura

- `src/main/java/controlador/` — Servlets (`@WebServlet`)
- `src/main/java/clases/` — Modelo y acceso a datos (`Producto`, `ProductoDAO`, `ConexionDB`)
- `src/main/webapp/jsp-*/` — Vistas JSP
- `supabase/schema.sql` — Esquema PostgreSQL (tablas, FKs, triggers, secuencias)

## Conexión a la base de datos

La clase `clases.ConexionDB` obtiene la conexión desde variables de entorno.
Soporta:

- `JDBC_DATABASE_URL` (o `DATABASE_URL`) — URL JDBC completa de PostgreSQL.
- O bien las variables separadas: `DB_HOST`, `DB_PORT`, `DB_NAME`,
  `DB_USER`, `DB_PASSWORD`.

Ejemplo de URL:
`jdbc:postgresql://<host>:5432/<db>?sslmode=require`

## Ejecución local

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=bd_registro
export DB_USER=postgres
export DB_PASSWORD=tu_clave
mvn clean package
# Desplegar target/Market.war en Tomcat 9
```

## Despliegue en Render (Docker)

1. Crear un nuevo **Web Service** con el método **Docker**.
2. Conectar el repositorio de GitHub.
3. Render detecta el `Dockerfile` automáticamente.
4. En *Environment*, definir:
   - `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
     (credenciales de Supabase / PostgreSQL), o directamente
     `JDBC_DATABASE_URL`.
5. El contenedor escucha en la variable de entorno `$PORT`.

## Migración MySQL → PostgreSQL

- Se reemplazó el driver `mysql-connector-j` por `org.postgresql:postgresql`.
- Todas las llamadas `DriverManager.getConnection(...)` usan ahora
  `ConexionDB.getConnection()`.
- Los `LIMIT n` y `NOW()` de MySQL son compatibles con PostgreSQL.
- Se corrigió `UPDATE ... LIMIT 1` (no soportado en PostgreSQL) por
  `UPDATE ... WHERE id = 1` en la edición del administrador.
- El esquema se generó con `/tmp/convert.py` a partir del dump MariaDB.
