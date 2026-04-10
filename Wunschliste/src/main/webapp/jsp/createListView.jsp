<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("loginView.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Neue Liste erstellen - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/createList.css">
</head>
<body>
    <%@ include file="navbar.jspf" %>

    <main class="create-container">
        <section class="create-card">
            <div class="create-header">
                <h1>Neue Wunschliste</h1>
                <p class="subtitle">Gib deiner Liste einen Namen und ein optionales Datum.</p>
            </div>

            <form action="../appl/createListAppl.jsp" method="POST" class="create-form">
                <div class="input-group">
                    <label for="title">Titel der Liste</label>
                    <input type="text" id="title" name="title" placeholder="z.B. Geburtstag 2026" required>
                </div>

                <div class="input-group">
                    <label for="eventDate">Datum des Events (Optional)</label>
                    <input type="date" id="eventDate" name="eventDate">
                </div>

                <button type="submit" class="btn-create">Liste speichern</button>
            </form>
        </section>
    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>