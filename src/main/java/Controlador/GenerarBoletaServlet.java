package controlador;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import modelo.CarritoItem;

@WebServlet("/generar-boleta")
public class GenerarBoletaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();
        String usuarioNombre = (String) sesion.getAttribute("usuarioNombre");

        List<CarritoItem> carrito = (List<CarritoItem>) sesion.getAttribute("carrito_final");

        if (carrito == null || carrito.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        response.setContentType("application/pdf");

        String fechaHora = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String nombreArchivo = "boleta_" + usuarioNombre.replaceAll("\\s+", "_") + "_" + fechaHora + ".pdf";

        response.setHeader("Content-Disposition", "attachment; filename=\"" + nombreArchivo + "\"");

        // ... (resto del código PDF)
        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());

            document.open();
            document.add(new Paragraph("🧾 Minimarket Anais"));
            document.add(new Paragraph("Cliente: " + usuarioNombre));
            document.add(new Paragraph("Fecha: " + new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date())));
            document.add(new Paragraph(" "));

            PdfPTable tabla = new PdfPTable(5);
            tabla.addCell("Producto");
            tabla.addCell("Precio");
            tabla.addCell("Cantidad");
            tabla.addCell("Unidad");
            tabla.addCell("Subtotal");

            double total = 0;
            for (CarritoItem item : carrito) {
                tabla.addCell(item.getNombre());
                tabla.addCell("S/ " + item.getPrecio());
                tabla.addCell(String.valueOf(item.getCantidad()));
                tabla.addCell(item.getUnidad());
                double subtotal = item.getSubtotal();
                total += subtotal;
                tabla.addCell("S/ " + String.format("%.2f", subtotal));
            }

            document.add(tabla);
            document.add(new Paragraph("\nTotal a pagar: S/ " + String.format("%.2f", total)));
            document.add(new Paragraph("\n¡Gracias por tu compra! 🛍️"));

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
