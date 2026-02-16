<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Initialization</title>
        </head>

        <body>
            <h1>Database Status</h1>
            <% try { String bucketUrl=System.getenv("DB_URL"); String host=System.getenv("DB_HOST"); String
                dbName=System.getenv("DB_NAME"); String user=System.getenv("DB_USER"); String
                password=System.getenv("DB_PASSWORD"); String port=System.getenv("DB_PORT"); String url; if (host !=null
                && dbName !=null) { if (port==null) port="5432" ; url="jdbc:postgresql://" + host + ":" + port + "/" +
                dbName + "?sslmode=require" ; } else if (bucketUrl !=null) { url=bucketUrl; } else {
                url="jdbc:postgresql://localhost:5432/student" ; } if (user==null) user="postgres" ; if (password==null)
                password="Rahul@2167" ; Class.forName("org.postgresql.Driver"); Connection
                con=DriverManager.getConnection(url, user, password); Statement stmt=con.createStatement(); String
                sql="CREATE TABLE IF NOT EXISTS quiz_result (" + "id SERIAL PRIMARY KEY, " + "fullname VARCHAR(255), "
                + "score INT, " + "result VARCHAR(50), " + "quiz_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP" + ")" ;
                stmt.executeUpdate(sql); /* Insert sample data if empty */ ResultSet countRs=stmt.executeQuery("SELECT
                COUNT(*) FROM quiz_result"); countRs.next(); if (countRs.getInt(1)==0) { stmt.executeUpdate("INSERT INTO
                quiz_result (fullname, score, result) VALUES ('Sample User', 8, 'PASS' )"); out.println("<h3>Inserted
                sample data.</h3>");
                }

                out.println("<h2 style='color:green'>Success! Database Connection OK. Table 'quiz_result' is ready.</h2>
                ");
                con.close();
                } catch (Exception e) {
                out.println("<h2 style='color:red'>Error: " + e.getMessage() + "</h2>");
                e.printStackTrace(new java.io.PrintWriter(out));
                }
                %>
                <a href="index.html">Go to Home</a>
        </body>

        </html>