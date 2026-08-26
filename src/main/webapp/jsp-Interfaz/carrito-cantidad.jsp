<%-- 
    Document   : carrito-cantidad
    Created on : 15 jul. 2025, 19:27:59
    Author     : Jerss
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="modelo.CarritoItem" %>
<%@ page session="true" %>

<%
    List<CarritoItem> carrito = (List<CarritoItem>) session.getAttribute("carrito");
    int total = 0;
    if (carrito != null) {
        for (CarritoItem item : carrito) {
            total += item.getCantidad();
        }
    }
%>
<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
    <%= total%>
</span>

