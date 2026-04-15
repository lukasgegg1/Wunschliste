package JDBC;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.Nutzer;

public class NutzerDAO {

    public boolean registerUser(Nutzer nutzer) {
        String sql = "INSERT INTO Nutzer (username, password, email) VALUES (?, ?, ?)";

        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();

            PreparedStatement pstmt = conn.prepareStatement(sql);

            // Platzhalter füllen
            pstmt.setString(1, nutzer.getUsername());
            pstmt.setString(2, nutzer.getPassword());
            pstmt.setString(3, nutzer.getEmail());

            int rowsAffected = pstmt.executeUpdate();

            pstmt.close();
            conn.close();

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
                eingeloggterNutzer.setEmail(rs.getString("email")); 
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
    
    public boolean isEmailTaken(String email) {
        String sql = "SELECT COUNT(*) FROM Nutzer WHERE email = ?";
        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Nutzer SET password = ? WHERE email = ?";
        try {
            MySQLAccess access = new MySQLAccess();
            Connection conn = access.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            int rows = pstmt.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}