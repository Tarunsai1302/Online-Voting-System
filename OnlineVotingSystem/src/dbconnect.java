import java.sql.Connection;
import java.sql.DriverManager;

public class dbconnect {
	
	private final static String url="jdbc:mysql://localhost:3306/scet";
	private final static String user="root";
	private final static String password="manager";
	public static Connection GetConnection() {
		Connection conn=null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection(url, user, password);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		
		
		
		return conn;
	}

	
}

