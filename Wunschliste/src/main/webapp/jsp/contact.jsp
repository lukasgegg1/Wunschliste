<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kontakt & Über Uns - WishList Pro</title>
    <link rel="stylesheet" href="../css/base.css">
    <link rel="stylesheet" href="../css/contact.css">
</head>
<body>

    <%@ include file="navbar.jspf" %>

    <main class="contact-container">
        <section class="about-section">
            <div class="about-content">
                <span class="badge">Unsere Story</span>
                <h1>Mehr als nur eine Liste.</h1>
                <p>
                    Alles begann mit einer misslungenen Überraschung im Freundeskreis. 
                    Wir fanden: Schenken sollte keine logistische Herausforderung sein, 
                    sondern pure Vorfreude.
                </p>
                <p>
                    <strong>WishList Pro</strong> wurde am Campus Ludwigshafen geboren. 
                    Wir glauben an Schenken ohne Stress und daran, dass die besten Geschenke 
                    die sind, die man sich wirklich wünscht, aber trotzdem eine Überraschung bleiben.
                </p>
            </div>
            <div class="about-stats">
                <div class="stat-item">
                    <span class="stat-number">100%</span>
                    <span class="stat-label">Überraschung</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">0€</span>
                    <span class="stat-label">Kostenlos</span>
                </div>
            </div>
        </section>

        <hr class="section-divider">

        <section class="contact-methods">
            <h2>Sag Hallo!</h2>
            
            <div class="method-grid">
                <div class="method-card">
                    <div class="icon">📍</div>
                    <h3>Besuch uns</h3>
                    <p>WishList Pro GmbH<br>Ernst-Boehe-Straße 4-6<br>67059 Ludwigshafen</p>
                    <div class="opening-hours">
                        <small>Support-Zeiten:</small>
                        <p>Mo - Fr: 08:00 - 18:00 Uhr</p>
                    </div>
                </div>

                <div class="method-card">
                    <div class="icon">📧</div>
                    <h3>Vernetz dich</h3>
                    <p>Schreib uns direkt oder folge uns für Geschenk-Inspirationen.</p>
                    
                    <a href="mailto:info@wishlistpro.com" class="btn-direct-mail">E-Mail senden</a>
                    
                    <div class="social-box">
                        <small>Social Media:</small>
                        <div class="social-links">
                            <a href="#">Instagram</a> • <a href="#">LinkedIn</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="footer.jspf" %>

</body>
</html>