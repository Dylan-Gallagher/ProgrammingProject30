class Screen {
 ArrayList<Widget> widgetList;
  int pageNo;
  
  Screen(int num) {
    widgetList = new ArrayList<Widget>();
    pageNo = num;
  }

  public void addWidget(Widget widget) {
    widgetList.add(widget);
  }

  public void draw() {
    for (int i = 0; i<currentScreen.widgetList.size(); i++) {
      Widget aWidget = (Widget)currentScreen.widgetList.get(i);
      aWidget.draw();
    }
  }
}
