<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Reservierungen" %>
<%@ page import="JDBC.ReservierungDAO" %>

<%
    // 1. Sicherheit: Ist ein Gast eingeloggt?
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    // 2. Parameter aus dem Reservierungs-Formular holen
    String giftIdStr = request.getParameter("giftId");
    String listIdStr = request.getParameter("listId");
    String isPartial = request.getParameter("isPartial"); // Checkbox
    
    // Wir haben entweder einen Teilbetrag oder den vollen Preis
    String amountStr = request.getParameter("amount");
    String fullPriceStr = request.getParameter("fullPrice");

    if (giftIdStr != null && listIdStr != null) {
        try {
            int giftId = Integer.parseInt(giftIdStr);
            double amountToReserve = 0.0;

            // Logik-Weiche: Teilbetrag oder Voller Betrag?
            if ("true".equals(isPartial)) {
                // Nutzer möchte nur einen Teil beitragen
                if (amountStr == null || amountStr.trim().isEmpty()) {
                    throw new NumberFormatException("Betrag darf nicht leer sein");
                }
                amountToReserve = Double.parseDouble(amountStr.replace(",", "."));
            } else {
                // Nutzer übernimmt das ganze Geschenk (Voller Preis)
                amountToReserve = Double.parseDouble(fullPriceStr.replace(",", "."));
            }

            // 3. Reservierungs-Objekt erstellen und befüllen
            Reservierungen neueRes = new Reservierungen();
            neueRes.setGiftId(giftId);
            neueRes.setGuestId(aktuellerNutzer.getUserid());
            neueRes.setReservedAmount(amountToReserve);

            // 4. In die Datenbank schreiben
            ReservierungDAO dao = new ReservierungDAO();
            boolean erfolg = dao.addReservation(neueRes);

            if (erfolg) {
                // Zurück zur Listenansicht
                response.sendRedirect("../jsp/listDetail.jsp?id=" + listIdStr);
            } else {
                // Bei DB-Fehler zurück
                response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=db");
            }

        } catch (NumberFormatException e) {
            // Bei falscher Eingabe (z.B. Buchstaben im Preis) zurück
            response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=input");
        }
    } else {
        response.sendRedirect("../jsp/dashboardView.jsp");
    }
%>