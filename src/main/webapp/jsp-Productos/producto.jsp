<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    request.setCharacterEncoding("UTF-8");

    String mensaje = null;
    String tipoMensaje = null;

    String eliminarId = request.getParameter("eliminar_id");
    if (eliminarId != null) {
        try {
            int id = Integer.parseInt(eliminarId);
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM productos WHERE id = ?");
            ps.setInt(1, id);
            int filas = ps.executeUpdate();
            ps.close();

            if (filas > 0) {
                // Registrar historial (ELIMINAR)
                String usuario = (String) session.getAttribute("usuario_admin");
                if (usuario == null) {
                    usuario = "Admin";
                }

                PreparedStatement psHist = conn.prepareStatement(
                        "INSERT INTO historial_admin (usuario_admin, accion, tabla_afectada, id_afectado, detalles) VALUES (?, ?, ?, ?, ?)"
                );
                psHist.setString(1, usuario);
                psHist.setString(2, "ELIMINAR");
                psHist.setString(3, "productos");
                psHist.setInt(4, id);
                psHist.setString(5, "Se eliminó el producto con ID: " + id);
                psHist.executeUpdate();
                psHist.close();

                mensaje = "✅ Producto eliminado correctamente.";
                tipoMensaje = "success";
            } else {
                mensaje = "⚠ No se encontró el producto.";
                tipoMensaje = "warning";
            }

            conn.close();

        } catch (Exception e) {
            mensaje = "❌ Error al eliminar: " + e.getMessage();
            tipoMensaje = "danger";
        }
    }

    if (request.getParameter("agregar") != null) {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        double precio = Double.parseDouble(request.getParameter("precio"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String cantidad = request.getParameter("cantidad");
        String unidad = request.getParameter("unidad");
        String categoria = request.getParameter("categoria");
        String imagen = request.getParameter("imagen");

        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement("INSERT INTO productos (nombre, descripcion, precio, stock, unidad, imagen_url, categoria) VALUES (?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setDouble(3, precio);
            ps.setInt(4, stock);
            ps.setString(5, cantidad + " " + unidad);
            ps.setString(6, imagen);
            ps.setString(7, categoria);
            ps.executeUpdate();

// Registrar historial (AGREGAR)
            String usuario = (String) session.getAttribute("usuario_admin");
            if (usuario == null) {
                usuario = "Admin";
            }

// Obtener ID del producto recién insertado
            Statement st = conn.createStatement();
            ResultSet rsId = st.executeQuery("SELECT MAX(id) AS id FROM productos");
            int nuevoId = 0;
            if (rsId.next()) {
                nuevoId = rsId.getInt("id");
            }
            rsId.close();
            st.close();

// Insertar historial
            PreparedStatement psHist = conn.prepareStatement(
                    "INSERT INTO historial_admin (usuario_admin, accion, tabla_afectada, id_afectado, detalles) VALUES (?, ?, ?, ?, ?)"
            );
            psHist.setString(1, usuario);
            psHist.setString(2, "AGREGAR");
            psHist.setString(3, "productos");
            psHist.setInt(4, nuevoId);
            psHist.setString(5, "Se agregó el producto: " + nombre);
            psHist.executeUpdate();
            psHist.close();

            conn.close();
            mensaje = "✅ Producto agregado correctamente.";
            tipoMensaje = "success";

        } catch (Exception e) {
            mensaje = "❌ Error al agregar: " + e.getMessage();
            tipoMensaje = "danger";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Productos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            /* Botón cálido */
            .btn-warm {
                background-color: #f57c00;
                color: white;
                border: 2px solid #f57c00;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 0 5px rgba(245, 124, 0, 0.5);
            }
            .btn-warm:hover {
                background-color: #ffa040;
                border-color: #ff9800;
                transform: scale(1.05);
                box-shadow: 0 0 10px rgba(255, 152, 0, 0.6);
            }

            /* Botón contorno cálido */
            .btn-outline-warm {
                background-color: transparent;
                color: #f57c00;
                border: 2px solid #f57c00;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .btn-outline-warm:hover {
                background-color: #ffe0b2;
                color: #bf360c;
                box-shadow: 0 0 10px rgba(255, 152, 0, 0.6);
                transform: scale(1.05);
            }

            /* Botón cerrar sesión cálido */
            .btn-warm-danger {
                background-color: #e64a19;
                color: white;
                border: 2px solid #e64a19;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .btn-warm-danger:hover {
                background-color: #ff7043;
                border-color: #ff5722;
                transform: scale(1.05);
                box-shadow: 0 0 10px rgba(230, 74, 25, 0.6);
            }
            /* Efecto hover para botones clásicos */
            .btn-info:hover {
                background-color: #17a2b8;
                box-shadow: 0 0 10px rgba(23, 162, 184, 0.5);
                transform: scale(1.03);
            }

            .btn-outline-secondary:hover {
                background-color: #f8f9fa;
                color: #343a40;
                box-shadow: 0 0 8px rgba(108, 117, 125, 0.4);
                transform: scale(1.03);
            }

            .btn-danger:hover {
                background-color: #c82333;
                box-shadow: 0 0 10px rgba(220, 53, 69, 0.5);
                transform: scale(1.03);
            }





            /* --- BOTÓN BUSCAR --- */

            .btn-buscar {
                background-color: #ffb74d;
                color: #fff;
                font-weight: bold;
                border: none;
                transition: all 0.3s ease;
                border-radius: 8px;
                box-shadow: 0 0 6px rgba(255, 183, 77, 0.4);
            }
            .btn-buscar:hover {
                background-color: #ffa726;
                box-shadow: 0 0 12px rgba(255, 152, 0, 0.7);
                transform: scale(1.05);
            }

        </style>
    </head>
    <body class="bg-light">

        <div class="container mt-4">
            <div class="d-flex justify-content-end mb-3 flex-wrap gap-2">
                <a href="../jsp-Proveedores/Proveedores.jsp" class="btn btn-warm">Proveedores</a>

                <!-- Ver historial en azul Bootstrap -->
                <a href="../jsp-Admin/historialAdmin.jsp" class="btn btn-info text-white">
                    <i class="bi bi-clock-history"></i> Ver mi historial
                </a>

                <!-- Editar perfil con contorno gris -->
                <a href="../jsp-Admin/editarAdmin.jsp" class="btn btn-outline-secondary">
                    <i class="bi bi-pencil-square"></i> Editar Perfil
                </a>

                <!-- Cerrar sesión con rojo -->
                <a href="../jsp-Admin/cerrarSesion.jsp" class="btn btn-danger">
                    <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
                </a>
            </div>



            <h3 class="text-center mb-3">🛒 Agregar Nuevo Producto</h3>

            <% if (mensaje != null) {%>
            <div class="alert alert-<%= tipoMensaje%> text-center shadow-sm">
                <%= mensaje%>
            </div>
            <% }%>

            <div class="card shadow mb-5">
                <div class="card-body">
                    <form method="post" action="producto.jsp">
                        <div class="row g-3">
                            <div class="col-md-4"><input name="nombre" class="form-control" placeholder="Nombre" required></div>
                            <div class="col-md-4"><input name="descripcion" class="form-control" placeholder="Descripción" required></div>
                            <div class="col-md-4"><input name="precio" type="number" step="0.01" class="form-control" placeholder="Precio (S/)" required></div>
                            <div class="col-md-4"><input name="stock" type="number" class="form-control" placeholder="Stock" required></div>
                            <div class="col-md-2"><input name="cantidad" type="number" step="0.01" min="0.01" class="form-control" placeholder="Cantidad" required></div>
                            <div class="col-md-2">
                                <select name="unidad" class="form-select" required>
                                    <option value="">Unidad</option>
                                    <option>Kilogramos</option><option>Gramos</option>
                                    <option>Litros</option><option>Mililitros</option>
                                    <option>Unidad</option><option>Paquete</option><option>Caja</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <select name="categoria" class="form-select" required>
                                    <option value="">Categoría</option>
                                    <option>Frutas</option><option>Verduras</option><option>Abarrotes</option>
                                    <option>Bebidas</option><option>Limpieza</option>
                                    <option>Cuidado Personal</option><option>Mascotas</option>
                                </select>
                            </div>
                            <div class="col-md-8"><input name="imagen" class="form-control" placeholder="URL de Imagen"></div>
                        </div>
                        <div class="d-grid mt-3">
                            <button type="submit" name="agregar" class="btn btn-warm">Agregar Producto</button>
                        </div>
                    </form>
                </div>
            </div>

            <form method="get" class="row mb-4 g-2 justify-content-center">
                <div class="col-md-4">
                    <input type="text" name="buscar" class="form-control" placeholder="Buscar por nombre..." value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
                </div>
                <div class="col-md-3">
                    <select name="categoria" class="form-select">
                        <option value="">Todas las categorías</option>
                        <% String[] categorias = {"Frutas", "Verduras", "Abarrotes", "Bebidas", "Limpieza", "Cuidado Personal", "Mascotas"};
                            String catSel = request.getParameter("categoria");
                            for (String c : categorias) {%>
                        <option value="<%= c%>" <%= c.equals(catSel) ? "selected" : ""%>><%= c%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-buscar w-100">Buscar</button>
                </div>
            </form>

            <h3 class="text-center mb-3">📦 Stock de Productos</h3>

            <div class="table-responsive">
                <table class="table table-bordered text-center align-middle shadow-sm">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th><th>Nombre</th><th>Descripción</th><th>Precio</th><th>Stock</th>
                            <th>Unidad</th><th>Imagen</th><th>Categoría</th><th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection conn = clases.ConexionDB.getConnection();
                                Statement stmt = conn.createStatement();
                                String filtro = request.getParameter("buscar");
                                String categoria = request.getParameter("categoria");
                                String query = "SELECT * FROM productos WHERE 1=1";
                                if (filtro != null && !filtro.trim().isEmpty()) {
                                    query += " AND nombre LIKE '%" + filtro + "%'";
                                }
                                if (categoria != null && !categoria.trim().isEmpty()) {
                                    query += " AND categoria = '" + categoria + "'";
                                }
                                ResultSet rs = stmt.executeQuery(query);
                                int i = 1;
                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= i++%></td>
                            <td><%= rs.getString("nombre")%></td>
                            <td><%= rs.getString("descripcion")%></td>
                            <td>S/ <%= rs.getDouble("precio")%></td>
                            <td><%= rs.getInt("stock")%></td>
                            <td><%= rs.getString("unidad")%></td>
                            <td>
                                <% String img = rs.getString("imagen_url"); %>
                                <% if (img != null && !img.trim().isEmpty()) {%>
                                <img src="../images/<%= img%>" alt="Imagen" width="60" height="60" style="object-fit: cover; border-radius: 6px;">
                                <% } else { %>
                                <span class="text-muted">Sin imagen</span>
                                <% }%>
                            </td>
                            <td><%= rs.getString("categoria")%></td>
                            <td>
                                <form method="get" onsubmit="return confirm('¿Eliminar producto?');">
                                    <input type="hidden" name="eliminar_id" value="<%= rs.getInt("id")%>">
                                    <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                </form>
                                <form method="get" action="EditarProducto.jsp" class="mt-1">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id")%>">
                                    <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                </form>
                            </td>
                        </tr>
                        <% }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='9'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
