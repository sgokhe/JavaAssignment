<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>NHLTeams</title>
</head>
<body>
<h1>NHL Teams List</h1>
<table border="1">
	<tr>
		<th>Team Name</th>
		<th>Head Coach</th>
		<th>Asst Coach</th>
		<th>Manager</th>
	</tr>	
	<c:forEach items="${teams}" var="team">
		<tr>
			<td><c:out value="${team.getTeamname()}"/></td>
			<td><c:out value="${team.getHeadCoach()}"/></td>
			<td><c:out value="${team.getAsstCoach()}"/></td>
			<td><c:out value="${team.getManager()}"/></td>
		</tr>
	</c:forEach>
</table>
</body>
</html>