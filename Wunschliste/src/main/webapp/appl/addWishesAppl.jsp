<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunsch" %>
<%@ page import="JDBC.WunschDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Sicherheit
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    String action = request.getParameter("action");
    String listIdStr = request.getParameter("listId");
    int listId = Integer.parseInt(listIdStr);

    // Sammelliste aus Session holen
    List<Wunsch> tempSammelListe = (List<Wunsch>) session.getAttribute("tempSammelListe");
    if (tempSammelListe == null) {
        tempSammelListe = new ArrayList<>();
    }

    if ("addTemp".equals(action)) {
        // Neuen Wunsch temporär speichern
        Wunsch w = new Wunsch();
        w.setTitle(request.getParameter("title"));
        w.setPrice(Double.parseDouble(request.getParameter("price").replace(",", ".")));
        w.setPriority(Integer.parseInt(request.getParameter("priority")));
        w.setLink(request.getParameter("link"));
        
        tempSammelListe.add(w);
        session.setAttribute("tempSammelListe", tempSammelListe);
        response.sendRedirect("../jsp/addWishesView.jsp?id=" + listId);

    } else if ("removeTemp".equals(action)) {
        // Einen Eintrag aus der Vorschau entfernen
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < tempSammelListe.size()) {
            tempSammelListe.remove(index);
        }
        session.setAttribute("tempSammelListe", tempSammelListe);
        response.sendRedirect("../jsp/addWishesView.jsp?id=" + listId);

    } else if ("saveAll".equals(action)) {
        // Alles in die Datenbank schreiben
        WunschDAO dao = new WunschDAO();
        for (Wunsch w : tempSammelListe) {
            dao.addWunsch(w, listId);
        }
        // Session leeren und zur Liste zurückkehren
        session.removeAttribute("tempSammelListe");
        response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listId);
    }
%>