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


  Heatmap (ArrayList<DataPoint> dps, HashMap<String, float[]> airports, int x, int y, int width, int height)
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
  }


  void populateData() {
    // Loop through the DataPoints
    for (DataPoint dp : dps)
    {
      addOrUpdate(dp);
    }
  }


  void addOrUpdate(DataPoint dp) {
    data.put(dp.originAirport, ((data.containsKey(dp.originAirport)) ? data.get(dp.originAirport) + 1 : 1));
  }


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


  void getIntensity() {
    // loop through the data
    for (String key : this.data.keySet())
    {
      double m = this.data.get(key);
      double scaledNum = 360 - (((m - this.min) / (this.max - this.min)) * 360);
      this.data.put(key, scaledNum);
    }
  }


  void draw()
  {
    populateData();
    getMinAndMax(this.data);
    getIntensity();

    // draw the heatmap

    // draw a background
    fill(255);
    rect(x, y, this.width, this.height);

    //// draw each of the circles
    //for (String key : this.data.keySet())
    //{
    //  if (this.airports.containsKey(key))
    //  {
    //    fill(this.data.get(key).intValue());
    //    ellipse(this.airports.get(key)[0], this.airports.get(key)[0], this.circleSize, this.circleSize);
    //  }
    //}
    colorMode(HSB, 360, 100, 100);
    for (String key : this.data.keySet()) {
      if (this.airports.containsKey(key)) {
        float[] location = this.airports.get(key);
        float latitudeVal = map(location[0], 25, 50, y + this.height, y);
        float longitudeVal = map(location[1], -125, -65, x, x + this.width);
        println("longitude:" + longitudeVal);
        println("latitude:" + latitudeVal);

        //float size = map(this.data.get(key).floatValue(), (float) this.min, (float) this.max, 1.0, 50.0);
        fill(this.data.get(key).intValue(), 100, 50);
        ellipse(longitudeVal, latitudeVal, this.circleSize, this.circleSize);
      }
    }
    colorMode(RGB, 255, 255, 255);
  }
}
