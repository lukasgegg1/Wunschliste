package beans;

import java.util.ArrayList;
import java.util.List;

import JDBC.ReservierungDAO;
import JDBC.WunschDAO;

public class Wunsch {

	private int giftId;
	private String title;
	private double price;
	private int priority;
	private String link;
	private boolean isGroupGift;
	private List<Reservierungen> reservierungenListe = new ArrayList<>();
	private int listId;

	public Wunsch() {

	}

	public double getCurrentAmount() {
		double total = 0.0;
		for (Reservierungen res : reservierungenListe) {
			total += res.getReservedAmount();
		}
		return total;
	}

	public double getMissingAmount() {
		double missing = this.price - this.getCurrentAmount();
		return Math.max(0, missing);
	}

	public String getStatus(boolean isOwner) {
		if (isOwner) {
			return "Geheim";
		}

		if (getMissingAmount() == 0) {
			return "Reserviert";
		} else if (getCurrentAmount() > 0) {
			return "Teil-reserviert";
		} else {
			return "Offen";
		}
	}

	public void addReservation(Reservierungen r) {
		if (r != null) {
			this.reservierungenListe.add(r);
		}
	}

	public void updatePriority(int newPriority) {
		if (newPriority >= 1 && newPriority <= 3) {
			this.priority = newPriority;
			if (this.giftId > 0) {
				WunschDAO dao = new WunschDAO();
				dao.updateWunsch(this);
			}
		}
	}

	public void loadReservations() {
		if (this.giftId > 0) {
			ReservierungDAO dao = new ReservierungDAO();
			this.reservierungenListe = dao.getReservationsByGift(this.giftId);
		}
	}
	
	// In Wunsch.java hinzufügen
	public int getReservationIdByUser(int userId) {
	    for (Reservierungen res : reservierungenListe) {
	        if (res.getGuestId() == userId) {
	            return res.getReservationId();
	        }
	    }
	    return -1;
	}

	public int getGiftId() {
		return giftId;
	}

	public void setGiftId(int giftId) {
		this.giftId = giftId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public boolean isGroupGift() {
		return isGroupGift;
	}

	public void setGroupGift(boolean isGroupGift) {
		this.isGroupGift = isGroupGift;
	}

	public List<Reservierungen> getReservierungenListe() {
		return reservierungenListe;
	}

	public void setReservierungenListe(List<Reservierungen> reservierungenListe) {
		this.reservierungenListe = reservierungenListe;
	}
	public int getListId() {
	    return listId;
	}

	public void setListId(int listId) {
	    this.listId = listId;
	}
}