package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.Wunschliste;

public class WunschlisteDAO {

    /***
     * Methode für die Gäste-Suche (ShareToken)
     * holt sich die Wunschliste anhand des shared Token der Gäste
     * @param token
     * @return
     */
    public Wunschliste getWunschlisteByToken(String token) {
        String sql = "SELECT * FROM Wunschliste WHERE ShareToken = ?";
        Wunschliste liste = null;

        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                liste = mapResultSetToWunschliste(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }

    /***
     * Methode: Liste hinzufügen
     * Hinzufügen einer neuen Wunschliste für die Gäste
     * @param liste
     * @return
     */
    public boolean addWunschliste(Wunschliste liste) {
        String sql = "INSERT INTO Wunschliste (Title, EventDate, OwnerID, ShareToken) VALUES (?, ?, ?, ?)";

        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, liste.getTitle());
            if (liste.getEventDate() != null) {
                pstmt.setDate(2, new java.sql.Date(liste.getEventDate().getTime()));
            } else {
                pstmt.setNull(2, java.sql.Types.DATE);
            }
            pstmt.setInt(3, liste.getOwnerId());
            pstmt.setString(4, liste.getShareToken());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /***
     * Methode: Listen eines Nutzers (Dashboard)
     * Zeigt Wunschliste des Besitzer an
     * @param ownerId
     * @return Liste<Wunschliste>
     */
    public List<Wunschliste> getWunschlistenByOwner(int ownerId) {
        List<Wunschliste> listen = new ArrayList<>();
        // Spaltenname an Schema angepasst: OwnerID
        String sql = "SELECT * FROM Wunschliste WHERE OwnerID = ? ORDER BY EventDate ASC";

        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ownerId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                listen.add(mapResultSetToWunschliste(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listen;
    }

    /***
     * Lade einzelne Listen anhand der listId
     * @param listId
     * @return Wunschliste
     */
    // 4. Bestehende Methode: Einzelne Liste laden
    public Wunschliste getWunschlisteById(int listId) {
        // Spaltenname an Schema angepasst: ListID
        String sql = "SELECT * FROM Wunschliste WHERE ListID = ?";
        Wunschliste liste = null;

        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, listId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                liste = mapResultSetToWunschliste(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return liste;
    }


    /***
     * Methode, um Redundanz zu vermeiden und Spaltennamen zentral zu verwalten
     * @param rs
     * @return
     * @throws SQLException
     */
    private Wunschliste mapResultSetToWunschliste(ResultSet rs) throws SQLException {
        Wunschliste w = new Wunschliste();
        w.setListId(rs.getInt("ListID"));
        w.setTitle(rs.getString("Title"));
        w.setShareToken(rs.getString("ShareToken"));

        java.sql.Date sqlDate = rs.getDate("EventDate");
        if (sqlDate != null) {
            w.setEventDate(new java.util.Date(sqlDate.getTime()));
        }
        w.setOwnerId(rs.getInt("OwnerID"));
        return w;
    }

    /***
     * Entfernen der Wunschliste anhand ihrer listId
     * @param listId
     * @return true, wenn Liste entfernt
     */
    public boolean deleteWunschliste(int listId) {
        String sql = "DELETE FROM Wunschliste WHERE ListID = ?";
        try (Connection conn = new MySQLAccess().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, listId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}