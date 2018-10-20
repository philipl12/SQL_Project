import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query1
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String queryString = "select orderid from Sales.Orders where orderid % 2 = 0";
         ResultSet rs = statement.executeQuery(queryString);
         while (rs.next()) {
            System.out.println(rs.getString(1));
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
	   Query1 connServer = new Query1();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;databaseName=TSQLV4;integratedSecurity=true");
   }
}
