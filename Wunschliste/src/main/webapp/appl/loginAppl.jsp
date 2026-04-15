<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="JDBC.NutzerDAO" %>

<%
    String userEingabe = request.getParameter("username");
    String passEingabe = request.getParameter("password");


    Nutzer nutzer = new Nutzer();
    nutzer.setUsername(userEingabe);
    nutzer.setPassword(passEingabe);

    NutzerDAO dao = new NutzerDAO();

    Nutzer validierterNutzer = dao.loginUser(userEingabe, passEingabe);

    if (nutzer.validateCredentials() && validierterNutzer != null) {
        session.setAttribute("eingeloggterNutzer", validierterNutzer);
        response.sendRedirect("../jsp/dashboardView.jsp");
        
    } else {
        response.sendRedirect("../jsp/loginView.jsp?error=1");
    }
%>