package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.Nutzer;

public class NutzerDAO {

    public boolean registerUser(Nutzer nutzer) {
        String sql = "INSERT INTO Nutzer (username, password) VALUES (?, ?)";

        try {
            // 1. Verbindung aufbauen
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();

            // 2. PreparedStatement vorbereiten
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // 3. Platzhalter füllen
            pstmt.setString(1, nutzer.getUsername());
            pstmt.setString(2, nutzer.getPassword());

            // 4. Befehl ausführen
            int rowsAffected = pstmt.executeUpdate();

            // Ressourcen schließen
            pstmt.close();
            conn.close();

            // Gibt true zurück, wenn mindestens eine Zeile in der DB verändert wurde
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler bei der Registrierung:");
            e.printStackTrace();
            return false;
        }
    }

    public Nutzer loginUser(String username, String password) {
        String sql = "SELECT * FROM Nutzer WHERE username = ? AND password = ?";
        Nutzer eingeloggterNutzer = null;

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                eingeloggterNutzer = new Nutzer();
                eingeloggterNutzer.setUserid(rs.getInt("userid"));
                eingeloggterNutzer.setUsername(rs.getString("username"));
                eingeloggterNutzer.setPassword(rs.getString("password"));
            }

            rs.close();
            pstmt.close();
            conn.close();

        } catch (SQLException e) {
            System.err.println("Fehler beim Login:");
            e.printStackTrace();
        }

        return eingeloggterNutzer;
    }
    
    public boolean isUsernameTaken(String username) {
        String sql = "SELECT COUNT(*) FROM Nutzer WHERE username = ?";
        
        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, username);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Wenn die Zahl größer als 0 ist, existiert der Name bereits
                return rs.getInt(1) > 0;
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch (SQLException e) {
            System.err.println("Fehler bei der Prüfung des Benutzernamens:");
            e.printStackTrace();
        }
        
        return false; // Im Zweifel (Fehler) gehen wir davon aus, dass er nicht existiert oder behandeln es im Flow
    }
    
    public boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE Nutzer SET password = ? WHERE username = ?";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, newPassword);
            pstmt.setString(2, username);

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Fehler beim Zurücksetzen des Passworts:");
            e.printStackTrace();
            return false;
        }
    }
}