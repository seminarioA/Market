<%-- 
    Document   : login
    Created on : 11 jul. 2025, 17:55:58
    Author     : Jerss
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Iniciar Sesión - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            /* Estilos new*/
            .btn-animado {
                transition: all 0.3s ease;
                font-weight: bold;
                border-radius: 10px;
                box-shadow: 0 0 6px rgba(255, 152, 0, 0.3);
            }

            .btn-animado:hover {
                transform: scale(1.07);
                box-shadow: 0 0 12px rgba(255, 152, 0, 0.6);
            }

            /* Botón verde */
            .btn-entrar {
                background-color: #4CAF50;
                color: white;
                border: none;
            }

            .btn-entrar:hover {
                background-color: #388e3c;
            }

            /* Botón azul */
            .btn-volver {
                background-color: #2196F3;
                color: white;
                border: none;
            }

            .btn-volver:hover {
                background-color: #1565c0;
            }
        </style>

    </head>
    <body class="bg-light">

        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white text-center">
                            <h4>Iniciar Sesión</h4>
                        </div>
                        <div class="card-body">

                            <% if (request.getParameter("error") != null) {%>
                            <div class="alert alert-danger">
                                <%= request.getParameter("error")%>
                            </div>
                            <% } %>

                            <% if (request.getParameter("registro") != null) { %>
                            <div class="alert alert-success">
                                ✅ Registro exitoso. Inicia sesión.
                            </div>
                            <% }%>

                            <form method="post" action="../login-usuario">
                                <div class="mb-3">
                                    <label class="form-label">Correo Electrónico:</label>
                                    <input type="email" name="correo" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Contraseña:</label>
                                    <input type="password" name="contrasena" class="form-control" required>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-entrar btn-animado">Entrar</button>
                                </div>

                            </form>

                            <div class="mt-3 text-center">
                                ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
                                <a href="../jsp-Interfaz/interfaz.jsp" class="btn btn-volver btn-animado ms-2">Volver al Inicio</a>

                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
