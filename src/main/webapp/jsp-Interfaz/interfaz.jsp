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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inicio - Minimarket Anais</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link href="../css/estilos.css" rel="stylesheet">
        <link href="../css/design-system.css" rel="stylesheet">
        <style>
            :root { --bs-primary: var(--ds-color-primary); }

            /* Navbar fija y consistente con la marca */
            .navbar-app {
                background: var(--ds-color-primary);
                position: sticky; top: 0; z-index: 1050;
                box-shadow: var(--ds-shadow-sm);
            }
            .navbar-app .nav-link, .navbar-app .navbar-brand { color: #fff; }
            .navbar-app .form-control { border-radius: var(--ds-radius-pill) 0 0 var(--ds-radius-pill); }
            .navbar-app .btn-buscar {
                border-radius: 0 var(--ds-radius-pill) var(--ds-radius-pill) 0;
                background: var(--ds-color-accent); border: none; font-weight: 600; color:#fff;
            }
            .navbar-app .btn-buscar:hover { background: #ffa726; }

            /* Menú lateral */
            .side-menu {
                background: var(--ds-color-surface);
                border: 1px solid var(--ds-color-border);
                border-radius: var(--ds-radius-lg);
                padding: var(--ds-space-4);
                position: sticky; top: 84px;
                max-height: calc(100vh - 100px); overflow-y: auto;
                box-shadow: var(--ds-shadow-sm);
            }
            .side-menu a.cat-link {
                display: block; margin: 2px 0; padding: 10px 12px;
                color: var(--ds-color-text); text-decoration: none;
                border-radius: var(--ds-radius-sm); font-weight: 500;
                transition: var(--ds-transition);
            }
            .side-menu a.cat-link:hover { background: var(--ds-color-surface-alt); }
            .side-menu a.cat-link.active {
                background: var(--ds-color-primary-soft); color: var(--ds-color-primary);
                border-left: 4px solid var(--ds-color-primary); font-weight: 700;
            }

            /* Chips de categoría (filtro rápido) */
            .cat-chips { display: flex; gap: 8px; flex-wrap: wrap; }
            .cat-chip {
                border: 1px solid var(--ds-color-border); background: var(--ds-color-surface);
                color: var(--ds-color-text); padding: 6px 14px; border-radius: var(--ds-radius-pill);
                text-decoration: none; font-size: var(--ds-font-size-sm); font-weight: 500;
                transition: var(--ds-transition);
            }
            .cat-chip:hover { border-color: var(--ds-color-primary); }
            .cat-chip.active { background: var(--ds-color-primary); color: #fff; border-color: var(--ds-color-primary); }

            /* Hero */
            .hero {
                background: linear-gradient(135deg, var(--ds-color-primary), #ff5a36);
                color: #fff; border-radius: var(--ds-radius-lg);
                padding: var(--ds-space-6); margin-bottom: var(--ds-space-5);
                box-shadow: var(--ds-shadow-md);
            }
            .hero h1 { font-weight: 700; letter-spacing: -0.5px; }
            .hero p { opacity: 0.95; }

            /* Tarjeta producto (usa design system) */
            .ds-card-product .ds-product-price { color: var(--ds-color-primary); }
            .product-unidad { color: var(--ds-color-text-muted); font-size: var(--ds-font-size-sm); }

            .empty-state {
                text-align: center; padding: var(--ds-space-7) var(--ds-space-4);
                color: var(--ds-color-text-muted);
            }
            .empty-state i { font-size: 3rem; opacity: 0.5; }

            /* Toast */
            .toast-region { position: fixed; bottom: 20px; right: 20px; z-index: 2000; }
        </style>
    </head>
    <body class="ds-body">

        <!-- NAVBAR -->
        <nav class="navbar navbar-expand-lg navbar-app">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold d-flex align-items-center" href="interfaz.jsp">
                    <i class="bi bi-basket me-2"></i> MINIMARKET ANAIS
                </a>
                <span id="clock" class="text-white-50 small d-none d-md-inline"></span>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuSuperior">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="menuSuperior">
                    <div class="d-flex w-100 justify-content-between align-items-center flex-wrap gap-2">
                        <!-- BUSCADOR -->
                        <form method="get" action="interfaz.jsp" class="d-flex my-2" role="search" style="flex-grow:1; max-width:480px;">
                            <input class="form-control" type="search" name="buscar" placeholder="¿Qué producto buscas?" aria-label="Buscar"
                                   value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>">
                            <button class="btn btn-buscar" type="submit"><i class="bi bi-search"></i> Buscar</button>
                        </form>

                        <!-- ENLACES -->
                        <ul class="navbar-nav d-flex align-items-center flex-row">
                            <li class="nav-item me-2 position-relative">
                                <a class="nav-link" href="carrito.jsp" aria-label="Carrito">
                                    <i class="bi bi-cart3 fs-4"></i>
                                    <span id="carrito-contador">
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                            <%
                                                List<modelo.CarritoItem> carrito = (List<modelo.CarritoItem>) session.getAttribute("carrito");
                                                int cantidadTotal = 0;
                                                if (carrito != null) {
                                                    for (modelo.CarritoItem item : carrito) cantidadTotal += item.getCantidad();
                                                }
                                            %>
                                            <%= cantidadTotal%>
                                        </span>
                                    </span>
                                </a>
                            </li>

                            <% if (usuarioNombre != null) {%>
                            <li class="nav-item dropdown">
                                <button class="btn btn-outline-light rounded-circle dropdown-toggle ms-2" type="button" data-bs-toggle="dropdown" style="width:42px;height:42px;">
                                    <%= usuarioNombre.split(" ")[0].charAt(0)%>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><span class="dropdown-item-text"><%= usuarioNombre%></span></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="historial.jsp"><i class="bi bi-receipt me-2"></i>Historial de Compras</a></li>
                                    <li><a class="dropdown-item" href="../jsp-Usuarios/editarUsuario.jsp"><i class="bi bi-gear me-2"></i>Editar Cuenta</a></li>
                                    <li><a class="dropdown-item text-danger" href="../jsp-Usuarios/cerrarSesion.jsp"><i class="bi bi-box-arrow-right me-2"></i>Cerrar sesión</a></li>
                                </ul>
                            </li>
                            <% } else { %>
                            <li class="nav-item"><a class="nav-link" href="../jsp-Usuarios/login.jsp">Iniciar Sesión</a></li>
                            <li class="nav-item"><a class="nav-link ms-2" href="../jsp-Usuarios/registro.jsp">Registrarse</a></li>
                            <% } %>
                            <li class="nav-item"><a class="nav-link ms-2" href="../jsp-Admin/loginAdmin.jsp"><i class="bi bi-shield-lock"></i> Admin</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container-fluid mt-4">
            <div class="row">
                <!-- MENÚ LATERAL -->
                <div class="col-md-2">
                    <div class="side-menu">
                        <h5 class="fw-bold mb-3"><i class="bi bi-grid-3x3-gap me-2"></i>Categorías</h5>
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
                                        if (rs.next()) categoriaActiva = rs.getString("categoria");
                                        rs.close(); ps.close(); con.close();
                                    } catch (Exception e) { categoriaActiva = ""; }
                                }
                            }
                            String[] cats = {"Frutas","Verduras","Abarrotes","Bebidas","Limpieza","Cuidado Personal","Mascotas","Todos"};
                            for (String c : cats) {
                        %>
                        <a href="interfaz.jsp?categoria=<%= c%>" class="cat-link <%= c.equals(categoriaActiva) ? "active" : ""%>"><%= c%></a>
                        <% } %>
                        <hr>
                        <h5 class="fw-bold mb-2"><i class="bi bi-geo-alt me-2"></i>Ubícanos</h5>
                        <a href="ubicacion.jsp" class="small">Ver en pantalla completa</a>
                        <div class="mt-2">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3901.485933242575!2d-76.2476843!3d-13.8333986!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x911063c05b97c905%3A0x51b09d4a0f70d9a8!2sMinimarket%20%26%20Licoreria%20Anais!5e0!3m2!1ses-419!2spe!4v1721173838403!5m2!1ses-419!2spe"
                                    width="100%" height="220" style="border:0; border-radius:10px;" allowfullscreen="" loading="lazy"></iframe>
                        </div>
                    </div>
                </div>

                <!-- CONTENIDO -->
                <div class="col-md-10">
                    <!-- HERO -->
                    <div class="hero d-flex flex-wrap justify-content-between align-items-center">
                        <div>
                            <h1><i class="bi bi-bag-heart me-2"></i>Tu minimarket de barrio, ahora online</h1>
                            <p class="mb-0">Frutas, verduras, abarrotes y más — frescos y a tu alcance.</p>
                        </div>
                        <i class="bi bi-truck fs-1 d-none d-lg-block"></i>
                    </div>

                    <!-- CARRUSEL PROMOS -->
                    <div class="d-flex justify-content-center gap-3 mb-4 flex-wrap">
                        <div id="carrusel1" class="carousel slide shadow" data-bs-ride="carousel" style="width:48%; min-width:280px;">
                            <div class="carousel-inner rounded">
                                <div class="carousel-item active"><img src="../images/promociones/promo1.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción 1"></div>
                                <div class="carousel-item"><img src="../images/promociones/promo2.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción 2"></div>
                                <div class="carousel-item"><img src="../images/promociones/promo3.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción 3"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carrusel1" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carrusel1" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
                        </div>
                        <div id="carrusel2" class="carousel slide shadow" data-bs-ride="carousel" style="width:48%; min-width:280px;">
                            <div class="carousel-inner rounded">
                                <div class="carousel-item active"><img src="../images/promociones/promoA.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción A"></div>
                                <div class="carousel-item"><img src="../images/promociones/promoB.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción B"></div>
                                <div class="carousel-item"><img src="../images/promociones/promoC.jpg" class="d-block w-100" style="height:220px;object-fit:cover;" alt="Promoción C"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carrusel2" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carrusel2" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
                        </div>
                    </div>

                    <!-- FILTRO RÁPIDO (chips) -->
                    <div class="cat-chips mb-4">
                        <% for (String c : cats) { %>
                        <a href="interfaz.jsp?categoria=<%= c%>" class="cat-chip <%= c.equals(categoriaActiva) ? "active" : ""%>"><%= c%></a>
                        <% } %>
                    </div>

                    <!-- PRODUCTOS -->
                    <div class="ds-product-grid">
                        <%
                            boolean hayProductos = false;
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
                                    hayProductos = true;
                                    String nombre = rs.getString("nombre");
                                    String descripcion = rs.getString("descripcion");
                                    double precio = rs.getDouble("precio");
                                    String unidad = rs.getString("unidad");
                                    String imagenUrl = rs.getString("imagen_url");
                                    if (imagenUrl == null || imagenUrl.trim().isEmpty()) imagenUrl = "default-product.png";
                                    int stock = rs.getInt("stock");
                        %>
                        <div class="ds-card ds-card-product">
                            <img src="../images/<%= imagenUrl%>" alt="<%= nombre%>" loading="lazy"
                                 onerror="this.src='../images/default-product.png'">
                            <div class="ds-card-body">
                                <% if (stock <= 0) { %><span class="ds-badge ds-badge--out">Agotado</span>
                                <% } else if (stock <= 10) { %><span class="ds-badge ds-badge--stock">¡Pocas unidades!</span><% } %>
                                <div class="ds-product-name"><%= nombre%></div>
                                <p class="ds-text-muted small mb-2"><%= descripcion != null ? descripcion : ""%></p>
                                <div class="ds-product-price">S/ <%= precio%></div>
                                <div class="product-unidad"><%= unidad != null ? unidad : ""%></div>
                                <button class="ds-btn ds-btn--primary ds-btn--block ds-mt-4" onclick="agregarAlCarrito(<%= rs.getInt("id")%>)">
                                    <i class="bi bi-cart-plus"></i> Agregar
                                </button>
                            </div>
                        </div>
                        <%
                                }
                                rs.close(); stmt.close(); con.close();
                            } catch (Exception e) {
                        %>
                        <div class="empty-state w-100">
                            <i class="bi bi-exclamation-triangle"></i>
                            <p class="mt-2">Estamos trabajando para brindarte un mejor servicio. Intenta más tarde.</p>
                        </div>
                        <% } %>

                        <% if (hayProductos == false && carrito != null) { %>
                        <div class="empty-state w-100">
                            <i class="bi bi-search"></i>
                            <p class="mt-2">No encontramos productos para tu búsqueda o categoría.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- TOAST feedback -->
        <div class="toast-region">
            <div id="toastCarrito" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body"><i class="bi bi-check-circle me-2"></i>Producto agregado al carrito</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>

        <script>
            function agregarAlCarrito(productoId) {
                fetch('../agregar-carrito', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'id=' + productoId
                })
                .then(response => {
                    if (response.ok) {
                        fetch('carrito-cantidad.jsp')
                            .then(res => res.text())
                            .then(html => { document.getElementById('carrito-contador').innerHTML = html; });
                        var t = new bootstrap.Toast(document.getElementById('toastCarrito'));
                        t.show();
                    }
                })
                .catch(error => console.error('Error al agregar:', error));
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const reloj = document.getElementById('clock');
                if (!reloj) return;
                function actualizarReloj() {
                    reloj.textContent = new Date().toLocaleDateString('es-PE', {
                        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
                        hour: '2-digit', minute: '2-digit', second: '2-digit'
                    });
                }
                actualizarReloj();
                setInterval(actualizarReloj, 1000);
            });
        </script>
    </body>
</html>
