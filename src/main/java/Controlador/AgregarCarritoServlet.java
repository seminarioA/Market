package controlador;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.CarritoItem;

@WebServlet("/agregar-carrito")
public class AgregarCarritoServlet extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/bd_registro";
    private final String usuario = "root";
    private final String clave = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");

        if (carrito == null) {
            carrito = new ArrayList<>();
        }

        boolean encontrado = false;
        for (CarritoItem item : carrito) {
            if (item.getId() == id) {
                item.setCantidad(item.getCantidad() + 1);
                encontrado = true;
                break;
            }
        }

        if (!encontrado) {
            try {
                Connection conn = clases.ConexionDB.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM productos WHERE id = ?");
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    CarritoItem nuevo = new CarritoItem(
                            id,
                            rs.getString("nombre"),
                            rs.getDouble("precio"),
                            1,
                            rs.getString("unidad")
                    );
                    carrito.add(nuevo);
                }

                rs.close();
                ps.close();
                conn.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        session.setAttribute("carrito", carrito);
        response.sendRedirect("jsp-Interfaz/interfaz.jsp");  // o donde quieras redirigir
    }
}
