<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="modelo.CarritoItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    String correoCliente = (String) session.getAttribute("correoCliente");

    if (correoCliente == null || correoCliente.isEmpty()) {
        response.sendRedirect("../jsp-Usuarios/login.jsp");
        return;
    }

    String usuarioNombre = (String) session.getAttribute("usuarioNombre");
    List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");

    if (carrito == null || carrito.isEmpty()) {
        response.sendRedirect("carrito.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/bd_registro";
    String usuario = "root";
    String clave = "";

    boolean exito = true;
    String mensaje = "";
    double total = 0;
    String fecha = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new Date());
    String hora = new java.text.SimpleDateFormat("HH:mm:ss").format(new Date());

    Connection conn = null;

    try {
        conn = clases.ConexionDB.getConnection();
        conn.setAutoCommit(false);

        // 1. Verificar stock y actualizar productos
        for (CarritoItem item : carrito) {
            PreparedStatement psCheck = conn.prepareStatement("SELECT stock FROM productos WHERE id = ?");
            psCheck.setInt(1, item.getId());
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                int stockActual = rs.getInt("stock");
                if (stockActual < item.getCantidad()) {
                    exito = false;
                    mensaje = "❌ No hay suficiente stock para " + item.getNombre();
                    break;
                }
            } else {
                exito = false;
                mensaje = "❌ Producto no encontrado: " + item.getNombre();
                break;
            }
            rs.close();
            psCheck.close();
        }

        // 2. Si todo está bien, proceder con la compra
        if (exito) {
            // Actualizar stock
            for (CarritoItem item : carrito) {
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE productos SET stock = stock - ? WHERE id = ?");
                psUpdate.setInt(1, item.getCantidad());
                psUpdate.setInt(2, item.getId());
                psUpdate.executeUpdate();
                psUpdate.close();
            }

            // Insertar en historial
            PreparedStatement psHistorial = conn.prepareStatement(
                    "INSERT INTO historial_compras (correo_usuario, producto, precio, cantidad, unidad, subtotal, fecha) VALUES (?, ?, ?, ?, ?, ?, NOW())"
            );

            for (CarritoItem item : carrito) {
                double subtotal = item.getPrecio() * item.getCantidad();
                psHistorial.setString(1, correoCliente.toLowerCase());
                psHistorial.setString(2, item.getNombre());
                psHistorial.setDouble(3, item.getPrecio());
                psHistorial.setInt(4, item.getCantidad());
                psHistorial.setString(5, item.getUnidad());
                psHistorial.setDouble(6, subtotal);
                psHistorial.executeUpdate();

                total += subtotal;
            }
            psHistorial.close();

            conn.commit();
            mensaje = "✅ ¡Compra realizada con éxito!";
            session.setAttribute("carrito_final", carrito);
            session.removeAttribute("carrito");
        } else {
            conn.rollback();
        }

    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
            }
        }
        exito = false;
        mensaje = "❌ Error al finalizar la compra: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Boleta de Compra</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background-color: #fff3e0; /* fondo cálido */
            }

            .card {
                border: 2px solid #f57c00;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(245, 124, 0, 0.2);
            }

            .card-header {
                background-color: #f57c00;
                border-bottom: 3px solid #ffa000;
            }

            .card-header h4 {
                font-weight: bold;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
            }

            .table-striped > tbody > tr:nth-of-type(odd) {
                background-color: #fff8e1; /* muy suave */
            }

            .table th {
                background-color: #ffe0b2;
                color: #bf360c;
                font-weight: bold;
            }

            .btn-warm {
                background-color: #f57c00;
                color: white;
                border: 2px solid #f57c00;
                transition: all 0.3s ease;
                font-weight: bold;
                border-radius: 8px;
                box-shadow: 0 0 5px rgba(245, 124, 0, 0.5);
            }

            .btn-warm:hover {
                transform: scale(1.07);
                background-color: #ffa040;
                border-color: #ff9800;
                box-shadow: 0 0 12px 3px rgba(255, 152, 0, 0.7);
            }

            .btn-lg {
                padding: 10px 24px;
                font-size: 1.1rem;
                border-radius: 8px;
                transition: all 0.3s ease;
                font-weight: bold;
            }

            .btn-danger {
                background-color: #e64a19;
                border: none;
            }

            .btn-danger:hover {
                background-color: #d84315;
                box-shadow: 0 0 12px rgba(230, 74, 25, 0.6);
                transform: scale(1.05);
            }

            .btn-primary {
                background-color: #ffb300;
                border: none;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #ffa000;
                transform: scale(1.05);
                box-shadow: 0 0 12px rgba(255, 160, 0, 0.6);
            }

            .btn-info {
                background-color: #29b6f6;
                border: none;
                color: #fff;
            }

            .btn-info:hover {
                background-color: #0288d1;
                transform: scale(1.05);
                box-shadow: 0 0 12px rgba(2, 136, 209, 0.6);
            }

            .alert-success {
                background-color: #c8e6c9;
                color: #2e7d32;
                font-weight: bold;
            }

            .alert-danger {
                background-color: #ffcdd2;
                color: #c62828;
                font-weight: bold;
            }

            h5.text-end strong {
                color: #e65100;
            }
            .alert-warm {
                background-color: #ffe0b2; /* fondo cálido */
                color: #bf360c;            /* texto oscuro cálido */
                border: 2px solid #f57c00;
                font-weight: bold;
                box-shadow: 0 0 12px rgba(245, 124, 0, 0.3);
                border-radius: 8px;
                animation: aparecer 0.5s ease;
            }

            @keyframes aparecer {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

        </style>

    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow">
                <div class="card-header text-white text-center" style="background-color: #f57c00;">

                    <h4>🧾 Boleta de Compra</h4>
                </div>
                <div class="card-body">
                    <% if (exito) {%>
                    <p><strong>Cliente:</strong> <%= usuarioNombre%></p>
                    <p><strong>Correo:</strong> <%= correoCliente%></p>
                    <p><strong>Fecha:</strong> <%= fecha%> - <strong>Hora:</strong> <%= hora%></p>
                    <hr>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Precio</th>
                                <th>Cantidad</th>
                                <th>Unidad</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CarritoItem item : carrito) {%>
                            <tr>
                                <td><%= item.getNombre()%></td>
                                <td>S/ <%= item.getPrecio()%></td>
                                <td><%= item.getCantidad()%></td>
                                <td><%= item.getUnidad()%></td>
                                <td>S/ <%= String.format("%.2f", item.getPrecio() * item.getCantidad())%></td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                    <h5 class="text-end">Total a pagar: <strong>S/ <%= String.format("%.2f", total)%></strong></h5>

                    <div class="alert alert-warm text-center mt-4">

                        <%= mensaje%>
                    </div>

                    <div class="text-center mt-4">
                        <!-- Botón para descargar PDF -->
                        <a href="${pageContext.request.contextPath}/generar-boleta" 
                           class="btn btn-danger btn-lg" 
                           target="_blank">
                            <i class="bi bi-file-earmark-pdf"></i> Descargar Boleta PDF
                        </a>

                        <!-- Botón para volver al inicio -->
                        <a href="interfaz.jsp" class="btn btn-primary btn-lg ms-3">
                            <i class="bi bi-house"></i> Volver al Inicio
                        </a>

                        <!-- Botón para ver historial -->
                        <a href="historial.jsp" class="btn btn-info btn-lg ms-3">
                            <i class="bi bi-clock-history"></i> Ver Historial
                        </a>
                    </div>
                    <% } else {%>
                    <div class="alert alert-danger text-center">
                        <%= mensaje%>
                    </div>
                    <div class="text-center mt-3">
                        <a href="carrito.jsp" class="btn btn-warning">Volver al Carrito</a>
                    </div>
                    <% }%>
                </div>
            </div>
        </div>

        <script>
            document.querySelector('a[href*="generar-boleta"]').addEventListener('click', function () {
                //aviso 
                alert('Generando tu boleta en PDF...');
            });
        </script>
    </body>
</html>