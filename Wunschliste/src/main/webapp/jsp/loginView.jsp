<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - WishList Pro</title>
    
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/login.css">
</head>
<body>

    <%-- NAVBAR --%>
    <%@ include file="navbar.jspf" %>

    <main class="login-container">
        <section class="login-card">
            <div class="login-header">
                <h1>Willkommen zurück!</h1>
                <p class="subtitle">Melde dich an, um deine Wunschlisten zu verwalten.</p>
            </div>
            
            <%-- Ganz schlichte Fehlermeldung --%>
			<% if ("1".equals(request.getParameter("error"))) { %>
   			 <p style="color: #ff4d4d; text-align: center; font-size: 0.9em; margin-bottom: 15px;">
        		Benutzername oder Passwort ist nicht korrekt.
    		</p>
			<% } %>

            <form action="../appl/loginAppl.jsp" method="POST" class="login-form">
                <div class="input-group">
                    <label for="username">Benutzername</label>
                    <input type="text" id="username" name="username" placeholder="Name" required>
                </div>

                <div class="input-group">
                    <label for="password">Passwort</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <div class="form-options">
                    <a href="passwortVergessenView.jsp" class="forgot-password">Passwort vergessen?</a>
                </div>

                <button type="submit" class="btn-login">Anmelden</button>
            </form>

            <div class="login-footer-text">
                <span>Noch kein Konto? <a href="registrierenView.jsp">Jetzt registrieren</a></span>
            </div>
        </section>
    </main>

    <%-- FOOTER --%>
    <%@ include file="footer.jspf" %>

</body>
</html>