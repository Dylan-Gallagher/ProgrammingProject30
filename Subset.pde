class Subset {
  ArrayList<DataPoint> data;

  Subset (ArrayList<DataPoint> fullData)
  {
    this.data = fullData;
  }

  // Methods for filtering / sorting data
  void filterOriginAirport(String originAirport)
  {
    ArrayList<DataPoint> newData = new ArrayList<DataPoint>();
    for (DataPoint dp : this.data)
    {
      if (dp.originAirport.equals(originAirport))
      {
        newData.add(dp);
      }
    }
    this.data = newData;
  }
}
