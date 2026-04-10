package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Reservierungen;

public class ReservierungDAO {


    public boolean addReservation(Reservierungen res) {
        String sql = "INSERT INTO Reservierungen (giftId, guestId, reservedAmount, timestamp) VALUES (?, ?, ?, NOW())";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, res.getGiftId());
            pstmt.setInt(2, res.getGuestId());
            pstmt.setDouble(3, res.getReservedAmount());

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Speichern der Reservierung:");
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservierungen> getReservationsByGift(int giftId) {
        List<Reservierungen> reservierungsListe = new ArrayList<>();
        String sql = "SELECT * FROM Reservierungen WHERE giftId = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, giftId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Reservierungen r = new Reservierungen();
                r.setReservationId(rs.getInt("reservationId"));
                r.setGiftId(rs.getInt("giftId"));
                r.setGuestId(rs.getInt("guestId"));
                r.setReservedAmount(rs.getDouble("reservedAmount"));
                r.setTimestamp(rs.getTimestamp("timestamp"));

                reservierungsListe.add(r);
            }

            rs.close();
            pstmt.close();
            conn.close();

        } catch (SQLException e) {
            System.err.println("Fehler beim Laden der Reservierungen:");
            e.printStackTrace();
        }

        return reservierungsListe;
    }

    public boolean updateReservationAmount(int reservationId, double newAmount) {
        String sql = "UPDATE Reservierungen SET reservedAmount = ? WHERE reservationId = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setDouble(1, newAmount);
            pstmt.setInt(2, reservationId);

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Aktualisieren des Reservierungsbetrags:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReservation(int reservationId) {
        String sql = "DELETE FROM Reservierungen WHERE reservationId = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, reservationId);

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Löschen der Reservierung:");
            e.printStackTrace();
            return false;
        }
    }
}