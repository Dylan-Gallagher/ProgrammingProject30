import controlP5.*;
import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;


//C. McCooey - Imported library for advanced widgets - 11am 29/03/23

//C. McCooey - Imported libraries to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920 -100;
final int SCREENY = 1080-100;

PFont stdFont;
ArrayList widgetList;

List currentList;
BarChart flightBarChart;
BarChart stateBarChart;
BarChart airlineBarChart;

final int EVENT_BUTTON1=1;
final int EVENT_BUTTON2=2;
final int EVENT_BUTTON3=3;
final int EVENT_BUTTON4=4;
final int EVENT_BUTTON5=5;
final int EVENT_BUTTON6=6;
final int EVENT_BUTTON7=7;
final int EVENT_BUTTON8=8;
final int EVENT_BUTTON9=9;
final int EVENT_BUTTON10=10;
final int EVENT_BUTTON11=11;
final int EVENT_SLIDER=0;
final int EVENT_NULL = 0;

Screen currentScreen;

Screen scrCreateQuery = new Screen(0);
Screen scrViewBarChart = new Screen(1);
Screen scrViewFlightList = new Screen(2);
Screen scrHeatMap = new Screen(3);
//Screen dataScreen = new Screen(3);

ArrayList<DataPoint> heatmapFlights = new ArrayList<DataPoint>();

Slider slider;

String airport = "";

int loadingProgress;

boolean canWrite = false;
boolean knowsPassword = false;

float right = 115;

Table table;
ArrayList<DataPoint> dps;
ArrayList<DataPoint> statesList = new ArrayList<DataPoint>();
ArrayList<DataPoint> airlinesList = new ArrayList<DataPoint>();
ArrayList<DataPoint> airports = new ArrayList<DataPoint>();

SQLite db;
Query query;
String currentQuery;

ControlP5 cp5;
PGraphics pg;
ScrollableList ddOrderBy;
CheckBox cbIncludeFields;
Button btnGo;
PGraphics textBox;
java.util.List<Toggle> cbStates;
boolean recordsGenerated = false;

String sortBy;
StringDict dictFields = new StringDict();
StringDict dictSortables = new StringDict();
ArrayList<String> cols = new ArrayList<String>();

String currentRecord;
ArrayList<String> records = new ArrayList<String>();
int space;
float crSlider;
boolean recordsDisplaying = false;

PImage statesMap;
Table airportsTable;
HashMap<String, float[]> airportsHashMap;

boolean airlineBC;
boolean distanceBC;

Heatmap heatmap;

int j = 0;
int k = 255;
int l = 255;

public void settings() {
  size(SCREENX, SCREENY);
}

