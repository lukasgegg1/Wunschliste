<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="JDBC.NutzerDAO" %>

<%
    // 1. Parameter aus dem Login-Formular abrufen
    String userEingabe = request.getParameter("username");
    String passEingabe = request.getParameter("password");

    // 2. Nutzer-Objekt mit den Eingabedaten erstellen
    Nutzer nutzer = new Nutzer();
    nutzer.setUsername(userEingabe);
    nutzer.setPassword(passEingabe);

    // 3. NutzerDAO initialisieren für die Datenbankprüfung
    NutzerDAO dao = new NutzerDAO();

    // 4. Logik-Prüfung:
    // Zuerst validieren (z.B. Feldlänge), dann über das DAO prüfen, ob die Kombi existiert.
    // Hinweis: In vielen Architekturen gibt 'loginUser' ein vollwertiges Nutzer-Objekt aus der DB zurück.
    Nutzer validierterNutzer = dao.loginUser(userEingabe, passEingabe);

    if (nutzer.validateCredentials() && validierterNutzer != null) {
        // Erfolg: Den Nutzer aus der Datenbank in die Session legen (enthält dann auch die korrekte UserID)
        session.setAttribute("eingeloggterNutzer", validierterNutzer);
        response.sendRedirect("../jsp/dashboardView.jsp");
    } else {
        // Fehler: Zurück zum Login mit Fehlerparameter
        response.sendRedirect("../jsp/loginView.jsp?error=1");
    }
%>