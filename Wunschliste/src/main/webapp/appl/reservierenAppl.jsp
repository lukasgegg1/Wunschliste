<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.Nutzer" %>
<%@ page import="beans.Reservierungen" %>
<%@ page import="JDBC.ReservierungDAO" %>

<%
    Nutzer aktuellerNutzer = (Nutzer) session.getAttribute("eingeloggterNutzer");
    if (aktuellerNutzer == null) {
        response.sendRedirect("../jsp/loginView.jsp");
        return;
    }

    String action = request.getParameter("action");
    String listIdStr = request.getParameter("listId");
    String giftIdStr = request.getParameter("giftId");

    ReservierungDAO resDao = new ReservierungDAO();

    if ("cancel".equals(action)) {
        String resIdStr = request.getParameter("resId");
        if (resIdStr != null) {
            try {
                resDao.deleteReservation(Integer.parseInt(resIdStr));
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listIdStr);
            } catch (Exception e) {
                response.sendRedirect("../jsp/dashboardView.jsp");
            }
        }
        return;
    }

    if (giftIdStr != null && listIdStr != null) {
        try {
            int giftId = Integer.parseInt(giftIdStr);
            String isPartial = request.getParameter("isPartial");
            String amountStr = request.getParameter("amount");
            String fullPriceStr = request.getParameter("fullPrice");

            double amountToReserve = 0.0;
            if ("true".equals(isPartial)) {
                if (amountStr == null || amountStr.trim().isEmpty()) throw new Exception();
                amountToReserve = Double.parseDouble(amountStr.replace(",", "."));
            } else {
                amountToReserve = Double.parseDouble(fullPriceStr.replace(",", "."));
            }

            Reservierungen neueRes = new Reservierungen();
            neueRes.setGiftId(giftId);
            neueRes.setGuestId(aktuellerNutzer.getUserid());
            neueRes.setReservedAmount(amountToReserve);

            if (resDao.addReservation(neueRes)) {
                response.sendRedirect("../jsp/wunschlisteView.jsp?id=" + listIdStr);
            } else {
                response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=db");
            }
        } catch (Exception e) {
            response.sendRedirect("../jsp/reserveGiftView.jsp?giftId=" + giftIdStr + "&listId=" + listIdStr + "&error=input");
        }
    } else {
        response.sendRedirect("../jsp/dashboardView.jsp");
    }
%>