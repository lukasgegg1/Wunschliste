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
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, res.getGiftId());
            pstmt.setInt(2, res.getGuestId());
            pstmt.setDouble(3, res.getReservedAmount());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservierungen> getReservationsByGift(int giftId) {
        List<Reservierungen> reservierungsListe = new ArrayList<>();
        String sql = "SELECT * FROM Reservierungen WHERE giftId = ?";
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, giftId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservierungen r = new Reservierungen();
                    r.setReservationId(rs.getInt("reservationId"));
                    r.setGiftId(rs.getInt("giftId"));
                    r.setGuestId(rs.getInt("guestId"));
                    r.setReservedAmount(rs.getDouble("reservedAmount"));
                    r.setTimestamp(rs.getTimestamp("timestamp"));
                    reservierungsListe.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservierungsListe;
    }

    public boolean deleteReservation(int reservationId) {
        String sql = "DELETE FROM Reservierungen WHERE reservationId = ?";
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reservationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateReservationAmount(int reservationId, double newAmount) {
        String sql = "UPDATE Reservierungen SET reservedAmount = ? WHERE reservationId = ?";
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDouble(1, newAmount);
            pstmt.setInt(2, reservationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}