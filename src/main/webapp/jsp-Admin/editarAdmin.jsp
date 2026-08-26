<%-- 
    Document   : editarAdmin
    Created on : 12 jul. 2025, 15:10:27
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    String usuarioActual = "";
    String claveActual = "";

    String url = "jdbc:mysql://localhost:3306/bd_registro";
    String usuarioBD = "root";
    String claveBD = "";

    if (request.getParameter("guardar") != null) {
        String nuevoUsuario = request.getParameter("nuevo_usuario");
        String nuevaClave = request.getParameter("nueva_clave");

        // ✅ Validación en el servidor
        if (nuevoUsuario == null || nuevoUsuario.trim().length() < 3
                || nuevaClave == null || nuevaClave.trim().length() < 4) {
%>
<script>
    alert("El usuario debe tener al menos 3 caracteres y la contraseña mínimo 4.");
    window.location.
            = "editarAdmin.jsp";
</script>
<%
        return;
    }

    try {
        Connection conn = clases.ConexionDB.getConnection();
        PreparedStatement ps = conn.prepareStatement("UPDATE admin SET usuario = ?, clave = ? WHERE id = 1");

        ps.setString(1, nuevoUsuario);
        ps.setString(2, nuevaClave);
        int actualizado = ps.executeUpdate();

        ps.close();
        conn.close();

        if (actualizado > 0) {
%>
<script>
    alert("Datos actualizados correctamente.");
    window.location.href = "../jsp-Productos/producto.jsp";
</script>
<%
            } else {
                out.println("<p style='color:red;'>No se actualizó ningún registro.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        // Obtener datos actuales
        try {
            Connection conn = clases.ConexionDB.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM admin LIMIT 1");

            if (rs.next()) {
                usuarioActual = rs.getString("usuario");
                claveActual = rs.getString("clave");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error al cargar los datos: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Datos del Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow col-md-6 mx-auto">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Editar Datos del Administrador</h5>
                </div>
                <div class="card-body">
                    <form method="post" action="editarAdmin.jsp" onsubmit="return validarFormulario()">
                        <input type="hidden" name="guardar" value="1">
                        <div class="mb-3">
                            <label>Usuario:</label>
                            <input type="text" class="form-control" name="nuevo_usuario" value="<%= usuarioActual%>" required>
                        </div>
                        <div class="mb-3 position-relative">
                            <label>Contraseña:</label>
                            <input type="password" class="form-control" id="clave" name="nueva_clave" value="<%= claveActual%>" required>
                            <i class="bi bi-eye-fill position-absolute top-50 end-0 translate-middle-y me-3 cursor-pointer" onclick="togglePassword(this)"></i>
                        </div>


                        <div class="d-grid">
                            <button type="submit" class="btn btn-success">Guardar Cambios</button>
                            <a href="../jsp-Productos/producto.jsp" class="btn btn-secondary mt-2">Cancelar</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Validación de datos  -->
        <script>
            function validarFormulario() {
                const usuario = document.forms[0]["nuevo_usuario"].value.trim();
                const clave = document.forms[0]["nueva_clave"].value;

                if (usuario.length < 3) {
                    alert("El nombre de usuario debe tener al menos 3 caracteres.");
                    return false;
                }

                if (clave.length < 4) {
                    alert("La contraseña debe tener al menos 4 caracteres.");
                    return false;
                }

                return true;
            }
        </script>

        <!-- Diseño-->
        <script>
            function togglePassword(icon) {
                const input = document.getElementById("clave");
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
