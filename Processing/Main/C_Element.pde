/**
 * Abstraction of an individual element in our system
 */
public class Element {
  
  // Unique ID of Element
  private int UID;
  
  // Friendly Name of Element
  private String name;
  
  // Coordinate Location of Element
  private Coordinate location;
  
  //// Child Elements (stored as both list and map for ease of reference)
  //private ArrayList<Element> list;
  //private HashMap<Integer, Element> map;
  
  /**
   * Construct new Element
   */
  public Element() {
    //list = new ArrayList<Element>();
    //map = new HashMap<Integer, Element>();
  }
  
  /**
   * Set the Name of the Element
   *
   * @param name
   */
  void setName(String name) {
    this.name = name;
  }
  
  /**
   * Get the Name of the Element
   */
  String getName() {
    return this.name;
  }
  
  /**
   * Set the Unique ID of the Element
   *
   * @param UID unique ID
   */
  void setUID(int UID) {
    this.UID = UID;
  }
  
  /**
   * Get the Unique ID of the Element
   */
  int getUID() {
    return this.UID;
  }
  
  /**
   * Set the Location of the Element
   *
   * @param location Coordinate
   */
  void setCoordinate(Coordinate location) {
    this.location = location;
  }
  
  /**
   * Get the Location of the Element
   */
  Coordinate getCoordinate() {
    return this.location;
  }
  
  ///**
  // * Add a child Element
  // *
  // * @param e Element
  // */
  //public void addElement(Element e) {
  //  if (containsElement(e)) {
  //    println("Element already exists as a child of this element");
  //  } else {
  //    list.add(e);
  //    map.put(e.getUID(), e);
  //  }
  //}
  
  ///**
  // * Remove a child Element
  // *
  // * @param e Element
  // */
  //public void removeElement(Element e) {
  //  if (containsElement(e)) {
  //    map.remove(e.getUID());
  //    list.remove(e);
  //  } else {
  //    println("No such element exists as a child of this element");
  //  }
  //}
  
  ///**
  // * Return a list of Child Elements
  // */
  //public ArrayList<Element> getElements() {
  //  return list;
  //}
  
  ///**
  // * Return a Child Element
  // *
  // * @param uid Unique ID
  // */
  //public Element getElement(int uid) {
  //  if (map.containsKey(uid)) {
  //    return map.get(uid);
  //  } else {
  //    println("No such UID is associated with a child of this element");
  //    return null;
  //  }
  //}
  
  ///**
  // * Check if a child Element exists
  // *
  // * @param e Element
  // */
  //public boolean containsElement(Element e) {
  //  // returns true if Element e is already in map
  //  return map.get(e.getUID()) != null;
  //}
}
