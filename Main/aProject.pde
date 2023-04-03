final int EVENT_BUTTON1=1;
final int EVENT_BUTTON2=2;
final int EVENT_BUTTON3=3;
final int EVENT_BUTTON4=4;
final int EVENT_BUTTON5=5;
final int EVENT_BUTTON6=6;
final int EVENT_BUTTON7=7;
final int EVENT_SLIDER=0;
final int EVENT_NULL=0;

final int SCREENX = 1920-100;
final int SCREENY = 1080-100;

import de.bezier.data.sql.*;
import java.util.*;

SQLite db;
Query query;
String currentQuery = "SELECT * FROM flights ORDER BY FL_DATE";

Table table;
ArrayList<DataPoint> dps;

PFont stdFont;
ArrayList widgetList;
Screen loadingScreen, dataScreen, screen1, screen2, screen3, currentScreen;

Slider slider;
List currentList;
BarChart flightBarChart;

String airport = "";

int loadingProgress;

boolean canWrite = false;
boolean knowsPassword = false;;

float right = 65;

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

  dps = new ArrayList<DataPoint>();

  //TEMPORARY
  ArrayList<String> cols = new ArrayList<String>();
  cols.add("Origin");

  query = new Query(false, cols, false, "", "FlightDate", true, 2000);
  currentQuery = query.getSQLquery();
  println("Loading data...");
  db = new SQLite(this, "SQLflights.db");
  if (db.connect()) {
    db.query(currentQuery);
    while (db.next()) {
      dps.add(new DataPoint(db));
    }
  }
  println("Loaded " + dps.size() + " flights!");

  loadingProgress = 50;
  background(0);
  text("Loading " + loadingProgress + "%", width/2, height/2);
  rect(50, height/2 + 50, loadingProgress*3, 20);

  FlightsPerAirport flights = new FlightsPerAirport(dps);
  flightBarChart = new BarChart(flights.airportNames, flights.numberOfFlights, "NumberOfAirports", "Airports");

  screen1 = new Screen();
  screen1.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen1.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen1.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));



  screen2 = new Screen();
  screen2.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen2.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen2.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));

  screen1.addWidget(slider = new Slider(SCREENX - 40, 60, 20, SCREENY -100, 1, 100, 50, color(255), color(0), stdFont, EVENT_SLIDER));

  screen3 = new Screen();
  screen3.addWidget(new Widget(0, 1, SCREENX/3 - 1, 40, "                            FLIGHTS", color(255), color(0), stdFont, EVENT_BUTTON5));
  screen3.addWidget(new Widget(SCREENX/3, 1, SCREENX/3, 40, "                          AIRPORT", color(255), color(0), stdFont, EVENT_BUTTON3));
  screen3.addWidget(new Widget(SCREENX/3 * 2 + 1, 1, SCREENX/3, 40, "                          DATE", color(255), color(0), stdFont, EVENT_BUTTON4));

  screen3.addWidget(new Widget(SCREENX/2, SCREENY - 100, 180, 40, "Enter your airport here :                                                                                                                                                                                     ", color(255), color(0), stdFont, EVENT_BUTTON2));
  screen3.addWidget(new Widget(952, 672, 70, 15, "                                                                                                                  ", color(255), color(0), stdFont, EVENT_BUTTON6));
  screen3.addWidget(new Widget(872, 672, 70, 15, "                                                                                                                   ", color(255), color(0), stdFont, EVENT_BUTTON1));

  dataScreen = new Screen();
  //dataScreen.addWidget(new Widget(100, 360, 80, 20, " ", color(255), color(0), stdFont, EVENT_BUTTON1));

  currentScreen = screen1;
}

void draw() {

  background(190);

  currentScreen.draw();

  if (currentScreen == screen3) {
    flightBarChart.draw();
  }

  if (currentScreen == screen3) {
    text(airport, SCREENX/2 + 55, 421);
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
      if (right != 65) {
        right += 150;
      }

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
