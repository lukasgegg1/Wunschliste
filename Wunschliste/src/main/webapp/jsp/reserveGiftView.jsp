<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="beans.Reservierungen" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="JDBC.WunschDAO" %>
<%@ page import="JDBC.ReservierungDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. Sicherheit: Session-Check
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }

    // 2. Parameter abrufen
    String giftIdStr = request.getParameter("giftId");
    String listIdStr = request.getParameter("listId");
    
    if (giftIdStr == null || listIdStr == null) {
        response.sendRedirect("dashboardView.jsp");
        return;
    }

    int giftId = Integer.parseInt(giftIdStr);
    int listId = Integer.parseInt(listIdStr);

    // 3. Daten aus der Datenbank laden
    WunschlisteDAO lDao = new WunschlisteDAO();
    Wunschliste aktuelleListe = lDao.getWunschlisteById(listId);
    
    WunschDAO wDao = new WunschDAO();
    List<Wunsch> alleWuensche = wDao.getWuenscheByListe(listId);
    
    Wunsch aktuellesGeschenk = null;
    for (Wunsch w : alleWuensche) {
        if (w.getGiftId() == giftId) {
            aktuellesGeschenk = w;
            break;
        }
    }

    if (aktuellesGeschenk == null) {
        response.sendRedirect("listDetail.jsp?id=" + listId);
        return;
    }

    // 4. Reservierungs-Status berechnen
    ReservierungDAO resDao = new ReservierungDAO();
    List<Reservierungen> bisherigeRes = resDao.getReservationsByGift(giftId);
    double bereitsReserviert = 0.0;
    for(Reservierungen r : bisherigeRes) {
        bereitsReserviert += r.getReservedAmount();
    }
    double restBetrag = aktuellesGeschenk.getPrice() - bereitsReserviert;
    if(restBetrag < 0) restBetrag = 0;
%>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Geschenk reservieren - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/reserveGift.css">
</head>
<body>
    <%@ include file="navbar.jspf" %>

    <main class="reserve-container">
        <div class="reserve-header">
            <h1><%= aktuelleListe.getTitle() %></h1>
            <span class="days-badge">Geschenk reservieren</span>
        </div>

        <%-- Fehlermeldungen --%>
        <% if ("input".equals(request.getParameter("error"))) { %>
            <p class="error-msg">Bitte gib einen gültigen Betrag ein.</p>
        <% } else if ("db".equals(request.getParameter("error"))) { %>
            <p class="error-msg">Fehler beim Speichern in der Datenbank. Bitte versuche es erneut.</p>
        <% } %>

        <%-- Geschenk-Details --%>
        <section class="table-section">
            <table class="gift-table">
                <thead>
                    <tr>
                        <th>Titel</th>
                        <th>Kosten</th>
                        <th>Priorität</th>
                        <th>Link</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong><%= aktuellesGeschenk.getTitle() %></strong></td>
                        <td class="price-cell">
                            <div class="price-total">Gesamt: <%= String.format("%.2f", aktuellesGeschenk.getPrice()) %>€</div>
                            <div class="price-reserved">Bereits reserviert: <%= String.format("%.2f", bereitsReserviert) %>€</div>
                            <div class="price-remaining">Noch offen: <%= String.format("%.2f", restBetrag) %>€</div>
                        </td>
                        <td class="stars">
                            <% for(int i=0; i < aktuellesGeschenk.getPriority(); i++) { out.print("★"); } %>
                        </td>
                        <td class="link-cell">
                            <% if (aktuellesGeschenk.getLink() != null && !aktuellesGeschenk.getLink().isEmpty()) { %>
                                <a href="<%= aktuellesGeschenk.getLink() %>" target="_blank" class="external-link">Ansehen</a>
                            <% } else { %>
                                <span style="color: var(--text-muted); font-size: 0.9rem;">-</span>
                            <% } %>
                        </td>
                    </tr>
                </tbody>
            </table>
        </section>

        <%-- Reservierungs-Formular --%>
        <section class="reserve-form-section">
            <% if (restBetrag > 0) { %>
                <form action="../appl/reservierenAppl.jsp" method="POST" id="reserveForm">
                    <input type="hidden" name="giftId" value="<%= giftId %>">
                    <input type="hidden" name="listId" value="<%= listId %>">
                    <%-- Als Standard-Vollpreis übergeben wir den aktuellen Restbetrag --%>
                    <input type="hidden" name="fullPrice" value="<%= restBetrag %>">

                    <div class="checkbox-group">
                        <label class="checkbox-container">
                            <input type="checkbox" id="isPartial" name="isPartial" value="true" onchange="toggleAmountInput()">
                            <span>Nur einen Teil beitragen</span>
                        </label>
                    </div>

                    <div class="amount-group" id="amountInputGroup" style="display: none;">
                        <label for="amount">Dein Beitrag (Maximal <%= String.format("%.2f", restBetrag) %>€):</label>
                        <div class="amount-input-wrapper">
                            <input type="number" step="0.01" id="amount" name="amount" placeholder="0.00" max="<%= restBetrag %>">
                            <span class="currency">€</span>
                        </div>
                    </div>

                    <div class="button-group">
                        <a href="wunschlisteView.jsp?id=<%= listId %>" class="btn-back">Abbrechen</a>
                        <button type="submit" class="btn-confirm">Reservierung bestätigen</button>
                    </div>
                </form>
            <% } else { %>
                <div style="text-align: center; padding: 20px;">
                    <h3>🎉 Vollständig finanziert!</h3>
                    <p>Für dieses Geschenk sind keine weiteren Reservierungen nötig.</p>
                    <a href="wunschlisteView.jsp?id=<%= listId %>" class="btn-back" style="margin-top: 15px; display: inline-block;">Zurück zur Liste</a>
                </div>
            <% } %>
        </section>
    </main>

    <%@ include file="footer.jspf" %>

    <script>
        function toggleAmountInput() {
            var checkBox = document.getElementById("isPartial");
            var amountGroup = document.getElementById("amountInputGroup");
            var amountInput = document.getElementById("amount");
            
            if (checkBox.checked == true){
                amountGroup.style.display = "block";
                amountInput.required = true;
                amountInput.focus();
            } else {
                amountGroup.style.display = "none";
                amountInput.required = false;
                amountInput.value = ""; 
            }
        }
    </script>
</body>
</html>