<%@ page import="java.sql.*" %>
    <%@ page language="java" %>

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

            <% // 1. Capture Form Data session.setAttribute("q10", request.getParameter("q10")); String
                submittedName=request.getParameter("fullname"); if (submittedName !=null &&
                !submittedName.trim().isEmpty()) { session.setAttribute("f1", submittedName); // Ensure name is in
                session } // 2. Retrieve Data String name=(String) session.getAttribute("f1"); if (name==null)
                name="Guest" ; String q1=(String) session.getAttribute("q1"); String q2=(String)
                session.getAttribute("q2"); String q3=(String) session.getAttribute("q3"); String q4=(String)
                session.getAttribute("q4"); String q5=(String) session.getAttribute("q5"); String q6=(String)
                session.getAttribute("q6"); String q7=(String) session.getAttribute("q7"); String q8=(String)
                session.getAttribute("q8"); String q9=(String) session.getAttribute("q9"); String q10=(String)
                session.getAttribute("q10"); // 3. Calculate Score int score=0; if("New Delhi".equals(q1)) score++;
                if("Mahatma Gandhi".equals(q2)) score++; if("Jupiter".equals(q3)) score++; if("Alexander Graham
                Bell".equals(q4)) score++; if("Nile".equals(q5)) score++; if("2019".equals(q6)) score++;
                if("Fiji".equals(q7)) score++; if("Department of Research and Development Laboratory".equals(q8))
                score++; if("Uranus".equals(q9)) score++; if("Dr A.P.J. Abdul Kalam".equals(q10)) score++; String
                resultVal=(score>= 6) ? "PASS" : "FAIL";

                // 4. Database Connection (Dynamic for Render)
                String errorMsg = null;
                try {
                Connection con;

                // Allow both Individual Env Vars (Render Managed DB) and Single DB_URL
                String bucketUrl = System.getenv("DB_URL");
                String host = System.getenv("DB_HOST");
                String dbName = System.getenv("DB_NAME");
                String user = System.getenv("DB_USER");
                String password = System.getenv("DB_PASSWORD");

                String url;
                if (host != null && dbName != null) {
                // Render Managed DB pattern
                url = "jdbc:postgresql://" + host + ":5432/" + dbName;
                } else if (bucketUrl != null) {
                // Generic connection string
                url = bucketUrl;
                } else {
                // Fallback for local
                url = "jdbc:postgresql://localhost:5432/student";
                }

                if (user == null) user = "postgres";
                if (password == null) password = "Rahul@2167"; // Fallback only

                Class.forName("org.postgresql.Driver");
                con = DriverManager.getConnection(url, user, password);

                PreparedStatement ps = con.prepareStatement(
                "INSERT INTO quiz_result(fullname,score,result) VALUES (?,?,?)");

                ps.setString(1, name);
                ps.setInt(2, score);
                ps.setString(3, resultVal);

                ps.executeUpdate();
                con.close();
                } catch(Exception e) {
                System.out.println("DB Connection Error: " + e);
                errorMsg = "Database Error: " + e.getMessage();
                }
                %>

                <h1 id=welcome>Welcome, <%= name %>!</h1>

                <div class="box">
                    <h2>Quiz Result</h2>

                    <!-- Error Display -->
                    <% if (errorMsg !=null) { %>
                        <div
                            style="background-color: #ffe6e6; color: red; padding: 10px; border: 1px solid red; margin-bottom: 20px;">
                            <strong>System Error:</strong>
                            <%= errorMsg %> <br>
                                <small>The app could not connect to the database. Results were not saved.</small>
                        </div>
                        <% } %>

                            <h3>Candidate: <%= name %>
                            </h3>
                            <h3>Score: <%= score %> / 10</h3>

                            <h3 class="<%= resultVal.equals(" PASS") ? "pass" : "fail" %>">
                                Result: <%= resultVal %>
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
                            <p>Q8: Department of Research and Development Laboratory | Your Ans: <%= q8 %>
                            </p>
                            <p>Q9: Uranus | Your Ans: <%= q9 %>
                            </p>
                            <p>Q10: Dr A.P.J. Abdul Kalam | Your Ans: <%= q10 %>
                            </p>

                            <form action="leaderboard.jsp">
                                <button>Check Leaderboard</button>
                            </form>

                            <form action="certificate.jsp">
                                <button>Download Certificate</button>
                            </form>
                </div>

        </body>

        </html>