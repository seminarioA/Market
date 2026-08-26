/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/editar-usuario")
public class EditarUsuarioServlet extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/bd_registro";
    private final String usuario = "root";
    private final String clave = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String correoOriginal = (String) session.getAttribute("correoCliente");

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String nuevoCorreo = request.getParameter("correo").toLowerCase();
        String contrasena = request.getParameter("contrasena");

        try {
            Connection con = clases.ConexionDB.getConnection();

            PreparedStatement ps = con.prepareStatement(
                    "UPDATE usuarios SET nombre = ?, apellidos = ?, correo = ?, contrasena = ? WHERE correo = ?"
            );

            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, nuevoCorreo);
            ps.setString(4, contrasena);
            ps.setString(5, correoOriginal);

            int filas = ps.executeUpdate();

            if (filas > 0) {
                session.setAttribute("usuarioNombre", nombre + " " + apellidos);
                session.setAttribute("correoCliente", nuevoCorreo);
                response.sendRedirect("jsp-Usuarios/editarUsuario.jsp?exito=1");

            } else {
                response.sendRedirect("jsp-Usuarios/editarUsuario.jsp?error=No se pudo actualizar");
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp-Usuarios/editarUsuario.jsp?error=Error: " + e.getMessage());
        }
    }
}
