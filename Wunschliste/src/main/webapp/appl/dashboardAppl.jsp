<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="JDBC.WunschlisteDAO" %>

<%
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    String action = request.getParameter("action");
    String idStr = request.getParameter("id");
    WunschlisteDAO dao = new WunschlisteDAO();

    // FALL 1: Liste löschen
    if ("delete".equals(action)) {
        if (idStr != null) {
            dao.deleteWunschliste(Integer.parseInt(idStr));
        }
        // Nach dem Löschen zurück zum Dashboard
        response.sendRedirect("../jsp/dashboardView.jsp");
        return;
    }

    // FALL 2: Liste öffnen (Die Weiche zur wunschlisteView)
    if ("open".equals(action)) {
        if (idStr != null) {
            // Leitet direkt an die wunschlisteView weiter und gibt die ID mit
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + idStr);
            return;
        }
    }

    // Standard-Fall: Wenn nichts passt, einfach zurück zum Dashboard
    response.sendRedirect("../jsp/dashboardView.jsp");
%>