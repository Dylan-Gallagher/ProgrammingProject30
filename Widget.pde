class Widget {
  int x, y, width, height;
  String label;
  int event;
  color widgetColor, hoverColor, labelColor;
  PFont widgetFont;
  boolean isHovering = false;

  Widget(int x, int y, int width, int height, String label, color widgetColor, color hoverColor, PFont widgetFont, int event) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
    this.event = event;
    this.widgetColor = widgetColor;
    this.hoverColor = hoverColor;
    this.widgetFont = widgetFont;
    labelColor = color(0);
  }
  void draw() {

    stroke(0);

    if (isHovering) {
      stroke(hoverColor) ;
    }

    fill(widgetColor);
    rect(x, y, width, height);
    textAlign(CENTER);
    textSize(20);
    fill(0);
    text(label, x+250, y+height-10);
  }
  int getEvent(int mX, int mY) {
    if (mX>x && mX < x+width && mY >y && mY <y+height) {
      return event;
    }
    return EVENT_NULL;
  }
  void setColor(int newColor) {
    widgetColor = newColor;
  }
}
