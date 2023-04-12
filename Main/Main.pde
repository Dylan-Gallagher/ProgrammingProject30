//C. McCooey - Merged code into one main file - 12pm 05/04/23 //<>// //<>// //<>// //<>//

import controlP5.*; //C. McCooey - Imported library for advanced widgets - 11am 29/03/23
import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*; //C. McCooey - Imported libraries to add SQLite integration - 2pm 23/03/23

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
final int EVENT_SLIDER=8;
final int EVENT_NULL = 0;

Screen currentScreen;

Screen scrCreateQuery = new Screen(0);
Screen scrViewBarChart = new Screen(1);
Screen scrViewFlightList = new Screen(2);
//Screen dataScreen = new Screen(3);

PGraphics textBox;
Slider slider;
ArrayList<String> records = new ArrayList<String>();

String airport = "";

int loadingProgress;

boolean canWrite = false;
boolean knowsPassword = false;


float right = 65;

Table table;
ArrayList<DataPoint> dps;
ArrayList<DataPoint> airports = new ArrayList<DataPoint>();
ArrayList<DataPoint> statesList = new ArrayList<DataPoint>();
ArrayList<DataPoint> airlinesList = new ArrayList<DataPoint>();

SQLite db;
Query query;
String currentQuery;

ControlP5 cp5;
PGraphics pg;
ScrollableList ddOrderBy;
CheckBox cbIncludeFields;
Button btnGo;

String sortBy = "FlightDate";
StringDict dictFields = new StringDict();
StringDict dictSortables = new StringDict();
ArrayList<String> cols = new ArrayList<String>();

String currentRecord;
int space;
boolean recordsDisplaying = false;

public void settings() {
  size(SCREENX, SCREENY);
}

public void setup()
{
  cp5 = new ControlP5(this);
  pg = createGraphics(SCREENX, SCREENY);
  currentScreen = scrCreateQuery;

  dps = new ArrayList<DataPoint>();

  stdFont=loadFont("YuGothicUI-Light-20.vlw");
  textFont(stdFont);

  textAlign(CENTER);
  textSize(20);
  fill(255);
  noStroke();

  dictFields.set("0", "OriginCityName");
  dictFields.set("1", "DestCityName");
  dictFields.set("2", "CRSDepTime");
  dictFields.set("3", "DepTime");
  dictFields.set("4", "CRSArrTime");
  dictFields.set("5", "ArrTime");
  dictFields.set("6", "ArrDelay");
  dictFields.set("7", "Distance");

  dictSortables.set("0", "FlightDate");
  dictSortables.set("1", "IATA_Code_Marketing_Airline");
  dictSortables.set("2", "Flight_Number_Marketing_Airline");
  dictSortables.set("3", "Origin");
  dictSortables.set("4", "Dest");

  //C.McCooey - Added code to process SQL queries and print result to console - 3pm 23/03/23
  //C.McCooey - Adjusted code to use currentQuery string and create DataPoints for each row processed - 5pm 28/03/23
  //D. Gallagher - Added Python code to pre-process data - 3pm 23/03/23

  //WIDGETS

  //C. McCooey - Added widgets to query entry screen - 11am 29/03/23
  String[] sortCols = new String[]{"Flight Date", "Airline", "Flight Number", "Origin Airport", "Destination Airport"};

  ddOrderBy = cp5.addScrollableList("SortBy")
    .setPosition(50, SCREENY-500)
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
    .addItem("Destination City", 1)
    .addItem("Expected Departure Time", 2)
    .addItem("Actual Departure Time", 3)
    .addItem("Expected Arrival Time", 4)
    .addItem("Actual Arrival Time", 5)
    .addItem("Delay", 6)
    .addItem("Distance travelled", 7)
    ;

  btnGo = cp5.addButton("Go")
    .setValue(0)
    .setPosition(300, SCREENY-500)
    .setSize(100, 50)
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



  scrCreateQuery.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(255), color(0), stdFont, EVENT_BUTTON5));
  scrCreateQuery.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(255), color(0), stdFont, EVENT_BUTTON3));
  scrCreateQuery.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(255), color(0), stdFont, EVENT_BUTTON4));

  scrViewFlightList.addWidget(slider = new Slider(SCREENX - 40, 60, 20, SCREENY -100, 1, 100, 50, color(255), color(0), stdFont, EVENT_SLIDER));

  scrViewFlightList.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(255), color(0), stdFont, EVENT_BUTTON5));
  scrViewFlightList.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(255), color(0), stdFont, EVENT_BUTTON3));
  scrViewFlightList.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(255), color(0), stdFont, EVENT_BUTTON4));

  scrViewBarChart.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(255), color(0), stdFont, EVENT_BUTTON5));
  scrViewBarChart.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(255), color(0), stdFont, EVENT_BUTTON3));
  scrViewBarChart.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(255), color(0), stdFont, EVENT_BUTTON4));
  scrViewBarChart.addWidget(new Widget(SCREENX/2, SCREENY - 100, 180, 40, "Enter your airport here :                                                                                                                                                                                     ", color(255), color(0), stdFont, EVENT_BUTTON2));
  scrViewBarChart.addWidget(new Widget(952, 672, 70, 15, "                                                                                                                  ", color(255), color(0), stdFont, EVENT_BUTTON6));
  scrViewBarChart.addWidget(new Widget(872, 672, 70, 15, "                                                                                                                   ", color(255), color(0), stdFont, EVENT_BUTTON1));

  //dataScreen.addWidget(new Widget(100, 360, 80, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON1));

  currentScreen = scrCreateQuery;
}

