class FlightsPerAirport{
  ArrayList<DataPoint> flights;
  ArrayList<String> airportNames;
  ArrayList<Integer> numberOfFlights;
  
  FlightsPerAirport(ArrayList<DataPoint> flights){
    this.flights = flights;
    for(DataPoint dp : flights){
      if(airportNames==null){
        airportNames = new ArrayList<String>();
        airportNames.add(new String(dp.originAirport));
        numberOfFlights = new ArrayList<Integer>();
        numberOfFlights.add(1);
      }
      else if (newAirportCheck(dp.originAirport, airportNames)){
        airportNames.add(new String(dp.originAirport));
        numberOfFlights.add(1);
      }
      else if (!newAirportCheck(dp.originAirport, airportNames)){
        numberOfFlights = addFlight(dp.originAirport, airportNames, numberOfFlights);
      }     
    }
    for (int i = 0; i < airportNames.size(); i++){
      System.out.print(airportNames.get(i) + " ");
    }
    for (int i = 0; i < numberOfFlights.size(); i++){
      System.out.print(numberOfFlights.get(i) + " ");
    }
  }
  
  boolean newAirportCheck(String airport, ArrayList<String> airportList){
    for (int i = 0; i < airportList.size(); i++){
      if (airport.equals(airportList.get(i))){
        return false;
      }
    }
    return true; 
  }
  
  ArrayList<Integer> addFlight(String airport, ArrayList<String> airportList, ArrayList<Integer> flightsNumber){
    for (int i = 0; i < airportList.size(); i++){
      if(airport.equals(airportList.get(i))){
        int number = flightsNumber.get(i);
        flightsNumber.set(i, ++number);
      }        
    }
    return flightsNumber; 
  }
}
