class List{
  ArrayList<DataPoint> dps;
  PFont arial;
  
  List(ArrayList<DataPoint> dps){
    this.dps = dps;
    arial = loadFont("ArialMT-15.vlw");
  }
  
  
  void draw(){
    background(255); 
    int x = 0; int y = 20;
    for(DataPoint dp : dps){ // in final version dps would be an arraylist excluding the rows filtered out in main screen
      if (SCREENY>y){
        textFont(arial);
        fill(0);
        text(dp.flightDate + ": " + dp.marketingCarrier + dp.marketingCarrierFlightNum + " from " + dp.originAirport + ", " + dp.originCity + " to " + dp.destinationAirport + ", " + dp.destinationCity, x ,y); //may change to excel like grids
        y +=20; 
      }
     //else
     //add widget "next page" that changes screen to see the next part of the list
     //add widget "previous page" possibly
    }
  }    
}
