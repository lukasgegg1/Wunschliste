package JDBC;

import java.sql.Connection;
import java.sql.SQLException;

public class AppInstallWishlistTables {
	Connection dbConn;

	public static void main(String[] args) throws SQLException {
		AppInstallWishlistTables myApp = new AppInstallWishlistTables();
		myApp.dbConn = new MySQLAccess().getConnection();
		myApp.doSomething();
	}

	public void doSomething() throws SQLException {
		this.dropAllTables();
		this.createAllTables();
	}


	public void executeUpdateWithoutParms(String sql) throws SQLException{
		System.out.println(sql);
		this.dbConn.prepareStatement(sql).executeUpdate();
	}

	public void createAllTables() throws SQLException{
		this.createTableNutzer();
		this.createTableWunschliste();
		this.createTableWunsch();
		this.createTableReservierungen();
		System.out.println("Alle Tabellen angelegt");
	}

	public void dropAllTables() throws SQLException{
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Reservierungen");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Wunsch");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Wunschliste");
		this.executeUpdateWithoutParms("DROP TABLE IF EXISTS Nutzer");
		System.out.println("Alle Tabellen geloescht");
	}

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