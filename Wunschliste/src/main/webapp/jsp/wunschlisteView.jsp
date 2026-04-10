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

    // 4. Rollenprüfung: Besitzer oder Gast?
    boolean istBesitzer = aktuelleListe.isOwner(aktuellerNutzer);

    // 5. Wünsche laden
    WunschDAO wDao = new WunschDAO();
    List<Wunsch> geschenke = wDao.getWuenscheByListe(listId);
    
    for (Wunsch w : geschenke) {
        w.loadReservations(); 
    }

    // 6. Tage bis zum Event berechnen
    String tageText = "Kein Datum gesetzt";
    if (aktuelleListe.getEventDate() != null) {
        long diff = aktuelleListe.getEventDate().getTime() - System.currentTimeMillis();
        long days = diff / (1000 * 60 * 60 * 24);
        if (days >= 0) {
            tageText = "Noch " + days + " Tage offen";
        } else {
            tageText = "Event ist vergangen";
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
</head>
<body>
    <%@ include file="navbar.jspf" %>

    <main class="list-container">
        <div class="list-header">
            <h1>Wunschliste: <%= aktuelleListe.getTitle() %></h1>
            <span class="days-badge"><%= tageText %></span>
        </div>

        <%-- OWNER CONTROLS: Jetzt korrekt verschachtelt für das Nebeneinander-Design --%>
		<%
		if (istBesitzer) {
		%>
		<div class="owner-controls">

			<div class="share-container">
				<p class="share-label">Liste mit Gästen teilen:</p>
				<div class="share-box">
					<input type="text" id="shareInput"
						value="http://localhost:8080/WishListPro/jsp/guestView.jsp?token=<%=aktuelleListe.getShareToken()%>"
						readonly>
					<button onclick="copyToClipboard()" class="btn-copy">Kopieren</button>
				</div>
			</div>

			<div class="owner-actions">
				<a href="addWishesView.jsp?id=<%=listId%>" class="btn-add-wish">Neuen
					Wunsch hinzufügen</a>
			</div>

		</div>
		<%
		}
		%>

		<section class="table-section">
            <table class="list-table">
                <thead>
                    <tr>
                        <th>Titel</th>
                        <th>Preis</th>
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
                    %>
                        <tr>
                            <td><strong><%= w.getTitle() %></strong></td>
                            <td><%= String.format("%.2f", w.getPrice()) %>€</td>
                            <td class="stars">
                                <% for (int j = 1; j <= 5; j++) { 
                                    if (j <= w.getPriority()) out.print("★");
                                    else out.print("☆");
                                } %>
                            </td>
                            <td class="link-cell">
                                <% if (w.getLink() != null && !w.getLink().isEmpty()) { %>
                                    <a href="<%= w.getLink() %>" target="_blank" class="external-link">Ansehen</a>
                                <% } else { %> - <% } %>
                            </td>
                            <td class="action-cell">
                                <% if (istBesitzer) { %>
                                    <div class="owner-links">
                                        <a href="../appl/wunschListeAppl.jsp?action=editWunsch&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-edit">bearbeiten</a>
                                        <a href="../appl/wunschListeAppl.jsp?action=deleteWunsch&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-delete" onclick="return confirm('Möchtest du diesen Wunsch wirklich löschen?');">löschen</a>
                                    </div>
                                <% } else { %>
                                    <% if (w.getMissingAmount() <= 0) { %>
                                        <span class="status-reserved">Bereits reserviert</span>
                                    <% } else { %>
                                        <a href="../appl/wunschListeAppl.jsp?action=goReserve&listId=<%= listId %>&giftId=<%= w.getGiftId() %>" class="action-reserve">Reservieren</a>
                                    <% } %>
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

    <script>
    function copyToClipboard() {
        var copyText = document.getElementById("shareInput");
        
        // Text auswählen
        copyText.select();
        copyText.setSelectionRange(0, 99999); // Für mobile Geräte

        // Kopieren
        navigator.clipboard.writeText(copyText.value).then(function() {
            // Visuelles Feedback
            const btn = document.querySelector('.btn-copy');
            const originalText = btn.innerText;
            btn.innerText = "Kopiert!";
            btn.style.backgroundColor = "#27ae60";
            
            setTimeout(() => {
                btn.innerText = originalText;
                btn.style.backgroundColor = "";
            }, 2000);
        }).catch(function(err) {
            console.error('Fehler beim Kopieren: ', err);
        });
    }
    </script>
</body>
</html>