<%@ page import="java.sql.*" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%! public String parsePsql(String psql) { if (psql==null) return null; String t=psql.trim(); if
            (!t.startsWith("psql")) return null; String host=null, port="5432" , db="postgres" ; String[]
            parts=t.split("\\s+"); for (int i=0; i < parts.length; i++) { if (("-h".equals(parts[i]) || "--host"
            .equals(parts[i])) && i + 1 < parts.length) host=parts[i+1]; if (("-p".equals(parts[i]) || "--port"
            .equals(parts[i])) && i + 1 < parts.length) port=parts[i+1]; if (("-d".equals(parts[i]) || "--dbname"
            .equals(parts[i])) && i + 1 < parts.length) db=parts[i+1]; } if (host==null) return null;
            return "jdbc:postgresql://" + host + ":" + port + "/" + db; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Leaderboard</title>
                <style>
                    body {
                        background: linear-gradient(135deg, #141e30, #243b55);
                        font-family: Arial;
                        color: white;
                        text-align: center;
                    }

                    h2 {
                        margin-top: 30px;
                    }

                    table {
                        margin: 30px auto;
                        border-collapse: collapse;
                        width: 80%;
                        background: white;
                        color: black;
                        border-radius: 10px;
                        overflow: hidden;
                    }

                    th {
                        background: #243b55;
                        color: white;
                        padding: 12px;
                    }

                    td {
                        padding: 10px;
                        border-bottom: 1px solid #ddd;
                    }

                    tr:nth-child(even) {
                        background: #f2f2f2;
                    }

                    .btn {
                        padding: 12px 25px;
                        background: #ff4b5c;
                        color: white;
                        border: none;
                        border-radius: 6px;
                        cursor: pointer;
                    }
                </style>
            </head>

            <body>
                <h2>🏆 Leaderboard</h2>
                <% String errorMsg=null; Connection con=null; Statement stmt=null; ResultSet rs=null; try { String
                    dbUrl=System.getenv("DB_URL"); String urlVar=System.getenv("URL"); String
                    host=System.getenv("DB_HOST"); String port=System.getenv("DB_PORT"); String
                    dbName=System.getenv("DB_NAME"); String user=System.getenv("DB_USER"); if (user==null)
                    user="postgres" ; String pass=System.getenv("DB_PASSWORD"); if (pass==null) pass="Rahul@2167" ;
                    java.util.List<String[]> strategies = new java.util.ArrayList<String[]>();
                        if (host != null && dbName != null) {
                        String p = (port != null) ? port : "5432";
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName +
                        "?sslmode=require", "Primary_SSL" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName,
                        "Primary_NoSSL" });
                        if ("6543".equals(p)) {
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName +
                        "?sslmode=require", "Port5432_SSL" });
                        strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName, "Port5432_NoSSL"
                        });
                        }
                        }
                        String[] vList = { dbUrl, urlVar };
                        for (String v : vList) {
                        if (v == null || v.trim().isEmpty()) continue;
                        String vt = v.trim();
                        String pURL = vt.startsWith("psql") ? parsePsql(vt) : (vt.startsWith("postgres://") ?
                        "jdbc:postgresql" + vt.substring(8) : vt);
                        if (pURL != null) {
                        strategies.add(new String[]{ pURL + (pURL.contains("?") ? "" : "?sslmode=require"), "URL_SSL"
                        });
                        strategies.add(new String[]{ pURL, "URL_AsIs" });
                        }
                        }
                        strategies.add(new String[]{ "jdbc:postgresql://localhost:5432/student", "Local" });
                        Class.forName("org.postgresql.Driver");
                        for (String[] s : strategies) {
                        try {
                        con = DriverManager.getConnection(s[0], user, pass);
                        if (con != null) break;
                        } catch (Exception e) {}
                        }
                        if (con != null) {
                        stmt = con.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM quiz_result ORDER BY score DESC, id DESC LIMIT 50");
                        } else { errorMsg = "Could not connect to database."; }
                        } catch (Exception e) { errorMsg = "Error: " + e.getMessage(); }
                        %>
                        <% if (errorMsg !=null) { %>
                            <div
                                style="width: 80%; margin: 20px auto; background:#ffe6e6; color:red; padding:15px; border-radius:5px;">
                                <%= errorMsg %>
                            </div>
                            <% } else { %>
                                <table>
                                    <tr>
                                        <th>Rank</th>
                                        <th>Name</th>
                                        <th>Score</th>
                                        <th>Result</th>
                                        <th>Date</th>
                                    </tr>
                                    <% int rank=1; while(rs !=null && rs.next()) { %>
                                        <tr>
                                            <td>
                                                <%= rank++ %>
                                            </td>
                                            <td>
                                                <%= rs.getString("fullname") %>
                                            </td>
                                            <td>
                                                <%= rs.getInt("score") %>
                                            </td>
                                            <td>
                                                <%= rs.getString("result") %>
                                            </td>
                                            <td>
                                                <%= rs.getDate("quiz_date") %>
                                            </td>
                                        </tr>
                                        <% } %>
                                </table>
                                <% } if(rs !=null) rs.close(); if(stmt !=null) stmt.close(); if(con !=null) con.close();
                                    %>
                                    <a href="index.html"><button class="btn">Back To Quiz</button></a>
            </body>

            </html>