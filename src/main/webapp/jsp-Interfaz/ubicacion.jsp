<%-- 
    Document   : ubicacion
    Created on : 20 jul. 2025, 03:22:16
    Author     : Jerss
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Ubícanos - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            iframe {
                width: 100%;
                height: 500px;
                border: none;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h3 class="mb-4 text-center">📍 Ubícanos</h3>
            <iframe 
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.1519319655324!2d-76.2476843!3d-13.8333986!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x911063c05b97c905%3A0x51b09d4a0f70d9a8!2sMinimarket%20%26%20Licoreria%20Anais!5e0!3m2!1ses!2spe!4v1710800000000" 
                allowfullscreen="" 
                loading="lazy" 
                referrerpolicy="no-referrer-when-downgrade">
            </iframe>
            <div class="text-center mt-3">
                <a href="interfaz.jsp" class="btn btn-primary">← Volver al inicio</a>
            </div>
        </div>
    </body>
</html>
