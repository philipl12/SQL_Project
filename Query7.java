import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query7
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String query1 = "SELECT testid, studentid, score\n"
  	           + "FROM Stats.Scores\n"
  	           + "WHERE testid = 'TEST XYZ' AND score <= 80;";
         ResultSet rs = statement.executeQuery(query1);
         while (rs.next()) {
 	        String testid = rs.getString("testid");
 	        String studentid = rs.getString("studentid");
 	        int score = rs.getInt("score");

 	        System.out.format("%s, %s, %s\n", testid, studentid, score);
         }
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query7 connServer = new Query7();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=TSQLV4;integratedSecurity=true");
   }
}
