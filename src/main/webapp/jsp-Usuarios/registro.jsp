su<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registro de Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            /* Botones estilizados con animación */
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

            /* Botón Registrar */
            .btn-registrar {
                background-color: #4CAF50;
                color: white;
                border: none;
            }

            .btn-registrar:hover {
                background-color: #388e3c;
            }

            /* Botón Inicio */
            .btn-volver {
                background-color: #2196F3;
                color: white;
                border: none;
            }

            .btn-volver:hover {
                background-color: #1565c0;
            }

            /* Ícono de ojo para contraseñas */
            .cursor-pointer {
                cursor: pointer;
                color: #6c757d;
                font-size: 1.2rem;
            }

            .cursor-pointer:hover {
                color: #ff9800;
            }
        </style>

    </head>


    <body class="bg-light">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white text-center">
                            <h4>Registro de Nuevo Usuario</h4>
                        </div>
                        <div class="card-body">
                            <% if (request.getParameter("error") != null) {%>
                            <div class="alert alert-danger">
                                <%= request.getParameter("error")%>
                            </div>
                            <% }%>

                            <form method="post" action="../registro-nuevo">
                                <div class="mb-3">
                                    <label class="form-label">Nombres:</label>
                                    <input type="text" name="nombre" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Apellidos:</label>
                                    <input type="text" name="apellidos" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Correo Electrónico:</label>
                                    <input type="email" name="correo" class="form-control" required>
                                </div>

                                <div class="mb-3 position-relative">
                                    <label class="form-label">Contraseña:</label>
                                    <input type="password" name="contrasena" id="contrasena" class="form-control" required>
                                    <i class="bi bi-eye-fill position-absolute top-50 end-0 translate-middle-y me-3 cursor-pointer" onclick="togglePassword('contrasena', this)"></i>
                                </div>

                                <div class="mb-3 position-relative">
                                    <label class="form-label">Confirmar Contraseña:</label>
                                    <input type="password" name="confirmar" id="confirmar" class="form-control" required>
                                    <i class="bi bi-eye-fill position-absolute top-50 end-0 translate-middle-y me-3 cursor-pointer" onclick="togglePassword('confirmar', this)"></i>
                                </div>



                                <div class="d-grid">
                                    <button type="submit" class="btn btn-registrar btn-animado">Registrar</button>
                                </div>

                            </form>

                            <div class="mt-3 text-center">
                                ¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a>
                                <a href="../jsp-Interfaz/interfaz.jsp" class="btn btn-volver btn-animado ms-2">Volver al Inicio</a>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function togglePassword(id, icon) {
                const input = document.getElementById(id);
                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove("bi-eye-fill");
                    icon.classList.add("bi-eye-slash-fill");
                } else {
                    input.type = "password";
                    icon.classList.remove("bi-eye-slash-fill");
                    icon.classList.add("bi-eye-fill");
                }
            }
        </script>


    </body>
</html>
