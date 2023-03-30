//Ernesto ortiz 22/03 //<>//
final float MARGINY = 70;
final float MARGINX = 30;
final float GAPPERCENT = 30;
class BarChart {
  ArrayList<String> names;
  ArrayList<Integer> frequency;
  float barSize;
  float largestFreq;
  float multiple;
  float gap;
  float barSpace;
  String xAxis;
  String yAxis;
  PFont arial;

  BarChart(ArrayList<String> name, ArrayList<Integer> frequency, String yAxis, String xAxis) {
    this.names = name;
    this.frequency = frequency;
    this.xAxis = xAxis;
    this.yAxis = yAxis;
    /*The following is just for testing different sizes of arraylists:
     for(int count = 0; count<60; count++){
     names.remove(count);
     frequency.remove(count);
     }
     */
    barSize = ((SCREENX-(MARGINX))/names.size())-((GAPPERCENT*((SCREENX-(MARGINX))/names.size()))/100);
    gap = ((GAPPERCENT*((SCREENX-(X))/names.size()))/100);
    barSpace = ((SCREENX-(MARGINX))/names.size());

    largestFreq=0;
    for (Integer freq : frequency) {
      if (largestFreq<freq) {
        largestFreq=(float)freq;
      }
    }
    multiple = -((float)(SCREENY-(MARGINY+30))/largestFreq);


    arial = loadFont("ArialMT-15.vlw");
  }

  void draw() {
    background(255);
    int counter = 0;
    for (Integer freq : frequency)
    {
      fill(0, 40, 120);
      rect(MARGINX + (barSpace)*counter, SCREENY-MARGINY, barSize, multiple*freq);
      textFont(arial);
      fill(0);
      if (barSize/1.5>18) textSize(18);
      else textSize(barSize/1.5);
      textAlign(CENTER);
      text(freq, MARGINX + barSize/2 + (barSpace)*counter, SCREENY-MARGINY+(multiple*freq)-10);
      counter++;
    }
    counter = 0;
    for (String name : names) {
      textFont(arial);
      fill(0);
      if (barSize/2>17) textSize(17);
      else textSize(barSize/2);
      textAlign(CENTER);
      text(name, MARGINX + barSize/2 + barSpace*counter, SCREENY+15-(MARGINY));
      counter++;
    }
    //Ernesto Ortiz 30/03
    textSize(24);
    textAlign(CENTER);
    translate(MARGINX/1.5, SCREENY/2);
    rotate(radians(-90));
    text(yAxis, 0, 0);
    textSize(24);
    textAlign(CENTER);
    rotate(radians(90));
    text(xAxis, SCREENX/2, SCREENY/2 - MARGINY/3);
  }
}
