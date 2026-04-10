<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="JDBC.WunschDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // 1. Sicherheit: Session-Check
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../html/Test.html");
        return;
    }

    String action = request.getParameter("action");
    int listId = Integer.parseInt(request.getParameter("listId"));

    // Wir holen uns die temporäre Sammel-Liste aus der Session
    List<Wunsch> tempSammelListe = (List<Wunsch>) session.getAttribute("tempSammelListe");
    if (tempSammelListe == null) {
        tempSammelListe = new ArrayList<>();
    }

    // --- FALL A: EINEN WUNSCH ZUR VORSCHAU HINZUFÜGEN ---
    if ("addTemp".equals(action)) {
        Wunsch w = new Wunsch();
        w.setTitle(request.getParameter("title"));
        w.setPrice(Double.parseDouble(request.getParameter("price")));
        w.setPriority(Integer.parseInt(request.getParameter("priority")));
        w.setLink(request.getParameter("link"));
        
        tempSammelListe.add(w);
        session.setAttribute("tempSammelListe", tempSammelListe);
        
        // Zurück zur Eingabemaske
        response.sendRedirect("../jsp/addWishes.jsp?id=" + listId);
    }

    // --- FALL B: EINEN WUNSCH AUS DER VORSCHAU LÖSCHEN ("verwerfen") ---
    else if ("removeTemp".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < tempSammelListe.size()) {
            tempSammelListe.remove(index);
        }
        session.setAttribute("tempSammelListe", tempSammelListe);
        response.sendRedirect("../jsp/addWishes.jsp?id=" + listId);
    }

    // --- FALL C: FINALES SPEICHERN IN DIE DATENBANK ---
    else if ("saveAll".equals(action)) {
        WunschDAO dao = new WunschDAO();
        for (Wunsch w : tempSammelListe) {
            dao.addWunsch(w, listId);
        }
        // Nach dem Speichern die temporäre Liste leeren
        session.removeAttribute("tempSammelListe");
        
        // Zurück zur Detailansicht der Liste
        response.sendRedirect("../jsp/listDetail.jsp?id=" + listId);
    }
%>