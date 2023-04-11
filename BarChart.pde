final float MARGINY = 350;
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
  float MARGINX;


  BarChart(ArrayList<String> name, ArrayList<Integer> frequency, String yAxis, String xAxis) { //<>//
    this.names = name; //<>//
    this.frequency = frequency;
    this.xAxis = xAxis;
    this.yAxis = yAxis;

    barSize = ((SCREENX + 2000)/names.size())-((GAPPERCENT*((SCREENX-(MARGINX))/names.size()))/100);
    gap = ((GAPPERCENT*((SCREENX-(X))/names.size()))/100);
    barSpace = ((SCREENX + 2000)/names.size());


    largestFreq=0;
    for (Integer freq : frequency) {
      if (largestFreq<freq) {
        largestFreq=(float)freq;
      }
    }
    
    multiple = -((float)(SCREENY-200-(MARGINY+30))/largestFreq); //<>//
  }

  void draw() {
    noStroke();
    
    MARGINX = right;
    
    int counter = 0;
    for (Integer freq : frequency)
    {
      fill(255, 0, 120);
      rect(MARGINX + (barSpace)*counter, SCREENY-MARGINY, barSize, multiple*freq);

      fill(0);
      if (barSize/1.5>18) textSize(18);
      else textSize(barSize/1.5);
      textAlign(CENTER);
      text(freq, MARGINX + barSize/2 + (barSpace)*counter, SCREENY-MARGINY+(multiple*freq)-10);
      counter++;
    }
    counter = 0;
    for (String name : names) {

      fill(0);
      if (barSize/2>17) textSize(17);
      else textSize(barSize/2);
      textAlign(CENTER);
      text(name, MARGINX + barSize/2 + barSpace*counter, SCREENY+15-(MARGINY));
      counter++;
    }
    fill(190);
    rect(0, 50, 64, 600); 
    fill(190);
    rect(SCREENX-64, 50, 64, 600); 
    textSize(24);
    fill(0);
    textAlign(CENTER);
    translate(57/1.5, SCREENY/2);
    rotate(radians(-90));
    text(yAxis, 70, 0);
    textSize(24);
    textAlign(CENTER);
    rotate(radians(90));
    text(xAxis, SCREENX/2, SCREENY/2 - 250);
  }
}
