<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Initialization</title>
        </head>

        <body>
            <h1>🔧 Database Initialization</h1>
            <% String bucketUrl=System.getenv("DB_URL"); if (bucketUrl==null) bucketUrl=System.getenv("URL"); if
                (bucketUrl==null) bucketUrl=System.getenv("DATABASE_URL"); String host=System.getenv("DB_HOST"); String
                port=System.getenv("DB_PORT"); if (port==null) port="5432" ; String dbName=System.getenv("DB_NAME");
                String user=System.getenv("DB_USER"); String password=System.getenv("DB_PASSWORD"); String url; if (host
                !=null && dbName !=null) { url="jdbc:postgresql://" + host + ":" + port + "/" + dbName
                + "?sslmode=require" ; } else if (bucketUrl !=null) { // Convert postgres:// to jdbc:postgresql:// if
                necessary url=bucketUrl; if (url.startsWith("postgres://")) { url="jdbc:postgresql" + url.substring(8);
                } if (!url.contains("?")) { url +="?sslmode=require" ; } else if (!url.contains("sslmode")) { url
                +="&sslmode=require" ; } } else { url="jdbc:postgresql://localhost:5432/student" ; } if (user==null)
                user="postgres" ; if (password==null) password="Rahul@2167" ; try { out.println("<div
                style='background: #e3f2fd; padding: 15px; margin: 20px; border-radius: 5px;'>");
                out.println("<h3>📋 Connection Details:</h3>");
                out.println("<p><strong>Host:</strong> " + (host != null ? host : "Not Set") + "</p>");
                out.println("<p><strong>Port:</strong> " + port + "</p>");
                out.println("<p><strong>DB Name:</strong> " + (dbName != null ? dbName : "Not Set") + "</p>");
                out.println("<p><strong>Final URL (masked):</strong> " + url.replaceAll(":.*@", ":***@") + "</p>");
                out.println("<p><strong>User:</strong> " + user + "</p>");
                out.println("</div>");

                Class.forName("org.postgresql.Driver");
                Connection con = DriverManager.getConnection(url, user, password);

                out.println("<div style='background: #fff3cd; padding: 15px; margin: 20px; border-radius: 5px;'>");
                    out.println("<h3>✅ Database Connected Successfully!</h3>");
                    out.println("</div>");

                Statement stmt = con.createStatement();
                String sql = "CREATE TABLE IF NOT EXISTS quiz_result (" +
                "id SERIAL PRIMARY KEY, " +
                "fullname VARCHAR(255), " +
                "score INT, " +
                "result VARCHAR(50), " +
                "quiz_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")";

                stmt.executeUpdate(sql);

                out.println("<div
                    style='background: #d4edda; padding: 15px; margin: 20px; border-radius: 5px; border-left: 5px solid green;'>
                    ");
                    out.println("<h2 style='color: green; margin: 0;'>✓ Success!</h2>");
                    out.println("<p style='margin: 10px 0 0 0;'>Table 'quiz_result' has been created/verified
                        successfully.</p>");
                    out.println("</div>");

                con.close();
                } catch (Exception e) {
                out.println("<div
                    style='background: #f8d7da; padding: 15px; margin: 20px; border-radius: 5px; border-left: 5px solid red;'>
                    ");
                    out.println("<h2 style='color: red; margin: 0;'>❌ Error:</h2>");
                    out.println("<p style='margin: 10px 0;'><strong>" + e.getMessage() + "</strong></p>");
                    out.println("
                    <pre style='background: #fff; padding: 10px; overflow: auto;'>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                    out.println("</pre>");
                    out.println("
                </div>");
                }
                %>
                <a href="index.html">Go to Home</a>
        </body>

        </html>