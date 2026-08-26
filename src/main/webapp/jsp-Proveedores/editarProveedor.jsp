<%-- 
    Document   : editarProveedor
    Created on : 21 jul. 2025, 16:03:48
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%
    String idProveedor = request.getParameter("id");
    String nombre = "", ruc = "", contacto = "", telefono = "", tipo = "";

    if (idProveedor != null) {
        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM proveedores WHERE id = ?");
            ps.setString(1, idProveedor);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nombre = rs.getString("nombre");
                ruc = rs.getString("ruc");
                contacto = rs.getString("contacto");
                telefono = rs.getString("telefono");
                tipo = rs.getString("tipo");
            }
            rs.close();
            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error al cargar proveedor: " + e.getMessage() + "</div>");
        }
    }

    if ("actualizar".equals(request.getParameter("accion"))) {
        nombre = request.getParameter("nombre");
        ruc = request.getParameter("ruc");
        contacto = request.getParameter("contacto");
        telefono = request.getParameter("telefono");
        tipo = request.getParameter("tipo");

        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE proveedores SET nombre=?, ruc=?, contacto=?, telefono=?, tipo=? WHERE id=?");
            ps.setString(1, nombre);
            ps.setString(2, ruc);
            ps.setString(3, contacto);
            ps.setString(4, telefono);
            ps.setString(5, tipo);
            ps.setString(6, idProveedor);
            ps.executeUpdate();

            response.sendRedirect("proveedores.jsp?exito=Proveedor actualizado");
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error al actualizar: " + e.getMessage() + "</div>");
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Proveedor - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            .card-header {
                background-color: #ffc107;
                color: #212529;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Editar Proveedor</h4>
                        </div>
                        <div class="card-body">
                            <form method="post">
                                <input type="hidden" name="accion" value="actualizar">

                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nombre*</label>
                                        <input type="text" name="nombre" class="form-control" value="<%= nombre%>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">RUC*</label>
                                        <input type="text" name="ruc" class="form-control" value="<%= ruc%>" pattern="[0-9]{11}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Contacto*</label>
                                        <input type="text" name="contacto" class="form-control" value="<%= contacto%>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Teléfono</label>
                                        <input type="tel" name="telefono" class="form-control" value="<%= telefono%>">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">Tipo de Productos*</label>
                                        <select name="tipo" class="form-select" required>
                                            <option value="Bebidas" <%= "Bebidas".equals(tipo) ? "selected" : ""%>>Bebidas</option>
                                            <option value="Abarrotes" <%= "Abarrotes".equals(tipo) ? "selected" : ""%>>Abarrotes</option>
                                            <option value="Limpieza" <%= "Limpieza".equals(tipo) ? "selected" : ""%>>Limpieza</option>
                                            <option value="Frutas/Verduras" <%= "Frutas/Verduras".equals(tipo) ? "selected" : ""%>>Frutas/Verduras</option>
                                            <option value="Licores" <%= "Licores".equals(tipo) ? "selected" : ""%>>Licores</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="<%= request.getContextPath()%>/jsp-Proveedores/proveedores.jsp" class="btn btn-secondary">
                                        Cancelar
                                    </a>
                                    <button type="submit" class="btn btn-warning">
                                        <i class="bi bi-check-circle"></i> Actualizar
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>