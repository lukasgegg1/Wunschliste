<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="JDBC.NutzerDAO" %>

<%
    String userEingabe = request.getParameter("username");
    String passEingabe = request.getParameter("password");
    String passRepeat  = request.getParameter("passwordRepeat");

    NutzerDAO dao = new NutzerDAO();

    // 1. Grundlegende Prüfung: Sind Passwörter identisch und nicht leer?
    if (passEingabe != null && !passEingabe.isEmpty() && passEingabe.equals(passRepeat)) {
        
        // 2. Prüfung: Existiert der Benutzername bereits?
        if (dao.isUsernameTaken(userEingabe)) {
            // Name vergeben -> Zurück zur Registrierung mit Fehler-Parameter
            response.sendRedirect("../jsp/registrierenView.jsp?error=usernameTaken");
        } else {
            
            // 3. Nutzer-Objekt befüllen
            Nutzer neuerNutzer = new Nutzer();
            neuerNutzer.setUsername(userEingabe);
            neuerNutzer.setPassword(passEingabe);

            // 4. Validierung (z.B. Passwortlänge) und Registrierung
            if (neuerNutzer.validateCredentials()) {
                // Wir nutzen hier direkt das DAO für die Registrierung
                boolean erfolg = dao.registerUser(neuerNutzer);
                
                if (erfolg) {
                    response.sendRedirect("../jsp/loginView.jsp?success=registered");
                } else {
                    response.sendRedirect("../jsp/registrierenView.jsp?error=dbError");
                }
            } else {
                response.sendRedirect("../jsp/registrierenView.jsp?error=invalidInput");
            }
        }
        
    } else {
        // Passwörter stimmen nicht überein
        response.sendRedirect("../jsp/registrierenView.jsp?error=passwordMismatch");
    }
%>