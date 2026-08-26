<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    String correoCliente = (String) session.getAttribute("correoCliente");

    if (correoCliente == null) {
        response.sendRedirect("../jsp-Usuarios/login.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/bd_registro";
    String usuario = "root";
    String clave = "";

    List<Map<String, Object>> historial = new ArrayList<>();

    try {
        Connection conn = clases.ConexionDB.getConnection();

        PreparedStatement ps = conn.prepareStatement(
                "SELECT producto, precio, cantidad, unidad, subtotal, fecha FROM historial_compras WHERE correo_usuario = ? ORDER BY fecha DESC"
        );
        ps.setString(1, correoCliente);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> compra = new HashMap<>();
            compra.put("producto", rs.getString("producto"));
            compra.put("precio", rs.getDouble("precio"));
            compra.put("cantidad", rs.getInt("cantidad"));
            compra.put("unidad", rs.getString("unidad"));
            compra.put("subtotal", rs.getDouble("subtotal"));
            compra.put("fecha", rs.getTimestamp("fecha"));
            historial.add(compra);
        }

        rs.close();
        ps.close();
        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Historial de Compras</title>
        <link rel="stylesheet" href="../css/estilos.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">🧾 Historial de Compras</h3>
                    <p class="mb-0">Cliente: <%= session.getAttribute("usuarioNombre")%></p>
                </div>
                <div class="card-body">
                    <% if (historial.isEmpty()) { %>
                    <div class="alert alert-info text-center">
                        No hay compras registradas aún.
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <thead class="table-success">
                                <tr>
                                    <th>Producto</th>
                                    <th>Precio</th>
                                    <th>Cantidad</th>
                                    <th>Unidad</th>
                                    <th>Subtotal</th>
                                    <th>Fecha</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> compra : historial) {%>
                                <tr>
                                    <td><%= compra.get("producto")%></td>
                                    <td>S/ <%= compra.get("precio")%></td>
                                    <td><%= compra.get("cantidad")%></td>
                                    <td><%= compra.get("unidad")%></td>
                                    <td>S/ <%= String.format("%.2f", compra.get("subtotal"))%></td>
                                    <td><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(compra.get("fecha"))%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% }%>

                    <div class="text-center mt-4">
                        <a href="interfaz.jsp" class="btn btn-primary">Volver al Inicio</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>