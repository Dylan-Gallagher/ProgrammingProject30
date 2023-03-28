final int EVENT_BUTTON1=1;
final int EVENT_BUTTON2=2;
final int EVENT_BUTTON3=3;
final int EVENT_BUTTON4=4;
final int EVENT_BUTTON5=5;
final int EVENT_BUTTON6=6;
final int EVENT_BUTTON7=7;
final int EVENT_SLIDER=0;
final int EVENT_NULL=0;

import de.bezier.data.sql.*;

final int SCREENX = 1920-100;
final int SCREENY = 1080-100;

import java.util.*;


Table table;
ArrayList<DataPoint> dps;
List currentList;
BarChart flightBarChart;


SQLite db;
String currentQuery = "SELECT * FROM flights ORDER BY FL_DATE";

PImage airplane;
PFont stdFont;
ArrayList widgetList;
Screen dataScreen, screen1, screen2, screen3, currentScreen;
boolean canWrite = false;
boolean knowsPassword = false;
String airport = "";
Slider slider;
int loadingProgress;

void settings() {
  size(SCREENX, SCREENY);
}

void setup() {

  stdFont=loadFont("Chalkboard-30.vlw");
  textFont(stdFont);

  textAlign(CENTER);
  textSize(20);
  fill(255);
  noStroke();

  background(0);
  text("Loading " + loadingProgress + "%", width/2, height/2);
  rect(50, height/2 + 50, loadingProgress*3, 20);

  db = new SQLite(this, "SQLflights2k.db");
  if (db.connect()) {
    db.query(currentQuery);
    while (db.next()) {
      println(db.getString("FL_DATE") + ": " + db.getString("MKT_CARRIER") + db.getString("MKT_CARRIER_FL_NUM") + " from " + db.getString("ORIGIN") + ", " + db.getString("ORIGIN_CITY_NAME") + " at "+ db.getInt("CRS_DEP_TIME") + " (" + db.getInt("DEP_TIME") + ") to " + db.getString("DEST") + ", " + db.getString("DEST_CITY_NAME") + " at " + db.getInt("CRS_ARR_TIME") + " (" + db.getInt("ARR_TIME") + "), a distance of " + db.getInt("DISTANCE") + " miles.");
    }
  }

  dps = new ArrayList<DataPoint>();

  dps.add(new DataPoint(row));


  for (DataPoint dp : dps) {
    if (dp.intArrivalTime == -1) {
      println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity +" WAC " + dp.originWAC + " at " + dp.intExpectedDepartureTime + " to " + dp.destinationAirport + ", " + dp.destinationCity + " WAC " + dp.destinationWAC + " at " + dp.intExpectedArrivalTime + ", a distance of " + dp.distance + " miles, was cancelled");
    } else {
      println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity +" WAC " + dp.originWAC + " at " + dp.intExpectedDepartureTime + " (" + dp.intDepartureTime + ")" + " to " + dp.destinationAirport + ", " + dp.destinationCity + " WAC " + dp.destinationWAC + " at " + dp.intExpectedArrivalTime + " (" + dp.intArrivalTime + "), a distance of " + dp.distance + " miles");
    }
  }
  println("Loaded " + dps.size() + " flights!");

  for (DataPoint dp : dps) {
    println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  }

  FlightsPerAirport flights = new FlightsPerAirport(dps);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights);
  //dps = new ArrayList<DataPoint>();

  //println("Loading data...");
  //table = loadTable("flights_full.csv", "header");
  //int numRows = table.getRowCount();
  //for (int i = 0; i < numRows; i++) {
  //  TableRow row = table.getRow(i);
  //  dps.add(new DataPoint(row));
  //}

  //println("Loaded " + dps.size() + " flights!");

  //for (DataPoint dp : dps) {
  //  text((dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity), 50, 0);
  //}
  //  Subset subset = new Subset(dps);
  //  subset.filterOriginAirport("DEN");
  //  for (DataPoint dp : subset.data)
  //  {
  //    println(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity);
  //  }

  screen1 = new Screen();
  screen1.addWidget(new Widget(0, 1, 132, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen1.addWidget(new Widget(268, 1, 132, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen1.addWidget(new Widget(134, 1, 132, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));

  screen1.addWidget(new Widget(100, 360, 80, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON1));
  screen1.addWidget(slider = new Slider(360, 60, 20, 320, 1, 100, 50, color(255), color(0), stdFont, EVENT_SLIDER));

  screen2 = new Screen();
  screen2.addWidget(new Widget(0, 1, 132, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen2.addWidget(new Widget(268, 1, 132, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen2.addWidget(new Widget(134, 1, 132, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));




  screen3 = new Screen();
  screen3.addWidget(new Widget(0, 1, 132, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen3.addWidget(new Widget(268, 1, 132, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen3.addWidget(new Widget(134, 1, 132, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));

  screen3.addWidget(new Widget(185, 50, 180, 40, "Enter your airport here:                                                        ", color(255), color(0), stdFont, EVENT_BUTTON2));

  //screen2.addWidget(new Widget(210, 50, 180, 40, "", color(255), color(0), stdFont, EVENT_BUTTON6));
  dataScreen = new Screen();
  dataScreen.addWidget(new Widget(100, 360, 80, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON6));

  currentScreen = screen1;
}

void draw() {

  background(190);
  currentScreen.draw();



  if (currentScreen == screen3) {
    text(airport, 275, 63);
  } else {
    airport = "";
  }

  if (knowsPassword) {
    background (0);
  }
}


void mousePressed() {

  int event;

  for (int i = 0; i< currentScreen.widgetList.size(); i++) {
    Widget aWidget = (Widget)currentScreen.widgetList.get(i);
    event = aWidget.getEvent(mouseX, mouseY);
    switch(event) {
    case EVENT_BUTTON1:
      currentScreen = dataScreen;
      break;
    case EVENT_BUTTON2:
      if (currentScreen == screen3) {
        canWrite = true;
        println("button 2!");
      }
      break;
    case EVENT_BUTTON3:
      currentScreen = screen3;
      break;
    case EVENT_BUTTON4:
      currentScreen = screen2;
      break;
    case EVENT_BUTTON5:
      currentScreen = screen1;
      break;
    case EVENT_BUTTON6:
      currentScreen = screen1;
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
