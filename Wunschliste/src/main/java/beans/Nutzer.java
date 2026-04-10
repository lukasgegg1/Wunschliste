package beans;

import JDBC.NutzerDAO;

public class Nutzer {

	private int userid;
	private String username;
	private String password;

	public Nutzer() {

	}

	public boolean login() {
        NutzerDAO dao = new NutzerDAO();
        Nutzer validierterNutzer = dao.loginUser(this.username, this.password);

        if (validierterNutzer != null) {
            this.userid = validierterNutzer.getUserid();
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

	public boolean resetPassword(String username, String newPassword) {
        NutzerDAO dao = new NutzerDAO();
        // Erst prüfen, ob der Nutzer existiert
        if (dao.isUsernameTaken(username)) {
            // Neues Passwort validieren (min. 6 Zeichen wie in validateCredentials)
            if (newPassword != null && newPassword.trim().length() >= 6) {
                return dao.updatePassword(username, newPassword);
            }
        }
        return false;
    }

	public boolean validateCredentials() {
		if (this.username == null || this.username.trim().length() < 3 || this.password == null || this.password.trim().length() < 6) {
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
}
