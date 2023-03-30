class Heatmap {
    int x;
    int y;
    int width;
    int height;
    int min;
    int max;
    int circleSize;
    ArrayList<DataPoint> dps;
    HashMap<String, Double> data;
    HashMap<String, float[]> airports;

    
    Heatmap (ArrayList<DataPoint> dps, HashMap<String, float[]> airports, int x, int y, int width, int height) 
    {
        this.dps = dps;
        this.data = new HashMap<String, Double>();
        this.airports = airports;
        this.min = null;
        this.max = null;
        this.circleSize = 5;
    }


    void populateData() {
        // Loop through the DataPoints
        for (DataPoint dp : dps)
        {
            addOrUpdate(dp);
        }
    }


    void addOrUpdate(dp) {
        data.put(dp.originAirport, ((data.containsKey(dp.originAirport)) ? data.get(dp.originAirport) + 1 : 1));
    }


    void getMinAndMax(HashMap<String, Double> data)
    {
        for (String key : data.keySet())
        {
            int value = data.get(key);
            if (this.min == null || value < this.min)
            {
                this.min = value;
            }

            if (this.max == null || value > this.max)
            {
                this.max = value;
            }
        }
    }


    void getIntensity() {
        double targetMin = 0;
        double targetMax = 255;

        // loop through the data
        for (String key : this.data.keySet())
        {
            double m = this.data.get(key);
            double scaledNum = 255 - (((m - this.min) / (this.max - this.min)) * 255);
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
        rect(x, y, width, height);

        // draw each of the circles
        for (String key : this.data.keySet())
        {
            fill(this.data.get(key));
            ellipse(this.airports.get(key)[0], this.airports.get(key)[0], this.circleSize, this.circleSize);
        }
    }
}