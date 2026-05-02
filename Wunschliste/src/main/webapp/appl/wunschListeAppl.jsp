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

    // Grundlegende Validierung
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
        // Prüfen, ob das Event-Datum in der Vergangenheit liegt
        istAbgelaufen = aktuelleListe.getEventDate().getTime() < System.currentTimeMillis();
    }

    boolean istBesitzer = aktuelleListe.isOwner(aktuellerNutzer);

    // --- LOGIK-WEICHE ---
    if (istBesitzer) {
        WunschDAO wDAO = new WunschDAO();
        
        // KRITISCHE SPERRE: Wenn abgelaufen, keine schreibenden Aktionen erlauben
        // (Verhindert Manipulation über manuelle URL-Eingabe)
        if (istAbgelaufen && ("deleteWunsch".equals(action) || "editWunsch".equals(action) || "addWunsch".equals(action) || "updateWunsch".equals(action))) {
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId + "&error=expired");
            return;
        }

        // AKTION: Wunsch löschen
        if ("deleteWunsch".equals(action) && giftIdStr != null) {
            wDAO.deleteWunsch(Integer.parseInt(giftIdStr));
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        } 
        
        // AKTION: Zum Bearbeitungs-Formular weiterleiten
        else if ("editWunsch".equals(action) && giftIdStr != null) {
            response.sendRedirect("../jsp/editGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listId);
        } 
        
        // AKTION: Daten aus dem Bearbeitungs-Formular speichern (NEU)
        else if ("updateWunsch".equals(action) && giftIdStr != null) {
            try {
                int gId = Integer.parseInt(giftIdStr);
                String titel = request.getParameter("titel");
                double preis = Double.parseDouble(request.getParameter("preis"));
                int prio = Integer.parseInt(request.getParameter("prio"));
                String link = request.getParameter("link");

                // Update im DAO ausführen
                wDAO.updateWunsch(gId, titel, preis, prio, link);
                
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
            } catch (Exception e) {
                // Bei Fehlern (z.B. falsches Zahlenformat) zurück zum Formular
                response.sendRedirect("../jsp/editGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listId + "&error=invalid");
            }
        }
        
        // AKTION: Zum Formular "Neuer Wunsch" weiterleiten
        else if ("addWunsch".equals(action)) {
            response.sendRedirect("../jsp/addWishesView.jsp?id=" + listId);
        }
        
        // DEFAULT: Zurück zur View
        else {
            response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
        }
    } 
    else {
        // --- GAST-LOGIK ---
        if ("goReserve".equals(action)) {
            // Sperre für Reservierungen, wenn Event vorbei
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