<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if ("agregar".equals(request.getParameter("accion"))) {
        String nombre = request.getParameter("nombre");
        String ruc = request.getParameter("ruc");
        String contacto = request.getParameter("contacto");
        String telefono = request.getParameter("telefono");
        String tipo = request.getParameter("tipo");

        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO proveedores (nombre, ruc, contacto, telefono, tipo) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, nombre);
            ps.setString(2, ruc);
            ps.setString(3, contacto);
            ps.setString(4, telefono);
            ps.setString(5, tipo);
            ps.executeUpdate();

            response.sendRedirect("Proveedores.jsp?exito=Proveedor registrado");

        } catch (Exception e) {
            response.sendRedirect("Proveedores.jsp?error=" + e.getMessage());

        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Nuevo Proveedor - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #fff7ed;
            }

            .card {
                border-radius: 12px;
                border: none;
            }

            .card-header {
                background-color: #f57c00;
                color: white;
                font-weight: bold;
                border-radius: 12px 12px 0 0;
            }

            .form-label {
                color: #6d4c41;
                font-weight: 500;
            }

            /* Botón cancelar con estilo neutro */
            .btn-cancelar {
                background-color: #a1887f;
                color: white;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .btn-cancelar:hover {
                background-color: #8d6e63;
                transform: scale(1.05);
                box-shadow: 0 0 8px rgba(141, 110, 99, 0.5);
            }

            /* Botón guardar con estilo cálido */
            .btn-guardar {
                background-color: #f57c00;
                color: white;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .btn-guardar:hover {
                background-color: #ffa040;
                transform: scale(1.05);
                box-shadow: 0 0 10px rgba(255, 152, 0, 0.5);
            }
        </style>
    </head>
    <body>

        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow">
                        <div class="card-header">
                            <h4 class="mb-0"><i class="bi bi-person-plus"></i> Registrar Nuevo Proveedor</h4>
                        </div>
                        <div class="card-body">
                            <form method="post">
                                <input type="hidden" name="accion" value="agregar">

                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Nombre*</label>
                                        <input type="text" name="nombre" class="form-control" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">RUC* (11 dígitos)</label>
                                        <input type="text" name="ruc" class="form-control" pattern="[0-9]{11}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Contacto*</label>
                                        <input type="text" name="contacto" class="form-control" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Teléfono</label>
                                        <input type="tel" name="telefono" class="form-control">
                                    </div>
                                    <div class="col-md-12">
                                        <label class="form-label">Tipo de Productos*</label>
                                        <select name="tipo" class="form-select" required>
                                            <option value="Bebidas">Bebidas</option>
                                            <option value="Abarrotes">Abarrotes</option>
                                            <option value="Limpieza">Limpieza</option>
                                            <option value="Frutas/Verduras">Frutas/Verduras</option>
                                            <option value="Licores">Licores</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="Proveedores.jsp" class="btn btn-cancelar">
                                        <i class="bi bi-x-circle"></i> Cancelar
                                    </a>
                                    <button type="submit" class="btn btn-guardar">
                                        <i class="bi bi-save"></i> Guardar Proveedor
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
