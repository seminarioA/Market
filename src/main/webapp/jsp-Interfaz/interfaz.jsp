<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.CarritoItem" %>

<%
    String usuarioNombre = (String) session.getAttribute("usuarioNombre");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Inicio - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link href="../css/estilos.css" rel="stylesheet">
        <style>
            .side-menu {
                background-color: #f8f9fa;
                padding: 15px;
                border-right: 1px solid #ddd;
                height: 100%;
            }
            .side-menu a {
                display: block;
                margin: 5px 0;
                color: #000;
                text-decoration: none;
            }
            .side-menu a:hover {
                text-decoration: underline;
            }
            /* Botón cálido personalizado */
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

            /* Animación extra para resplandor */
            @keyframes glow {
                0% {
                    box-shadow: 0 0 5px rgba(255, 152, 0, 0.5);
                }
                50% {
                    box-shadow: 0 0 15px rgba(255, 152, 0, 0.9);
                }
                100% {
                    box-shadow: 0 0 5px rgba(255, 152, 0, 0.5);
                }
            }

            .btn-warm:hover {
                animation: glow 1.5s infinite;
            }
            .product-card {
                border: 2px solid #f57c00;
                padding: 15px;
                border-radius: 10px;
                background-color: #fff;
                transition: all 0.3s ease;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .product-card:hover {
                transform: scale(1.02);
                border: 2px solid #ffd54f; /*amarillo*/
                box-shadow: 0 0 14px rgba(255, 213, 79, 0.7); /*sombra*/
            }
            /* --- BOTÓN BUSCAR  --- */
            button[type="submit"].btn-primary {
                font-weight: bold;
                border-radius: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 0 6px rgba(33, 150, 243, 0.4);
            }

            button[type="submit"].btn-primary:hover {
                transform: scale(1.05);
                box-shadow: 0 0 12px rgba(33, 150, 243, 0.8);
            }

            /* --- ICONO DE CARRITO --- */
            .nav-link[href="carrito.jsp"] {
                transition: all 0.3s ease;
                font-size: 1.3rem;
                padding: 5px 10px;
                border-radius: 8px;
            }

            .nav-link[href="carrito.jsp"]:hover {
                background-color: rgba(255, 213, 79, 0.25); /* más claro */
                box-shadow: 0 0 10px rgba(255, 213, 79, 0.7); /* sombra cálida */
                transform: scale(1.1);
            }

            /* --- NAV-LINKS: Iniciar Sesión / Registro / Admin --- */
            .nav-link[href*="login.jsp"],
            .nav-link[href*="registro.jsp"],
            .nav-link[href*="Admin"] {
                transition: all 0.3s ease;
                font-weight: bold;
                padding: 6px 10px;
                border-radius: 10px;
            }

            .nav-link[href*="login.jsp"]:hover,
            .nav-link[href*="registro.jsp"]:hover,
            .nav-link[href*="Admin"]:hover {
                background-color: rgba(255, 213, 79, 0.25);
                color: #fff;
                transform: scale(1.07);
                box-shadow: 0 0 8px rgba(255, 213, 79, 0.7);
            }
            /* Mantener menu lateral */
            .side-menu {
                position: sticky;
                top: 80px;
                max-height: calc(100vh - 100px);
                overflow-y: auto;
                z-index: 1000;
            }
            /* Fijador para barra superior */
            .navbar {
                position: sticky;
                top: 0;
                z-index: 1050;
            }
            /*Buscador con estilos personalizados */
            .side-menu a.active-category {
                background-color: #ffe0b2;
                font-weight: bold;
                color: #d84315;
                border-left: 5px solid #f57c00;
                padding-left: 10px;
                border-radius: 4px;
            }

            @media (max-width: 991px) {
                .navbar form {
                    margin-top: 10px;
                    width: 100%;
                    flex-direction: column;
                    align-items: stretch;
                }

                .navbar form input {
                    margin-bottom: 10px;
                }
            }
            /* paleta de colores */
            .btn-buscar {
                background-color: #ffb74d;
                color: #fff;
                font-weight: bold;
                border: none;
                transition: all 0.3s ease;
                border-radius: 8px;
                box-shadow: 0 0 6px rgba(255, 183, 77, 0.4);
            }

            .btn-buscar:hover {
                background-color: #ffa726;
                box-shadow: 0 0 12px rgba(255, 152, 0, 0.7);
                transform: scale(1.05);
            }

            /* alineación verticalmente */
            form[role="search"] input.form-control {
                height: 38px;
            }





        </style>
    </head>
    <body>



        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #f57c00;">
            <div class="container-fluid">
                <!-- Modificacion para nombre de la empresa y reloj -->
                <a class="navbar-brand fw-bold text-white d-flex align-items-center pe-4" href="#">
                    MINIMARKET Y LICORERÍA - ANAIS

                </a>
                <span id="clock" class="ms-2 fs-6 text-white"></span>





                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuSuperior">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="menuSuperior">
                    <div class="d-flex w-100 justify-content-between align-items-center flex-wrap">

                        <!-- CENTRO: BUSCADOR -->
                        <form method="get" action="interfaz.jsp" class="d-flex mx-auto my-2" role="search" style="max-width: 500px; flex-grow: 1; justify-content: center;">
                            <input class="form-control me-2" type="search" name="buscar" placeholder="¿Qué producto buscas?" aria-label="Buscar"
                                   value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
                            <button class="btn btn-buscar" type="submit">Buscar</button>
                        </form>

                        <!-- DERECHA: Enlaces -->
                        <ul class="navbar-nav d-flex align-items-center">
                            <li class="nav-item me-3 position-relative">
                                <a class="nav-link text-white" href="carrito.jsp">
                                    🛒
                                    <span id="carrito-contador">
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                            <%
                                                List<modelo.CarritoItem> carrito = (List<modelo.CarritoItem>) session.getAttribute("carrito");
                                                int cantidadTotal = 0;
                                                if (carrito != null) {
                                                    for (modelo.CarritoItem item : carrito) {
                                                        cantidadTotal += item.getCantidad();
                                                    }
                                                }
                                            %>

                                            <%= cantidadTotal%>
                                        </span>
                                    </span>
                                </a>
                            </li>

                            <% if (usuarioNombre != null) {%>
                            <li class="nav-item dropdown">
                                <button class="btn btn-outline-light rounded-circle dropdown-toggle ms-2" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="width: 45px; height: 45px;">
                                    <%= usuarioNombre.split(" ")[0].charAt(0)%>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><span class="dropdown-item-text"><%= usuarioNombre%></span></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="historial.jsp">📜 Historial de Compras</a></li>
                                    <li><a class="dropdown-item" href="../jsp-Usuarios/editarUsuario.jsp">⚙️ Editar Cuenta</a></li>
                                    <li><a class="dropdown-item text-danger" href="../jsp-Usuarios/cerrarSesion.jsp">Cerrar sesión</a></li>
                                </ul>
                            </li>

                            <% } else { %>
                            <li class="nav-item">
                                <a class="nav-link text-white" href="../jsp-Usuarios/login.jsp">Iniciar Sesión</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-white ms-2" href="../jsp-Usuarios/registro.jsp">Registrarse</a>
                            </li>
                            <% } %>
                            <li class="nav-item">
                                <a class="nav-link text-white ms-2" href="../jsp-Admin/loginAdmin.jsp">Admin</a>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </nav>





        <div class="container-fluid mt-4">
            <div class="row">
                <!-- Menú lateral -->
                <div class="col-md-2">
                    <div class="side-menu">
                        <h5 class="fw-bold mb-3">Categorías</h5>
                        <%
                            String categoriaActiva = request.getParameter("categoria");

                            if (categoriaActiva == null || categoriaActiva.isEmpty()) {
                                String textoBusqueda = request.getParameter("buscar");
                                if (textoBusqueda != null && !textoBusqueda.trim().isEmpty()) {
                                    try {
                                        Connection con = clases.ConexionDB.getConnection();
                                        PreparedStatement ps = con.prepareStatement("SELECT categoria FROM productos WHERE nombre LIKE ? LIMIT 1");
                                        ps.setString(1, "%" + textoBusqueda + "%");
                                        ResultSet rs = ps.executeQuery();
                                        if (rs.next()) {
                                            categoriaActiva = rs.getString("categoria");
                                        }
                                        rs.close();
                                        ps.close();
                                        con.close();
                                    } catch (Exception e) {
                                        categoriaActiva = "";
                                    }
                                }
                            }
                        %>


                        <a href="interfaz.jsp?categoria=Frutas" class="<%= "Frutas".equals(categoriaActiva) ? "active-category" : ""%>">Frutas</a>
                        <a href="interfaz.jsp?categoria=Verduras" class="<%= "Verduras".equals(categoriaActiva) ? "active-category" : ""%>">Verduras</a>
                        <a href="interfaz.jsp?categoria=Abarrotes" class="<%= "Abarrotes".equals(categoriaActiva) ? "active-category" : ""%>">Abarrotes</a>
                        <a href="interfaz.jsp?categoria=Bebidas" class="<%= "Bebidas".equals(categoriaActiva) ? "active-category" : ""%>">Bebidas</a>
                        <a href="interfaz.jsp?categoria=Limpieza" class="<%= "Limpieza".equals(categoriaActiva) ? "active-category" : ""%>">Limpieza</a>
                        <a href="interfaz.jsp?categoria=Cuidado Personal" class="<%= "Cuidado Personal".equals(categoriaActiva) ? "active-category" : ""%>">Cuidado Personal</a>
                        <a href="interfaz.jsp?categoria=Mascotas" class="<%= "Mascotas".equals(categoriaActiva) ? "active-category" : ""%>">Mascotas</a>
                        <a href="interfaz.jsp?categoria=Todos" class="<%= "Todos".equals(categoriaActiva) ? "active-category" : ""%>">Todos</a>


                        <hr>

                        <h5 class="fw-bold mb-2">📍 Ubícanos</h5>
                        <a href="ubicacion.jsp">Ver en pantalla completa</a>

                        <div class="mt-2">
                            <iframe 
                                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3901.485933242575!2d-76.2476843!3d-13.8333986!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x911063c05b97c905%3A0x51b09d4a0f70d9a8!2sMinimarket%20%26%20Licoreria%20Anais!5e0!3m2!1ses-419!2spe!4v1721173838403!5m2!1ses-419!2spe" 
                                width="100%" height="260    " style="border:0;" allowfullscreen="" loading="lazy" 
                                referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>
                    </div>
                </div>


                <!-- Carrusel y Productos -->
                <div class="col-md-10">
                    <!-- Carruseles en dos columnas -->
                    <div class="contenedor-carruseles d-flex justify-content-center gap-3 mb-4">
                        <!-- Carrusel Promociones 1 -->
                        <div id="carrusel1" class="carousel slide shadow" data-bs-ride="carousel" style="width: 48%;">
                            <div class="carousel-inner rounded">
                                <div class="carousel-item active">
                                    <img src="../images/promociones/promo1.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo 1">
                                </div>
                                <div class="carousel-item">
                                    <img src="../images/promociones/promo2.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo 2">
                                </div>
                                <div class="carousel-item">
                                    <img src="../images/promociones/promo3.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo 3">
                                </div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carrusel1" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carrusel1" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>

                        <!-- Carrusel Promociones A -->
                        <div id="carrusel2" class="carousel slide shadow" data-bs-ride="carousel" style="width: 48%;">
                            <div class="carousel-inner rounded">
                                <div class="carousel-item active">
                                    <img src="../images/promociones/promoA.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo A">
                                </div>
                                <div class="carousel-item">
                                    <img src="../images/promociones/promoB.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo B">
                                </div>
                                <div class="carousel-item">
                                    <img src="../images/promociones/promoC.jpg" class="d-block w-100" style="height: 250px; object-fit: cover;" alt="Promo C">
                                </div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carrusel2" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carrusel2" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>
                    </div>


                    <!-- Productos -->
                    <div class="container">
                        <div class="row row-cols-1 row-cols-md-3 g-4 mt-3">
                            <%
                                String url = "jdbc:mysql://localhost:3306/bd_registro";
                                String user = "root";
                                String pass = "";
                                try {
                                    Connection con = clases.ConexionDB.getConnection();
                                    Statement stmt = con.createStatement();
                                    String categoriaSeleccionada = request.getParameter("categoria");
                                    String query = "SELECT * FROM productos WHERE 1=1";

                                    if (categoriaSeleccionada != null && !categoriaSeleccionada.equals("Todos")) {
                                        query += " AND categoria = '" + categoriaSeleccionada + "'";
                                    }

                                    String textoBusqueda = request.getParameter("buscar");
                                    if (textoBusqueda != null && !textoBusqueda.trim().isEmpty()) {
                                        query += " AND nombre LIKE '%" + textoBusqueda + "%'";
                                    }

                                    ResultSet rs = stmt.executeQuery(query);
                                    while (rs.next()) {
                                        String nombre = rs.getString("nombre");
                                        String descripcion = rs.getString("descripcion");
                                        double precio = rs.getDouble("precio");
                                        String unidad = rs.getString("unidad");
                                        String imagenUrl = rs.getString("imagen_url");
                                        if (imagenUrl == null || imagenUrl.trim().isEmpty()) {
                                            imagenUrl = "default-product.png";
                                        }
                            %>
                            <div class="col">
                                <div class="product-card text-center">
                                    <img src="../images/<%= imagenUrl%>" class="img-fluid mb-2" alt="<%= nombre%>" style="width: 200px; height: 200px; object-fit: cover;">
                                    <h5><%= nombre%></h5>
                                    <p><%= descripcion%></p>
                                    <p class="text-success fw-bold">S/ <%= precio%> - <%= unidad%></p>
                                    <button class="btn btn-warm" onclick="agregarAlCarrito(<%= rs.getInt("id")%>)">Agregar</button>


                                </div>
                            </div>
                            <%
                                    }
                                    rs.close();
                                    stmt.close();
                                    con.close();
                                } catch (Exception e) {
                                    out.println("<p class='text-danger'>Estamos trabajando para brindarle un servicio mejor: " + e.getMessage() + "</p>");
                                }
                            %>
                        </div>
                    </div>
                </div> <!-- col-md-10 -->
            </div> <!-- row -->
        </div> <!-- container-fluid -->


        <script>
            function agregarAlCarrito(productoId) {
                fetch('../agregar-carrito', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'id=' + productoId
                })
                        .then(response => {
                            if (response.ok) {
                                // Notificar 
                                return fetch('carrito-cantidad.jsp')
                                        .then(res => res.text())
                                        .then(html => {
                                            document.getElementById('carrito-contador').innerHTML = html;
                                        });
                            }
                        })
                        .catch(error => console.error('Error al agregar:', error));
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            //reloj

            document.addEventListener('DOMContentLoaded', function () {
                const reloj = document.getElementById('clock');
                if (!reloj) {
                    console.error("No se encontró el elemento #clock");
                    return;
                }

                function actualizarReloj() {
                    const ahora = new Date();
                    const opciones = {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    };
                    reloj.textContent = ahora.toLocaleDateString('es-PE', opciones);
                }

                actualizarReloj();
                setInterval(actualizarReloj, 1000);
            });
        </script>

    </body>

</html>
