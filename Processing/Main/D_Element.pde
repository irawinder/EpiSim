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
  public void setName(String name) {
    this.name = name;
  }
  
  /**
   * Get the Name of the Element
   */
  public String getName() {
    return this.name;
  }
  
  /**
   * Set the Unique ID of the Element
   *
   * @param UID unique ID
   */
  public void setUID(int UID) {
    this.UID = UID;
  }
  
  /**
   * Get the Unique ID of the Element
   */
  public int getUID() {
    return this.UID;
  }
  
  /**
   * Set the Location of the Element
   *
   * @param location Coordinate
   */
  public void setCoordinate(Coordinate location) {
    this.location = location;
  }
  
  /**
   * Get the Location of the Element
   */
  public Coordinate getCoordinate() {
    return this.location;
  }
  
  @Override
  public String toString() {
    return this.UID + ": " + this.name + ", " + this.location;
  }
  
}
