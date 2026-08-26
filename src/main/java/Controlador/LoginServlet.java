package controlador;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/login-usuario")
public class LoginServlet extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/bd_registro";
    private final String usuario = "root";
    private final String clave = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        try {
            Connection con = clases.ConexionDB.getConnection();

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM usuarios WHERE correo = ? AND contrasena = ?"
            );
            ps.setString(1, correo);
            ps.setString(2, contrasena);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                String nombreCompleto = rs.getString("nombre") + " " + rs.getString("apellidos");
                session.setAttribute("usuarioNombre", nombreCompleto);
                session.setAttribute("correoCliente", correo.toLowerCase());
                session.setAttribute("usuarioId", rs.getInt("id"));

                response.sendRedirect("jsp-Interfaz/interfaz.jsp");
            } else {
                response.sendRedirect("jsp-Usuarios/login.jsp?error=Credenciales incorrectas");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp-Usuarios/login.jsp?error=Error del servidor: " + e.getMessage());
        }
    }
}