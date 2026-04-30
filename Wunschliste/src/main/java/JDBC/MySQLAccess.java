package JDBC;

public class MySQLAccess extends JDBCAccess {

    public MySQLAccess() throws NoConnectionException {
        super();
    }

    @Override
    public void setDBParms() {
        dbDrivername = "com.mysql.cj.jdbc.Driver";
        dbURL        = "jdbc:mysql://localhost:3306/Wunschliste";
        dbUser       = "root";
        dbPassword   = "";
        dbSchema     = "Wunschliste";
    }

    public static void main(String[] args) throws NoConnectionException {
        // Ein kleiner Test, um zu sehen, ob es klappt
        MySQLAccess access = new MySQLAccess();
        if (access.getConnection() != null) {
            System.out.println("Verbindung zur Wunschliste-DB erfolgreich!");
        }
    }
}