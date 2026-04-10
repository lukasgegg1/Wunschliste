<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="JDBC.WunschlisteDAO" %>

<%
    // 1. Session-Check (Sicherheit)
    // Überprüft, ob ein Nutzer eingeloggt ist, bevor die Seite geladen wird.
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }

    // 2. Datenbeschaffung
    // Lädt alle Wunschlisten, die dem aktuell eingeloggten Nutzer gehören.
    WunschlisteDAO dao = new WunschlisteDAO();
    List<Wunschliste> meineListen = dao.getWunschlistenByOwner(aktuellerNutzer.getUserid());
    
    // Datumsformatierer für die Anzeige der Event-Daten
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
</head>
<body>

    <%-- NAVBAR Fragment einbinden --%>
    <%@ include file="navbar.jspf" %>

    <main class="dashboard-container">
        
        <div class="dashboard-header-section">
            <h1>Meine Wunschlisten</h1>
        </div>

        <%-- 
          WEICHE für die Anzeige:
          Falls keine Listen vorhanden sind, wird das leere Mockup angezeigt.
          Ansonsten werden alle Listen in Kartenform aufgelistet.
        --%>
        <% if (meineListen == null || meineListen.isEmpty()) { %>
            
            <%-- Mockup: Keine Listen vorhanden --%>
            <section class="empty-state">
                <a href="createListView.jsp" class="btn-create-large">Erstelle deine erste Wunschliste</a>
                <p class="empty-text">Du hast noch keine<br>Wunschliste erstellt</p>
            </section>

        <% } else { %>
            
            <%-- Mockup: Listen vorhanden --%>
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
                                <%-- 
                                  AKTION: Öffnen
                                  Leitet an die dashboardAppl.jsp weiter mit action=open. 
                                  Dort findet die Weiche zur wunschlisteView.jsp statt.
                                --%>
                                <a href="../appl/dashboardAppl.jsp?action=open&id=<%= liste.getListId() %>" class="action-link">Liste öffnen</a>
                                
                                <%-- 
                                  AKTION: Löschen
                                  Ruft die dashboardAppl.jsp mit action=delete auf.
                                --%>
                                <a href="../appl/dashboardAppl.jsp?action=delete&id=<%= liste.getListId() %>" 
                                   class="action-link delete" 
                                   onclick="return confirm('Möchtest du diese Liste wirklich löschen?');">Liste löschen</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </section>

        <% } %>

    </main>

    <%-- FOOTER Fragment einbinden --%>
    <%@ include file="footer.jspf" %>

</body>
</html>
