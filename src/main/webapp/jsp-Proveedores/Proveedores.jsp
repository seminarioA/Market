<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
// Procesar acciones (eliminar/agregar)
    if ("eliminar".equals(request.getParameter("accion"))) {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection con = clases.ConexionDB.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE proveedores SET activo = FALSE WHERE id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Proveedores - Minimarket & Licorería Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #d0f0ff;
            }
            .card-proveedor {
                transition: all 0.3s;
            }
            .card-proveedor:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <!-- Encabezado -->
            <div class="text-center mb-4 p-4 bg-white rounded shadow-sm">
                <h2 class="text-primary"><i class="bi bi-truck"></i> Proveedores</h2>
                <p class="text-muted">Gestión completa de proveedores y compras</p>
                <div>
                    <a href="../jsp-Productos/producto.jsp" class="btn btn-primary">
                        <i class="bi bi-arrow-left"></i> Volver
                    </a>
                    <a href="nuevoProveedor.jsp" class="btn btn-success ms-2">
                        <i class="bi bi-plus-circle"></i> Nuevo Proveedor
                    </a>
                    <a href="comprasProveedor.jsp" class="btn btn-warning ms-2">
                        <i class="bi bi-cart-plus"></i> Registrar Compra
                    </a>
                </div>
            </div>

            <!-- Tarjetas de Proveedores -->
            <div class="row row-cols-1 row-cols-md-3 g-4 mb-4">
                <%
                    try (Connection con = clases.ConexionDB.getConnection()) {
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM proveedores WHERE activo = TRUE");

                        while (rs.next()) {
                %>
                <div class="col">
                    <div class="card card-proveedor h-100 border-primary">
                        <div class="card-header bg-primary text-white">
                            <h5 class="card-title mb-0">
                                <i class="bi bi-building"></i> <%= rs.getString("nombre")%>
                            </h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">
                                <strong><i class="bi bi-person"></i> Contacto:</strong> <%= rs.getString("contacto")%><br>
                                <strong><i class="bi bi-telephone"></i> Teléfono:</strong> <%= rs.getString("telefono")%><br>
                                <strong><i class="bi bi-upc"></i> RUC:</strong> <%= rs.getString("ruc")%>
                            </p>
                        </div>
                        <div class="card-footer bg-transparent">
                            <div class="d-flex justify-content-between">
                                <a href="editarProveedor.jsp?id=<%= rs.getInt("id")%>" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil"></i> Editar
                                </a>
                                <form method="post" class="d-inline">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="id" value="<%= rs.getInt("id")%>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i> Desactivar
                                    </button>
                                </form>
                                <a href="historialProveedor.jsp?id=<%= rs.getInt("id")%>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-clock-history"></i> Historial
                                </a>
                            </div>
                        </div>

                    </div>
                </div>
                <%
                        }
                        rs.close();
                        st.close();
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error al cargar proveedores: " + e.getMessage() + "</div>");
                    }
                %>
            </div>

            <!-- Tabla de Compras Recientes -->
            <div class="card shadow mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="bi bi-clock-history"></i> Últimas Compras</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Proveedor</th>
                                    <th>Producto</th>
                                    <th>Cantidad</th>
                                    <th>Precio Unitario</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection con = clases.ConexionDB.getConnection()) {
                                        String sql = "SELECT cp.*, p.nombre AS nombre_proveedor, pr.nombre AS nombre_producto "
                                                + "FROM compras_proveedores cp "
                                                + "JOIN proveedores p ON cp.proveedor_id = p.id "
                                                + "JOIN productos pr ON cp.producto_id = pr.id "
                                                + "ORDER BY cp.fecha_registro DESC LIMIT 5";
                                        Statement st = con.createStatement();
                                        ResultSet rs = st.executeQuery(sql);

                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getTimestamp("fecha_registro")%></td>
                                    <td><%= rs.getString("nombre_proveedor")%></td>
                                    <td><%= rs.getString("nombre_producto")%></td>
                                    <td><%= rs.getInt("cantidad")%></td>
                                    <td>S/ <%= rs.getDouble("precio_unitario")%></td>
                                    <td class="fw-bold">S/ <%= rs.getInt("cantidad") * rs.getDouble("precio_unitario")%></td>
                                </tr>
                                <%
                                        }
                                        rs.close();
                                        st.close();
                                    } catch (Exception e) {
                                        out.println("<tr><td colspan='6' class='text-center text-danger'>Error al cargar compras: " + e.getMessage() + "</td></tr>");
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>