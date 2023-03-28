class DataPoint {
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
  int intExpectedDepartureTime; //CRS_DEP_TIME?
  int intDepartureTime;
  int intExpectedArrivalTime;
  int intArrivalTime;
  int cancelled;
  int diverted;
  int distance;

  //C.McCooey - Wrote initial version of DataPoint constructor - 9am 16/03/23
  DataPoint(TableRow row) {
    cancelled = row.getInt("CANCELLED");
    switch(cancelled) {
    case 0:
      intDepartureTime = row.getInt("DEP_TIME");
      intArrivalTime = row.getInt("ARR_TIME");
      break;
    case 1:
    default:
      intDepartureTime = -1;
      intArrivalTime = -1;
      break;
    }
    //Convert these to date format within constructor?

    flightDate = row.getString("FL_DATE");
    marketingCarrier = row.getString("MKT_CARRIER");
    marketingCarrierFlightNum = row.getInt("MKT_CARRIER_FL_NUM");

    originAirport = row.getString("ORIGIN");
    originCity = row.getString("ORIGIN_CITY_NAME");
    originStateAbr = row.getString("ORIGIN_STATE_ABR");
    originWAC = row.getInt("ORIGIN_WAC");

    destinationAirport = row.getString("DEST");
    destinationCity = row.getString("DEST_CITY_NAME");
    destinationStateAbr = row.getString("DEST_STATE_ABR");
    destinationWAC = row.getInt("DEST_WAC");

    intExpectedDepartureTime = row.getInt("CRS_DEP_TIME");
    intExpectedArrivalTime = row.getInt("CRS_ARR_TIME");
    //Convert these to date format within constructor?

    diverted = row.getInt("DIVERTED");

    distance = row.getInt("DISTANCE");
  }
}
