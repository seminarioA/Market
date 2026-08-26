<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.CarritoItem" %>

<%
    String usuarioNombre = (String) session.getAttribute("usuarioNombre");
    List<modelo.CarritoItem> carrito = (List<modelo.CarritoItem>) session.getAttribute("carrito");
    int cantidadTotal = 0;
    if (carrito != null) {
        for (modelo.CarritoItem item : carrito) cantidadTotal += item.getCantidad();
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inicio - Market</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

        <script src="https://cdn.tailwindcss.com/3.4.16"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            brand: { DEFAULT: '#e60000', dark: '#c50000', soft: '#ffe5e5' },
                            accent: '#f7941d',
                            cream: '#fff8f0',
                            line: '#efe3d8',
                            sand: '#fff0e6',
                            success: { DEFAULT: '#2e7d32', soft: '#e6f4e7' }
                        },
                        fontFamily: { sans: ['Poppins', 'Segoe UI', 'system-ui', 'Arial', 'sans-serif'] }
                    }
                }
            };
        </script>
    </head>
    <body class="bg-cream text-gray-900 font-sans min-h-screen">

        <!-- ===================== NAVBAR ===================== -->
        <nav class="sticky top-0 z-50 bg-brand text-white shadow-md">
            <div class="max-w-7xl mx-auto px-4">
                <div class="flex items-center gap-3 sm:gap-4 h-16">
                    <!-- Marca -->
                    <a href="interfaz.jsp" class="flex items-center gap-2 font-bold text-lg shrink-0">
                        <i class="bi bi-basket text-xl"></i> MARKET
                    </a>

                    <!-- Buscador (desktop) -->
                    <form method="get" action="interfaz.jsp" class="relative flex-1 max-w-xl hidden sm:block" role="search">
                        <i class="bi bi-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        <input name="buscar" type="search" placeholder="¿Qué producto buscas?"
                               value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>"
                               class="w-full rounded-full pl-11 pr-4 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-white/70"
                               aria-label="Buscar">
                    </form>

                    <!-- Derecha -->
                    <div class="flex items-center gap-3 sm:gap-5 ml-auto">
                        <!-- Estado (desktop) -->
                        <span class="hidden lg:inline-flex items-center gap-2 bg-white/15 rounded-full px-3 py-1 text-sm whitespace-nowrap">
                            <span class="w-2 h-2 rounded-full bg-green-400" style="box-shadow:0 0 0 3px rgba(74,222,128,.35)"></span>
                            Abierto <span id="clock" class="tabular-nums opacity-90"></span>
                        </span>

                        <!-- Carrito -->
                        <a href="carrito.jsp" class="relative text-2xl" aria-label="Carrito">
                            <i class="bi bi-cart3"></i>
                            <span class="absolute -top-1 -right-2 min-w-[20px] h-5 px-1 rounded-full bg-white text-brand text-xs font-bold flex items-center justify-center border border-brand">
                                <span id="carrito-contador"><%= cantidadTotal%></span>
                            </span>
                        </a>

                        <!-- Usuario -->
                        <% if (usuarioNombre != null) {%>
                        <div class="relative">
                            <button id="userMenuBtn" onclick="toggleUserMenu()" type="button"
                                    class="w-10 h-10 rounded-full bg-white/20 hover:bg-white/30 font-bold flex items-center justify-center">
                                <%= usuarioNombre.split(" ")[0].charAt(0)%>
                            </button>
                            <div id="userMenu" class="hidden absolute right-0 mt-2 w-52 bg-white text-gray-800 rounded-xl shadow-lg py-2 z-50">
                                <div class="px-4 py-2 text-sm font-semibold border-b border-line"><%= usuarioNombre%></div>
                                <a href="historial.jsp" class="flex items-center gap-2 px-4 py-2 text-sm hover:bg-sand"><i class="bi bi-receipt"></i> Historial de Compras</a>
                                <a href="../jsp-Usuarios/editarUsuario.jsp" class="flex items-center gap-2 px-4 py-2 text-sm hover:bg-sand"><i class="bi bi-gear"></i> Editar Cuenta</a>
                                <a href="../jsp-Usuarios/cerrarSesion.jsp" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-sand"><i class="bi bi-box-arrow-right"></i> Cerrar sesión</a>
                            </div>
                        </div>
                        <% } else { %>
                        <a href="../jsp-Usuarios/login.jsp" class="hover:opacity-80 text-sm font-medium">Iniciar Sesión</a>
                        <a href="../jsp-Usuarios/registro.jsp" class="hover:opacity-80 text-sm font-medium">Registrarse</a>
                        <% } %>

                        <!-- Admin -->
                        <a href="../jsp-Admin/loginAdmin.jsp" class="text-lg hover:opacity-80" title="Admin"><i class="bi bi-shield-lock"></i></a>
                    </div>
                </div>

                <!-- Buscador (móvil) -->
                <form method="get" action="interfaz.jsp" class="sm:hidden pb-3" role="search">
                    <div class="relative">
                        <i class="bi bi-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        <input name="buscar" type="search" placeholder="¿Qué producto buscas?"
                               value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : ""%>"
                               class="w-full rounded-full pl-11 pr-4 py-2 text-sm text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-white/70"
                               aria-label="Buscar">
                    </div>
                </form>
            </div>
        </nav>

        <!-- ===================== CONTENIDO ===================== -->
        <div class="max-w-7xl mx-auto px-4 mt-4 grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- MENÚ LATERAL -->
            <aside class="lg:col-span-3">
                <div class="lg:sticky lg:top-20 bg-white border border-line rounded-2xl p-4 shadow-sm">
                    <h5 class="font-bold mb-3"><i class="bi bi-grid-3x3-gap me-2"></i>Categorías</h5>
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
                    <a href="interfaz.jsp?categoria=<%= c%>"
                       class="block px-3 py-2 rounded-lg font-medium hover:bg-sand <%= c.equals(categoriaActiva) ? "bg-brand-soft text-brand font-bold border-l-4 border-brand" : ""%>"><%= c%></a>
                    <% } %>
                    <hr class="my-3 border-line">
                    <h5 class="font-bold mb-2"><i class="bi bi-geo-alt me-2"></i>Ubícanos</h5>
                    <a href="ubicacion.jsp" class="text-sm text-brand hover:underline">Ver en pantalla completa</a>
                    <div class="mt-2">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3901.485933242575!2d-76.2476843!3d-13.8333986!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x911063c05b97c905%3A0x51b09d4a0f70d9a8!2sMinimarket%20%26%20Licoreria%20Anais!5e0!3m2!1ses-419!2spe!4v1721173838403!5m2!1ses-419!2spe"
                                width="100%" height="200" style="border:0; border-radius:12px;" allowfullscreen="" loading="lazy"></iframe>
                    </div>
                </div>
            </aside>

            <!-- PRINCIPAL -->
            <main class="lg:col-span-9">
                <!-- HERO -->
                <div class="rounded-2xl p-6 sm:p-8 mb-6 bg-gradient-to-br from-brand to-[#ff5a36] text-white shadow-md flex flex-wrap justify-between items-center gap-4">
                    <div>
                        <h1 class="text-2xl sm:text-3xl font-bold"><i class="bi bi-bag-heart me-2"></i>Tu minimarket de barrio, ahora online</h1>
                        <p class="opacity-95">Frutas, verduras, abarrotes y más — frescos y a tu alcance.</p>
                    </div>
                    <i class="bi bi-truck text-4xl hidden lg:block"></i>
                </div>

                <!-- PROMOS -->
                <div class="grid sm:grid-cols-2 gap-4 mb-6">
                    <a href="interfaz.jsp?categoria=Bebidas" class="relative block rounded-2xl overflow-hidden shadow-sm group" style="height:190px;background:linear-gradient(135deg,#e60000,#ff5a36)">
                        <img src="../images/promociones/promo1.jpg" class="absolute inset-0 w-full h-full object-cover group-hover:scale-105 transition duration-300" onerror="this.remove()" alt="Promoción">
                        <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                        <div class="absolute bottom-3 left-4 text-white"><div class="font-bold">Promos de la semana</div><div class="text-sm opacity-90">Hasta 30% dscto</div></div>
                    </a>
                    <a href="interfaz.jsp?categoria=Limpieza" class="relative block rounded-2xl overflow-hidden shadow-sm group" style="height:190px;background:linear-gradient(135deg,#f7941d,#ffb347)">
                        <img src="../images/promociones/promoA.jpg" class="absolute inset-0 w-full h-full object-cover group-hover:scale-105 transition duration-300" onerror="this.remove()" alt="Promoción">
                        <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                        <div class="absolute bottom-3 left-4 text-white"><div class="font-bold">Limpieza al mejor precio</div><div class="text-sm opacity-90">Renueva tu hogar</div></div>
                    </a>
                </div>

                <!-- FILTRO RÁPIDO (chips) -->
                <div class="flex flex-wrap gap-2 mb-6">
                    <% for (String c : cats) { %>
                    <a href="interfaz.jsp?categoria=<%= c%>"
                       class="px-4 py-1.5 rounded-full border border-line bg-white text-sm font-medium hover:border-brand <%= c.equals(categoriaActiva) ? "bg-brand text-white border-brand" : ""%>"><%= c%></a>
                    <% } %>
                </div>

                <!-- PRODUCTOS -->
                <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
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
                    <div class="bg-white border border-line rounded-2xl overflow-hidden shadow-sm hover:shadow-md hover:-translate-y-0.5 transition flex flex-col">
                        <div class="aspect-square bg-sand p-3 flex items-center justify-center">
                            <img src="../images/<%= imagenUrl%>" alt="<%= nombre%>" loading="lazy"
                                 class="max-h-full object-contain" onerror="this.src='../images/default-product.png'">
                        </div>
                        <div class="p-4 flex flex-col flex-1">
                            <% if (stock <= 0) { %><span class="self-start bg-brand-soft text-brand text-xs font-bold uppercase px-2 py-0.5 rounded-full mb-1">Agotado</span>
                            <% } else if (stock <= 10) { %><span class="self-start bg-success-soft text-success text-xs font-bold uppercase px-2 py-0.5 rounded-full mb-1">¡Pocas unidades!</span><% } %>
                            <div class="font-bold"><%= nombre%></div>
                            <p class="text-sm text-gray-500 mb-2 line-clamp-2"><%= descripcion != null ? descripcion : ""%></p>
                            <div class="text-brand font-bold text-lg">S/ <%= precio%></div>
                            <div class="text-sm text-gray-400"><%= unidad != null ? unidad : ""%></div>
                            <button onclick="agregarAlCarrito(<%= rs.getInt("id")%>)"
                                    class="mt-auto bg-brand text-white rounded-lg py-2 font-medium hover:bg-brand-dark flex items-center justify-center gap-2">
                                <i class="bi bi-cart-plus"></i> Agregar
                            </button>
                        </div>
                    </div>
                    <%
                            }
                            rs.close(); stmt.close(); con.close();
                        } catch (Exception e) {
                    %>
                    <div class="col-span-full text-center text-gray-400 py-16">
                        <i class="bi bi-exclamation-triangle text-5xl opacity-50"></i>
                        <p class="mt-2">Estamos trabajando para brindarte un mejor servicio. Intenta más tarde.</p>
                    </div>
                    <% } %>

                    <% if (hayProductos == false && carrito != null) { %>
                    <div class="col-span-full text-center text-gray-400 py-16">
                        <i class="bi bi-search text-5xl opacity-50"></i>
                        <p class="mt-2">No encontramos productos para tu búsqueda o categoría.</p>
                    </div>
                    <% } %>
                </div>
            </main>
        </div>

        <!-- TOAST feedback -->
        <div id="toastCarrito" class="fixed bottom-5 right-5 z-[2000] hidden bg-success text-white px-4 py-3 rounded-xl shadow-lg flex items-center gap-2">
            <i class="bi bi-check-circle"></i> Producto agregado al carrito
            <button onclick="hideToast()" class="ml-2 text-white/80 hover:text-white text-lg leading-none">&times;</button>
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
                            .then(html => {
                                const m = html.match(/>(\d+)</);
                                const n = m ? m[1] : '0';
                                document.getElementById('carrito-contador').textContent = n;
                            });
                        showToast();
                    }
                })
                .catch(error => console.error('Error al agregar:', error));
            }

            let toastTimer;
            function showToast() {
                const t = document.getElementById('toastCarrito');
                t.classList.remove('hidden');
                clearTimeout(toastTimer);
                toastTimer = setTimeout(hideToast, 2500);
            }
            function hideToast() { document.getElementById('toastCarrito').classList.add('hidden'); }

            function toggleUserMenu() { document.getElementById('userMenu').classList.toggle('hidden'); }
            document.addEventListener('click', function (e) {
                if (!e.target.closest('#userMenuBtn') && !e.target.closest('#userMenu')) {
                    const m = document.getElementById('userMenu');
                    if (m) m.classList.add('hidden');
                }
            });

            document.addEventListener('DOMContentLoaded', function () {
                const reloj = document.getElementById('clock');
                if (!reloj) return;
                function actualizarReloj() {
                    reloj.textContent = new Date().toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
                }
                actualizarReloj();
                setInterval(actualizarReloj, 1000);
            });
        </script>
    </body>
</html>
