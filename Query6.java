import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query6
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         String query6 = "SELECT C.custid, COUNT( DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty\n"
    	           + "FROM Sales.Customers AS C\n"
    	           + "	INNER JOIN Sales.Orders AS O\n"
    	           + "		ON O.custid = C.custid\n"
    	           + "	INNER JOIN Sales.OrderDetails AS OD\n"
    	           + "		ON OD.orderid = O.orderid\n"
    	           + "		WHERE C.country = N'JPN'\n"
    	           + "GROUP BY C.custid;";
           Statement statement = conn.createStatement();
           ResultSet rs = statement.executeQuery(query6);
           while (rs.next())
  	      {
  	        int custid = rs.getInt("custid");
  	        int numorders = rs.getInt("numorders");
  	        int totalqty = rs.getInt("totalqty");
  	        // print the results
  	        System.out.format("%s, %s, %s\n",custid , numorders , totalqty);
  	      }
  	      statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query6 connServer = new Query6();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=TSQLV4;integratedSecurity=true");
   }
}
