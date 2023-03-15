//C. McCooey - Copied Screen class from week 6 project - 3pm 15/03/23
class Screen {
  ArrayList lstWidgets = new ArrayList();
  color colBG;

  Screen(color col) {
    colBG = col;
  }

  int getEvent() {
    if (!lstWidgets.isEmpty()) {
      for (int i = 0; i < lstWidgets.size(); i++) {
        Widget w = (Widget) lstWidgets.get(i);
        if (w.getEvent(mouseX, mouseY) == i+1) return i+1;
      }
    }
    return -1;
  }

  void addWidget(int x, int y, int width, int height, String label, color widgetColor, PFont widgetFont) {
    if(lstWidgets.isEmpty())lstWidgets.add(new Widget(x, y, width, height, label, widgetColor, widgetFont, 1));
    else lstWidgets.add(new Widget(x, y, width, height, label, widgetColor, widgetFont, lstWidgets.size()+1));
  }

  void draw() {
    if (!lstWidgets.isEmpty()) {
      for (int i = 0; i < lstWidgets.size(); i++) {
        Widget w = (Widget) lstWidgets.get(i);
        w.draw();
      }
    }
  }
}
