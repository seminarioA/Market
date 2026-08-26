package clases;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class ProductoDAO {

    private final String url = "jdbc:mysql://localhost:3306/bd_registro";
    private final String usuario = "root";
    private final String clave = ""; 

    public void agregarProducto(Producto producto) {
        String sql = "INSERT INTO productos(nombre, descripcion, precio, stock, unidad) VALUES (?, ?, ?, ?, ?)";

        try {
            Connection conn = clases.ConexionDB.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, producto.getNombre());
            stmt.setString(2, producto.getDescripcion());
            stmt.setDouble(3, producto.getPrecio());
            stmt.setInt(4, producto.getStock());
            stmt.setString(5, producto.getUnidad()); // new 

            stmt.executeUpdate();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
