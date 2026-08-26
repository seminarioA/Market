package clases;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionDB {

    public static Connection getConnection() throws Exception {
        Class.forName("org.postgresql.Driver");

        String url = System.getenv("JDBC_DATABASE_URL");
        if (url == null || url.isEmpty()) {
            url = System.getenv("DATABASE_URL");
        }

        if (url != null && !url.isEmpty()) {
            if (url.startsWith("postgres://")) {
                url = "jdbc:postgresql://" + url.substring("postgres://".length());
            } else if (url.startsWith("postgresql://")) {
                url = "jdbc:" + url;
            }
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");
            if (user != null && pass != null) {
                return DriverManager.getConnection(url, user, pass);
            }
            return DriverManager.getConnection(url);
        }

        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String db = System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");
        if (host == null) host = "localhost";
        if (port == null) port = "5432";
        if (db == null) db = "postgres";
        url = "jdbc:postgresql://" + host + ":" + port + "/" + db + "?sslmode=require";
        return DriverManager.getConnection(url, user, pass);
    }
}
