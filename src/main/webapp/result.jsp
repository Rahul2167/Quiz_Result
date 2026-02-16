<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%! 
    /* Helper to parse psql command if provided as a URL */
    public String parsePsql(String psql) {
        if (psql == null) return null;
        String t = psql.trim();
        if (!t.startsWith("psql")) return null;
        String host = null, port = "5432", db = "postgres";
        String[] parts = t.split("\\s+");
        for (int i = 0; i < parts.length; i++) {
            if (("-h".equals(parts[i]) || "--host".equals(parts[i])) && i + 1 < parts.length)
                host = parts[i + 1];
            if (("-p".equals(parts[i]) || "--port".equals(parts[i])) && i + 1 < parts.length)
                port = parts[i + 1];
            if (("-d".equals(parts[i]) || "--dbname".equals(parts[i])) && i + 1 < parts.length)
                db = parts[i + 1];
        }
        return host != null ? "jdbc:postgresql://" + host + ":" + port + "/" + db : null;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Results</title>
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
    <h2>📊 Quiz Results</h2>
    <%
        String errorMsg = null;
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;

        String dbUrl = System.getenv("DB_URL");
        String urlVar = System.getenv("URL");
        String databaseUrl = System.getenv("DATABASE_URL");
        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");

        if (user == null) user = "postgres";
        if (pass == null) pass = "Rahul@2167";

        /* Multi-Try Logic */
        java.util.List<String[]> strategies = new java.util.ArrayList<String[]>();

        if (host != null && dbName != null) {
            String p = (port != null) ? port : "5432";
            strategies.add(new String[] { "jdbc:postgresql://" + host + ":" + p + "/" + dbName + "?sslmode=require", "Primary (SSL)" });
            strategies.add(new String[] { "jdbc:postgresql://" + host + ":" + p + "/" + dbName, "Primary (No SSL)" });
            if ("6543".equals(p)) {
                strategies.add(new String[] { "jdbc:postgresql://" + host + ":5432/" + dbName + "?sslmode=require", "Host + 5432 (SSL)" });
                strategies.add(new String[] { "jdbc:postgresql://" + host + ":5432/" + dbName, "Host + 5432 (No SSL)" });
            }
        }

        String[] vars = { dbUrl, urlVar, databaseUrl };
        for (String v : vars) {
            if (v == null || v.trim().isEmpty()) continue;
            String vt = v.trim();
            String parsed = vt.startsWith("psql") ? parsePsql(vt) : (vt.startsWith("postgres://") ? "jdbc:postgresql" + vt.substring(8) : vt);
            if (parsed != null) {
                String sUrl = parsed + (parsed.contains("?") ? (parsed.contains("sslmode") ? "" : "&sslmode=require") : "?sslmode=require");
                strategies.add(new String[] { sUrl, "URL Var (SSL)" });
                strategies.add(new String[] { parsed, "URL Var (As-is)" });
            }
        }

        strategies.add(new String[] { "jdbc:postgresql://localhost:5432/student", "Localhost" });

        try {
            Class.forName("org.postgresql.Driver");
            for (String[] s : strategies) {
                try {
                    con = DriverManager.getConnection(s[0], user, pass);
                    if (con != null) break;
                } catch (Exception e) { /* try next */ }
            }
            if (con == null) throw new Exception("All connection strategies failed.");

            String sql = "SELECT * FROM quiz_result ORDER BY quiz_date DESC";
            stmt = con.createStatement();
            rs = stmt.executeQuery(sql);
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
    %>

    <% if (errorMsg != null) { %>
        <div style="width: 80%; margin: 20px auto; background-color: #ffe6e6; color: red; padding: 15px; border-radius: 5px; text-align: left;">
            <strong>Error connecting to database:</strong><br>
            <%= errorMsg %>
        </div>
    <% } else { %>
        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Score</th>
                <th>Result</th>
                <th>Date</th>
            </tr>
            <% if (rs != null) {
                   while (rs.next()) { %>
                       <tr>
                           <td><%= rs.getInt("id") %></td>
                           <td><%= rs.getString("fullname") %></td>
                           <td><%= rs.getInt("score") %></td>
                           <td><%= rs.getString("result") %></td>
                           <td><%= rs.getDate("quiz_date") %></td>
                       </tr>
            <%     }
               } %>
        </table>
    <% } %>

    <%
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    %>

    <a href="index.html" style="text-decoration: none;">
        <button class="btn">⬅ Back To Quiz</button>
    </a>
</body>
</html>