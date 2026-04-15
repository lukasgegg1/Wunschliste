<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>

<%
    // 1. Parameter aus dem Formular abrufen (name="email" aus der View)
    String emailEingabe = request.getParameter("email");
    String passNeu      = request.getParameter("newPassword");
    String passBestätig = request.getParameter("passwordRepeat");

    // 2. Grundlegende Validierung
    if (emailEingabe == null || emailEingabe.isEmpty() || passNeu == null || passNeu.isEmpty()) {
        response.sendRedirect("../jsp/passwortVergessenView.jsp?error=emptyFields");
        return;
    }

    // 3. Prüfen, ob die Passwörter übereinstimmen
    if (passNeu.equals(passBestätig)) {
        
        Nutzer helperNutzer = new Nutzer();
        
        // 4. Wir übergeben nun die Email statt dem Benutzernamen
        boolean erfolg = helperNutzer.resetPassword(emailEingabe, passNeu);

        if (erfolg) {
            response.sendRedirect("../jsp/loginView.jsp?success=passwordReset");
        } else {
            // Nutzer mit dieser Email nicht gefunden oder Passwort zu kurz
            response.sendRedirect("../jsp/passwortVergessenView.jsp?error=userNotFoundOrInvalid");
        }
        
    } else {
        response.sendRedirect("../jsp/passwortVergessenView.jsp?error=passwordMismatch");
    }
%>