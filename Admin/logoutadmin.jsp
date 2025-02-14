<%
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("admin_login.jsp");
%>
