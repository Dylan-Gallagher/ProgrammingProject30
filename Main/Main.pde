final int SCREENX = 1920/2;
final int SCREENY = 1080/2;

int currentPage;
Table table;
ArrayList<DataPoint> dps;
List currentList;

void settings(){
  size(SCREENX, SCREENY);
}

void setup()
{
  currentPage = 1;


  // C. McCooey - Added code to load csv file and create Datapoint objects from each row - 10am 16/03/23
  dps = new ArrayList<DataPoint>();
  // Load data from csv into DataPoint objects
  println("Loading data...");
  table = loadTable("flights10k.csv", "header");
  for (TableRow row : table.rows()) {
    dps.add(new DataPoint(row));
  }
  println("Loaded " + dps.size() + " flights!");

  // C.McCooey - Added loop to demonstrate reading from DataPoint ArrayList - 10am 16/03/23
  for(DataPoint dp : dps){
    println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  }
  
  // D.Gallagher - Added Subset class to filter by airport - 12pm 16/03/23
  Subset subset = new Subset(dps);
  subset.filterOriginAirport("DEN");
  for (DataPoint dp : subset.data)
  {
    println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  }
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
