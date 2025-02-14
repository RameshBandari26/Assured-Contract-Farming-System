<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%

    // If a session exists, invalidate it to log the user out
    if (session != null) {
        session.invalidate(); // Invalidate the session, effectively logging the user out
    }

    // Redirect the user to the login page
    response.sendRedirect("login.jsp");
%>
