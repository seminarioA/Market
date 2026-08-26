jsp<%-- 
    Document   : cerrarSesion
    Created on : 12 jul. 2025, 14:40:48
    Author     : Jerss
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Cerrar sesión actual
    session.invalidate();

    // Redirigir al inicio del market
    response.sendRedirect("../jsp-Admin/loginAdmin.jsp");
%>
