<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="beans.Wunschliste" %>



<%--
   Hier wird die Wunschliste anhand des passenden Tokens
   in der Datenbank rausgesucht
   Listen-Detailansicht anzeigen
   ansonsten  zurueck zur Startseite
--%>


<%
    String shareToken = request.getParameter("listCode");

    if (shareToken != null && !shareToken.trim().isEmpty()) {
        WunschlisteDAO dao = new WunschlisteDAO();
        
        // Suche die Liste anhand des Tokens in der DB
        Wunschliste liste = dao.getWunschlisteByToken(shareToken);

        if (liste != null) {
            // Gefunden! Weiterleitung zur Listen-Detailansicht mit der echten ID
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + liste.getListId());
        } else {
            // Code falsch -> Zurück zur Startseite mit Fehler-Flag
            response.sendRedirect("../jsp/homepage.jsp?error=invalidCode");
        }
    } else {
        response.sendRedirect("../jsp/homepage.jsp");
    }
%>