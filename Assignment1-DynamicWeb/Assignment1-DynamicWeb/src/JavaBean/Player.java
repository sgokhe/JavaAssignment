package JavaBean;

public class Player implements java.io.Serializable {
	
	private String firstname;
	private String lastname;
	private String position;
	private int jersey;
	
	public Player()
	{
		setFirstname(null);
		setLastname(null);
		setPosition(null);
		setJersey(0);
	}
	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getLastname() {
		return lastname;
	}
	public void setLastname(String lastname) {
		this.lastname = lastname;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public int getJersey() {
		return jersey;
	}
	public void setJersey(int jersey) {
		this.jersey = jersey;
	}
}