<%@ page import="java.sql.*" %>
    <%@ page language="java" %>
        <%! /* Helper to parse psql command if provided as a URL */ public String parsePsql(String psql) { if
            (psql==null) return null; String t=psql.trim(); if (!t.startsWith("psql")) return null; String host=null,
            port="5432" , db="postgres" ; String[] parts=t.split("\\s+"); for (int i=0; i < parts.length; i++) { if
            (("-h".equals(parts[i]) || "--host" .equals(parts[i])) && i + 1 < parts.length) host=parts[i+1]; if
            (("-p".equals(parts[i]) || "--port" .equals(parts[i])) && i + 1 < parts.length) port=parts[i+1]; if
            (("-d".equals(parts[i]) || "--dbname" .equals(parts[i])) && i + 1 < parts.length) db=parts[i+1]; } return
            host !=null ? "jdbc:postgresql://" + host + ":" + port + "/" + db : null; } %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Final Result</title>
                <style>
                    body {
                        background: linear-gradient(135deg, #141e30, #243b55);
                        font-family: Arial;
                        color: white;
                        text-align: center;
                    }

                    .box {
                        background: white;
                        color: black;
                        width: 600px;
                        margin: 40px auto;
                        padding: 30px;
                        border-radius: 10px;
                    }

                    .pass {
                        color: green;
                        font-weight: bold;
                    }

                    .fail {
                        color: red;
                        font-weight: bold;
                    }

                    button {
                        padding: 10px 20px;
                        background: #243b55;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                    }
                </style>
            </head>

            <body>
                <% /* Capture Form Data */ String q10Param=request.getParameter("q10"); session.setAttribute("q10",
                    q10Param); String sName=request.getParameter("fullname"); if (sName !=null &&
                    !sName.trim().isEmpty()) { session.setAttribute("f1", sName); } /* Retrieve Data */ String
                    name=(String) session.getAttribute("f1"); if (name==null) { name="Guest" ; } String q1=(String)
                    session.getAttribute("q1"); String q2=(String) session.getAttribute("q2"); String q3=(String)
                    session.getAttribute("q3"); String q4=(String) session.getAttribute("q4"); String q5=(String)
                    session.getAttribute("q5"); String q6=(String) session.getAttribute("q6"); String q7=(String)
                    session.getAttribute("q7"); String q8=(String) session.getAttribute("q8"); String q9=(String)
                    session.getAttribute("q9"); String q10=(String) session.getAttribute("q10"); /* Calculate Score */
                    int score=0; if ("New Delhi".equals(q1)) score++; if ("Mahatma Gandhi".equals(q2)) score++; if
                    ("Jupiter".equals(q3)) score++; if ("Alexander Graham Bell".equals(q4)) score++; if
                    ("Nile".equals(q5)) score++; if ("2019".equals(q6)) score++; if ("Fiji".equals(q7)) score++; if
                    ("Department of Research and Development Laboratory".equals(q8)) score++; if ("Uranus".equals(q9))
                    score++; if ("Dr A.P.J. Abdul Kalam".equals(q10)) score++; String resV=(score>= 6) ? "PASS" :
                    "FAIL";

                    /* Database Connection */
                    String errorMsg = null;
                    Connection con = null;
                    try {
                    String dbUrl = System.getenv("DB_URL");
                    String urlVar = System.getenv("URL");
                    String databaseUrl = System.getenv("DATABASE_URL");
                    String host = System.getenv("DB_HOST");
                    String port = System.getenv("DB_PORT");
                    String dbName = System.getenv("DB_NAME");
                    String user = System.getenv("DB_USER"); if (user == null) user = "postgres";
                    String pass = System.getenv("DB_PASSWORD"); if (pass == null) pass = "Rahul@2167";

                    java.util.List<String[]> strategies = new java.util.ArrayList<String[]>();
                            if (host != null && dbName != null) {
                            String p = (port != null) ? port : "5432";
                            strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName +
                            "?sslmode=require", "Primary (SSL)" });
                            strategies.add(new String[]{ "jdbc:postgresql://" + host + ":" + p + "/" + dbName, "Primary
                            (No SSL)" });
                            if ("6543".equals(p)) {
                            strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName +
                            "?sslmode=require", "Host + 5432 (SSL)" });
                            strategies.add(new String[]{ "jdbc:postgresql://" + host + ":5432/" + dbName, "Host + 5432
                            (No SSL)" });
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
                            strategies.add(new String[]{ "jdbc:postgresql://localhost:5432/student", "Localhost" });

                            Class.forName("org.postgresql.Driver");
                            for (String[] s : strategies) {
                            try {
                            con = DriverManager.getConnection(s[0], user, pass);
                            if (con != null) break;
                            } catch (Exception e) { /* try next */ }
                            }

                            if (con == null) throw new Exception("All connection strategies failed.");

                            PreparedStatement ps = con.prepareStatement("INSERT INTO quiz_result(fullname, score,
                            result) VALUES (?, ?, ?)");
                            ps.setString(1, name); ps.setInt(2, score); ps.setString(3, resV);
                            ps.executeUpdate();
                            } catch(Exception e) {
                            System.out.println("DB Error: " + e);
                            errorMsg = "Database Error: " + e.getMessage();
                            } finally {
                            if (con != null) { try { con.close(); } catch (SQLException se) { se.printStackTrace(); } }
                            }
                            %>

                            <div class="box">
                                <h1>Welcome, <%= name %>!</h1>
                                <h2>Quiz Result</h2>
                                <% if (errorMsg !=null) { %>
                                    <div
                                        style="background-color: #ffe6e6; color: red; padding: 10px; border: 1px solid red; margin-bottom: 20px;">
                                        <strong>System Error:</strong>
                                        <%= errorMsg %> <br>
                                            <small>The app could not connect to the database. Results were not
                                                saved.</small>
                                    </div>
                                    <% } %>
                                        <h3>Candidate: <%= name %>
                                        </h3>
                                        <h3>Score: <%= score %> / 10</h3>
                                        <h3 class="<%= resV.equals(" PASS") ? "pass" : "fail" %>">Result: <%= resV %>
                                        </h3>
                                        <hr>
                                        <p>Q1: New Delhi | Your Ans: <%= q1 %>
                                        </p>
                                        <p>Q2: Mahatma Gandhi | Your Ans: <%= q2 %>
                                        </p>
                                        <p>Q3: Jupiter | Your Ans: <%= q3 %>
                                        </p>
                                        <p>Q4: Alexander Graham Bell | Your Ans: <%= q4 %>
                                        </p>
                                        <p>Q5: Nile | Your Ans: <%= q5 %>
                                        </p>
                                        <p>Q6: 2019 | Your Ans: <%= q6 %>
                                        </p>
                                        <p>Q7: Fiji | Your Ans: <%= q7 %>
                                        </p>
                                        <p>Q8: DRDL | Your Ans: <%= q8 %>
                                        </p>
                                        <p>Q9: Uranus | Your Ans: <%= q9 %>
                                        </p>
                                        <p>Q10: Dr A.P.J. Abdul Kalam | Your Ans: <%= q10 %>
                                        </p>
                                        <form action="leaderboard.jsp"><button>Check Leaderboard</button></form>
                                        <form action="certificate.jsp"><button>Download Certificate</button></form>
                            </div>
            </body>

            </html>