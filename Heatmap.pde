// D. Gallagher - Made Heatmap class (prototype) - 11am 31/03/2023

class Heatmap {
  int x;
  int y;
  int width;
  int height;
  double min;
  double max;
  int circleSize;
  ArrayList<DataPoint> dps;
  HashMap<String, Double> data;
  HashMap<String, float[]> airports;
  PImage map;


  Heatmap (ArrayList<DataPoint> dps, HashMap<String, float[]> airports, int x, int y, int width, int height, PImage map)
  {
    this.dps = dps;
    this.data = new HashMap<String, Double>();
    this.airports = airports;
    this.min = 99999;
    this.max = 0;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.circleSize = 5;
    this.map = map;
  }


  // D. Gallagher - Made 'data' HashMap and associated methods for populating it - 12pm 04/04/2023
  // fill the 'data' HashMap, which stores the number of flights at each airport
  void populateData() {
    for (DataPoint dp : dps)
    {
      addOrUpdate(dp);
    }
  }


  // helper method for populateData() method
  void addOrUpdate(DataPoint dp) {
    // if the HashMap already has that airport, increment the value by one, else make a new key-value pair and set that airport to 1  
    data.put(dp.originAirport, ((data.containsKey(dp.originAirport)) ? data.get(dp.originAirport) + 1 : 1));
  }


  // D. Gallagher - Made method for finding max and min values - 6pm 08/04/2023
  // find the range of values in the 'data' HashMap, used for the colour scale 
  void getMinAndMax(HashMap<String, Double> data)
  {
    for (String key : data.keySet())
    {
      double value = data.get(key);
      if (value < this.min)
      {
        this.min = value;
      }

      if (value > this.max)
      {
        this.max = value;
      }
    }
  }


  // draw map of the states
  void drawBackground() {
    image(map, x, y, width, height);
  }


  // D. Gallagher - Made v1 of draw method for heatmap - 1am 10/04/2023
  // D. Gallagher - Made v2 of draw method for heatmap, added color scaling - 6pm 12/04/2023
  // D. Gallagher - Made final version of draw method for heatmap, added size scaling and removed borders from circles - 11pm 12/04/2023
  // draw everything to screen
  void draw()
  {
    populateData();
    getMinAndMax(this.data);

    // draw a white background
    fill(255);
    rect(x, y, this.width, this.height);

    // draw map of states
    drawBackground();

    // change colormode to Hue, Saturation and Brightness (HSB), makes it much easier to scale the colors
    colorMode(HSB, 360, 100, 100);

    // remove borders from circles on map
    noStroke();

    // draw each of the airports in the correct size and color
    for (String key : this.data.keySet()) {
      if (this.airports.containsKey(key)) {
        float[] location = this.airports.get(key);
        float latitudeVal = map(location[0], 10, 71.18, y + this.height, y);
        float longitudeVal = map(location[1], -126, -66, x, x + this.width);

	// represent the color on the scale from popular (red) to unpopular (blue)
        float hue = map(this.data.get(key).floatValue(), (float) this.min, (float) this.max, 240, 0);

        // set the color using the calculated hue, and full saturation and brightness
        fill(hue, 100, 100);
        
	// scale the size of the circle based on popularity (more popular -> bigger)
        float adjustedCircleSize = map(this.data.get(key).floatValue(), (float) this.min, (float) this.max, 10, 25);

	// draw the circle
        ellipse(longitudeVal, latitudeVal, adjustedCircleSize, adjustedCircleSize);
      }
    }

    // change colormode back to RGB, so it doesn't mess up the rest of the program
    colorMode(RGB, 255, 255, 255);
  }
}
