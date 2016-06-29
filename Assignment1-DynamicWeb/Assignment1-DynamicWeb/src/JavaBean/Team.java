package JavaBean;

public class Team implements java.io.Serializable {
	
	private String teamID;
	private String teamname;
	private String headCoach;
	private String asstCoach;
	private String manager;
	
	public Team()
	{
		setTeamID(null);
		setTeamname(null);
		setHeadCoach(null);
		setAsstCoach(null);
		setManager(null);
	}
	
	public String getTeamID() {
		return teamID;
	}
	public void setTeamID(String teamID) {
		this.teamID = teamID;
	}
	public String getTeamname() {
		return teamname;
	}
	public void setTeamname(String teamname) {
		this.teamname = teamname;
	}
	public String getHeadCoach() {
		return headCoach;
	}
	public void setHeadCoach(String headCoach) {
		this.headCoach = headCoach;
	}
	public String getAsstCoach() {
		return asstCoach;
	}
	public void setAsstCoach(String asstCoach) {
		this.asstCoach = asstCoach;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
}