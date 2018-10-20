import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Query5
{
   public void dbConnect(
		   String url

           )
   {
      try {
         Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
         Connection conn = DriverManager.getConnection(url);
         Statement statement = conn.createStatement();
         String query5 = ";WITH IndivSalesData AS\n"
  	           + "(\n"
  	           + "    SELECT\n"
  	           + "       SaleYear = YEAR(oh.OrderDate),\n"
  	           + "       SalesForYear = SUM(od.LineTotal) \n"
  	           + "    FROM \n"
  	           + "        Sales.SalesOrderDetail od \n"
  	           + "    INNER JOIN \n"
  	           + "        Sales.SalesOrderHeader oh ON od.SalesOrderID = oh.SalesOrderID\n"
  	           + "    INNER JOIN \n"
  	           + "        Sales.Customer c ON oh.CustomerID = c.CustomerID\n"
  	           + "    INNER JOIN \n"
  	           + "        Person.Person p ON c.PersonID = p.BusinessEntityID\n"
  	           + "    WHERE\n"
  	           + "        p.PersonType = 'IN'\n"
  	           + "    GROUP BY\n"
  	           + "       YEAR(oh.OrderDate)\n"
  	           + "), \n"
  	           + "-- sales data for corporate customers, grouped by year\n"
  	           + "CorporateSalesData AS\n"
  	           + "(\n"
  	           + "    SELECT\n"
  	           + "       SaleYear = YEAR(oh.OrderDate),\n"
  	           + "       SalesForYear = SUM(od.LineTotal) \n"
  	           + "    FROM \n"
  	           + "        Sales.SalesOrderDetail od \n"
  	           + "    INNER JOIN \n"
  	           + "        Sales.SalesOrderHeader oh ON od.SalesOrderID = oh.SalesOrderID\n"
  	           + "    INNER JOIN \n"
  	           + "        Sales.Customer c ON oh.CustomerID = c.CustomerID\n"
  	           + "    INNER JOIN \n"
  	           + "        Person.Person p ON c.PersonID = p.BusinessEntityID\n"
  	           + "    WHERE\n"
  	           + "        p.PersonType = 'SC'\n"
  	           + "    GROUP BY\n"
  	           + "       YEAR(oh.OrderDate)\n"
  	           + ")\n"
  	           + "-- select the Year, determine total sales, and percentages\n"
  	           + "SELECT \n"
  	           + "    Indiv.SaleYear, \n"
  	           + "    PercentToIndividuals = Indiv.SalesForYear / (Indiv.SalesForYear + SC.SalesForYear) * 100.0,\n"
  	           + "    PercentToCorporate = SC.SalesForYear / (Indiv.SalesForYear + SC.SalesForYear) * 100.0,\n"
  	           + "    TotalSales = Indiv.SalesForYear + SC.SalesForYear\n"
  	           + "FROM \n"
  	           + "    IndivSalesData Indiv\n"
  	           + "INNER JOIN \n"
  	           + "    CorporateSalesData SC ON Indiv.SaleYear = SC.SaleYear\n"
  	           + "ORDER BY \n"
  	           + "    Indiv.SaleYear\n"
  	           + " ";

         ResultSet rs = statement.executeQuery(query5);

	       while (rs.next()) {
	        String SaleYear = rs.getString("SaleYear");
	        double PercentToIndividuals = rs.getFloat("PercentToIndividuals");
	        double PercentToCorporate = rs.getFloat("PercentToCorporate");
	        double TotalSales = rs.getFloat("TotalSales");
	        // print the results
	        System.out.format("%s, %s, %s, %s ,\n",SaleYear,PercentToIndividuals, PercentToCorporate,TotalSales);
	      }
         statement.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }

   public static void main(String[] args)
   {
      Query5 connServer = new Query5();
      connServer.dbConnect("jdbc:sqlserver://ASUS-UX303\\PLIN;database=AdventureWorks2014;integratedSecurity=true");
   }
}
