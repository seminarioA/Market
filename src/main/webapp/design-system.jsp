<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Market · Design System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/design-system.css">
    <style>
        .swatch { width: 100%; height: 64px; border-radius: var(--ds-radius-md); border: 1px solid var(--ds-color-border); }
        .token-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: var(--ds-space-4); }
    </style>
</head>
<body class="ds-body">
    <!-- Navbar -->
    <nav class="ds-navbar">
        <div class="ds-container ds-navbar-inner">
            <span class="ds-navbar-brand">Market</span>
            <div>
                <a href="#">Inicio</a>
                <a href="#">Productos</a>
                <a href="#">Proveedores</a>
                <a href="#">Admin</a>
            </div>
        </div>
    </nav>

    <main class="ds-container ds-mt-6">
        <h1 class="ds-section-title">Design System · Market</h1>
        <p class="ds-text-muted">Tokens y componentes reutilizables. Tema "mercado fresco": rojo de marca sobre crema cálida, acentos naranja (promos) y verde (stock).</p>

        <!-- Color tokens -->
        <h2 class="ds-section-title ds-mt-6">Color</h2>
        <div class="token-grid ds-mb-4">
            <div><div class="swatch" style="background:var(--ds-color-primary)"></div><small>primary</small></div>
            <div><div class="swatch" style="background:var(--ds-color-accent)"></div><small>accent</small></div>
            <div><div class="swatch" style="background:var(--ds-color-success)"></div><small>success</small></div>
            <div><div class="swatch" style="background:var(--ds-color-bg)"></div><small>bg</small></div>
            <div><div class="swatch" style="background:var(--ds-color-surface-alt)"></div><small>surface-alt</small></div>
            <div><div class="swatch" style="background:var(--ds-color-border)"></div><small>border</small></div>
        </div>

        <!-- Botones -->
        <h2 class="ds-section-title ds-mt-6">Botones</h2>
        <div class="ds-flex ds-gap-2 ds-mb-4">
            <button class="ds-btn ds-btn--primary">Primario</button>
            <button class="ds-btn ds-btn--accent">Promo</button>
            <button class="ds-btn ds-btn--success">Confirmar</button>
            <button class="ds-btn ds-btn--outline">Outline</button>
            <button class="ds-btn ds-btn--ghost">Ghost</button>
            <button class="ds-btn ds-btn--primary ds-btn--sm">Sm</button>
            <button class="ds-btn ds-btn--primary ds-btn--lg">Grande</button>
        </div>

        <!-- Tarjeta de producto -->
        <h2 class="ds-section-title ds-mt-6">Tarjeta de producto</h2>
        <div class="ds-product-grid ds-mb-4" style="max-width:680px">
            <div class="ds-card ds-card-product">
                <img src="${pageContext.request.contextPath}/images/frutas/manzana.png" alt="Manzana"
                     onerror="this.style.display='none'">
                <div class="ds-card-body">
                    <span class="ds-badge ds-badge--promo">-15%</span>
                    <div class="ds-product-name">Manzana Roja</div>
                    <div class="ds-product-price">S/ 3.50</div>
                    <div class="ds-product-unit">por kg</div>
                    <div class="ds-flex ds-gap-2 ds-mt-4">
                        <button class="ds-btn ds-btn--primary ds-btn--sm">Agregar</button>
                        <button class="ds-btn ds-btn--outline ds-btn--sm">Ver</button>
                    </div>
                </div>
            </div>
            <div class="ds-card ds-card-product">
                <div class="ds-card-body" style="background:var(--ds-color-surface-alt)"></div>
                <div class="ds-card-body">
                    <span class="ds-badge ds-badge--stock">En stock</span>
                    <div class="ds-product-name">Detergente</div>
                    <div class="ds-product-price">S/ 12.90</div>
                    <div class="ds-product-unit">unidad</div>
                    <div class="ds-flex ds-gap-2 ds-mt-4">
                        <button class="ds-btn ds-btn--primary ds-btn--sm">Agregar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Formularios -->
        <h2 class="ds-section-title ds-mt-6">Formularios</h2>
        <div style="max-width:420px">
            <div class="ds-field">
                <label class="ds-label">Correo</label>
                <input class="ds-input" type="email" placeholder="cliente@correo.com">
            </div>
            <div class="ds-field">
                <label class="ds-label">Categoría</label>
                <select class="ds-select">
                    <option>Frutas</option><option>Verduras</option><option>Limpieza</option>
                </select>
            </div>
            <button class="ds-btn ds-btn--primary ds-btn--block">Guardar</button>
        </div>

        <!-- Tabla -->
        <h2 class="ds-section-title ds-mt-6">Tabla</h2>
        <table class="ds-table ds-mb-4">
            <thead><tr><th>Producto</th><th>Precio</th><th>Stock</th><th>Estado</th></tr></thead>
            <tbody>
                <tr><td>Manzana</td><td>S/ 3.50</td><td>120</td><td><span class="ds-badge ds-badge--stock">Disponible</span></td></tr>
                <tr><td>Detergente</td><td>S/ 12.90</td><td>8</td><td><span class="ds-badge ds-badge--out">Poco stock</span></td></tr>
            </tbody>
        </table>

        <!-- Alertas -->
        <h2 class="ds-section-title ds-mt-6">Alertas</h2>
        <div class="ds-alert ds-alert--success">Compra registrada correctamente.</div>
        <div class="ds-alert ds-alert--error">No hay stock suficiente para este producto.</div>
    </main>
</body>
</html>
