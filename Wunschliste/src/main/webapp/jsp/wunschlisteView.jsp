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

    // 2. Listen-ID aus URL laden
    String listIdStr = request.getParameter("id");
    if (listIdStr == null) {
        response.sendRedirect("dashboardView.jsp");
        return;
    }
    int listId = Integer.parseInt(listIdStr);

    // 3. Listen-Daten holen
    WunschlisteDAO lDao = new WunschlisteDAO();
    Wunschliste aktuelleListe = lDao.getWunschlisteById(listId);
    
    if (aktuelleListe == null) {
        response.sendRedirect("dashboardView.jsp");
        return;
    }

    // 4. Rollenprüfung
    boolean istBesitzer = aktuelleListe.isOwner(aktuellerNutzer);

    // 5. Wünsche laden
    WunschDAO wDao = new WunschDAO();
    List<Wunsch> geschenke = wDao.getWuenscheByListe(listId);
    for (Wunsch w : geschenke) {
        w.loadReservations();
    }

    // 6. Ablauf-Logik berechnen
    String tageText = "Kein Datum gesetzt";
    boolean istAbgelaufen = false; 

    if (aktuelleListe.getEventDate() != null) {
        long diff = aktuelleListe.getEventDate().getTime() - System.currentTimeMillis();
        long days = diff / (1000 * 60 * 60 * 24);
        
        if (diff < 0) {
            tageText = "Event ist vergangen";
            istAbgelaufen = true;
        } else {
            tageText = "Noch " + days + " Tage offen";
        }
    }
%>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title><%= aktuelleListe.getTitle() %> - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/wunschliste.css">
    <style>
        .status-expired {
            color: #95a5a6;
            font-style: italic;
            font-size: 0.85rem;
        }
        .error-banner {
            background-color: #ffcccc;
            color: #cc0000;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jspf" %>

    <main class="list-container">
        <div class="list-header">
            <h1>Wunschliste: <%= aktuelleListe.getTitle() %></h1>
            <span class="days-badge"><%= tageText %></span>
        </div>

        <%-- Fehlermeldung bei Manipulationsversuch --%>
        <% if ("expired".equals(request.getParameter("error"))) { %>
            <div class="error-banner">Aktion nicht möglich: Die Liste ist bereits abgelaufen.</div>
        <% } %>

        <% if (istBesitzer) { %>
            <div class="owner-controls">
                <div class="share-container">
                    <p class="share-label">Dein Zugangs-Code für Gäste:</p>
                    <div class="share-box">
                        <input type="text" id="shareInput" value="<%= aktuelleListe.getShareToken() %>" readonly>
                        <button onclick="copyToClipboard()" class="btn-copy">Kopieren</button>
                    </div>
                </div>

                <div class="owner-actions">
                    <% if (!istAbgelaufen) { %>
                        <a href="../appl/wunschListeAppl.jsp?action=addWunsch&listId=<%= listId %>" class="btn-add-wish">Neuen Wunsch hinzufügen</a>
                    <% } else { %>
                        <span class="status-expired">Liste archiviert (Event vorbei)</span>
                    <% } %>
                </div>
            </div>
        <% } %>

        <section class="table-section">
            <table class="list-table">
                <thead>
                    <tr>
                        <th>Titel</th>
                        <th>Preis & Status</th>
                        <th>Priorität</th>
                        <th>Link</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (geschenke.isEmpty()) { %>
                        <tr><td colspan="5" class="empty-row">Diese Liste enthält noch keine Wünsche.</td></tr>
                    <% } else { 
                        for (Wunsch w : geschenke) { 
                            double price = w.getPrice();
                            double missing = w.getMissingAmount();
                            if(missing < 0) missing = 0;
                            
                            double paid = price - missing;
                            double percent = (price > 0) ? (paid / price) * 100 : 0;
                            if(percent > 100) percent = 100;
                    %>
                        <tr>
                            <td><strong><%= w.getTitle() %></strong></td>
                            <td>
                                <div><strong><%= String.format("%.2f", price) %>€</strong></div>
                                <div class="progress-wrapper">
                                    <div class="progress-bar-container">
                                        <div class="progress-bar-fill" style="width: <%= percent %>%;"></div>
                                    </div>
                                    <div class="progress-text">
                                        <%= String.format("%.2f", paid) %>€ von <%= String.format("%.2f", price) %>€ reserviert
                                    </div>
                                </div>
                            </td>
                            <td class="stars">
                                <% for (int j = 1; j <= 5; j++) { 
                                    if (j <= w.getPriority()) out.print("★");
                                    else out.print("☆");
                                } %>
                            </td>
                            <td class="link-cell">
					    <% 
					        if (w.getLink() != null && !w.getLink().isEmpty()) { 
					            String finalUrl = w.getLink();
					            // Prüfen, ob der Link mit http startet, falls nicht, https davorhängen
					            if (!finalUrl.toLowerCase().startsWith("http://") && !finalUrl.toLowerCase().startsWith("https://")) {
					                finalUrl = "https://" + finalUrl;
					            }
					    %>
					        <a href="<%= finalUrl %>" target="_blank" class="external-link">Ansehen</a>
					    <% } else { %> 
					        - 
					    <% } %>
					</td>
                            <td class="action-cell">
                                <% if (istBesitzer) { %>
                                    <div class="owner-links">
                                        <% if (!istAbgelaufen) { %>
                                            <a href="../appl/wunschListeAppl.jsp?action=editWunsch&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-edit">bearbeiten</a>
                                            <a href="../appl/wunschListeAppl.jsp?action=deleteWunsch&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-delete" onclick="return confirm('Möchtest du diesen Wunsch wirklich löschen?');">löschen</a>
                                        <% } else { %>
                                            <span class="status-expired">Gesperrt</span>
                                        <% } %>
                                    </div>
                                <% } else { 
                                    int userResId = w.getReservationIdByUser(aktuellerNutzer.getUserid());
                                %>
                                    <div class="guest-actions">
                                        <% if (userResId != -1) { %>
                                            <% if (!istAbgelaufen) { %>
                                                <a href="../appl/reservierenAppl.jsp?action=cancel&resId=<%= userResId %>&listId=<%= listId %>" class="btn-discard" onclick="return confirm('Reservierung aufheben?');">Austragen</a>
                                            <% } else { %>
                                                <span class="status-reserved">Reserviert (Event vorbei)</span>
                                            <% } %>
                                        <% } else if (missing <= 0) { %>
                                            <span class="status-reserved">Voll reserviert</span>
                                        <% } else if (istAbgelaufen) { %>
                                            <span class="status-expired">Abgelaufen</span>
                                        <% } else { %>
                                            <a href="../appl/wunschListeAppl.jsp?action=goReserve&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-reserve">
                                                <%= (paid > 0) ? "Rest reservieren" : "Reservieren" %>
                                            </a>
                                        <% } %>
                                    </div>
                                <% } %>
                            </td>
                        </tr>
                    <%  } 
                       } %>
                </tbody>
            </table>
        </section>
    </main>
    <%@ include file="footer.jspf" %>
</body>
</html>