<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Reservierungen" %>
<%@ page import="JDBC.ReservierungDAO" %>

<%
    // 1. Sicherheit: Ist ein Nutzer/Gast eingeloggt?
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    // 2. Allgemeine Parameter abrufen
    String action = request.getParameter("action");
    String listIdStr = request.getParameter("listId");
    String giftIdStr = request.getParameter("giftId");

    // Datenbank-Objekt initialisieren
    ReservierungDAO resDao = new ReservierungDAO();

    // --- WEICHE 1: RESERVIERUNG STORNIEREN (AUSTRAGEN) ---
    if ("cancel".equals(action)) {
        String resIdStr = request.getParameter("resId");
        
        if (resIdStr != null) {
            try {
                int resId = Integer.parseInt(resIdStr);
                // Nutzt deine bestehende Methode im DAO
                resDao.deleteReservation(resId);
                
                // Zurück zur Liste
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listIdStr);
            } catch (Exception e) {
                response.sendRedirect("../jsp/dashboardView.jsp");
            }
        }
        return; // Wichtig: Hier abbrechen
    }

    // --- WEICHE 2: NEUE RESERVIERUNG SPEICHERN ---
    if (giftIdStr != null && listIdStr != null) {
        try {
            int giftId = Integer.parseInt(giftIdStr);
            String isPartial = request.getParameter("isPartial");
            String amountStr = request.getParameter("amount");
            String fullPriceStr = request.getParameter("fullPrice");

            double amountToReserve = 0.0;

            // Logik: Teilbetrag oder Voller Betrag?
            if ("true".equals(isPartial)) {
                if (amountStr == null || amountStr.trim().isEmpty()) {
                    throw new NumberFormatException("Betrag leer");
                }
                amountToReserve = Double.parseDouble(amountStr.replace(",", "."));
            } else {
                amountToReserve = Double.parseDouble(fullPriceStr.replace(",", "."));
            }

            // Reservierungs-Objekt erstellen
            Reservierungen neueRes = new Reservierungen();
            neueRes.setGiftId(giftId);
            neueRes.setGuestId(aktuellerNutzer.getUserid());
            neueRes.setReservedAmount(amountToReserve);

            // In die DB schreiben
            boolean erfolg = resDao.addReservation(neueRes);

            if (erfolg) {
                // Zurück zur Listenansicht
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listIdStr);
            } else {
                // Fehler in der DB
                response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=db");
            }

        } catch (NumberFormatException e) {
            // Falsche Eingabe (Buchstaben o.ä.)
            response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=input");
        }
    } else {
        // Fallback falls Parameter fehlen
        response.sendRedirect("../jsp/dashboardView.jsp");
    }
%>