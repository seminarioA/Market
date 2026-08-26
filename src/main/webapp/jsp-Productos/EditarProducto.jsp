<%-- 
    Document   : EditarProducto
    Created on : 12 jul. 2025, 13:54:49
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    String idParam = request.getParameter("id");
    int id = Integer.parseInt(idParam);

    String url = "jdbc:mysql://localhost:3306/bd_registro";
    String usuario = "root";
    String clave = "";

    String nombre = "", descripcion = "", unidad = "", categoria = "", imagen_url = "", cantidadUnidad = "";
    double precio = 0;
    int stock = 0;

    if (request.getParameter("guardar") == null) {
        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM productos WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nombre = rs.getString("nombre");
                descripcion = rs.getString("descripcion");
                precio = rs.getDouble("precio");
                stock = rs.getInt("stock");
                unidad = rs.getString("unidad");
                categoria = rs.getString("categoria");
                imagen_url = rs.getString("imagen_url");

                // Separar cantidad y unidad
                String[] partesUnidad = unidad.split(" ");
                cantidadUnidad = partesUnidad.length > 0 ? partesUnidad[0] : "";
                unidad = partesUnidad.length > 1 ? partesUnidad[1] : "";
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error al cargar producto: " + e.getMessage() + "</p>");
        }
    } else {
        // Actualización del producto
        nombre = request.getParameter("nombre");
        descripcion = request.getParameter("descripcion");
        precio = Double.parseDouble(request.getParameter("precio"));
        stock = Integer.parseInt(request.getParameter("stock"));
        String cantidad = request.getParameter("cantidad");
        String unidadSeleccionada = request.getParameter("unidad");
        String unidadCompleta = cantidad + " " + unidadSeleccionada;
        categoria = request.getParameter("categoria");
        imagen_url = request.getParameter("imagen");

        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE productos SET nombre=?, descripcion=?, precio=?, stock=?, unidad=?, imagen_url=?, categoria=? WHERE id=?"
            );
            ps.setString(1, nombre);
            ps.setString(2, descripcion);
            ps.setDouble(3, precio);
            ps.setInt(4, stock);
            ps.setString(5, unidadCompleta);
            ps.setString(6, imagen_url);
            ps.setString(7, categoria);
            ps.setInt(8, id);

            ps.executeUpdate();
            ps.close();
            conn.close();

            response.sendRedirect("../jsp-Productos/producto.jsp");
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error al actualizar: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Editar Producto</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h3 class="text-center mb-4">Editar Producto</h3>
            <form method="post" action="EditarProducto.jsp?id=<%= id%>">
                <input type="hidden" name="guardar" value="1">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label>Nombre:</label>
                        <input type="text" name="nombre" class="form-control" value="<%= nombre%>" required>
                    </div>
                    <div class="col-md-6">
                        <label>Descripción:</label>
                        <input type="text" name="descripcion" class="form-control" value="<%= descripcion%>" required>
                    </div>
                    <div class="col-md-4">
                        <label>Precio (S/):</label>
                        <input type="number" name="precio" step="0.01" class="form-control" value="<%= precio%>" required>
                    </div>
                    <div class="col-md-4">
                        <label>Stock:</label>
                        <input type="number" name="stock" class="form-control" value="<%= stock%>" required>
                    </div>
                    <div class="col-md-4">
                        <label>Cantidad:</label>
                        <input type="number" name="cantidad" class="form-control" step="0.01" min="0.01" value="<%= cantidadUnidad%>" required>

                    </div>
                    <div class="col-md-4">
                        <label>Unidad:</label>
                        <select name="unidad" class="form-select" required>
                            <option value="Kilogramos" <%= unidad.equals("Kilogramos") ? "selected" : ""%>>Kilogramos</option>
                            <option value="Gramos" <%= unidad.equals("Gramos") ? "selected" : ""%>>Gramos</option>
                            <option value="Litros" <%= unidad.equals("Litros") ? "selected" : ""%>>Litros</option>
                            <option value="Mililitros" <%= unidad.equals("Mililitros") ? "selected" : ""%>>Mililitros</option>
                            <option value="Unidad" <%= unidad.equals("Unidad") ? "selected" : ""%>>Unidad</option>
                            <option value="Paquete" <%= unidad.equals("Paquete") ? "selected" : ""%>>Paquete</option>
                            <option value="Caja" <%= unidad.equals("Caja") ? "selected" : ""%>>Caja</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label>Categoría:</label>
                        <input type="text" name="categoria" class="form-control" value="<%= categoria%>" required>
                    </div>
                    <div class="col-md-8">
                        <label>URL de Imagen:</label>
                        <input type="text" name="imagen" class="form-control" value="<%= imagen_url%>">
                    </div>
                </div>
                <div class="d-grid mt-4">
                    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                    <a href="producto.jsp" class="btn btn-secondary mt-2">Cancelar</a>
                </div>
            </form>
        </div>
    </body>
</html>
