import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query3
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String query3 = "use adventureworks2014;\n"
                 + "SELECT\n"
                 + "   pr.productid,\n"
                 + "   pr.rating,\n"
                 + "   sod.orderqty,\n"
                 + "   sod.unitprice\n"
                 + "FROM\n"
                 + "   production.productreview AS pr\n"
                 + "   INNER JOIN\n"
                 + "      sales.salesorderdetail AS sod\n"
                 + "      ON pr.productid = sod.productid\n"
                 + "WHERE\n"
                 + "   pr.rating >= 4\n"
                 + "   AND sod.orderqty > 10\n"
                 + "ORDER BY\n"
                 + "   sod.orderqty;";

         ResultSet rs = statement.executeQuery(query3);

         while (rs.next())
         {
             int productid = rs.getInt("productid");
             int rating = rs.getInt("rating");
             int orderqty = rs.getInt("orderqty");
             double unitprice = rs.getDouble("unitprice");
             // print the results
             System.out.format("%s,%s,%s,%s,\n",productid,rating,orderqty,unitprice);
         }
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query3 connServer = new Query3();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=TSQLV4;integratedSecurity=true");
   }
}
