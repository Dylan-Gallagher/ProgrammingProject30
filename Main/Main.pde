import de.bezier.data.sql.*; //C. McCooey - Imported library to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920/2;
final int SCREENY = 1080/2;

int currentPage;
Table table;
ArrayList<DataPoint> dps;
List currentList;
//BarChart flightBarChart;


Table airportsTable;
HashMap<String, float[]> airports;

SQLite db;
Query query;
String currentQuery;

void settings() {
  size(SCREENX, SCREENY);
}

void setup()
{

  currentPage = 1;

  dps = new ArrayList<DataPoint>();

  //TEMPORARY
  ArrayList<String> cols = new ArrayList<String>();
  cols.add("Origin");


  query = new Query(false, cols, false, "", "FlightDate", true, 2000);
  currentQuery = query.getSQLquery();
  println("Loading data...");
  db = new SQLite(this, "SQLflights.db"); //C.McCooey - Added code to process SQL queries and print result to console - 3pm 23/03/23
  if (db.connect()) {
    db.query(currentQuery);
    while (db.next()) {
      dps.add(new DataPoint(db));
    }
  }
  println("Loaded " + dps.size() + " flights!");

  // D. Gallagher - Added Python code to pre-process data - 3pm 23/03/23



  // D. Gallagher - Added code to read in airport CSV data
  airports = new HashMap<String, float[]>();
  println("Loading airport data...");
  airportsTable = loadTable("airports_new.csv", "header");

  for (TableRow row : airportsTable.rows()) {
    airports.put(row.getString("iata_code"), new float[] {row.getFloat("latitude_deg"), row.getFloat("longitude_deg")});
  }

  println("Done loading airport data...");
  
  // D. Gallagher - Added code to demonstrate heatmap
  // Heatmap (ArrayList<DataPoint> dps, HashMap<String, float[]> airports, int x, int y, int width, int height) 
  
  Heatmap myHeatmap = new Heatmap(dps, airports, 50, 50, 300, 300);
  myHeatmap.draw();
  println("done drawing heatmap");
  


  //FlightsPerAirport flights = new FlightsPerAirport(dps);
  //flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights, "NumberOfAirports", "Airports" );
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


    //currentList = new List(dps);
    //currentList.draw();
    //flightBarChart.draw();
  }
}
