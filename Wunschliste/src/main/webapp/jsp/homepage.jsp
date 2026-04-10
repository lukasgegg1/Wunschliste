<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WishList Pro</title>
<link rel="stylesheet" href="../css/base.css">
<link rel="stylesheet" href="../css/homepage.css">
</head>
<body id="home-page">
<%-- 1. NAVBAR --%>
    <%@ include file="navbar.jspf" %>

    <main>
        <section id="hero">
            <h1>Geschenke planen, <span class="accent-text">Überraschungen</span> bewahren.</h1>
            <p>Erstelle deine Wunschliste und teile sie mit Freunden - ohne dass du siehst, was bereits reserviert wurde.</p>
        </section>

        <section id="actions">
            <article class="card owner-path">
                <div class="icon-circle">📝</div>
                <h2>Für Planer</h2>
                <p>Erstelle deine eigene Liste und verwalte deine Wünsche ganz einfach.</p>
                <a href="createListView.jsp" class="btn-main">Eigene Liste erstellen</a>
            </article>

            <article class="card guest-path">
                <div class="icon-circle">🔍</div>
                <h2>Für Gäste</h2>
                <p>Du hast einen Link erhalten? Gib hier den Code ein:</p>
                <form class="guest-form" action="../appl/findListAppl.jsp" method="GET">
                    <input type="text" name="listCode" placeholder="z.B. BDAY-2026" required>
                    <button type="submit" class="btn-dark">Liste finden</button>
                </form>
            </article>
        </section>

        <section id="how-it-works">
            <div class="section-title">
                <h2>In 3 Schritten zum Wunschgeschenk.</h2>
            </div>
            <div class="step-container">
                <div class="step">
                    <div class="step-number">1</div>
                    <h4>Erstellen</h4>
                    <p>Wünsche hinzufügen, Bilder hochladen und Details festlegen.</p>
                </div>
                <div class="step">
                    <div class="step-number">2</div>
                    <h4>Teilen</h4>
                    <p>Code an Freunde senden. Sie reservieren anonym.</p>
                </div>
                <div class="step">
                    <div class="step-number">3</div>
                    <h4>Freuen</h4>
                    <p>Die Überraschung bleibt bis zum Schluss perfekt!</p>
                </div>
            </div>
        </section>
    </main>

    <%-- 2. FOOTER --%>
    <%@ include file="footer.jspf" %>
</body>
</html>