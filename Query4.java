import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query4
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String query4 = "SELECT\n"
                 + "   Fact.Sale.Description,\n"
                 + "   Fact.Sale.Quantity,\n"
                 + "   Fact.Sale.[Unit Price],\n"
                 + "   Dimension.City.City,\n"
                 + "   Fact.Sale.Profit\n"
                 + "FROM\n"
                 + "   Dimension.Customer\n"
                 + "   INNER JOIN\n"
                 + "      Fact.Sale\n"
                 + "      ON Dimension.Customer.[Customer Key] = Fact.Sale.[Customer Key]\n"
                 + "      AND Dimension.Customer.[Customer Key] = Fact.Sale.[Bill TO Customer Key]\n"
                 + "   INNER JOIN\n"
                 + "      Dimension.City\n"
                 + "      ON Fact.Sale.[City Key] = Dimension.City.[City Key]\n"
                 + "WHERE\n"
                 + "   Fact.Sale.Profit > 700\n"
                 + "   AND Dimension.City.City = 'McCall'\n"
                 + "ORDER BY\n"
                 + "   Fact.Sale.Profit DESC";
         ResultSet rs = statement.executeQuery(query4);
         while (rs.next()) {
        	 String Description = rs.getString("Description");
             int Quantity = rs.getInt("Quantity");
             double UnitPrice = rs.getDouble("Unit Price");
             String City = rs.getString("City");
             double Profit = rs.getDouble("Profit");
             // print the results
             System.out.format("%s,%s,%s,%s,%s,\n", Description, Quantity, UnitPrice, City, Profit);
         }
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query4 connServer = new Query4();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=WideWorldImportersDW;integratedSecurity=true");
   }
}
