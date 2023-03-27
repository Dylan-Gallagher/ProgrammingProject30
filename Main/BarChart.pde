//Ernesto ortiz 22/03
final int MARGIN = 30;
final int GAPPERCENT = 30;
class BarChart{
  ArrayList<String> names;
  ArrayList<Integer> frequency;
  int barSize;
  int largestFreq;
  int multiple;
  int gap;
  int barSpace;
  PFont arial;
  
  BarChart(ArrayList<String> name, ArrayList<Integer> frequency){
    this.names = name; this.frequency = frequency;
    /*The following is just for testing different sizes of arraylists:
    for(int count = 0; count<60; count++){  //<>//
      names.remove(count); 
      frequency.remove(count);
    }
    */ //<>//
    barSize = ((SCREENX-(MARGIN))/names.size())-((GAPPERCENT*((SCREENX-(MARGIN))/names.size()))/100);
    gap = ((GAPPERCENT*((SCREENX-(MARGIN))/names.size()))/100);
    barSpace = ((SCREENX-(MARGIN))/names.size());
    
    largestFreq=0;
    for(Integer freq:frequency){
      if(largestFreq<freq){
        largestFreq=freq;
      }
    }
    multiple = -((SCREENY-50)/largestFreq);
    arial = loadFont("ArialMT-7.vlw");
  }
  
  void draw(){
    background(255);
    int counter = 0;
    for(Integer freq : frequency)
    {
      fill(0,40,120);
      rect(30 + (barSize +gap)*counter, SCREENY-MARGIN, barSize, multiple*freq);
      textFont(arial);
      fill(0);
      text(freq, barSize/4 + 30 + (barSize +gap)*counter, SCREENY-MARGIN+(multiple*freq)-10);
      counter++;
    }
    counter = 0;
    for(String name : names){
      textFont(arial);
      fill(0);
      text(name, 30 + (barSize +gap)*counter, SCREENY-(MARGIN/2));
      counter++;
    }
  }  
}
