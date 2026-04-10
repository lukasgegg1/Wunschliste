<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>

<%
    // 1. Parameter aus dem Formular abrufen
    String userEingabe = request.getParameter("username");
    String passNeu     = request.getParameter("newPassword");
    String passBestätig = request.getParameter("passwordRepeat");

    // 2. Grundlegende Validierung
    if (userEingabe == null || userEingabe.isEmpty() || passNeu == null || passNeu.isEmpty()) {
        response.sendRedirect("../jsp/passwortVergessenView.jsp?error=emptyFields");
        return;
    }

    // 3. Prüfen, ob die Passwörter übereinstimmen
    if (passNeu.equals(passBestätig)) {
        
        Nutzer helperNutzer = new Nutzer();
        
        // 4. Methode in der Bean aufrufen (diese prüft intern via DAO, ob der User existiert)
        boolean erfolg = helperNutzer.resetPassword(userEingabe, passNeu);

        if (erfolg) {
            // Passwort wurde geändert -> Weiter zum Login
            response.sendRedirect("../jsp/loginView.jsp?success=passwordReset");
        } else {
            // Entweder Nutzer nicht gefunden oder Passwort zu kurz
            response.sendRedirect("../jsp/passwortVergessenView.jsp?error=userNotFoundOrInvalid");
        }
        
    } else {
        // Passwörter stimmen nicht überein
        response.sendRedirect("../jsp/passwortVergessenView.jsp?error=passwordMismatch");
    }
%>