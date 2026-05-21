package JDBC;

/***
 *Klasse für den Verbindungsaufbau der MySQL Datenbank
 */
public class MySQLAccess extends JDBCAccess {

    public MySQLAccess() throws NoConnectionException {
        super();
    }

    /**
     * Methode zum übergeben der Parameter für die Datenbankverbindung
     * @Override der abstrakten Methode aus JDBC Access
     */
    @Override
    public void setDBParms() {
        dbDrivername = "com.mysql.cj.jdbc.Driver";
        dbURL        = "jdbc:mysql://localhost:3306/Wunschliste";
        dbUser       = "root";
        dbPassword   = "";
        dbSchema     = "Wunschliste";
    }

    /**
     * Verbindung zur DB afbauen.
     * @param args
     * @throws NoConnectionException
     */
    public static void main(String[] args) throws NoConnectionException {
        // Ein kleiner Test, um zu sehen, ob es klappt
        MySQLAccess access = new MySQLAccess();
        if (access.getConnection() != null) {
            System.out.println("Verbindung zur Wunschliste-DB erfolgreich!");
        }
    }
}