<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="JDBC.WunschDAO" %>
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
    
    // Das spezifische Geschenk aus der Liste heraussuchen
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
            <h1>Wunschliste: <%= aktuelleListe.getTitle() %></h1>
            <span class="days-badge">Geschenk auswählen</span>
        </div>

        <%-- Fehlermeldungen abfangen --%>
        <% if ("input".equals(request.getParameter("error"))) { %>
            <p class="error-msg">Bitte gib einen gültigen Betrag ein.</p>
        <% } else if ("db".equals(request.getParameter("error"))) { %>
            <p class="error-msg">Es gab einen Fehler beim Speichern. Bitte versuche es erneut.</p>
        <% } %>

        <%-- Tabelle mit den Geschenk-Details (Mockup) --%>
        <section class="table-section">
            <table class="gift-table">
                <thead>
                    <tr>
                        <th>Titel</th>
                        <th>Preis</th>
                        <th>Priorität</th>
                        <th>Link</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong><%= aktuellesGeschenk.getTitle() %></strong></td>
                        <td><%= String.format("%.2f", aktuellesGeschenk.getPrice()) %>€</td>
                        <td class="stars">
                            <%-- Sterne basierend auf Priorität anzeigen --%>
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
            <form action="../appl/reservierenAppl.jsp" method="POST" id="reserveForm">
                <input type="hidden" name="giftId" value="<%= giftId %>">
                <input type="hidden" name="listId" value="<%= listId %>">
                <%-- Wir übergeben den vollen Preis versteckt, falls die Checkbox NICHT geklickt wird --%>
                <input type="hidden" name="fullPrice" value="<%= aktuellesGeschenk.getPrice() %>">

                <div class="checkbox-group">
                    <label class="checkbox-container">
                        <input type="checkbox" id="isPartial" name="isPartial" value="true" onchange="toggleAmountInput()">
                        <span class="checkmark"></span>
                        nur einen Teil beitragen
                    </label>
                </div>

                <div class="amount-group" id="amountInputGroup" style="display: none;">
                    <label for="amount">Wie viel möchtest du beitragen?</label>
                    <div class="amount-input-wrapper">
                        <input type="number" step="0.01" id="amount" name="amount" placeholder="0.00">
                        <span class="currency">€</span>
                    </div>
                </div>

                <div class="button-group">
                    <a href="wunschlisteView.jsp?id=<%= listId %>" class="btn-back">zurück</a>
                    <button type="submit" class="btn-confirm">Bestätigen</button>
                </div>
            </form>
        </section>
    </main>

    <%@ include file="footer.jspf" %>

    <%-- JavaScript für die Checkbox-Logik --%>
    <script>
        function toggleAmountInput() {
            var checkBox = document.getElementById("isPartial");
            var amountGroup = document.getElementById("amountInputGroup");
            var amountInput = document.getElementById("amount");
            
            if (checkBox.checked == true){
                amountGroup.style.display = "block";
                amountInput.required = true;
            } else {
                amountGroup.style.display = "none";
                amountInput.required = false;
                amountInput.value = ""; // Wert zurücksetzen
            }
        }
    </script>
</body>
</html>