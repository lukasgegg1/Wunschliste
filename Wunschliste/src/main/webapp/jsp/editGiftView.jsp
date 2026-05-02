<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="JDBC.WunschDAO" %>

<%
    // 1. Sicherheit: Session-Check
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }

    // 2. IDs aus URL laden
    String gIdParam = request.getParameter("giftId");
    String lIdParam = request.getParameter("listId");

    if (gIdParam == null || lIdParam == null) {
        response.sendRedirect("dashboardView.jsp");
        return;
    }

    int giftId = Integer.parseInt(gIdParam);
    int listId = Integer.parseInt(lIdParam);

    // 3. Daten laden über das WunschDAO (nutzt intern MySQLAccess)
    WunschDAO wDao = new WunschDAO();
    Wunsch w = wDao.getWunschById(giftId); 

    // Sicherheits-Check: Falls der Wunsch nicht existiert oder ID falsch ist
    if (w == null) {
        response.sendRedirect("wunschlisteView.jsp?id=" + listId);
        return;
    }
%>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wunsch bearbeiten - WishList Pro</title>
    
    <!-- CSS Einbindung -->
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/edit-gift.css">
    
    <style>
        /* Spezifisches Styling für das kompakte Prioritäts-Zahlenfeld */
        .prio-input {
            width: 100px !important;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- Navbar Fragment einbinden -->
    <%@ include file="navbar.jspf" %>

    <main class="form-container">
        <div class="form-header">
            <h1>Wunsch bearbeiten</h1>
            <p class="subtitle">Du bearbeitest gerade: <strong><%= w.getTitle() %></strong></p>
        </div>
        
        <%-- Fehlermeldung bei fehlerhafter Übertragung --%>
        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="error-msg">Speichern fehlgeschlagen. Bitte prüfe das Preisformat (z.B. 10.50).</div>
        <% } %>

        <form action="../appl/wunschListeAppl.jsp" method="POST" class="edit-form">
            <!-- Hidden Fields für die Steuerung in der Appl -->
            <input type="hidden" name="action" value="updateWunsch">
            <input type="hidden" name="giftId" value="<%= giftId %>">
            <input type="hidden" name="listId" value="<%= listId %>">

            <!-- Titel Feld -->
            <div class="form-group">
                <label for="titel">Bezeichnung</label>
                <input type="text" id="titel" name="titel" 
                       value="<%= w.getTitle() %>" 
                       placeholder="z.B. Neue Kopfhörer" required>
            </div>

            <!-- Preis Feld -->
            <div class="form-group">
                <label for="preis">Preis in Euro (€)</label>
                <input type="number" id="preis" name="preis" 
                       step="0.01" 
                       value="<%= w.getPrice() %>" 
                       placeholder="0.00">
            </div>

            <!-- Priorität Feld (Zahlenfeld statt Slider) -->
            <div class="form-group">
                <label for="prio">Priorität (1 = niedrig, 5 = hoch)</label>
                <input type="number" id="prio" name="prio" 
                       min="1" max="5" 
                       value="<%= w.getPriority() %>" 
                       class="prio-input" 
                       required>
            </div>

            <!-- Link Feld -->
            <div class="form-group">
			    <label for="link">Link (Optional)</label>
			    <input type="text" 
			           id="link" 
			           name="link" 
			           value="<%= (w.getLink() != null) ? w.getLink() : "" %>" 
			           placeholder="Link (Optional)">
			</div>

            <!-- Buttons -->
            <div class="form-buttons">
                <a href="wunschlisteView.jsp?id=<%= listId %>" class="btn-cancel">Abbrechen</a>
                <button type="submit" class="btn-save">Speichern</button>
            </div>
        </form>
    </main>

    <!-- Footer Fragment einbinden -->
    <%@ include file="footer.jspf" %>

</body>
</html>