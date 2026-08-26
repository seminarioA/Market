<%-- 
    Document   : historialAdmin
    Created on : 21 jul. 2025, 13:42:46
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Historial del Administrador</title>
        <meta charset="UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            /* Paleta cálida */
            body {
                background-color: #fff8f1;
            }

            .card-header {
                background-color: #f57c00;
                color: white;
            }

            /* Badge personalizados cálidos */
            .badge-edit {
                background-color: #ffb300;
                color: #fff;
            }

            .badge-delete {
                background-color: #e53935;
                color: #fff;
            }

            .badge-add {
                background-color: #43a047;
                color: #fff;
            }

            .change-item {
                margin-bottom: 3px;
            }

            .change-item i {
                margin-right: 6px;
                color: #f57c00;
            }

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
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h2 class="mb-0"><i class="bi bi-clock-history"></i> Historial de Acciones</h2>
                </div>

                <!-- Botón volver en la parte superior -->
                <div class="text-start mt-3 ms-3">
                    <a href="../jsp-Productos/producto.jsp" class="btn btn-warm btn-sm">
                        <i class="bi bi-arrow-left"></i> Volver a Productos
                    </a>
                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha</th>
                                    <th>Acción</th>
                                    <th>Producto ID</th>
                                    <th>Detalles de Cambios</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Connection conn = clases.ConexionDB.getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery(
                                                "SELECT * FROM historial_admin ORDER BY fecha DESC LIMIT 100");

                                        while (rs.next()) {
                                            String accion = rs.getString("accion");
                                            String detalles = rs.getString("detalles");
                                %>
                                <tr>
                                    <td><%= rs.getTimestamp("fecha")%></td>
                                    <td>
                                        <span class="badge 
                                              <%=accion.equals("EDITAR") ? "badge-edit"
                                                      : accion.equals("ELIMINAR") ? "badge-delete"
                                                      : "badge-add"%>">
                                            <%= accion%>
                                        </span>
                                    </td>
                                    <td>#<%= rs.getInt("id_afectado")%></td>
                                    <td>
                                        <% if (detalles != null && !detalles.isEmpty()) {
                                                String[] cambios = detalles.split("\\|");
                                                for (String cambio : cambios) {
                                                    if (!cambio.trim().isEmpty()) {%>
                                        <div class="change-item">
                                            <i class="bi <%=cambio.contains("Nombre") ? "bi-tag"
                                                    : cambio.contains("Descripción") ? "bi-card-text"
                                                    : cambio.contains("Precio") ? "bi-cash"
                                                    : cambio.contains("Stock") ? "bi-box-seam"
                                                    : cambio.contains("Unidad") ? "bi-rulers"
                                                    : cambio.contains("Imagen") ? "bi-image"
                                                    : cambio.contains("Categoría") ? "bi-bookmark"
                                                    : "bi-info-circle"%>"></i>
                                            <%= cambio.trim()%>
                                        </div>
                                        <% }
                                                }
                                            } %>
                                    </td>
                                </tr>
                                <% }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {%>
                                <tr>
                                    <td colspan="4" class="text-center text-danger">
                                        <i class="bi bi-exclamation-triangle"></i> Error al cargar historial: <%= e.getMessage()%>
                                    </td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>

                    <div class="text-center mt-4">
                        <a href="../jsp-Productos/producto.jsp" class="btn btn-warm">
                            <i class="bi bi-arrow-left"></i> Volver a Productos
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
