package beans;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import JDBC.ReservierungDAO;

public class Reservierungen {

	private int reservationId;
	private int giftId;
	private int guestId;
	private double reservedAmount;
	private Timestamp timestamp;

	public Reservierungen() {

	}

	/***
	 * Methode für die Reservierung eines Geschenks.
	 * @return true, Reservierung war erfolgreich.
	 */
	public boolean confirm() {
		ReservierungDAO dao = new ReservierungDAO();
		return dao.addReservation(this);
	}


	/***
	 * Methode, um die Reservierung aufzulößen.
	 * reservationId wird auf passenden wert gesetzt.
	 */
	public void cancel() {
		if (this.reservationId > 0) {
			ReservierungDAO dao = new ReservierungDAO();
			dao.deleteReservation(this.reservationId);
		}
	}

	/***
	 * Updaten des reservierten "Geldbetrags" - Menge.
	 * Attribut reservedAmount wird für diese Instanz angepasst.
	 * @param newAmount
	 */
	public void updateAmount(double newAmount) {
		if (newAmount > 0) {
			ReservierungDAO dao = new ReservierungDAO();
			boolean erfolg = dao.updateReservationAmount(this.reservationId, newAmount);

			if (erfolg) {
				this.reservedAmount = newAmount;
			}
		}
	}

	/***
	 * Richtiges Datumsformat wird übergeben.
	 * @return passendes Datumsformat
	 */
	public String getFormattedTimestamp() {
		if (this.timestamp == null) {
			return "Datum unbekannt";
		}
		SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm 'Uhr'");
		return sdf.format(this.timestamp);
	}


	public int getReservationId() {
		return reservationId;
	}

	public void setReservationId(int reservationId) {
		this.reservationId = reservationId;
	}

	public int getGiftId() {
		return giftId;
	}

	public void setGiftId(int giftId) {
		this.giftId = giftId;
	}

	public int getGuestId() {
		return guestId;
	}

	public void setGuestId(int guestId) {
		this.guestId = guestId;
	}

	public double getReservedAmount() {
		return reservedAmount;
	}

	public void setReservedAmount(double reservedAmount) {
		this.reservedAmount = reservedAmount;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}
}