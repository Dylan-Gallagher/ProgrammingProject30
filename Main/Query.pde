//C. McCooey - Added Query class - 5pm 27/03/23
class Query{
  boolean isDistinct = false;
  ArrayList<String> columnsToDisplay = new ArrayList<String>();
  String tableName = "flights";
  boolean hasRowFilter = false;
  String rowFilter;
  String orderByCol;
  boolean sortAscending = false;
  int count;
  
  Query(boolean distinct, ArrayList<String> columns, boolean hasRowFilter, String rowFilter, String orderBy, boolean sortAsc, int count){
    this.isDistinct = distinct;
    this.columnsToDisplay = columns;
    this.hasRowFilter = hasRowFilter;
    this.rowFilter = rowFilter;
    this.orderByCol = orderBy;
    this.sortAscending = sortAsc;
    this.count = count;
  }
  
  String getSQLquery(){
    String query = "SELECT ";
    
    for(int i = 0; i < columnsToDisplay.size(); i++){
      query += columnsToDisplay.get(i);
      if(i != columnsToDisplay.size()-1){
        query += ", ";
      }
    }
    
    query += " FROM " + tableName;
    
    if(hasRowFilter){
      query += "WHERE " + rowFilter;
    }
    
    query += " ORDER BY " + orderByCol;
    
    if(sortAscending) query += " ASC ";
    else query += " DESC ";
    
    if(count > 0) query += "LIMIT " + count;
    
    return query;
  }
}
