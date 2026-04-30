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
    
    // Daten laden
    WunschlisteDAO lDAO = new WunschlisteDAO();
    Wunschliste aktuelleListe = lDAO.getWunschlisteById(listId);
    
    if (aktuelleListe == null) {
        response.sendRedirect("../jsp/dashboardView.jsp");
        return;
    }

    // --- ABLAUF-LOGIK CHECK ---
    boolean istAbgelaufen = false;
    if (aktuelleListe.getEventDate() != null) {
        istAbgelaufen = aktuelleListe.getEventDate().getTime() < System.currentTimeMillis();
    }

    boolean istBesitzer = aktuelleListe.isOwner(aktuellerNutzer);

    // --- LOGIK-WEICHE ---
    if (istBesitzer) {
        WunschDAO wDAO = new WunschDAO();
        
        // KRITISCHE SPERRE: Wenn abgelaufen, keine schreibenden Aktionen erlauben
        if (istAbgelaufen && ("deleteWunsch".equals(action) || "editWunsch".equals(action) || "addWunsch".equals(action))) {
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId + "&error=expired");
            return;
        }

        if ("deleteWunsch".equals(action) && giftIdStr != null) {
            wDAO.deleteWunsch(Integer.parseInt(giftIdStr));
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        } 
        else if ("editWunsch".equals(action) && giftIdStr != null) {
            response.sendRedirect("../jsp/editGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listId);
        } 
        else if ("addWunsch".equals(action)) {
            response.sendRedirect("../jsp/addWishesView.jsp?id=" + listId);
        }
        else {
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        }
    } 
    else {
        // GAST-LOGIK
        if ("goReserve".equals(action)) {
            // Sperre für Reservierungen
            if (istAbgelaufen) {
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId + "&error=expired");
                return;
            }

            if (giftIdStr != null) {
                response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listId);
            } else {
                response.sendRedirect("../jsp/dashboardView.jsp");
            }
        }
    }
%>