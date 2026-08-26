<%-- 
    Document   : comprasProveedor
    Created on : 21 jul. 2025, 15:52:53
    Author     : Jerss
--%>

<%@ page import="java.sql.*" %>
<%
    if ("agregar".equals(request.getParameter("accion"))) {
        try {
            Connection con = clases.ConexionDB.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO compras_proveedores (proveedor_id, producto_id, cantidad, precio_unitario) VALUES (?, ?, ?, ?)");
            ps.setInt(1, Integer.parseInt(request.getParameter("proveedor_id")));
            ps.setInt(2, Integer.parseInt(request.getParameter("producto_id")));
            ps.setInt(3, Integer.parseInt(request.getParameter("cantidad")));
            ps.setDouble(4, Double.parseDouble(request.getParameter("precio")));
            ps.executeUpdate();

            // Actualizar stock
            PreparedStatement psStock = con.prepareStatement("UPDATE productos SET stock = stock + ? WHERE id = ?");
            psStock.setInt(1, Integer.parseInt(request.getParameter("cantidad")));
            psStock.setInt(2, Integer.parseInt(request.getParameter("producto_id")));
            psStock.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/jsp-Proveedores/Proveedores.jsp?exito=Compra registrada");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/jsp-Proveedores/Proveedores.jsp?error=" + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Compra de Proveedor</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            .form-container {
                max-width: 600px;
                margin: 40px auto;
                padding: 25px;
                border-radius: 12px;
                background-color: #fff8f0;
                box-shadow: 0 0 12px rgba(0,0,0,0.08);
            }

            h3 {
                color: #e65100;
                font-weight: bold;
                margin-bottom: 25px;
                text-align: center;
            }

            label {
                font-weight: 500;
                color: #5d4037;
            }

            .btn-warm {
                background-color: #f57c00;
                color: white;
                border: none;
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 0 6px rgba(245, 124, 0, 0.4);
            }

            .btn-warm:hover {
                background-color: #ffa040;
                transform: scale(1.05);
                box-shadow: 0 0 10px rgba(255, 152, 0, 0.5);
            }
        </style>
    </head>
    <body class="bg-light">

        <div class="form-container">
            <h3><i class="bi bi-cart-plus-fill"></i> Registrar Compra de Proveedor</h3>

            <form method="post">
                <input type="hidden" name="accion" value="agregar">

                <div class="mb-3">
                    <label for="proveedor">Proveedor</label>
                    <select name="proveedor_id" class="form-select" required>
                        <%
                            Connection con = clases.ConexionDB.getConnection();
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery("SELECT id, nombre FROM proveedores WHERE activo = 1");
                            while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id")%>"><%= rs.getString("nombre")%></option>
                        <% } %>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="producto">Producto</label>
                    <select name="producto_id" class="form-select" required>
                        <%
                            rs = st.executeQuery("SELECT id, nombre FROM productos");
                            while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id")%>"><%= rs.getString("nombre")%></option>
                        <% }
                            rs.close();
                            st.close();
                            con.close();
                        %>
                    </select>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Cantidad</label>
                        <input type="number" name="cantidad" min="1" class="form-control" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Precio Unitario (S/)</label>
                        <input type="number" name="precio" step="0.01" min="0.01" class="form-control" required>
                    </div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-warm">Registrar Compra</button>
                </div>
                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath()%>/jsp-Proveedores/Proveedores.jsp" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Volver a Proveedores
                    </a>
                </div>

            </form>
        </div>

    </body>
</html>
