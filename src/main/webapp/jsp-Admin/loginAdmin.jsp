<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    boolean accesoPermitido = false;
    String user = request.getParameter("usuario");
    String pass = request.getParameter("clave");

    if (user != null && pass != null) {
        try {
            String url = "jdbc:mysql://localhost:3306/bd_registro";
            String usuarioBD = "root";
            String claveBD = "";

            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM admin WHERE usuario = ? AND clave = ?");
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                accesoPermitido = true;
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<script>alert('Error de conexión: " + e.getMessage() + "');</script>");
        }

        if (accesoPermitido) {
%>
<script>
    alert("Bienvenido <%= user%>");
    window.location.href = "../jsp-Productos/producto.jsp";
</script>
<%
} else {
%>
<script>
    alert("Usuario o contraseña incorrectos");
    window.location.href = "loginAdmin.jsp";
</script>
<%
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Login Administrador</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/estilos.css" rel="stylesheet">
        <style>
            /* Estilos adicionales para el reloj */
            .header-login {
                border-bottom: 1px solid #eee;
                padding-bottom: 1rem;
                margin-bottom: 1.5rem;
            }
            #clock {
                font-size: 0.9rem;
                color: #666;
            }

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

        </style>
    </head>
    <body class="bg-light d-flex align-items-center justify-content-center" style="height:100vh;">

        <form action="loginAdmin.jsp" method="post">
            <div class="card p-4 shadow" style="width: 22rem;">
                <!-- Encabezado con nombre y reloj -->
                <div class="header-login text-center">
                    <h4 class="mb-2">MINIMARKET ANAIS</h4>
                    <div id="clock" class="mb-3"></div>
                    <h5 class="text-muted">Administrador</h5>
                </div>

                <div class="mb-3">
                    <label for="usuario" class="form-label">Nombre</label>
                    <input type="text" name="usuario" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label for="clave" class="form-label">Contraseña</label>
                    <input type="password" name="clave" class="form-control" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-warm">Iniciar Sesión</button>
                    <a href="../jsp-Interfaz/interfaz.jsp" class="btn btn-outline-warm">Salir</a>
                </div>

            </div>

        </form>

        <!-- Script del reloj -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const reloj = document.getElementById('clock');
                if (!reloj)
                    return;

                function actualizarReloj() {
                    const ahora = new Date();
                    const opciones = {
                        weekday: 'short',
                        day: '2-digit',
                        month: 'short',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    };
                    reloj.textContent = ahora.toLocaleDateString('es-PE', opciones);
                }

                actualizarReloj();
                setInterval(actualizarReloj, 1000);
            });
        </script>

    </body>
</html>