public void setup()
{
  // D. Gallagher - Got QGIS exported image of states with exact latitude and longitude cutoffs - 2pm 1/4/2023
  statesMap = loadImage("imageOfStates5.png");

  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query("SELECT Origin FROM flights LIMIT 2000");
    while (db.next()) {
      heatmapFlights.add(new DataPoint(true, false, false, db));
    }
  }


  cp5 = new ControlP5(this);
  pg = createGraphics(SCREENX, SCREENY);
  currentScreen = scrCreateQuery;

  dps = new ArrayList<DataPoint>();

  stdFont=loadFont("Bahnschrift-30.vlw");
  textFont(stdFont);

  textAlign(CENTER);
  textSize(20);
  fill(0);
  noStroke();

  dictFields.set("0", "OriginCityName");
  dictFields.set("1", "OriginState");
  dictFields.set("2", "DestCityName");
  dictFields.set("3", "DestState");
  dictFields.set("4", "CRSDepTime");
  dictFields.set("5", "DepTime");
  dictFields.set("6", "CRSArrTime");
  dictFields.set("7", "ArrTime");
  dictFields.set("8", "ArrDelay");
  //dictFields.set("9", "Cancelled");
  dictFields.set("9", "Diverted");
  dictFields.set("10", "Distance");

  dictSortables.set("0", "FlightDate");
  dictSortables.set("1", "IATA_Code_Marketing_Airline");
  dictSortables.set("2", "Flight_Number_Marketing_Airline");
  dictSortables.set("3", "Origin");
  dictSortables.set("4", "Dest");

  //C.McCooey - Added code to process SQL queries and print result to console - 3pm 23/03/23
  //C.McCooey - Adjusted code to use currentQuery string and create DataPoints for each row processed - 5pm 28/03/23
  //D. Gallagher - Added Python code to pre-process data (pre-processed-data.py) - 3pm 23/03/23

  //WIDGETS

  //C. McCooey - Added widgets to query entry screen - 11am 29/03/23
  String[] sortCols = new String[]{"Flight Date", "Airline", "Flight Number", "Origin Airport", "Destination Airport"};
  //cols.add("FlightDate");
  //cols.add("IATA_Code_Marketing_Airline");
  //cols.add("Flight_Number_Marketing_Airline");
  //cols.add("Origin");
  //cols.add("Dest");

  ddOrderBy = cp5.addScrollableList("SortBy")
    .setPosition(900, 350)
    .setSize(200, 100)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(sortCols)
    .setType(ScrollableList.DROPDOWN)
    .setOpen(false)
    .hide()
    ;

  cbIncludeFields = cp5.addCheckBox("Include")
    .setPosition(400, 280)
    .setSize(50, 50)
    .setItemsPerRow(3)
    .setSpacingColumn(100)
    .setSpacingRow(60)
    .addItem("Origin City", 0)
    //.addItem("Origin State", 1)
    .addItem("Destination City", 2)
    //.addItem("Destination State", 3)
    .addItem("Expected Departure Time", 4)
    .addItem("Actual Departure Time", 5)
    .addItem("Expected Arrival Time", 6)
    .addItem("Actual Arrival Time", 7)
    .addItem("Delay", 8)
    //.addItem("Cancelled", 9)
    .addItem("Diverted", 9)
    .addItem("Distance travelled", 10)
    ;

  btnGo = cp5.addButton("Go")
    .setValue(0)
    .setPosition(900, 280)
    .setSize(200, 50)
    ;

  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query("SELECT Origin FROM flights");
    while (db.next()) {
      airports.add(new DataPoint(true, false, false, db));
    }
  }

  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query("SELECT OriginState FROM flights");
    while (db.next()) {
      statesList.add(new DataPoint(false, true, false, db));
    }
  }

  db = new SQLite(this, "SQLFlights.db");
  if (db.connect()) {
    db.query("SELECT IATA_Code_Marketing_Airline, Distance FROM flights");
    while (db.next()) {
      airlinesList.add(new DataPoint(false, false, true, db));
    }
  }

  FlightsPerAirport flights = new FlightsPerAirport(airports);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights, "Number of Flights", "Airports");

  FlightsPerState states = new FlightsPerState(statesList);
  stateBarChart = new BarChart(states.stateNames, states.numberOfFlights, "Number of Flights", "States");

  DistancePerAirline airlineDistances = new DistancePerAirline(airlinesList);
  airlineBarChart = new BarChart(airlineDistances.airlineNames, airlineDistances.distanceTravelled, "Distance Travelled", "Airlines");

  // D. Gallagher - Improved efficiency of program by changing data structures to HashMaps - 7/4/2023
  airportsHashMap= new HashMap<String, float[]>();
  println("Loading airport data...");
  airportsTable = loadTable("airports_new.csv", "header");

  for (TableRow row : airportsTable.rows()) {
    airportsHashMap.put(row.getString("iata_code"), new float[] {row.getFloat("latitude_deg"), row.getFloat("longitude_deg")});
  }

  println("done loading airport data");


  scrCreateQuery.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(200), color(0), stdFont, EVENT_BUTTON5));
  scrCreateQuery.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(200), color(0), stdFont, EVENT_BUTTON3));
  scrCreateQuery.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(200), color(0), stdFont, EVENT_BUTTON4));

  scrViewFlightList.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(200), color(0), stdFont, EVENT_BUTTON5));
  scrViewFlightList.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(200), color(0), stdFont, EVENT_BUTTON3));
  scrViewFlightList.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(200), color(0), stdFont, EVENT_BUTTON4));
  scrViewFlightList.addWidget(slider = new Slider(SCREENX - 40, 60, 20, SCREENY -100, 1, 100, 50, color(255), color(0), stdFont, EVENT_SLIDER));

  scrViewBarChart.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(200), color(0), stdFont, EVENT_BUTTON5));
  scrViewBarChart.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(200), color(0), stdFont, EVENT_BUTTON3));
  scrViewBarChart.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(200), color(0), stdFont, EVENT_BUTTON4));
  //scrViewBarChart.addWidget(new Widget(SCREENX/2, SCREENY - 100, 180, 40, "Enter your airport here :                                                                                                                                                                                     ", color(255), color(0), stdFont, EVENT_BUTTON2));
  scrViewBarChart.addWidget(new Widget(952, 672, 70, 15, "                                                                                                                  ", color(255), color(0), stdFont, EVENT_BUTTON6));
  scrViewBarChart.addWidget(new Widget(872, 672, 70, 15, "                                                                                                                   ", color(255), color(0), stdFont, EVENT_BUTTON1));
  scrViewBarChart.addWidget(new Widget(1072, 672, 40, 15, "                                                                                                                   ", color(230), color(0), stdFont, EVENT_BUTTON11));
  scrViewBarChart.addWidget(new Widget(1122, 672, 40, 15, "                                                                                                                   ", color(230), color(0), stdFont, EVENT_BUTTON9));
  scrViewBarChart.addWidget(new Widget(1172, 672, 40, 15, "                                                                                                                   ", color(230), color(0), stdFont, EVENT_BUTTON10));

  scrViewBarChart.addWidget(new Widget(72, 672, 30, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON8));
  scrViewBarChart.addWidget(new Widget(102, 672, 30, 20, " ", color(0), color(0), stdFont, EVENT_BUTTON7));

  scrHeatMap.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(200), color(0), stdFont, EVENT_BUTTON5));
  scrHeatMap.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(200), color(0), stdFont, EVENT_BUTTON3));
  scrHeatMap.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(200), color(0), stdFont, EVENT_BUTTON4));
  scrHeatMap.addWidget(new Widget(72, 672, 30, 20, " ", color(0), color(0), stdFont, EVENT_BUTTON8));
  scrHeatMap.addWidget(new Widget(102, 672, 30, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON7));

  heatmap = new Heatmap (heatmapFlights, airportsHashMap, 0, 40, 1880, 940, statesMap);

  currentScreen = scrCreateQuery;
}

