import java.util.*;
import controlP5.*; //C. McCooey - Imported library for advanced widgets - 11am 29/03/23
import de.bezier.data.sql.*; //C. McCooey - Imported library to add SQLite integration - 2pm 23/03/23

final int SCREENX = 1920 -100;
final int SCREENY = 1080-100;

PFont stdFont;
ArrayList widgetList;

List currentList;
BarChart flightBarChart;

final int EVENT_BUTTON1=1;
final int EVENT_BUTTON2=2;
final int EVENT_BUTTON3=3;
final int EVENT_BUTTON4=4;
final int EVENT_BUTTON5=5;
final int EVENT_BUTTON6=6;
final int EVENT_BUTTON7=7;
final int EVENT_SLIDER=0;
final int EVENT_NULL = 0;

Screen currentScreen;

Screen scrCreateQuery = new Screen(0);
Screen scrViewBarChart = new Screen(1);
Screen scrViewFlightList = new Screen(2);
//Screen dataScreen = new Screen(3);

Slider slider;

String airport = "";

int loadingProgress;

boolean canWrite = false;
boolean knowsPassword = false;
;

float right = 65;

Table table;
ArrayList<DataPoint> dps;
ArrayList<DataPoint> airports = new ArrayList<DataPoint>();

SQLite db;
Query query;
String currentQuery;

ControlP5 cp5;
PGraphics pg;
ScrollableList ddOrderBy;
CheckBox cbIncludeFields;
Button btnGo;

String sortBy;
StringDict dictFields = new StringDict();
StringDict dictSortables = new StringDict();
ArrayList<String> cols = new ArrayList<String>();

void settings() {
  size(SCREENX, SCREENY);
}

void setup()
{
  cp5 = new ControlP5(this);
  pg = createGraphics(SCREENX, SCREENY);
  currentScreen = scrCreateQuery;

  dps = new ArrayList<DataPoint>();

  stdFont=loadFont("Bahnschrift-30.vlw");
  textFont(stdFont);

  textAlign(CENTER);
  textSize(20);
  fill(255);
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
  dictFields.set("9", "Cancelled");
  dictFields.set("10", "Diverted");
  dictFields.set("11", "Distance");

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
  cols.add("FlightDate");
  cols.add("IATA_Code_Marketing_Airline");
  cols.add("Flight_Number_Marketing_Airline");
  cols.add("Origin");
  cols.add("Dest");

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
    .setPosition(300,SCREENY-500)
    .setSize(100, 50)
    ;

  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query("SELECT Origin FROM flights");
    while (db.next()) {
      airports.add(new DataPoint(true, db));
    }
  }
  FlightsPerAirport flights = new FlightsPerAirport(airports);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights, "NumberOfAirports", "Airports");

  scrCreateQuery.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            CHOOSE DATA", color(255), color(0), stdFont, EVENT_BUTTON5));
  scrCreateQuery.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                               BAR CHART", color(255), color(0), stdFont, EVENT_BUTTON3));
  scrCreateQuery.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          VIEW DATA", color(255), color(0), stdFont, EVENT_BUTTON4));
  scrCreateQuery.addWidget(slider = new Slider(SCREENX - 40, 60, 20, SCREENY -100, 1, 100, 50, color(255), color(0), stdFont, EVENT_SLIDER));

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

void draw()
{
  background(190);

  currentScreen.draw();

  if (knowsPassword) {
    background (0);
  }
  pg.beginDraw();
  // D.Gallagher - Added code for multiple screens, 11am 16/03/23
  // C.McCooey - Refactored screen switching code to use switch statement and Screen objects - 9am 29/03/23
  switch(currentScreen.pageNo) {
  case 0: //Query screen
    // code for main screen (query data, etc)
    //C. McCooey - Added code to show widgets on query selection screen - 1pm 29/03/23]
    currentScreen = scrCreateQuery;
    airport = "";
    ddOrderBy.show();
    ddOrderBy.draw(pg);

    cbIncludeFields.show();
    cbIncludeFields.draw(pg);

    btnGo.show();
    btnGo.draw(pg);

    break;
  case 1: //Data display screen
    currentScreen = scrViewBarChart;
    ddOrderBy.hide();
    cbIncludeFields.hide();
    flightBarChart.draw();
    text(airport, SCREENX/2 + 55, 421);
    break;
  case 2:
    airport = "";
    ddOrderBy.setVisible(false);
    cbIncludeFields.setVisible(false);
    btnGo.setVisible(false);
    break;
  case 3:
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

    query = new Query(false, cols, false, "", sortBy, true, 50);
    currentQuery = query.getSQLquery();
    println(currentQuery);
    println("Loading data...");

    int space = 0;
    db = new SQLite(this, "SQLflights.db");
    if (db.connect()) {
      db.query(currentQuery);
      while (db.next()) {
        text(db.getInt("FlightDate") + " "+ db.getString("IATA_Code_Marketing_Airline") + db.getString("Flight_Number_Marketing_Airline") + " from " + db.getString("Origin") + " to " + db.getString("Dest"), 0, space);
        space += 10;
      }
    }
    println("Loaded " + dps.size() + " flights!");
    currentScreen = scrViewFlightList;
  }
}

void SortBy(int index) {
  sortBy = dictSortables.get(cp5.get(ScrollableList.class, "SortBy").getItem(index).get("value").toString());
}

void mousePressed() {

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
      currentScreen = scrViewBarChart;
      break;
    case EVENT_BUTTON4:
      currentScreen = scrViewFlightList;
      break;
    case EVENT_BUTTON5:
      currentScreen = scrCreateQuery;
      break;
    case EVENT_BUTTON6:
      if (right != -1885) {
        right -= 150;
      }
    }
  }
}

void mouseMoved() {
  for (int i = 0; i<currentScreen.widgetList.size(); i++) {
    Widget aWidget = (Widget) currentScreen.widgetList.get(i);
    if (aWidget.getEvent(mouseX, mouseY) != EVENT_NULL) {
      aWidget.isHovering = true;
    } else {
      aWidget.isHovering = false;
    }
  }
}

void mouseDragged() {
  if (slider.isDragging) {
    slider.sliderPosition = constrain(mouseY - 5, slider.y, slider.y + slider.height - 10);
    slider.currentValue = round(map(slider.sliderPosition, slider.x, slider.x + slider.width, slider.minValue, slider.maxValue));
  }
}

void mouseReleased() {
  slider.isDragging = false;
}

void keyPressed() {
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
