<%-- 
    Document   : historialProveedor
    Created on : 21 jul. 2025, 16:04:48
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idProveedor = request.getParameter("id");
    String nombreProveedor = "";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Historial de Proveedor - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            .badge-compra {
                background-color: #20c997;
            }
            .badge-edicion {
                background-color: #fd7e14;
            }
            .badge-eliminacion {
                background-color: #dc3545;
            }
            .timeline {
                border-left: 3px solid #0d6efd;
            }
            .timeline-item {
                position: relative;
                padding-left: 20px;
                margin-bottom: 20px;
            }
            .timeline-dot {
                position: absolute;
                left: -10px;
                top: 5px;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: #0d6efd;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="mb-0"><i class="bi bi-clock-history"></i> Historial Completo</h4>
                        <a href="Proveedores.jsp" class="btn btn-light btn-sm">
                            <i class="bi bi-arrow-left"></i> Volver
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <% if (idProveedor != null) {
                            try (Connection con = clases.ConexionDB.getConnection()) {
                                PreparedStatement ps = con.prepareStatement("SELECT nombre FROM proveedores WHERE id = ?");
                                ps.setString(1, idProveedor);
                                ResultSet rs = ps.executeQuery();
                                if (rs.next()) {
                                    nombreProveedor = rs.getString("nombre");
                    %>
                    <h5 class="mb-4">Proveedor: <strong><%= nombreProveedor%></strong></h5>
                    <%      }
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error al cargar proveedor: " + e.getMessage() + "</div>");
                        }
                    } %>

                    <!-- Filtros -->
                    <form method="get" class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Proveedor</label>
                            <select name="id" class="form-select">
                                <option value="">Todos los proveedores</option>
                                <%
                                    try (Connection con = clases.ConexionDB.getConnection()) {
                                        Statement st = con.createStatement();
                                        ResultSet rs = st.executeQuery("SELECT id, nombre FROM proveedores WHERE activo = TRUE");
                                        while (rs.next()) {
                                %>
                                <option value="<%= rs.getInt("id")%>" <%= idProveedor != null && idProveedor.equals(rs.getString("id")) ? "selected" : ""%>>
                                    <%= rs.getString("nombre")%>
                                </option>
                                <%
                                        }
                                    } catch (Exception e) {
                                        out.println("<option value=''>Error al cargar proveedores</option>");
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Acción</label>
                            <select name="accion" class="form-select">
                                <option value="">Todas</option>
                                <option value="COMPRA_PROV">Compras</option>
                                <option value="EDITAR">Ediciones</option>
                                <option value="ELIMINAR">Eliminaciones</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Fecha desde</label>
                            <input type="date" name="fecha_desde" class="form-control">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-funnel"></i> Filtrar
                            </button>
                        </div>
                    </form>

                    <!-- Lista de eventos -->
                    <div class="timeline">
                        <%
                            String filtroAccion = request.getParameter("accion");
                            String filtroFecha = request.getParameter("fecha_desde");

                            try (Connection con = clases.ConexionDB.getConnection()) {
                                String sql = "SELECT h.*, p.nombre AS proveedor_nombre "
                                        + "FROM historial_admin h "
                                        + "LEFT JOIN proveedores p ON h.id_afectado = p.id "
                                        + "WHERE h.tabla_afectada IN ('proveedores', 'compras_proveedores') ";

                                if (idProveedor != null) {
                                    sql += "AND h.id_afectado = " + idProveedor + " ";
                                }
                                if (filtroAccion != null && !filtroAccion.isEmpty()) {
                                    sql += "AND h.accion = '" + filtroAccion + "' ";
                                }
                                if (filtroFecha != null && !filtroFecha.isEmpty()) {
                                    sql += "AND DATE(h.fecha) >= '" + filtroFecha + "' ";
                                }

                                sql += "ORDER BY h.fecha DESC LIMIT 50";

                                Statement st = con.createStatement();
                                ResultSet rs = st.executeQuery(sql);

                                while (rs.next()) {
                                    String badgeClass = "";
                                    String icon = "";

                                    if (rs.getString("accion").equals("COMPRA_PROV")) {
                                        badgeClass = "badge-compra";
                                        icon = "<i class='bi bi-cart-check'></i>";
                                    } else if (rs.getString("accion").equals("EDITAR")) {
                                        badgeClass = "badge-edicion";
                                        icon = "<i class='bi bi-pencil'></i>";
                                    } else {
                                        badgeClass = "badge-eliminacion";
                                        icon = "<i class='bi bi-trash'></i>";
                                    }
                        %>
                        <div class="timeline-item card mb-2">
                            <div class="timeline-dot"></div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="badge <%= badgeClass%>">
                                        <%= icon%> <%= rs.getString("accion")%>
                                    </span>
                                    <small class="text-muted">
                                        <%= rs.getTimestamp("fecha")%>
                                    </small>
                                </div>
                                <% if (idProveedor == null) {%>
                                <p class="mb-1"><strong>Proveedor:</strong> <%= rs.getString("proveedor_nombre") != null ? rs.getString("proveedor_nombre") : "N/A"%></p>
                                <% }%>
                                <p class="mb-1"><strong>Detalles:</strong> <%= rs.getString("detalles")%></p>
                                <small class="text-muted">
                                    Por: <%= rs.getString("usuario_admin")%>
                                </small>
                            </div>
                        </div>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error al cargar historial: " + e.getMessage() + "</div>");
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>