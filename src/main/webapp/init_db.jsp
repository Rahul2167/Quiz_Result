<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Initialization</title>
        </head>

        <body>
            <h1>🔧 Database Initialization</h1>
            <%! public String parsePsql(String psql) { if (psql==null) return null; String t=psql.trim(); if
                (!t.startsWith("psql")) return null; String host=null, port="5432" , db="postgres" ; String[]
                parts=t.split("\\s+"); for (int i=0; i < parts.length; i++) { if (("-h".equals(parts[i]) || "--host"
                .equals(parts[i])) && i + 1 < parts.length) host=parts[i+1]; if (("-p".equals(parts[i]) || "--port"
                .equals(parts[i])) && i + 1 < parts.length) port=parts[i+1]; if (("-d".equals(parts[i]) || "--dbname"
                .equals(parts[i])) && i + 1 < parts.length) db=parts[i+1]; } return host !=null ? "jdbc:postgresql://" +
                host + ":" + port + "/" + db : null; } %>
                <% try { String dbUrl=System.getenv("DB_URL"); String urlVar=System.getenv("URL"); String
                    databaseUrl=System.getenv("DATABASE_URL"); String host=System.getenv("DB_HOST"); String
                    port=System.getenv("DB_PORT"); String dbName=System.getenv("DB_NAME"); String
                    user=System.getenv("DB_USER"); if (user==null) user="postgres" ; String
                    pass=System.getenv("DB_PASSWORD"); if (pass==null) pass="Rahul@2167" ; java.util.List<String[]>
                    strategies = new java.util.ArrayList<String[]>();
                        if (host != null && dbName != null) {
                        String p = (port != null) ? port : "5432";
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName +
                        "?sslmode=require", "Primary (SSL)" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName, "Primary (No
                        SSL)" });
                        if ("6543".equals(p)) {
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName +
                        "?sslmode=require", "Host + 5432 (SSL)" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName, "Host + 5432 (No
                        SSL)" });
                        }
                        }
                        String[] vars = { dbUrl, urlVar, databaseUrl };
                        for (String v : vars) {
                        if (v == null || v.trim().isEmpty()) continue;
                        String vt = v.trim();
                        String parsed = vt.startsWith("psql") ? parsePsql(vt) : (vt.startsWith("postgres://") ?
                        "jdbc:postgresql" + vt.substring(8) : vt);
                        if (parsed != null) {
                        String sUrl = parsed + (parsed.contains("?") ? (parsed.contains("sslmode") ? "" :
                        "&sslmode=require") : "?sslmode=require");
                        strategies.add(new String[]{ sUrl, "URL Var (SSL)" });
                        strategies.add(new String[]{ parsed, "URL Var (As-is)" });
                        }
                        }
                        strategies.add(new String[]{ "jdbc:postgresql://localhost:5432/student", "Localhost Fallback"
                        });

                        Connection con = null;
                        String successfulStrategy = null;
                        String finalUrl = null;
                        StringBuilder log = new StringBuilder();

                        out.println("<div style='background:#e3f2fd;padding:15px;margin:20px;border-radius:5px;'>");
                            out.println("<h3>🔍 Connection Strategist</h3>
                            <ul>");

                                for (String[] strategy : strategies) {
                                try {
                                Class.forName("org.postgresql.Driver");
                                con = DriverManager.getConnection(strategy[0], user, pass);
                                if (con != null) {
                                successfulStrategy = strategy[1]; finalUrl = strategy[0];
                                log.append("<li style='color:green;'>✅ SUCCESS: " + strategy[1] + "</li>");
                                break;
                                }
                                } catch (Exception e) {
                                log.append("<li style='color:#666;'>❌ " + strategy[1] + ": " + e.getMessage() + "</li>
                                ");
                                }
                                }
                                out.println(log.toString() + "</ul>");

                            if (con != null) {
                            out.println("<div style='background:#d4edda;color:#155724;padding:10px;border-radius:5px;'>
                                ");
                                out.println("<strong>✓ Connected using:</strong> " + successfulStrategy + "<br>");
                                out.println("<small>Final URL: " + finalUrl.replaceAll(":.*@", ":***@") + "</small>
                            </div>");

                            Statement stmt = con.createStatement();
                            String sql = "CREATE TABLE IF NOT EXISTS quiz_result (id SERIAL PRIMARY KEY, fullname
                            VARCHAR(255), score INT, result VARCHAR(50), quiz_date TIMESTAMP DEFAULT
                            CURRENT_TIMESTAMP)";
                            stmt.executeUpdate(sql);
                            out.println("<div style='background:#d4edda;padding:15px;margin:20px;border-radius:5px;'>
                                <h2>✓ Success!</h2>
                                <p>Table verified.</p>
                            </div>");
                            con.close();
                            }
                            out.println("
                        </div>");
                        } catch (Exception e) {
                        out.println("<div style='color:red;'>
                            <h2>❌ Error:</h2>
                            <pre>" + e.getMessage() + "</pre>
                        </div>");
                        }
                        %>
                        <a href="index.html">Go to Home</a>
        </body>

        </html>