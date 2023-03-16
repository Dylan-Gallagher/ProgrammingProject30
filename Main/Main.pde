Table table;
ArrayList<DataPoint> dps;

void setup() 
{
  //C. McCooey - Added code to load csv file and create Datapoint objects from each row - 10am 16/03/23
  dps = new ArrayList<DataPoint>();
  //Load data from csv into DataPoint objects
  println("Loading data...");
  table = loadTable("flights10k.csv", "header");
  for(TableRow row : table.rows()){
    dps.add(new DataPoint(row));
  }
  println("Loaded " + dps.size() + " flights!");
  
  //C.McCooey - Added loop to demonstrate reading from DataPoint ArrayList - 10am 16/03/23
  for(DataPoint dp : dps){
    println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  }
}

void draw()
{
  
}
