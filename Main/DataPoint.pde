//C.McCooey - Declared attributes for DataPoint class - 9am 16/03/23
class DataPoint {
  boolean isAirportList;
  String flightDate;
  String marketingCarrier;
  int marketingCarrierFlightNum;
  String originAirport;
  String originCity;
  String originStateAbr;
  int originWAC;
  String destinationAirport;
  String destinationCity;
  String destinationStateAbr;
  int destinationWAC;
  int intExpectedDepartureTime;
  int intDepartureTime;
  int intExpectedArrivalTime;
  int intArrivalTime;
  int cancelled;
  int diverted;
  int distance;

  //C.McCooey - Wrote initial version of DataPoint constructor - 9am 16/03/23
  //C.McCooey - Updated constructor to accept SQLite table instead of TableRow - 4pm 28/03/23
  DataPoint(boolean isAirportList, SQLite db) {
    if (isAirportList) {
      originAirport = db.getString("Origin");
    } else {
      cancelled = db.getInt("Cancelled");
      switch(cancelled) {
      case 0:
        intDepartureTime = db.getInt("DepTime");
        intArrivalTime = db.getInt("ArrTime");
        break;
      case 1:
      default:
        intDepartureTime = -1;
        intArrivalTime = -1;
        break;
      }
      //Convert these to date format within constructor?
      flightDate = db.getString("FlightDate");
      if (flightDate != null)flightDate = flightDate.split(" ")[0]; //C. McCooey - Fixed date to not include redundant hours/minutes - 4pm 16/03/23

      marketingCarrier = db.getString("IATA_Code_Marketing_Airline");
      marketingCarrierFlightNum = db.getInt("Flight_Number_Marketing_Airline");

      originAirport = db.getString("Origin");
      try{
      originCity = db.getString("OriginCityName");
      }catch(Exception e){}     
      //originStateAbr = db.getString("OriginState");
      //originWAC = db.getInt("OriginWac");

      destinationAirport = db.getString("Dest");
      try{
      destinationCity = db.getString("DestCityName");
      }catch(Exception e){}
      //destinationStateAbr = db.getString("DestState");
      //destinationWAC = db.getInt("DestWac");
      try{
      intExpectedDepartureTime = db.getInt("CRSDepTime");
      }catch(Exception e){}
      try{
      intExpectedArrivalTime = db.getInt("CRSArrTime");
      }catch(Exception e){}
      //Convert these to date format within constructor?
      
      try{
      diverted = db.getInt("Diverted");
      }catch(Exception e){}
      try{
      distance = db.getInt("Distance");
      }catch(Exception e){}
    }
  }
}
