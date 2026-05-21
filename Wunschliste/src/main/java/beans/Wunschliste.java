package beans;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Wunschliste {

	private int listId;
	private String title;
	private Date eventDate;
	private int ownerId;
	private List<Wunsch> geschenkeListe = new ArrayList<>();
	private String shareToken;

	public Wunschliste() {

	}


	/***
	 * Prüft, ob das aktuelle Datum nach dem Event-Datum liegt.
	 * @return true = eventDate
	 */
	public boolean isExpired() {
	    if (this.eventDate == null) return false;
	    return new java.util.Date().after(this.eventDate);
	}


	/***
	 * Prüft, ob der übergebene Nutzer auch der tatsächliche
	 * Nutzer ist.
	 * @param u
	 * @return true, bei identischer nutzer & user Id
	 */
	public boolean isOwner(Nutzer u) {
		if (u == null) {
			return false;
		}
		return this.ownerId == u.getUserid();
	}


	/***
	 * Fügt Wunsch zur Geschenkliste hinzu.
	 * Wunsch kann nicht "leer" sein.
	 * @param w
	 */
	public void addGift(Wunsch w) {
		if (w != null) {
			this.geschenkeListe.add(w);
		}
	}

	public List<Wunsch> getVisibleGifts(){
		return this.geschenkeListe;
	}

	/***
	 * Gibt den Gesamtbetrag der Geschenkliste durch das
	 * addieren der einzelnen Geschenke.
	 * @return  Gesamtbetrag
	 */
	public double calculateTotalBudget() {
		double total = 0.0;
		for (Wunsch w : geschenkeListe) {
			total += w.getPrice();
		}
		return total;
	}


	/***
	 * Prüft, ob das Datum vor dem aktuellen Datum ist.
	 * @return
	 */
	public boolean checkTimer() {
		if (this.eventDate == null) {
			return false;
		}
		Date heute = new Date();
		return this.eventDate.before(heute);
	}

	public int getListId() {
		return listId;
	}

	public void setListId(int listId) {
		this.listId = listId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

	public int getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(int ownerId) {
		this.ownerId = ownerId;
	}

	public List<Wunsch> getGeschenkeListe() {
		return geschenkeListe;
	}

	public void setGeschenkeListe(List<Wunsch> geschenkeListe) {
		this.geschenkeListe = geschenkeListe;
	}
	public String getShareToken() {
        return shareToken;
    }

    public void setShareToken(String shareToken) {
        this.shareToken = shareToken;
    }
}