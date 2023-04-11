//Ernesto ortiz 04/04
class DistancePerAirline{
  ArrayList<DataPoint> flights;
  ArrayList<String> airlineNames;
  ArrayList<Integer> distanceTravelled;
  
  DistancePerAirline(ArrayList<DataPoint> flights){
    this.flights = flights;
    for(DataPoint dp : flights){
      if(airlineNames==null){
        airlineNames = new ArrayList<String>();
        airlineNames.add(new String(dp.marketingCarrier));
        distanceTravelled = new ArrayList<Integer>();
        distanceTravelled.add(dp.distance);
      }
      else if (newAirlineCheck(dp.marketingCarrier, airlineNames)){
        airlineNames.add(new String(dp.marketingCarrier));
        distanceTravelled.add(dp.distance);
      }
      else if (!newAirlineCheck(dp.marketingCarrier, airlineNames)){
        distanceTravelled = addDistance(dp.distance, dp.marketingCarrier, airlineNames, distanceTravelled);
      }     
    }
    //for (int i = 0; i < airportNames.size(); i++){
    //  System.out.print(airportNames.get(i) + " ");
    //}
    //for (int i = 0; i < numberOfFlights.size(); i++){
    //  System.out.print(numberOfFlights.get(i) + " ");
    //}
  }
  
  boolean newAirlineCheck(String airline, ArrayList<String> airportList){
    for (int i = 0; i < airportList.size(); i++){
      if (airline.equals(airportList.get(i))){
        return false;
      }
    }
    return true; 
  }
  
  ArrayList<Integer> addDistance(int distance, String airline, ArrayList<String> airlineList, ArrayList<Integer> distanceList){
    for (int i = 0; i < airlineList.size(); i++){
      if(airline.equals(airlineList.get(i))){
        int number = distanceList.get(i);
        number += distance;
        distanceList.set(i, number);
      }        
    }
    return distanceList; 
  }
}
