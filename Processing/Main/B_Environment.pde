/** 
 * Environment is an element that a Host and/or Agent can Occupy
 */
public class Environment extends Element {
  
  // The 2D Size size of the environment
  private float size;
  
  /**
   * Set Environment Size
   *
   * @param size
   */
  public void setSize(float size) {
    this.size = size;
  }
  
  /**
   * Get Environment Size
   */
  public float getSize() {
    return this.size;
  }
  
  @Override
  public String toString() {
    String info = 
      "Environment UID: " + getUID()
      + "; Size: " + getSize()
      ;
    return info;
  }
}

/** 
 * Place is a special Environment that a Host and/or Agent can Occupy
 *
 */
public class Place extends Environment {
  
  // The type of use or activity in this Place
  private LandUse type;
  
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
