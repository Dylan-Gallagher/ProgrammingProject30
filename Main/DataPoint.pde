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
      cancelled = db.getInt("CANCELLED");
      switch(cancelled) {
      case 0:
        intDepartureTime = db.getInt("DEP_TIME");
        intArrivalTime = db.getInt("ARR_TIME");
        break;
      case 1:
      default:
        intDepartureTime = -1;
        intArrivalTime = -1;
        break;
      }
      //Convert these to date format within constructor?

      flightDate = db.getString("FlightDate");
      flightDate = flightDate.split(" ")[0]; //C. McCooey - Fixed date to not include redundant hours/minutes - 4pm 16/03/23

      marketingCarrier = db.getString("IATA_Code_Marketing_Airline");
      marketingCarrierFlightNum = db.getInt("Flight_Number_Marketing_Airline");

      originAirport = db.getString("Origin");
      originCity = db.getString("ORIGIN_CITY_NAME");
      originStateAbr = db.getString("ORIGIN_STATE_ABR");
      originWAC = db.getInt("ORIGIN_WAC");

      destinationAirport = db.getString("DEST");
      destinationCity = db.getString("DEST_CITY_NAME");
      destinationStateAbr = db.getString("DEST_STATE_ABR");
      destinationWAC = db.getInt("DEST_WAC");

      intExpectedDepartureTime = db.getInt("CRS_DEP_TIME");
      intExpectedArrivalTime = db.getInt("CRS_ARR_TIME");
      //Convert these to date format within constructor?

      diverted = db.getInt("DIVERTED");

      distance = db.getInt("DISTANCE");
    }
  }
}
