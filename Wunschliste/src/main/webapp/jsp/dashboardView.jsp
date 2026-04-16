<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="JDBC.WunschDAO" %>

<%
    // 1. Session-Check (Sicherheit)
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }

    // 2. Daten laden
    WunschlisteDAO lDao = new WunschlisteDAO();
    WunschDAO wDao = new WunschDAO();
    
    // Eigene Listen (Besitzer-Ansicht)
    List<Wunschliste> meineListen = lDao.getWunschlistenByOwner(aktuellerNutzer.getUserid());
    
    // Reservierte Geschenke (Gast-Ansicht)
    List<Wunsch> meineReservierungen = wDao.getReservedWishesByUser(aktuellerNutzer.getUserid());
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy");
%>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - WishList Pro</title>
    
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/dashboard.css">
    <link rel="stylesheet" href="../css/wunschliste.css"> <%-- Wichtig für Button-Styles --%>
</head>
<body>

    <%@ include file="navbar.jspf" %>

    <main class="dashboard-container">
        
        <%-- ABSCHNITT 1: MEINE EIGENEN LISTEN --%>
        <div class="dashboard-header-section">
            <h1>Meine Wunschlisten</h1>
        </div>

        <% if (meineListen == null || meineListen.isEmpty()) { %>
            <section class="empty-state">
                <a href="createListView.jsp" class="btn-create-large">Erstelle deine erste Wunschliste</a>
                <p class="empty-text">Du hast noch keine Wunschliste erstellt.</p>
            </section>
        <% } else { %>
            <section class="populated-state">
                <div class="action-bar">
                    <a href="createListView.jsp" class="btn-create-small">Neue Liste erstellen</a>
                </div>

                <div class="lists-wrapper">
                    <% for (Wunschliste liste : meineListen) { %>
                        <div class="list-card">
                            <div class="list-info">
                                <h2><%= liste.getTitle() %></h2>
                                <% if (liste.getEventDate() != null) { %>
                                    <span class="list-date">Endet: <%= sdf.format(liste.getEventDate()) %></span>
                                <% } %>
                            </div>
                            
                            <div class="list-actions">
                                <a href="wunschlisteView.jsp?id=<%= liste.getListId() %>" class="action-link">Öffnen</a>
                                <a href="../appl/dashboardAppl.jsp?action=delete&id=<%= liste.getListId() %>" 
                                   class="action-link delete" 
                                   onclick="return confirm('Möchtest du diese Liste wirklich löschen?');">Löschen</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>
        <% } %>

        <hr class="section-divider" style="margin: 4rem 0; border: 0; border-top: 1px solid #eee;">

        <%-- ABSCHNITT 2: MEINE RESERVIERUNGEN --%>
        <div class="dashboard-header-section">
            <h1>Meine Reservierungen</h1>
            <p class="subtitle" style="color: var(--text-muted); font-size: 0.9rem;">Geschenke, die du für andere reserviert hast.</p>
        </div>

        <% if (meineReservierungen == null || meineReservierungen.isEmpty()) { %>
            <p class="empty-info-text" style="text-align: center; padding: 2rem; color: var(--text-muted);">
                Du hast noch keine Geschenke reserviert.
            </p>
        <% } else { %>
            <div class="lists-wrapper">
                <% for (Wunsch w : meineReservierungen) { %>
                    <div class="list-card reservation-card" style="border-left: 5px solid var(--primary);">
                        <div class="list-info">
                            <span class="category-tag" style="font-size: 0.7rem; color: var(--primary); font-weight: bold;">RESERVIERT</span>
                            <h2><%= w.getTitle() %></h2>
                            <span class="price-tag"><%= String.format("%.2f", w.getPrice()) %>€</span>
                        </div>
                        
                        <div class="list-actions">
                            <%-- Hier nutzen wir die listId aus der Wunsch-Bean, um zur Liste zu gelangen --%>
                            <a href="wunschlisteView.jsp?id=<%= w.getListId() %>" class="action-link">Zur Liste</a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

    </main>

    <%@ include file="footer.jspf" %>

</body>
</html>