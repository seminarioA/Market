<%-- 
    Document   : carrito
    Created on : 16 jul. 2025, 16:27:02
    Author     : Jerss
--%>

<%@ page import="java.util.*" %>
<%@ page import="modelo.CarritoItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String usuarioNombre = (String) session.getAttribute("usuarioNombre");
    List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
    double total = 0;
    String fechaCompra = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new Date());
    String horaCompra = new java.text.SimpleDateFormat("HH:mm:ss").format(new Date());
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Carrito de Compras</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            /* boton personalizado*/
            button.btn-success {
                font-weight: bold;
                border-radius: 10px;
                transition: all 0.3s ease;
                box-shadow: 0 0 4px rgba(76, 175, 80, 0.3);
            }

            button.btn-success:hover {
                transform: scale(1.07);
                box-shadow: 0 0 10px rgba(76, 175, 80, 0.7);
                background-color: #43a047; /* tono más oscuro */
                color: white;
            }
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
            .btn-volver {
                background-color: #2196F3;
                color: white;
                border: none;
            }

            .btn-volver:hover {
                background-color: #1565c0;
            }

        </style>
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h2 class="mb-4">🛒 Carrito de Compras</h2>

            <% if (usuarioNombre != null) {%>
            <p class="fw-bold">Hola, <%= usuarioNombre%> 👋</p>
            <p>📅 Fecha: <%= fechaCompra%> - 🕓 Hora: <%= horaCompra%></p>
            <% } %>

            <% if (carrito != null && !carrito.isEmpty()) { %>
            <table class="table table-bordered">
                <thead class="table-warning">
                    <tr>
                        <th>Producto</th>
                        <th>Precio</th>
                        <th>Cantidad</th>
                        <th>Unidad</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CarritoItem item : carrito) {
                            total += item.getSubtotal();
                    %>
                    <tr>
                        <td><%= item.getNombre()%></td>
                        <td>S/ <%= item.getPrecio()%></td>
                        <td><%= item.getCantidad()%></td>
                        <td><%= item.getUnidad()%></td>
                        <td>S/ <%= String.format("%.2f", item.getSubtotal())%></td>
                    </tr>
                    <% }%>
                </tbody>
            </table>

            <h4 class="text-end">Total: <strong>S/ <%= String.format("%.2f", total)%></strong></h4>

            <form action="finalizar-compra.jsp" method="post" class="text-end">
                <button type="submit" class="btn btn-success">Finalizar Compra</button>
            </form>

            <% } else { %>
            <div class="alert alert-info">Tu carrito está vacío.</div>
            <% }%>

            <a href="interfaz.jsp" class="btn btn-volver btn-animado mt-3">← Seguir Comprando</a>

        </div>
    </body>
</html>
