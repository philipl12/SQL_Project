import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query2
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String query2 = "USE AdventureWorks2014;\n"
                 + "SELECT Name\n"
                 + "FROM Sales.Store\n"
                 + "ORDER BY Name";

         ResultSet rs = statement.executeQuery(query2);

         while (rs.next())
         {
           String Name = rs.getString("Name");
           // print the results
           System.out.format("%s,\n",Name);
         }
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query2 connServer = new Query2();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=TSQLV4;integratedSecurity=true");
   }
}
