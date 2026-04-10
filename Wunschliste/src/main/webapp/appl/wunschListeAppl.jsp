<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="JDBC.WunschDAO" %>

<%
    // 1. Sicherheit: Session-Check
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    // 2. Parameter holen
    String action = request.getParameter("action");
    String listIdStr = request.getParameter("listId");
    String giftIdStr = request.getParameter("giftId");

    if (listIdStr == null || action == null) {
        response.sendRedirect("../jsp/dashboardView.jsp");
        return;
    }

    int listId = Integer.parseInt(listIdStr);
    
    // Prüfen, wer die Aktion ausführt
    WunschlisteDAO lDAO = new WunschlisteDAO();
    Wunschliste aktuelleListe = lDAO.getWunschlisteById(listId);
    boolean istBesitzer = aktuelleListe.isOwner(aktuellerNutzer);

    // --- LOGIK-WEICHE ---
    if (istBesitzer) {
        // WEG A: BESITZER-LOGIK
        WunschDAO wDAO = new WunschDAO();
        
        if ("deleteWunsch".equals(action) && giftIdStr != null) {
            wDAO.deleteWunsch(Integer.parseInt(giftIdStr));
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        } 
        else if ("editWunsch".equals(action) && giftIdStr != null) {
            // Weiterleitung zur Bearbeiten-Seite
            response.sendRedirect("../jsp/editGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listId);
        } else {
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        }
    } 
    else {
        // WEG B: GAST-LOGIK
        if ("goReserve".equals(action)) {
    String gId = request.getParameter("giftId");
    String lId = request.getParameter("listId");

    // Falls die Parameter da sind, hänge sie an den Redirect an
    if (gId != null && lId != null) {
        response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + gId + "&listId=" + lId);
    } else {
        response.sendRedirect("../jsp/dashboardView.jsp");
    }
    return; // Wichtig: Damit die restliche Appl nicht weiter ausgeführt wird
}
    }
%>