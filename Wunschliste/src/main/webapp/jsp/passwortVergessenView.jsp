<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passwort vergessen - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/passwortVergessen.css">
</head>
<body>

    <%@ include file="navbar.jspf" %>

    <main class="forgot-container">
        <section class="forgot-card">
            <div class="forgot-header">
                <div class="icon-circle">🔑</div>
                <h1>Passwort zurücksetzen</h1>
                <p class="subtitle">Gib deinen Namen und dein neues Passwort ein.</p>
            </div>

            <%-- Anzeige von Fehlermeldungen --%>
            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="error-message" style="color: #ff4d4d; margin-bottom: 15px; text-align: center; font-weight: bold;">
                    <%
                        if ("userNotFoundOrInvalid".equals(error)) out.print("Benutzer nicht gefunden oder Passwort zu kurz.");
                        else if ("passwordMismatch".equals(error)) out.print("Die Passwörter stimmen nicht überein.");
                        else if ("emptyFields".equals(error)) out.print("Bitte alle Felder ausfüllen.");
                    %>
                </div>
            <% } %>

            <form action="../appl/passwortVergessenAppl.jsp" method="POST" class="forgot-form">
                
                <div class="input-group">
                    <label for="username">Benutzername</label>
                    <input type="text" id="username" name="username" placeholder="Dein Benutzername" required>
                </div>

                <div class="input-group">
                    <label for="newPassword">Neues Passwort</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="••••••••" required>
                </div>

                <div class="input-group">
                    <label for="passwordRepeat">Passwort bestätigen</label>
                    <input type="password" id="passwordRepeat" name="passwordRepeat" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-forgot">Passwort speichern</button>
            </form>

            <div class="forgot-footer-text">
                <span>Doch wieder eingefallen? <a href="loginView.jsp">Zurück zum Login</a></span>
            </div>
        </section>
    </main>

    <%@ include file="footer.jspf" %>

</body>
</html>