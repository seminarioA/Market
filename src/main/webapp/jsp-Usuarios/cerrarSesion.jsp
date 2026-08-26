<%-- 
    Document   : cerrarSesion
    Created on : 15 jul. 2025, 18:15:08
    Author     : Jerss
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    session.invalidate();
    response.sendRedirect("../jsp-Interfaz/interfaz.jsp");
%>
