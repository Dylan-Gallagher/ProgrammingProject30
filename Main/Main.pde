import java.util.*;
import controlP5.*; //C. McCooey - Imported library for advanced widgets - 11am 29/03/23
import de.bezier.data.sql.*; //C. McCooey - Imported library to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920/2;
final int SCREENY = 1080/2;
final int EVENT_NULL = -1;

Screen currentScreen;

Screen scrCreateQuery = new Screen(0);
Screen scrViewBarChart = new Screen(1);

Table table;
ArrayList<DataPoint> dps;
List currentList;
BarChart flightBarChart;

SQLite db;
Query query;
String currentQuery;

ControlP5 cp5;
PGraphics pg;
ScrollableList ddOrderBy;
CheckBox cbIncludeFields;
Button btnGo;

void settings() {
  size(SCREENX, SCREENY);
}

void setup()
{
  cp5 = new ControlP5(this);
  pg = createGraphics(SCREENX, SCREENY);
  currentScreen = scrCreateQuery;

  dps = new ArrayList<DataPoint>();

  //TEMPORARY
  ArrayList<String> cols = new ArrayList<String>();
  cols.add("Origin");


  query = new Query(false, cols, false, "", "FlightDate", true, 2000);
  currentQuery = query.getSQLquery();
  println("Loading data...");

  //C.McCooey - Added code to process SQL queries and print result to console - 3pm 23/03/23
  //C.McCooey - Adjusted code to use currentQuery string and create DataPoints for each row processed - 5pm 28/03/23
  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query(currentQuery);
    while (db.next()) {
      dps.add(new DataPoint(db));
    }
  }
  println("Loaded " + dps.size() + " flights!");

  // D. Gallagher - Added Python code to pre-process data - 3pm 23/03/23

  FlightsPerAirport flights = new FlightsPerAirport(dps);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights);

  //WIDGETS

  //C. McCooey - Added widgets to query entry screen - 11am 29/03/23
  String[] sortCols = new String[]{"Flight Date", "Flight Number", "Origin Airport", "Destination Airport"};

  ddOrderBy = cp5.addScrollableList("Sort by")
    .setPosition(50, SCREENY-200)
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(sortCols)
    .setType(ScrollableList.DROPDOWN)
    .setOpen(false)
    .hide()
    ;

  cbIncludeFields = cp5.addCheckBox("Include")
    .setPosition(50, 100)
    .setSize(20, 20)
    .setItemsPerRow(4)
    .setSpacingColumn(150)
    .setSpacingRow(20)
    .addItem("Origin City", 0)
    .addItem("Origin State", 1)
    .addItem("Destination City", 2)
    .addItem("Destination State", 3)
    .addItem("Expected Departure Time", 4)
    .addItem("Actual Departure Time", 5)
    .addItem("Expected Arrival Time", 6)
    .addItem("Actual Arrival Time", 7)
    .addItem("Delay", 8)
    .addItem("Cancelled", 9)
    .addItem("Diverted", 10)
    .addItem("Distance travelled", 11)
    ;

  btnGo = cp5.addButton("Go")
    .setValue(0)
    .setPosition(SCREENX-150, SCREENY-100)
    .setSize(100, 50)
    ;
}

void draw()
{
  pg.beginDraw();
  // D.Gallagher - Added code for multiple screens, 11am 16/03/23
  // C.McCooey - Refactored screen switching code to use switch statement and Screen objects - 9am 29/03/23
  switch(currentScreen.pageNo) {
  case 0: //Query screen
    // code for main screen (query data, etc)
    //C. McCooey - Added code to show widgets on query selection screen - 1pm 29/03/23
    ddOrderBy.show();
    ddOrderBy.draw(pg);

    cbIncludeFields.show();
    cbIncludeFields.draw(pg);

    btnGo.show();
    btnGo.draw(pg);

    break;
  case 1: //Data display screen
    ddOrderBy.hide();
    cbIncludeFields.hide();
    btnGo.hide();//TEMP
    // code for data display screen (e.g. Graphs, data, etc)
    //currentList = new List(dps);
    //currentList.draw();
    flightBarChart.draw();
    break;
  }
  pg.endDraw();
}

public void controlEvent(ControlEvent event){
  //C. McCooey - Began to add code to generate query based on input - 2pm 29/03/23
  if(event.isFrom(btnGo)){
    println("go go go");
    java.util.List<Toggle> cbStates = cbIncludeFields.getItems();
    for(int i = 0; i< cbStates.size(); i++){
      println(cbIncludeFields.getState(i));
    }
  }
}