public void draw()
{
  if (!recordsDisplaying) background(190);

  currentScreen.draw();

  if (knowsPassword) {
    background (0);
  }
  pg.beginDraw();
  // D.Gallagher - Added code for multiple screens, 11am 16/03/23
  // C.McCooey - Refactored screen switching code to use switch statement and Screen objects - 9am 29/03/23
  switch(currentScreen.pageNo) {
  case 0: //Query screen
    //C. McCooey - Added code to show widgets on query selection screen - 1pm 29/03/23]
    recordsDisplaying = false;
    //currentScreen = scrCreateQuery;
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

    break;
  case 1: //Data display screen
    recordsDisplaying = false;
    ddOrderBy.hide();
    cbIncludeFields.hide();
    airlineBarChart.draw();
    text(airport, SCREENX/2 + 55, 421);
    break;
  case 2:
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
        if (cols.contains("Distance")) currentRecord += " (a distance of " + dp.distance + " miles)";
        if (cols.contains("DepTime")) {
          if (dp.intDepartureTime == dp.intExpectedDepartureTime)currentRecord += " left on schedule";
          else currentRecord += " actually left";
          currentRecord += " at " + dp.intDepartureTime;
          if (cols.contains("ArrTime"))currentRecord += " and ";
        }
        if (cols.contains("ArrTime")) {
          if (dp.intArrivalTime == dp.intExpectedArrivalTime)currentRecord += " arrived on schedule";
          else currentRecord += " actually arrived";
          currentRecord += " at " + dp.intArrivalTime;
        }

        if (cols.contains("ArrDelay")) {
          if (cols.contains("DepTime") || cols.contains("ArrTime")) currentRecord += " and";
          if (dp.delay < 0) currentRecord += " was early by ";
          else currentRecord += " was delayed ";
          currentRecord += Math.abs(dp.delay) + " minutes";
        }
      }
      recordsDisplaying = true;
      records.add(currentRecord);
      currentRecord = "";
    }

    if (records != null) {
      getTextBox();
      image(textBox, 50, 50 + slider.currentValue);      
    }
    
    dps = new ArrayList<DataPoint>();
    records = new ArrayList<String>();
    break;
  }
  pg.endDraw();
}

public void controlEvent(ControlEvent event) {
  //C. McCooey - Began to add code to generate query based on input - 2pm 29/03/23
  if (event.isFrom(btnGo)) {
    java.util.List<Toggle> cbStates = cbIncludeFields.getItems();
    for (int i = 0; i< cbStates.size(); i++) {
      if (cbIncludeFields.getState(i)) {
        cols.add(dictFields.get(str(i)));
      }
    }
    //cols = new ArrayList<String>();
    //query = new Query(false, cols, false, "", sortBy, true, 50);
    //currentQuery = query.getSQLquery();
    currentQuery = "SELECT * FROM flights ORDER BY " + sortBy + " ASC LIMIT 500";
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
      if (right != 65) {
        right += 150;
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
      if (right != -1885) {
        right -= 150;
      }
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
  slider.getEvent(mouseX, mouseY);
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
