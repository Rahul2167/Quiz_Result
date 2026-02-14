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
                    transform: rotateX(360deg);
                    transition: 1s;
                    background-color: rgb(255, 255, 0);

                }
            </style>
        </head>

        <body>

            <h2>🏆 Leaderboard</h2>

            <table>
                <tr>
                    <th>Rank</th>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Score</th>
                    <th>Result</th>
                    <th>Date</th>
                </tr>

                <% int rank=1; String errorMsg=null; Connection con=null; ResultSet rs=null; try { String
                    url=System.getenv("DB_URL"); if (url==null) url="jdbc:postgresql://localhost:5432/student" ; String
                    user=System.getenv("DB_USER"); if (user==null) user="postgres" ; String
                    pwd=System.getenv("DB_PASSWORD"); if (pwd==null) pwd="Rahul@2167" ;
                    Class.forName("org.postgresql.Driver"); con=DriverManager.getConnection(url, user, pwd); // Rank
                    wise (highest score first) String sql="SELECT * FROM quiz_result ORDER BY score DESC, quiz_date ASC"
                    ; Statement stmt=con.createStatement(); rs=stmt.executeQuery(sql); } catch(Exception e) {
                    System.out.println(e); errorMsg="Database Error: " + e.getMessage(); } %>

                    <% if (errorMsg !=null) { %>
                        <div
                            style="width: 80%; margin: 20px auto; color: red; background: #ffe6e6; padding: 10px; border: 1px solid red; border-radius: 5px; text-align: center;">
                            <h3>Something went wrong!</h3>
                            <p>
                                <%= errorMsg %>
                            </p>
                            <p><small>Please check your Environment Variables in Render.</small></p>
                        </div>
                        <% } %>

                            <% if (rs !=null) { try { while(rs.next()) { %>
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
                                <% } con.close(); } catch(Exception e) { out.println(e); } } %>

            </table>

            <a href="index.html">
                <button class="btn">⬅ Back To Quiz</button>
            </a>

        </body>

        </html>