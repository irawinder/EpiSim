/** 
 * Place is a special Environment that a Host and/or Agent can Occupy
 *
 */
public class Place extends Environment {
  
  // The type of use or activity in this Place
  private LandUse type;
  
  /**
   * Construct new Place
   */
  public Place() {
    super();
    type = LandUse.DWELLING;
  }
  
  /**
   * Set Land Use
   *
   * @param size
   */
  public void setUse(LandUse type) {
    this.type = type;
  }
  
  /**
   * Get Land Use
   */
  public LandUse getUse() {
    return this.type;
  }
  
  @Override
  public String toString() {
    String info = 
      "Place UID: " + getUID()
      + "; Type: " + getUse() 
      + "; Size: " + getSize()
      ;
    return info;
  }
}