public void draw()
{
  background(200);

  rect(0, 0, 2000, 0);
  rect(0, 0, 1, 2000);
  rect(SCREENX - 1, 0, 1, 2000);
  if (currentScreen == scrViewBarChart) currentScreen.draw();

  if (knowsPassword) {
    background (0);
  }
  pg.beginDraw();
  //currentScreen.draw();
  // D.Gallagher - Added code for multiple screens, 11am 16/03/23
  // C.McCooey - Refactored screen switching code to use switch statement and Screen objects - 9am 29/03/23
  switch(currentScreen.pageNo) {
  case 0: //Query screen
    //C. McCooey - Added code to show widgets on query selection screen - 1pm 29/03/23]
    recordsDisplaying = false;
    currentScreen = scrCreateQuery;
    airport = "";
    ddOrderBy.show();
    ddOrderBy.draw(pg);

    cbIncludeFields.show();
    cbIncludeFields.draw(pg);

    btnGo.show();
    btnGo.draw(pg);

    cols = new ArrayList<String>();
    cols.add("FlightDate");
    cols.add("IATA_Code_Marketing_Airline");
    cols.add("Flight_Number_Marketing_Airline");
    cols.add("Origin");
    cols.add("Dest");

    rect(0, 0, 2000, 0);
    rect(0, 0, 1, 2000);
    rect(SCREENX - 1, 0, 1, 2000);
    noStroke();
    fill(200);
    rect(2, 41, SCREENX/3 - 2, 1);

    break;
  case 1: //Data display screen
    recordsDisplaying = false;
    currentScreen = scrViewBarChart;
    ddOrderBy.setVisible(false);
    cbIncludeFields.setVisible(false);
    btnGo.setVisible(false);
    if (!airlineBC && !distanceBC) {
      flightBarChart.draw();
    }
    if (airlineBC) {
      airlineBarChart.draw();
    }
    if (distanceBC) {
      stateBarChart.draw();
    }

    text(airport, SCREENX/2 + 55, 421);


    break;
  case 2:
    currentScreen = scrViewFlightList;
    airport = "";
    ddOrderBy.setVisible(false);
    cbIncludeFields.setVisible(false);
    btnGo.setVisible(false);
    textAlign(LEFT);
    for (DataPoint dp : dps) {
      //Print selected data to screen - 10pm 05/04/23
      currentRecord = dp.flightDate + " flight " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport;
      if (cols.contains("OriginCityName"))currentRecord += ", " + dp.originCity;
      if (cols.contains("CRSDepTime"))currentRecord += " at " + dp.intExpectedDepartureTime;
      currentRecord += " to " + dp.destinationAirport;
      if (cols.contains("DestCityName"))currentRecord += ", " + dp.destinationCity;
      if (cols.contains("CRSArrTime"))currentRecord += " at " + dp.intExpectedArrivalTime;
      if (dp.cancelled == 1) {
        currentRecord += " was cancelled";
      } else {
        if (cols.contains("DepTime")) {
          if (dp.intDepartureTime == dp.intExpectedDepartureTime)currentRecord += " left on schedule";
          else currentRecord += " actually left";
          currentRecord += " at " + dp.intDepartureTime;
        }
      }
      recordsDisplaying = true;
      crSlider = slider.currentValue;
      records.add(currentRecord);
      //text(currentRecord, 200, 100 + crSlider + space);
      //space += 25;
      currentRecord = "";
    }

    rect(0, 0, 2000, 0);
    rect(0, 0, 1, 2000);
    rect(SCREENX - 1, 0, 1, 2000);

    noStroke();
    fill(200);
    rect(SCREENX/3 * 2 + 1, 41, SCREENX/3, 1);
    if (!recordsGenerated) {
      getTextBox();
      recordsGenerated = true;
    }
    //getTextBox();
    image(textBox, 50, 50 + crSlider);

    break;
  case 3:
    heatmap.draw();
  }
  if (currentScreen != scrViewBarChart)currentScreen.draw();

  pg.endDraw();
}

