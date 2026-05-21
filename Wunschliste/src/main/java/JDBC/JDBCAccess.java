package JDBC;

import java.sql.Connection;
import java.sql.DriverManager;
//import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Abstrakte Klasse für JDBC Access
 */
public abstract class JDBCAccess {

	Connection dbConn;
	String dbDrivername;
	String dbURL;
	String dbUser;
	String dbPassword;
	String dbSchema;
	public JDBCAccess() throws NoConnectionException{
		this.setDBParms();
		this.createConnection();
		this.setSchema();
	}

	/**
	 * Abstrakte Methode zur setzung der Datenbank Parameter
	 */
	public abstract void setDBParms();

	/**
	 * Erzeuge das Schema der Datenbank
	 * @throws NoConnectionException
	 */
	public void setSchema() throws NoConnectionException {
		try{
			String sql = "USE "+ dbSchema;
			System.out.println(sql);
			dbConn.createStatement().executeUpdate(sql);
			System.out.println("Schema " + dbSchema + " erfolgreich gesetzt");
		}catch(SQLException se){
			se.printStackTrace();
			throw new NoConnectionException();
		}
	}

	/***
	 * Methode für das erzeugen der Verbindung des DB-Driver
	 * und übergabe der Attribute.
	 * @throws NoConnectionException
	 */
	public void createConnection() throws NoConnectionException{
		try{
			Class.forName(dbDrivername);
			System.out.println("JDBC-Treiber erfolgreich geladen");

			dbConn = DriverManager.getConnection(
												dbURL,
												dbUser,
												dbPassword
												);
			System.out.println("Datenbankverbindung erfolgreich angelegt");
		}catch(Exception e){
			e.printStackTrace();
			throw new NoConnectionException();
		}
	}

	/**
	 * Versuche die Verbindung aufzubauen.
	 * @return Connection object für die Verbindung der DB
	 * @throws NoConnectionException
	 */
	public Connection getConnection() throws NoConnectionException {
		try{
			this.setSchema();
			return dbConn;
		}catch(SQLException se){
			se.printStackTrace();
			throw new NoConnectionException();
		}
	}
}