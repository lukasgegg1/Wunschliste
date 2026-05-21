package JDBC;

import java.sql.SQLException;

/**
 * Eigene NoConnectionException Klasse
 * Erbt von SQL Exception
 * Gibt kurze "Message", bei Fehlschlag der Verbindung
 */
@SuppressWarnings("serial")
public class NoConnectionException extends SQLException {

	public NoConnectionException(){
		super("Erzeugung der JDBC-Connection ist fehlgeschlagen");
	}
	public NoConnectionException(String msg){
		super(msg);
	}

}