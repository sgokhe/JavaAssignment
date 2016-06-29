package JavaBean;

public class Game implements java.io.Serializable {

	private int gameID;
	private int arena;
	private String home;
	private String visitors;
	
	public Game() 
	{
		setHome(null);
		setVisitors(null);
	}	
	
	public int getGameID() {
		return gameID;
	}
	public void setGameID(int gameID) {
		this.gameID = gameID;
	}
	public int getArena() {
		return arena;
	}
	public void setArena(int arena) {
		this.arena = arena;
	}
	public String getHome() {
		return home;
	}
	public void setHome(String home) {
		this.home = home;
	}
	public String getVisitors() {
		return visitors;
	}
	public void setVisitors(String visitors) {
		this.visitors = visitors;
	}
}