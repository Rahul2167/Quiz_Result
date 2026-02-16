<%@ page import="java.sql.*" %>
    <%@ page language="java" %>
        <%! public String pP(String p) { if (p==null) return null; String t=p.trim(); if (!t.startsWith("psql")) return
            null; String h=null, pt="5432" , d="postgres" ; String[] s=t.split("\\s+"); for (int i=0; i < s.length; i++)
            { if ("-h".equals(s[i]) && i+1 < s.length) h=s[i+1]; if ("-p".equals(s[i]) && i+1 < s.length) pt=s[i+1]; if
            ("-d".equals(s[i]) && i+1 < s.length) d=s[i+1]; } if (h==null) return null; return "jdbc:postgresql://" + h
            + ":" + pt + "/" + d; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Leaderboard</title>
                <style>
                    body {
                        background: #141e30;
                        color: white;
                        text-align: center;
                        font-family: Arial;
                    }

                    table {
                        margin: 20px auto;
                        border-collapse: collapse;
                        width: 80%;
                        background: white;
                        color: black;
                        border-radius: 8px;
                        overflow: hidden;
                    }

                    th {
                        background: #243b55;
                        color: white;
                        padding: 12px;
                    }

                    td {
                        padding: 8px;
                        border-bottom: 1px solid #ddd;
                    }

                    button {
                        padding: 10px 20px;
                        background: #ff4b5c;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                    }
                </style>
            </head>

            <body>
                <h2>🏆 Leaderboard</h2>
                <% String em=null; Connection c=null; Statement stm=null; ResultSet rs=null; try { String
                    dbH=System.getenv("DB_HOST"); String dbP=System.getenv("DB_PORT"); String
                    dbN=System.getenv("DB_NAME"); String dbU=System.getenv("DB_USER"); String
                    dbW=System.getenv("DB_PASSWORD"); String urlV=System.getenv("URL"); if (dbU==null) dbU="postgres" ;
                    if (dbW==null) dbW="Rahul@216746" ; java.util.List<String> st = new java.util.ArrayList<String>();
                        if (dbH != null && dbN != null) {
                        String p = (dbP != null) ? dbP : "5432";
                        st.add("jdbc:postgresql://" + dbH + ":" + p + "/" + dbN + "?sslmode=require");
                        st.add("jdbc:postgresql://" + dbH + ":" + p + "/" + dbN);
                        if ("6543".equals(p)) {
                        st.add("jdbc:postgresql://" + dbH + ":5432/" + dbN + "?sslmode=require");
                        }
                        }
                        if (urlV != null) {
                        String pu = pP(urlV);
                        if (pu != null) {
                        st.add(pu + "?sslmode" + "=require");
                        st.add(pu);
                        } else if (urlV.startsWith("postgres://")) {
                        st.add("jdbc:postgresql" + urlV.substring(8));
                        }
                        }
                        st.add("jdbc:postgresql://localhost:5432/student");
                        Class.forName("org.postgresql.Driver");
                        for (String s : st) {
                        try {
                        c = DriverManager.getConnection(s, dbU, dbW);
                        if (c != null) break;
                        } catch (Exception ex) {}
                        }
                        if (c != null) {
                        stm = c.createStatement();
                        String sql = "SELECT * FROM " + "quiz_result" + " ORDER BY " + "score DESC, id DESC " + "LIMIT
                        100";
                        rs = stm.executeQuery(sql);
                        } else { em = "Database Connectivity Failed"; }
                        } catch (Exception e) { em = e.getMessage(); }
                        %>
                        <% if (em !=null) { %>
                            <div style="color:red; background:#ffe6e6; padding:10px; margin:20px;"><b>Error:</b>
                                <%= em %>
                            </div>
                            <% } else { %>
                                <table>
                                    <tr>
                                        <th>Rank</th>
                                        <th>Name</th>
                                        <th>Score</th>
                                        <th>Result</th>
                                    </tr>
                                    <% int r=1; while(rs !=null && rs.next()) { %>
                                        <tr>
                                            <td>
                                                <%= r++ %>
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
                                        </tr>
                                        <% } %>
                                </table>
                                <% } if(rs !=null) rs.close(); if(stm !=null) stm.close(); if(c !=null) c.close(); %>
                                    <a href="index.html"><button>Back To Quiz</button></a>
            </body>

            </html>