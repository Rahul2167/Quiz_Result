<%@ page language="java" %>
    <%@ page import="java.sql.*" %>
        <%! public String pP(String p) { if (p==null) return null; String t=p.trim(); if (!t.startsWith("psql")) return
            null; String h=null, pt="5432" , d="postgres" ; String[] s=t.split("\\s+"); for (int i=0; i < s.length; i++)
            { if ("-h".equals(s[i]) && i+1 < s.length) h=s[i+1]; if ("-p".equals(s[i]) && i+1 < s.length) pt=s[i+1]; if
            ("-d".equals(s[i]) && i+1 < s.length) d=s[i+1]; } if (h==null) return null; return "jdbc:postgresql://" + h
            + ":" + pt + "/" + d; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>DB Init</title>
            </head>

            <body>
                <h1>Init</h1>
                <% try { String dbH=System.getenv("DB_HOST"); String dbP=System.getenv("DB_PORT"); String
                    dbN=System.getenv("DB_NAME"); String dbU=System.getenv("DB_USER"); String
                    dbW=System.getenv("DB_PASSWORD"); String urlV=System.getenv("URL"); if (dbU==null) dbU="postgres" ;
                    if (dbW==null) dbW="Rahul@216746" ; java.util.List<String> st = new java.util.ArrayList<String>();
                        if (dbH != null && dbN != null) {
                        String p = (dbP != null) ? dbP : "5432";
                        st.add("jdbc:postgresql://"+dbH+":"+p+"/"+dbN+"?sslmode=require");
                        st.add("jdbc:postgresql://"+dbH+":"+p+"/"+dbN);
                        if ("6543".equals(p)) {
                        st.add("jdbc:postgresql://"+dbH+":5432/"+dbN+"?sslmode=require");
                        }
                        }
                        if (urlV != null) {
                        String pu = pP(urlV);
                        if (pu != null) {
                        st.add(pu+"?sslmode=require");
                        } else if (urlV.startsWith("postgres://")) {
                        st.add("jdbc:postgresql" + urlV.substring(8));
                        }
                        }
                        Connection c = null; String suc = null;
                        for (String s : st) {
                        try {
                        Class.forName("org.postgresql.Driver");
                        c = DriverManager.getConnection(s, dbU, dbW);
                        if (c != null) { suc = s; break; }
                        } catch (Exception ex) { out.println("Fail: " + s + "<br>"); }
                        }
                        if (c != null) {
                        out.println("Success: " + suc + "<br>");
                        Statement stm = c.createStatement();
                        stm.executeUpdate("CREATE TABLE IF NOT EXISTS quiz_result (id SERIAL PRIMARY KEY, fullname
                        VARCHAR(255), score INT, result VARCHAR(50), quiz_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
                        out.println("Table Checked<br>");
                        c.close();
                        }
                        } catch (Exception e) { out.println("Error: " + e.getMessage()); }
                        %>
                        <a href="index.html">Home</a>
            </body>

            </html>