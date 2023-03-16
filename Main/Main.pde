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
  
  //TODO: Demonstrate loading data from objects in ArrayList
}

void draw()
{
  
}
