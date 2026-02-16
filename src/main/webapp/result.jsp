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
                <title>Result</title>
                <style>
                    body {
                        background: #141e30;
                        color: white;
                        text-align: center;
                        font-family: Arial;
                    }

                    .box {
                        background: white;
                        color: black;
                        width: 500px;
                        margin: 50px auto;
                        padding: 20px;
                        border-radius: 10px;
                    }

                    .p {
                        color: green;
                        font-weight: bold;
                    }

                    .f {
                        color: red;
                        font-weight: bold;
                    }

                    button {
                        padding: 10px;
                        background: #243b55;
                        color: white;
                        border: none;
                        border-radius: 5px;
                        cursor: pointer;
                    }
                </style>
            </head>

            <body>
                <% String q10p=request.getParameter("q10"); if (q10p !=null) session.setAttribute("q10", q10p); String
                    fn=request.getParameter("fullname"); if (fn !=null && !fn.isEmpty()) session.setAttribute("f1", fn);
                    String n=(String)session.getAttribute("f1"); if (n==null) n="Guest" ; String
                    q1=(String)session.getAttribute("q1"); String q2=(String)session.getAttribute("q2"); String
                    q3=(String)session.getAttribute("q3"); String q4=(String)session.getAttribute("q4"); String
                    q5=(String)session.getAttribute("q5"); String q6=(String)session.getAttribute("q6"); String
                    q7=(String)session.getAttribute("q7"); String q8=(String)session.getAttribute("q8"); String
                    q9=(String)session.getAttribute("q9"); String q10=(String)session.getAttribute("q10"); int sc=0; if
                    ("New Delhi".equals(q1)) sc++; if ("Mahatma Gandhi".equals(q2)) sc++; if ("Jupiter".equals(q3))
                    sc++; if ("Alexander Graham Bell".equals(q4)) sc++; if ("Nile".equals(q5)) sc++; if
                    ("2019".equals(q6)) sc++; if ("Fiji".equals(q7)) sc++; if ("Department of Research and Development
                    Laboratory".equals(q8)) sc++; if ("Uranus".equals(q9)) sc++; if ("Dr A.P.J. Abdul
                    Kalam".equals(q10)) sc++; String rv=(sc>= 6) ? "PASS" : "FAIL";
                    String em = null;
                    Connection c = null;
                    try {
                    String dbH = System.getenv("DB_HOST");
                    String dbP = System.getenv("DB_PORT");
                    String dbN = System.getenv("DB_NAME");
                    String dbU = System.getenv("DB_USER");
                    String dbW = System.getenv("DB_PASSWORD");
                    String urlV = System.getenv("URL");
                    if (dbU == null) dbU = "postgres";
                    if (dbW == null) dbW = "Rahul@216746";
                    java.util.List<String> st = new java.util.ArrayList<String>();
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
                            st.add(pu);
                            } else if (urlV.startsWith("postgres://")) {
                            String ju = "jdbc:postgresql" + urlV.substring(8);
                            st.add(ju);
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
                            PreparedStatement ps = c.prepareStatement("INSERT INTO quiz_result(fullname,score,result)
                            VALUES (?,?,?)");
                            ps.setString(1, n); ps.setInt(2, sc); ps.setString(3, rv);
                            ps.executeUpdate();
                            c.close();
                            } else { em = "Conn Failed"; }
                            } catch (Exception e) { em = e.getMessage(); }
                            %>
                            <div class="box">
                                <h1>Welcome <%= n %>
                                </h1>
                                <h2>Score: <%= sc %> / 10</h2>
                                <h3 class="<%= rv.equals(" PASS") ? "p" : "f" %>">Result: <%= rv %>
                                </h3>
                                <hr>
                                <% if (em !=null) { %>
                                    <p style="color:red">DB Error: <%= em %>
                                    </p>
                                    <% } %>
                                        <p>Q1: New Delhi | Ans: <%= q1 %>
                                        </p>
                                        <p>Q2: Mahatma Gandhi | Ans: <%= q2 %>
                                        </p>
                                        <p>Q3: Jupiter | Ans: <%= q3 %>
                                        </p>
                                        <p>Q4: A.G. Bell | Ans: <%= q4 %>
                                        </p>
                                        <p>Q5: Nile | Ans: <%= q5 %>
                                        </p>
                                        <p>Q6: 2019 | Ans: <%= q6 %>
                                        </p>
                                        <p>Q7: Fiji | Ans: <%= q7 %>
                                        </p>
                                        <p>Q8: DRDL | Ans: <%= q8 %>
                                        </p>
                                        <p>Q9: Uranus | Ans: <%= q9 %>
                                        </p>
                                        <p>Q10: Kalam | Ans: <%= q10 %>
                                        </p>
                                        <a href="leaderboard.jsp"><button>Leaderboard</button></a>
                                        <a href="index.html"><button>Home</button></a>
                            </div>
            </body>

            </html>