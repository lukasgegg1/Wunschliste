package JDBC;

import java.sql.Connection;
import java.sql.SQLException;

/***
 * Klasse zur erzeugung der Wishlist Tabellen
 */
public class AppInstallWishlistTables {
	Connection dbConn;

	/**
	 * Stelle Verbindung mit der Datenbank her.
	 * Eintrittspunkt zur Erstellung der Tabellen.
	 * @param args
	 * @throws SQLException
	 */
	public static void main(String[] args) throws SQLException {
		AppInstallWishlistTables myApp = new AppInstallWishlistTables();
		myApp.dbConn = new MySQLAccess().getConnection();
		myApp.doSomething();
	}

	/**
	 * Methode zum löschen und erzeugen der Tabellen beim starten
	 * @throws SQLException
	 */
	public void doSomething() throws SQLException {
		this.dropAllTables();
		this.createAllTables();
	}

	/***
	 * Print der SQL Statements
	 * @param sql
	 * @throws SQLException
	 */
	public void executeUpdateWithoutParms(String sql) throws SQLException{
		System.out.println(sql);
		this.dbConn.prepareStatement(sql).executeUpdate();
	}

	/**
	 * Erstellung der Tabellen:
	 * Nutzer, Wunschliste, Wunsch, Reservierungen
	 * @throws SQLException
	 */
	public void createAllTables() throws SQLException{
		this.createTableNutzer();
		this.createTableWunschliste();
		this.createTableWunsch();
		this.createTableReservierungen();
		System.out.println("Alle Tabellen angelegt");
	}

	/**
	 * Methode zum Löschen aller erstellten Tabellen, wenn diese exisiteren.
	 * @throws SQLException
	 */
	public void dropAllTables() throws SQLException{
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Reservierungen");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Wunsch");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Wunschliste");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Nutzer");
		System.out.println("Alle Tabellen geloescht");
	}

	/***
	 * SQL Statement zum erstellen der Nutzer Tabelle.
	 * @throws SQLException
	 */
	public void createTableNutzer() throws SQLException {
		this.executeUpdateWithoutParms(
			"CREATE TABLE Nutzer ("
			+ "UserID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
			+ "Email VARCHAR(100) NOT NULL UNIQUE,"
			+ "Username VARCHAR(20) NOT NULL,"
			+ "password VARCHAR(255) NOT NULL"
			+ ")"
		);
	}


	/***
	 * SQL Statement zum erstellen der Wunschlisten Tabelle.
	 * @throws SQLException
	 */
	public void createTableWunschliste() throws SQLException {
	    this.executeUpdateWithoutParms(
	        "CREATE TABLE Wunschliste ("
	        + "ListID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
	        + "OwnerID INT NOT NULL,"
	        + "Title VARCHAR(100) NOT NULL,"
	        + "EventDate DATE,"
	        + "ShareToken VARCHAR(50) UNIQUE NOT NULL,"
	        + "FOREIGN KEY (OwnerID) REFERENCES Nutzer(UserID) ON DELETE CASCADE"
	        + ")"
	    );
	}

	/***
	 * SQL Statement zum erstellen der Wunsch Tabelle.
	 * @throws SQLException
	 */
	public void createTableWunsch() throws SQLException {
	    this.executeUpdateWithoutParms(
	        "CREATE TABLE Wunsch ("
	        + "GiftID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
	        + "ListID INT NOT NULL," // Diese Spalte hat gefehlt!
	        + "Title VARCHAR(100) NOT NULL,"
	        + "Link VARCHAR(500)," // Link sollte optional sein (NULL erlaubt)
	        + "Price DECIMAL(10,2) NOT NULL,"
	        + "Priority INT,"
	        + "IsGroupGift BOOLEAN DEFAULT FALSE,"
	        + "FOREIGN KEY (ListID) REFERENCES Wunschliste(ListID) ON DELETE CASCADE"
	        + ")"
	    );
	}

	/***
	 * SQL Statement zum erstellen der Reservierung Tabelle.
	 * @throws SQLException
	 */
	public void createTableReservierungen() throws SQLException {
		this.executeUpdateWithoutParms(
			"CREATE TABLE Reservierungen ("
			+ "ReservationID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,"
			+ "GiftID INT NOT NULL,"
			+ "GuestID INT NOT NULL,"
			+ "ReservedAmount DECIMAL(10,2),"
			+ "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
			+ "FOREIGN KEY (GiftID) REFERENCES Wunsch(GiftID) ON DELETE CASCADE,"
			+ "FOREIGN KEY (GuestID) REFERENCES Nutzer(UserID) ON DELETE CASCADE"
			+ ")"
		);
	}
}