//Ernesto ortiz 04/04
class FlightsPerState{ //<>//
  ArrayList<DataPoint> flights;
  ArrayList<String> stateNames;
  ArrayList<Integer> numberOfFlights;
  
  FlightsPerState(ArrayList<DataPoint> flights){
    this.flights = flights;
    for(DataPoint dp : flights){
      if(stateNames==null){
        stateNames = new ArrayList<String>();
        stateNames.add(new String(dp.originStateAbr));
        numberOfFlights = new ArrayList<Integer>();
        numberOfFlights.add(1);
      }
      else if (newAirportCheck(dp.originStateAbr, stateNames)){
        stateNames.add(new String(dp.originStateAbr));
        numberOfFlights.add(1);
      }
      else if (!newAirportCheck(dp.originStateAbr, stateNames)){
        numberOfFlights = addFlight(dp.originStateAbr, stateNames, numberOfFlights);
      }     
    }
    for (int i = 0; i < stateNames.size(); i++){
      System.out.print(stateNames.get(i) + "\", \"");
    }
    for (int i = 0; i < numberOfFlights.size(); i++){
      System.out.print(numberOfFlights.get(i) + ", ");
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
