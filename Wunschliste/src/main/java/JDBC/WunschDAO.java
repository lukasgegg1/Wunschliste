package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Wunsch;

public class WunschDAO {

    public boolean addWunsch(Wunsch wunsch, int ListID) {
        String sql = "INSERT INTO Wunsch (title, price, priority, link, isGroupGift, ListID) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, wunsch.getTitle());
            pstmt.setDouble(2, wunsch.getPrice());
            pstmt.setInt(3, wunsch.getPriority());
            pstmt.setString(4, wunsch.getLink());
            pstmt.setBoolean(5, wunsch.isGroupGift());
            pstmt.setInt(6, ListID);

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Hinzufügen des Wunsches:");
            e.printStackTrace();
            return false;
        }
    }

    public List<Wunsch> getWuenscheByListe(int ListID) {
        List<Wunsch> wunschListe = new ArrayList<>();
        String sql = "SELECT * FROM Wunsch WHERE ListID = ? ORDER BY priority DESC";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, ListID);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Wunsch w = new Wunsch();
                w.setGiftId(rs.getInt("GiftID"));
                w.setTitle(rs.getString("title"));
                w.setPrice(rs.getDouble("price"));
                w.setPriority(rs.getInt("priority"));
                w.setLink(rs.getString("link"));
                w.setGroupGift(rs.getBoolean("isGroupGift"));

                // Hier könnte man später noch ein ReservierungsDAO aufrufen,
                // um die Liste der Reservierungen für diesen Wunsch zu füllen.

                wunschListe.add(w);
            }

            rs.close();
            pstmt.close();
            conn.close();

        } catch (SQLException e) {
            System.err.println("Fehler beim Laden der Wünsche:");
            e.printStackTrace();
        }

        return wunschListe;
    }

    public boolean updateWunsch(Wunsch wunsch) {
        String sql = "UPDATE Wunsch SET title = ?, price = ?, priority = ?, link = ?, isGroupGift = ? WHERE GiftID = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, wunsch.getTitle());
            pstmt.setDouble(2, wunsch.getPrice());
            pstmt.setInt(3, wunsch.getPriority());
            pstmt.setString(4, wunsch.getLink());
            pstmt.setBoolean(5, wunsch.isGroupGift());
            pstmt.setInt(6, wunsch.getGiftId());

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Aktualisieren des Wunsches:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteWunsch(int GiftID) {
        String sql = "DELETE FROM Wunsch WHERE GiftID = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, GiftID);

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Löschen des Wunsches:");
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Wunsch> getReservedWishesByUser(int userId) {
        List<Wunsch> liste = new ArrayList<>();
        // Wir joinen die Wunschliste-Tabelle, um an den Titel der Liste zu kommen
        String sql = "SELECT w.*, wl.title AS listenTitel FROM Wunsch w " +
                     "JOIN Reservierungen r ON w.giftId = r.giftId " +
                     "JOIN Wunschliste wl ON w.listId = wl.listId " +
                     "WHERE r.guestId = ?";
                     
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Wunsch w = new Wunsch();
                w.setGiftId(rs.getInt("giftId"));
                w.setTitle(rs.getString("title"));
                w.setPrice(rs.getDouble("price"));
                w.setListId(rs.getInt("listId"));
                // Wir "missbrauchen" ein Feld oder nutzen ein temporäres Attribut für den Listennamen
                // Falls du kein Feld dafür hast, nenne es einfach im Titel mit:
                w.setTitle(rs.getString("title") + " (aus: " + rs.getString("listenTitel") + ")");
                
                liste.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }
}