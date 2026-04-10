<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registrieren - WishList Pro</title>
    
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/registrieren.css">
</head>
<body>

    <%-- NAVBAR --%>
    <%@ include file="navbar.jspf" %>

    <main class="register-container">
        <section class="register-card">
            <div class="register-header">
                <h1>Konto erstellen</h1>
                <p class="subtitle">Tritt bei und beginne mit deiner ersten Wunschliste.</p>
            </div>

            <form action="../appl/registrierenAppl.jsp" method="POST" class="register-form">
                <div class="input-group">
                    <label for="username">Benutzername</label>
                    <input type="text" id="username" name="username" placeholder="Max Mustermann" required>
                </div>

                <div class="input-group">
                    <label for="password">Passwort wählen</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <div class="input-group">
                    <label for="password-confirm">Passwort bestätigen</label>
                    <input type="password" id="password-confirm" name="passwordRepeat" placeholder="••••••••" required>
                </div>

                <div class="form-terms">
    				<label>
				        <input type="checkbox" required> 
				        Ich akzeptiere die 
				        <a href="policy.jsp" target="_blank" rel="noopener noreferrer">Datenschutzbestimmungen. ↗</a>
				    </label>
				</div>

                <button type="submit" class="btn-register">Konto erstellen</button>
            </form>

            <div class="register-footer-text">
                <span>Bereits ein Konto? <a href="loginView.jsp">Jetzt anmelden</a></span>
            </div>
        </section>
    </main>

    <%-- FOOTER --%>
    <%@ include file="footer.jspf" %>

</body>
</html>