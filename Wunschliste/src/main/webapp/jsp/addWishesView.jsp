<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Sicherheit: Session-Check
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }

    // ListID aus der URL holen
    String listIdStr = request.getParameter("id");
    if (listIdStr == null) {
        response.sendRedirect("dashboardView.jsp");
        return;
    }
    int listId = Integer.parseInt(listIdStr);

    // Infos zur Liste für die Überschrift laden
    WunschlisteDAO lDao = new WunschlisteDAO();
    Wunschliste aktuelleListe = lDao.getWunschlisteById(listId);

    // Temporäre Wunsch-Liste aus der Session laden
    List<Wunsch> tempSammelListe = (List<Wunsch>) session.getAttribute("tempSammelListe");
    if (tempSammelListe == null) {
        tempSammelListe = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Wünsche hinzufügen - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/addWishes.css">
</head>
<body>
    <%@ include file="navbar.jspf" %>

    <main class="wishes-container">
        <div class="wishes-header">
            <h1>Wunschliste: <%= aktuelleListe.getTitle() %></h1>
            <span class="days-badge">Noch aktiv</span>
        </div>

        <section class="add-section">
            <form action="../appl/addWishesAppl.jsp" method="POST" class="add-form">
                <input type="hidden" name="action" value="addTemp">
                <input type="hidden" name="listId" value="<%= listId %>">
                
                <div class="form-row">
                    <input type="text" name="title" placeholder="Titel" required>
                    <input type="number" step="0.01" name="price" placeholder="Preis (€)" required>
                    <input type="number" name="priority" placeholder="Prio (1-5)" required>
                    <input type="text" name="link" placeholder="Link (Optional)">
                    <button type="submit" class="btn-add">noch einen Wunsch hinzufügen</button>
                </div>
            </form>
        </section>

        <section class="table-section">
            <table class="wishes-table">
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
                    <% if (tempSammelListe.isEmpty()) { %>
                        <tr><td colspan="5" class="empty-row">Keine Wünsche in der Vorschau.</td></tr>
                    <% } else { 
                        for (int i = 0; i < tempSammelListe.size(); i++) {
                            Wunsch w = tempSammelListe.get(i);
                    %>
                        <tr>
                            <td><%= w.getTitle() %></td>
                            <td><%= String.format("%.2f", w.getPrice()) %>€</td>
                            <td><%= w.getPriority() %></td>
                            <td class="link-cell"><%= (w.getLink() != null && !w.getLink().isEmpty()) ? w.getLink() : "-" %></td>
                            <td>
                                <a href="../appl/addWishesAppl.jsp?action=removeTemp&listId=<%= listId %>&index=<%= i %>" class="btn-discard">verwerfen</a>
                            </td>
                        </tr>
                    <%  } 
                       } %>
                </tbody>
            </table>
        </section>

        <div class="footer-actions">
            <form action="../appl/addWishesAppl.jsp" method="POST">
                <input type="hidden" name="action" value="saveAll">
                <input type="hidden" name="listId" value="<%= listId %>">
                <button type="submit" class="btn-save" <%= tempSammelListe.isEmpty() ? "disabled" : "" %>>Wünsche der Liste hinzufügen</button>
            </form>
        </div>
    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>