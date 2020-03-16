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
  
  /**
   * Construct new Element
   */
  public Element() {
    this.UID = -1;
    this.name = "";
    this.location = new Coordinate();
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
}
