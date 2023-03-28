import de.bezier.data.sql.*; //C. McCooey - Imported library to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920/2;
final int SCREENY = 1080/2;

int currentPage;
Table table;
ArrayList<DataPoint> dps;
List currentList;
BarChart flightBarChart;

SQLite db;
Query query;
String currentQuery;

void settings(){
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
  if(db.connect()){
    db.query(currentQuery);
    while(db.next()){
      dps.add(new DataPoint(db));
    }
  }
  println("Loaded " + dps.size() + " flights!");

  // D. Gallagher - Added Python code to pre-process data - 3pm 23/03/23

  FlightsPerAirport flights = new FlightsPerAirport(dps);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights);

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
    flightBarChart.draw();
  }
}
