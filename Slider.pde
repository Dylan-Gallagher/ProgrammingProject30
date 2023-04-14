class Slider extends Widget {
  int minValue, maxValue, currentValue;
  float sliderPosition;
  boolean isDragging = false;

  Slider(int x, int y, int width, int height, int minValue, int maxValue, int startValue, color widgetColor, color hoverColor, PFont widgetFont, int event) {
    super(x, y, width, height, "", widgetColor, hoverColor, widgetFont, event);
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.currentValue = startValue;

    this.sliderPosition = map(startValue, minValue, maxValue, y-10, y + width - 10);
  }

  void draw() {
    super.draw();
    fill(0);
    rect(x, sliderPosition, width, 10);
    text(getValue(), x + 11, y + height + 20);
  }

  int getEvent(int mX, int mY) {
    if (mousePressed) {
      if (mY > sliderPosition && mY < sliderPosition + 10 && mX > x && mX < x + width) {
        isDragging = true;
        return event;
      }
    } else {
      isDragging = false;
    }
    return event;
  }

  int getValue() {
    float sliderValue = map(sliderPosition, y, y + height - 10, minValue, maxValue);
    return round(sliderValue);
  }
}
