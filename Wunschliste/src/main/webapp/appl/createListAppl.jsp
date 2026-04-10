<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Wunschliste" %>
<%@ page import="JDBC.WunschlisteDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.UUID" %>

<%
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../");
        return;
    }

    String title = request.getParameter("title");
    String dateStr = request.getParameter("eventDate");

    if (title != null && !title.isEmpty()) {
        Wunschliste neueListe = new Wunschliste();
        neueListe.setTitle(title);
        neueListe.setOwnerId(aktuellerNutzer.getUserid());
        
        // --- LOGIK START: SHARE-TOKEN GENERIEREN ---
        // Wir erzeugen einen zufälligen 8-stelligen String
        String randomToken = UUID.randomUUID().toString().substring(0, 8);
        neueListe.setShareToken(randomToken); 
        // --- LOGIK ENDE ---

        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                neueListe.setEventDate(sdf.parse(dateStr));
            } catch (Exception e) { e.printStackTrace(); }
        }
        
        WunschlisteDAO dao = new WunschlisteDAO();
        dao.addWunschliste(neueListe);
    }
    
    response.sendRedirect("../jsp/dashboardView.jsp");
%>