<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Assignment 1</title>
</head>
<body>
	<form name="loginPage" action="./LoginServlet" method="post">
     	<center>
         	<table border="1" cellpadding="5" cellspacing="2">
           	<thead>
             	<tr>
            		<th colspan="2">Login Authentication</th>
              	</tr>
          	</thead>
           	<tbody>
             	<tr>
                 	<td>Username</td>
                    <td><input type="text" id="username" name="username"/></td>
              	</tr>
              	
                <tr>
                  	<td>Password</td>
                    <td><input type="password" id="password" name="password"/></td>
               	</tr>
               	
               	<tr>
                  	<td colspan="2" align="center"><input type="submit" value="Login" /></td>                        
               	</tr>                    
         	</tbody>
      		</table>
      	</center>
  	</form>
</body>
</html>