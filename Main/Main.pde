import de.bezier.data.sql.*; //C. McCooey - Imported library to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920/2;
final int SCREENY = 1080/2;

int currentPage;
Table table;
ArrayList<DataPoint> dps;
List currentList;

SQLite db;
String currentQuery = "SELECT * FROM flights ORDER BY FL_DATE";

void settings(){
  size(SCREENX, SCREENY);
}

void setup()
{
  
  currentPage = 1;
  
  db = new SQLite(this, "SQLflights2k.db"); //C.McCooey - Added code to process SQL queries and print result to console - 3pm 23/03/23
  if(db.connect()){
    db.query(currentQuery);
    while(db.next()){
      println(db.getString("FL_DATE") + ": " + db.getString("MKT_CARRIER") + db.getString("MKT_CARRIER_FL_NUM") + " from " + db.getString("ORIGIN") + ", " + db.getString("ORIGIN_CITY_NAME") + " at "+ db.getInt("CRS_DEP_TIME") + " (" + db.getInt("DEP_TIME") + ") to " + db.getString("DEST") + ", " + db.getString("DEST_CITY_NAME") + " at " + db.getInt("CRS_ARR_TIME") + " (" + db.getInt("ARR_TIME") + "), a distance of " + db.getInt("DISTANCE") + " miles.");
    }
  }


  // C. McCooey - Added code to load csv file and create Datapoint objects from each row - 10am 16/03/23
  dps = new ArrayList<DataPoint>();
  // Load data from csv into DataPoint objects
  println("Loading data...");

  // D. Gallagher - Added Python code to pre-process data - 3pm 23/03/23
  table = loadTable("flights2k.csv", "header");

  for (TableRow row : table.rows()) {
    dps.add(new DataPoint(row));
  }
  // C.McCooey - Added loop to demonstrate reading from DataPoint ArrayList - 10am 16/03/23
  //for(DataPoint dp : dps){
  //  if(dp.intArrivalTime == -1){ //C. McCooey - Added conditional to provide different output for cancelled flights - 5pm 16/03/23
  //        println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity +" WAC " + dp.originWAC + " at " + dp.intExpectedDepartureTime + " to " + dp.destinationAirport + ", " + dp.destinationCity + " WAC " + dp.destinationWAC + " at " + dp.intExpectedArrivalTime + ", a distance of " + dp.distance + " miles, was cancelled");
  //  }
  //  else{
  //        println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity +" WAC " + dp.originWAC + " at " + dp.intExpectedDepartureTime + " (" + dp.intDepartureTime + ")" + " to " + dp.destinationAirport + ", " + dp.destinationCity + " WAC " + dp.destinationWAC + " at " + dp.intExpectedArrivalTime + " (" + dp.intArrivalTime + "), a distance of " + dp.distance + " miles");
  //  }
  //}
  
  println("Loaded " + dps.size() + " flights!");

  // C.McCooey - Added loop to demonstrate reading from DataPoint ArrayList - 10am 16/03/23
  //for(DataPoint dp : dps){
  //  println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  //}
  
  // D.Gallagher - Added Subset class to filter by airport - 12pm 16/03/23

  //Subset subset = new Subset(dps);
  //subset.filterOriginAirport("DEN");
  //for (DataPoint dp : subset.data)
  //{
  //  println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  //}

}

void draw()
{
  // D.Gallagher - Added code for multiple screens, 11am 16/03/23
  if (currentPage == 0)         // Main Screen
  {
    // code for main screen (query data, etc)
  } else if (currentPage == 1)    // Data Display Screen
  {
    // code for data display screen (e.g. Graphs, data, etc)

    currentList = new List(dps);
    currentList.draw();

  }

}
