<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Initialization</title>
        </head>

        <body>
            <h1>🔧 Database Initialization</h1>
            <% String dbUrl=System.getenv("DB_URL"); String urlVar=System.getenv("URL"); String
                databaseUrl=System.getenv("DATABASE_URL"); String host=System.getenv("DB_HOST"); String
                port=System.getenv("DB_PORT"); String dbName=System.getenv("DB_NAME"); String
                user=System.getenv("DB_USER"); String password=System.getenv("DB_PASSWORD"); // Determine which variable
                to use String bucketUrl=dbUrl !=null ? dbUrl : (urlVar !=null ? urlVar : databaseUrl); String url;
                String connectionSource; if (host !=null && dbName !=null) { if (port==null) port="5432" ;
                url="jdbc:postgresql://" + host + ":" + port + "/" + dbName + "?sslmode=require" ;
                connectionSource="HOST/NAME/PORT (Manual or Render Managed)" ; } else if (bucketUrl !=null) {
                url=bucketUrl; if (url.startsWith("postgres://")) { url="jdbc:postgresql" + url.substring(8); } else if
                (url.startsWith("psql ")) {
                        // Diagnostic: The user might have pasted a psql command instead of a URL
                        url = " INVALID_URL_PSQL_COMMAND"; } if (!url.equals("INVALID_URL_PSQL_COMMAND")) { if
                (!url.contains("?")) url +="?sslmode=require" ; else if (!url.contains("sslmode")) url
                +="&sslmode=require" ; } connectionSource="DB_URL/URL/DATABASE_URL Variable" ; } else {
                url="jdbc:postgresql://localhost:5432/student" ; connectionSource="Local Fallback (localhost)" ; } if
                (user==null) user="postgres" ; if (password==null) password="Rahul@2167" ; try { out.println("<div
                style='background: #e3f2fd; padding: 15px; margin: 20px; border-radius: 5px;'>");
                out.println("<h3>📋 Diagnostic Information:</h3>");
                out.println("<p><strong>Detected Connection Source:</strong> " + connectionSource + "</p>");
                out.println("
                <hr>");
                out.println("<p><strong>DB_HOST:</strong> " + (host != null ? "<code>" + host + "</code>" : "<span
                        style='color:orange'>Not Set</span>") + "</p>");
                out.println("<p><strong>DB_PORT:</strong> " + (System.getenv("DB_PORT") != null ?
                    "<code>" + System.getenv("DB_PORT") + "</code>" : "<span style='color:gray'>Not Set (Defaulting to
                        5432)</span>") + "</p>");
                out.println("<p><strong>DB_NAME:</strong> " + (dbName != null ? "<code>" + dbName + "</code>" : "<span
                        style='color:orange'>Not Set</span>") + "</p>");
                out.println("<p><strong>URL Variable:</strong> " + (urlVar != null ?
                    "<code>" + (urlVar.length() > 20 ? urlVar.substring(0, 20) + "..." : urlVar) + "</code>" : "<span
                        style='color:gray'>Not Set</span>") + "</p>");
                out.println("
                <hr>");
                out.println("<p><strong>Final JDBC URL (masked):</strong>
                    <code>" + url.replaceAll(":.*@", ":***@") + "</code></p>");
                out.println("<p><strong>DB User:</strong> <code>" + user + "</code></p>");

                if (url.equals("INVALID_URL_PSQL_COMMAND")) {
                out.println("<div
                    style='background: #fff3cd; padding: 10px; border-left: 5px solid #ffc107; margin-top: 10px;'>");
                    out.println("<strong>⚠️ WARNING:</strong> Your 'URL' variable looks like a <code>psql</code> command
                    (starts with 'psql'). Java needs a JDBC URL (e.g.,
                    <code>jdbc:postgresql://host:port/dbname</code>).");
                    out.println("</div>");
                }

                if (host != null && host.contains("render.com") && "6543".equals(port)) {
                out.println("<div
                    style='background: #fff3cd; padding: 10px; border-left: 5px solid #ffc107; margin-top: 10px;'>");
                    out.println("<strong>⚠️ POTENTIAL MISMATCH:</strong> You are using a Render host with Port 6543.
                    Port 6543 is usually for Supabase Pooler. Render internal databases normally use 5432.");
                    out.println("</div>");
                }

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