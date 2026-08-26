package controlador;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/registro-nuevo")
public class RegistroServlet extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/bd_registro";
    private final String usuario = "root";
    private final String clave = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String correo = request.getParameter("correo").toLowerCase();
        String contrasena = request.getParameter("contrasena");
        String confirmar = request.getParameter("confirmar");

        // Validación de contraseña
        if (!contrasena.equals(confirmar)) {
            response.sendRedirect("jsp-Usuarios/registro.jsp?error=Las contraseñas no coinciden");
            return;
        }

        try {
            Connection con = clases.ConexionDB.getConnection();

            // Verificar si el correo ya existe
            PreparedStatement checkStmt = con.prepareStatement("SELECT id FROM usuarios WHERE correo = ?");
            checkStmt.setString(1, correo);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // El correo ya está registrado
                response.sendRedirect("jsp-Usuarios/registro.jsp?error=El correo ya está registrado");
                con.close();
                return;
            }

            // Insertar nuevo usuario
            PreparedStatement insertStmt = con.prepareStatement(
                    "INSERT INTO usuarios (nombre, apellidos, correo, contrasena) VALUES (?, ?, ?, ?)"
            );
            insertStmt.setString(1, nombre);
            insertStmt.setString(2, apellidos);
            insertStmt.setString(3, correo);
            insertStmt.setString(4, contrasena); // opcional: encriptar aquí

            int resultado = insertStmt.executeUpdate();
            con.close();

            if (resultado > 0) {
                // Redirige al login al terminar el registro
                response.sendRedirect("jsp-Usuarios/login.jsp?registro=exito");
            } else {
                response.sendRedirect("jsp-Usuarios/registro.jsp?error=Error al registrar el usuario");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp-Usuarios/registro.jsp?error=Error interno del servidor");
        }
    }
}
