<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
    <%@ page language="java" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition","attachment;filename=certificate.pdf");
%>

<h2>Certificate of Completion</h2>
<p>This certifies that <b><% String f1= request.getParameter("fullname");%></b></p>
<p>has successfully completed the quiz.</p>


</body>
</html>