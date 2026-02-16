<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Leaderboard</title>

            <style>
                body {
                    background: linear-gradient(135deg, #141e30, #243b55);
                    font-family: Arial, sans-serif;
                    color: white;
                    text-align: center;
                }

                h2 {
                    text-align: center;
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
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
                }

                th {
                    background: #243b55;
                    color: white;
                    padding: 12px;
                    text-align: center;
                }

                td {
                    padding: 10px;
                    text-align: center;
                }

                tr:nth-child(even) {
                    background: #f2f2f2;
                }

                tr:hover {
                    background: #dcdcdc;
                }

                .btn {
                    display: block;
                    margin: 20px auto;
                    padding: 12px 25px;
                    background: #ff4b5c;
                    color: black;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 16px;
                }

                .btn:hover {
                    background: #ff2e44;
                    transition: 0.3s;
                    transform: scale(1.05);
                    color: white;
                }
            </style>
        </head>

        <body>

            <h2>🏆 Leaderboard</h2>

            <% String errorMsg=null; Connection con=null; Statement stmt=null; ResultSet rs=null; try { /* Database
                Connection */ String bucketUrl=System.getenv("DB_URL"); String host=System.getenv("DB_HOST"); String
                dbName=System.getenv("DB_NAME"); String user=System.getenv("DB_USER"); String
                password=System.getenv("DB_PASSWORD"); String port=System.getenv("DB_PORT"); String url; if (host !=null
                && dbName !=null) { if (port==null) port="5432" ; url="jdbc:postgresql://" + host + ":" + port + "/" +
                dbName + "?sslmode=require&prepareThreshold=0" ; } else if (bucketUrl !=null) { url=bucketUrl; } else {
                url="jdbc:postgresql://localhost:5432/student" ; } if (user==null) user="postgres" ; if (password==null)
                password="Rahul@2167" ; Class.forName("org.postgresql.Driver"); con=DriverManager.getConnection(url,
                user, password); /* Rank wise query */ String
                sql="SELECT * FROM quiz_result ORDER BY score DESC, quiz_date ASC" ; stmt=con.createStatement();
                rs=stmt.executeQuery(sql); } catch(Exception e) { errorMsg=e.getMessage(); e.printStackTrace(); } %>

                <% if (errorMsg !=null) { %>
                    <div
                        style="width: 80%; margin: 20px auto; background-color: #ffe6e6; color: red; padding: 15px; border-radius: 5px; text-align: left;">
                        <strong>Error connecting to database:</strong><br>
                        <%= errorMsg %>
                    </div>
                    <% } else { %>
                        <table>
                            <tr>
                                <th>Rank</th>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Score</th>
                                <th>Result</th>
                                <th>Date</th>
                            </tr>

                            <% int rank=1; if (rs !=null) { while(rs.next()) { %>
                                <tr>
                                    <td>
                                        <%= rank++ %>
                                    </td>
                                    <td>
                                        <%= rs.getInt("id") %>
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
                                <% } } %>
                        </table>
                        <% } /* Close resources */ if(rs !=null) rs.close(); if(stmt !=null) stmt.close(); if(con
                            !=null) con.close(); %>

                            <a href="index.html" style="text-decoration: none;">
                                <button class="btn">⬅ Back To Quiz</button>
                            </a>

        </body>

        </html>