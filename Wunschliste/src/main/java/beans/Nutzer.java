package beans;

import JDBC.NutzerDAO;

public class Nutzer {

	private int userid;
	private String username;
	private String password;
	private String email;

	public Nutzer() {

	}

	public boolean login() {
        NutzerDAO dao = new NutzerDAO();
        Nutzer validierterNutzer = dao.loginUser(this.username, this.password);

        if (validierterNutzer != null) {
            this.userid = validierterNutzer.getUserid();
            this.email = validierterNutzer.getEmail(); // optional übernehmen
            return true;
        }
        return false;
    }

	public void register() {
        NutzerDAO dao = new NutzerDAO();
        boolean erfolg = dao.registerUser(this);

        if (erfolg) {
            System.out.println("Nutzer " + this.username + " wurde registriert.");
        }
    }

	public boolean resetPassword(String email, String newPassword) {
	    NutzerDAO dao = new NutzerDAO();
	    
	    // Wir prüfen nun, ob die Email in der Datenbank existiert
	    if (dao.isEmailTaken(email)) { // Du musst isEmailTaken in der DAO ergänzen (siehe unten)
	        if (newPassword != null && newPassword.trim().length() >= 6) {
	            return dao.updatePasswordByEmail(email, newPassword);
	        }
	    }
	    return false;
	}

	public boolean validateCredentials() {
		if (this.username == null || this.username.trim().length() < 3 ||
		    this.password == null || this.password.trim().length() < 6 ||
		    this.email == null || !this.email.contains("@")) { // <-- einfache Email-Prüfung
			return false;
		}
		return true;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	// ===== NEU =====
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
