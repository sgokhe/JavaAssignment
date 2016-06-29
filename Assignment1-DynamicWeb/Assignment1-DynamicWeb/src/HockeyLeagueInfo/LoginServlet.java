package HockeyLeagueInfo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import JavaBean.Player;
import JavaBean.Team;


/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// task 1 a query
		String NHLTeamsQuery = "select t.teamName, s.firstname || ', ' || s.lastname as HeadCoach," +
							   "s1.firstname || ' ' || s1.lastname as AsstCoach," + 
							   "s2.firstname || ' ' || s2.lastname as Trainer," +
							   "s3.firstname || ' ' || s3.lastname as Manager " +
							   "from TEAM t join STAFF s on s.staffID = t.headCoach " +
							   "join STAFF s1 on s1.staffID = t.asstCoach " +
							   "join STAFF s2 on s2.staffID = t.trainer " +
							   "join STAFF s3 on s3.staffID = t.manager " +
							   "order by teamName";
		
		// task 1 b query
		String TeamRostersQuery = "SELECT t.FIRSTNAME, t.LASTNAME, TEAMNAME, r.POSITION, r.JERSEY " +
								  "FROM GPAULLEY.TEAM t INNER JOIN GPAULLEY.ROSTER r ON t.TEAMID = r.TEAM " +
								  "JOIN gpaulley.player p on p.playerID = r.player ";
		
		// task 1 c query
		String CompletedGameQuery = "Select OT, SO, ARENANAME, HOMESCORE, VISITORSCORE  from gpaulley.arena" +
									"INNER JOIN GPAULLEY.GAME ON GPAULLEY.ARENA.arenaid = GPAULLEY.game.arena" +
									"WHERE OT='Y'AND SO='Y'";
		
		// task 1 d query
		String GamesNotPlayedQuery = "Select VISITOR, HOME, ARENANAME, HOMESCORE, VISITORSCORE, TEAMNAME  from gpaulley.arena" +
									 "INNER JOIN GPAULLEY.GAME ON GPAULLEY.ARENA.arenaid = GPAULLEY.game.arena" +
									 "INNER JOIN GPAULLEY.TEAM ON GPAULLEY.game.home = GPAULLEY.team.teamid" +
									 "WHERE HOMESCORE IS NULL";
		
		String userName = request.getParameter("username");
		String password = request.getParameter("password");
		Properties connectionPros = new Properties();
		Connection conn = null;
		HttpSession  session = request.getSession();
		
		ArrayList<Team> teams = new ArrayList<Team>();
		ArrayList<Player> player = new ArrayList<Player>();
		
		connectionPros.put("user", userName);
		connectionPros.put("password", password);
		
		try
		{
			conn = DriverManager.getConnection("jdbc:derby://localhost:1527/LeagueDB;create=true", connectionPros);
			ResultSet rs = (ResultSet) conn.prepareStatement(NHLTeamsQuery).executeQuery();
			
			while(rs.next())
			{
				Team currTeam = new Team();
				currTeam.setTeamname(rs.getString("teamname"));
				currTeam.setHeadCoach(rs.getString("headcoach"));
				currTeam.setAsstCoach(rs.getString("headcoach"));
				currTeam.setManager(rs.getString("manager"));
				
				teams.add(currTeam);
			}
			session.setAttribute("teams", teams);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/MenuPage.jsp");
			dispatcher.forward(request, response);
		}
		catch(SQLException e)
		{
			System.out.println("SQLException: " + e.getMessage());
		}
		finally
		{
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} // ends finally
	}
}