public void controlEvent(ControlEvent event) {
  //C. McCooey - Began to add code to generate query based on input - 2pm 29/03/23
  if (event.isFrom(btnGo)) {
    cbStates = cbIncludeFields.getItems();
    for (int i = 0; i< cbStates.size(); i++) {
      if (cbIncludeFields.getState(i)) {
        cols.add(dictFields.get(str(i)));
      }
    }
    dps = new ArrayList<DataPoint>();
    currentQuery = "SELECT * FROM flights ORDER BY " + sortBy + " ASC LIMIT 1000";
    println(currentQuery);
    println("Loading data...");
    db = new SQLite(this, "SQLflights.db");
    if (db.connect()) {
      db.query(currentQuery);
      while (db.next()) {
        dps.add(new DataPoint(false, false, false, db));
      }
    }
    println("Loaded " + dps.size() + " flights!");
    currentScreen = scrViewFlightList;
  }
}


public void SortBy(int index) {
  sortBy = dictSortables.get(cp5.get(ScrollableList.class, "SortBy").getItem(index).get("value").toString());
}

public void mousePressed() {

  int event;

  for (int i = 0; i< currentScreen.widgetList.size(); i++) {
    Widget aWidget = (Widget)currentScreen.widgetList.get(i);
    event = aWidget.getEvent(mouseX, mouseY);
    switch(event) {
    case EVENT_BUTTON1:
      if (right != 115) {
        right += 1000;
      }

      break;
    case EVENT_BUTTON2:
      if (currentScreen == scrViewBarChart) {
        canWrite = true;
        println("button 2!");
      }
      break;
    case EVENT_BUTTON3:
      loop();
      currentScreen = scrViewBarChart;
      break;
    case EVENT_BUTTON4:
      currentScreen = scrViewFlightList;
      break;
    case EVENT_BUTTON5:
      loop();
      currentScreen = scrCreateQuery;
      break;
    case EVENT_BUTTON6:
      if (right != -21115) {
        right -= 1000;
      }
      break;
    case EVENT_BUTTON7:
      currentScreen = scrViewBarChart;
      break;
    case EVENT_BUTTON8:
      currentScreen = scrHeatMap;
      break;
    case EVENT_BUTTON9:
      distanceBC = false;
      airlineBC = true;
      j = 255;
      k = 0;
      l = 255;
      
      break;
    case EVENT_BUTTON10:
      airlineBC = false;
      distanceBC = true;
      
      j = 255;
      k = 255;
      l = 0;
      
      break;
    case EVENT_BUTTON11:
      airlineBC = false;
      distanceBC = false;
      
      j = 0;
      k = 255;
      l = 255;
    }
  }
}

public void mouseMoved() {
  for (int i = 0; i<currentScreen.widgetList.size(); i++) {
    Widget aWidget = (Widget) currentScreen.widgetList.get(i);
    if (aWidget.getEvent(mouseX, mouseY) != EVENT_NULL) {
      aWidget.isHovering = true;
    } else {
      aWidget.isHovering = false;
    }
  }
}

public void mouseDragged() {
  if (slider.isDragging) {
    slider.sliderPosition = constrain(mouseY - 5, slider.y, slider.y + slider.height - 10);
    slider.currentValue = round(map(slider.sliderPosition, slider.x, slider.x + slider.width, slider.minValue, slider.maxValue));
  }
}

public void mouseReleased() {
  slider.isDragging = false;
}

public void keyPressed() {
  boolean constrain = true;
  if (airport.length() >= 3) {
    constrain = false;
  }
  if (canWrite) {
    if (key==CODED) {
      if (keyCode==LEFT) {
        println ("left");
      } else {
        println ("unknown special key");
      }
    } else {
      if (key==BACKSPACE) {
        if (airport.length()>0) {
          airport = airport.substring(0, airport.length()-1);
        }
      } else if (key==RETURN || key==ENTER) {
        println ("ENTER");
        if (airport.equals("abcd")) {
          println("Hurra!");
          knowsPassword=true;
          airport = "";
        } else {
          knowsPassword=false;
        }
      } else {
        if (constrain) {
          airport += key;
        }
      }
    }
  }
}

public void getTextBox() {
  textBox = createGraphics(1000, 100000);
  textBox.beginDraw();
  for (String record : records) {
    textBox.text(record, 0, space);
    space += 20;
  }
  textBox.endDraw();
}
