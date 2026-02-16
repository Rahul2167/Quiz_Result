<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Initialization</title>
        </head>

        <body>
            <h1>🔧 Database Initialization</h1>
            <%! // Helper to parse psql command if provided as a URL public String parsePsql(String psql) { if
                (psql==null || !psql.trim().startsWith("psql")) return null; String host=null, port="5432" ,
                db="postgres" ; String[] parts=psql.split("\\s+"); for (int i=0; i < parts.length; i++) { if
                (("-h".equals(parts[i]) || "--host" .equals(parts[i])) && i + 1 < parts.length) host=parts[i+1]; if
                (("-p".equals(parts[i]) || "--port" .equals(parts[i])) && i + 1 < parts.length) port=parts[i+1]; if
                (("-d".equals(parts[i]) || "--dbname" .equals(parts[i])) && i + 1 < parts.length) db=parts[i+1]; }
                return host !=null ? "jdbc:postgresql://" + host + ":" + port + "/" + db : null; } %>
                <% String dbUrl=System.getenv("DB_URL"); String urlVar=System.getenv("URL"); String
                    databaseUrl=System.getenv("DATABASE_URL"); String host=System.getenv("DB_HOST"); String
                    port=System.getenv("DB_PORT"); String dbName=System.getenv("DB_NAME"); String
                    user=System.getenv("DB_USER"); String pass=System.getenv("DB_PASSWORD"); if (user==null)
                    user="postgres" ; if (pass==null) pass="Rahul@2167" ; // List of strategies to try
                    java.util.List<String[]> strategies = new java.util.ArrayList<>();

                        // Strategy 1: Primary Host/Name configuration with current port
                        if (host != null && dbName != null) {
                        String p = (port != null) ? port : "5432";
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName +
                        "?sslmode=require", "Primary Variables (SSL)" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName, "Primary
                        Variables (No SSL)" });

                        // Strategy 2: If port was 6543, try 5432 as well (common Render/local port)
                        if ("6543".equals(p)) {
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName +
                        "?sslmode=require", "Render Host + Standard Port 5432 (SSL)" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName, "Render Host +
                        Standard Port 5432 (No SSL)" });
                        }
                        }

                        // Strategy 3: Try provided URL variables
                        String[] urlVars = { dbUrl, urlVar, databaseUrl };
                        for (String v : urlVars) {
                        if (v == null || v.trim().isEmpty()) continue;
                        String parsed = v;
                        if (v.trim().startsWith("psql")) {
                        parsed = parsePsql(v);
                        } else if (v.startsWith("postgres://")) {
                        parsed = "jdbc:postgresql" + v.substring(8);
                        }

                        if (parsed != null) {
                        if (!parsed.contains("?")) {
                        strategies.add(new String[]{ parsed + "?sslmode=require", "Variable URL (SSL)" });
                        strategies.add(new String[]{ parsed, "Variable URL (No SSL)" });
                        } else {
                        strategies.add(new String[]{ parsed, "Variable URL (As-is)" });
                        }
                        }
                        }

                        // Strategy 4: Local Fallback
                        strategies.add(new String[]{ "jdbc:postgresql://localhost:5432/student", "Localhost Fallback"
                        });

                        Connection con = null;
                        String successfulStrategy = null;
                        String finalUrl = null;
                        StringBuilder diagnosticLog = new StringBuilder();

                        out.println("<div style='background: #e3f2fd; padding: 15px; margin: 20px; border-radius: 5px;'>
                            ");
                            out.println("<h3>🔍 Connection Strategist</h3>");
                            out.println("<p>Trying multiple connection paths to find a working one...</p>");

                            for (String[] strategy : strategies) {
                            String attemptUrl = strategy[0];
                            String attemptName = strategy[1];
                            try {
                            Class.forName("org.postgresql.Driver");
                            con = DriverManager.getConnection(attemptUrl, user, pass);
                            successfulStrategy = attemptName;
                            finalUrl = attemptUrl;
                            diagnosticLog.append("<li style='color: green;'>✅ <strong>SUCCESS:</strong> " + attemptName
                                + "</li>");
                            break;
                            } catch (Exception e) {
                            diagnosticLog.append("<li style='color: #666;'>❌ " + attemptName + ": " + e.getMessage() + "
                            </li>");
                            }
                            }

                            out.println("<ul>" + diagnosticLog.toString() + "</ul>");

                            if (con != null) {
                            out.println("<div
                                style='background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-top: 10px;'>
                                ");
                                out.println("<strong>✓ Connected using:</strong> " + successfulStrategy + "<br>");
                                out.println("<small>Final URL: " + finalUrl.replaceAll(":.*@", ":***@") + "</small>");
                                out.println("</div>");
                            }
                            out.println("</div>");

                        if (con != null) {
                        Statement stmt = con.createStatement();

                        out.println("<div style='background: #fff3cd; padding: 15px; margin: 20px; border-radius: 5px;'>
                            ");
                            out.println("<h3>✅ Database Connected Successfully!</h3>");
                            out.println("</div>");

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