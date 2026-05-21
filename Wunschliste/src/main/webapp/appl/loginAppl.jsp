<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="JDBC.NutzerDAO" %>



<%--
    Einloggen des Nutzers
    Hier wird zusätzlich die Validierung gemacht
    Falls fehler bei der Validierung kommt es zum Error.
--%>

<%
    String userEingabe = request.getParameter("username");
    String passEingabe = request.getParameter("password");

    // Sicherheits-Check: Falls die Parameter null sind (direkter Aufruf der Seite)
    if (userEingabe == null || passEingabe == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    NutzerDAO dao = new NutzerDAO();
    // Das DAO übernimmt die Prüfung gegen die DB
    Nutzer validierterNutzer = dao.loginUser(userEingabe, passEingabe);

    if (validierterNutzer != null) {
        // LOGIN ERFOLGREICH
        session.setAttribute("eingeloggterNutzer", validierterNutzer);
        response.sendRedirect("../jsp/dashboardView.jsp");
    } else {
        // LOGIN FEHLGESCHLAGEN
        response.sendRedirect("../jsp/loginView.jsp?error=1");
    }
%>