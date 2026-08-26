<%-- 
    Document   : editarUsuario
    Created on : 21 jul. 2025, 12:44:59
    Author     : Jerss
--%>

<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession sesion = request.getSession();
    String nombreCompleto = (String) sesion.getAttribute("usuarioNombre");
    String correo = (String) sesion.getAttribute("correoCliente");

    if (nombreCompleto == null || correo == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String[] partesNombre = nombreCompleto.split(" ", 2);
    String nombre = partesNombre.length > 0 ? partesNombre[0] : "";
    String apellidos = partesNombre.length > 1 ? partesNombre[1] : "";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Cuenta</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
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

            .btn-volver {
                background-color: #2196F3;
                color: white;
                border: none;
                border-radius: 8px;
            }

            .btn-volver:hover {
                background-color: #1976D2;
            }

            .btn-animado {
                transition: all 0.3s ease;
                font-weight: bold;
                box-shadow: 0 0 6px rgba(255, 152, 0, 0.3);
            }

            .btn-animado:hover {
                transform: scale(1.07);
                box-shadow: 0 0 12px rgba(255, 152, 0, 0.6);
            }

        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-7">
                    <div class="card shadow">
                        <div class="card-header bg-warning text-dark text-center">
                            <h4>Editar Información de Usuario</h4>
                        </div>
                        <div class="card-body">
                            <% if (request.getParameter("exito") != null) { %>
                            <div class="alert alert-success text-center">
                                ✅ Datos actualizados correctamente.
                            </div>
                            <% }%>

                            <form method="post" action="${pageContext.request.contextPath}/editar-usuario">
                                <div class="mb-3">
                                    <label class="form-label">Nombres:</label>
                                    <input type="text" name="nombre" class="form-control" value="<%= nombre%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Apellidos:</label>
                                    <input type="text" name="apellidos" class="form-control" value="<%= apellidos%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Correo Electrónico:</label>
                                    <input type="email" name="correo" class="form-control" value="<%= correo%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Nueva Contraseña:</label>
                                    <input type="password" name="contrasena" class="form-control" placeholder="Dejar en blanco si no deseas cambiar">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Confirmar Contraseña:</label>
                                    <input type="password" name="confirmar" class="form-control" placeholder="Confirmar nueva contraseña">
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="../jsp-Interfaz/interfaz.jsp" class="btn btn-volver btn-animado">Volver</a>
                                    <button type="submit" class="btn btn-warm btn-animado">Guardar Cambios</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
