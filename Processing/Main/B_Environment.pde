/** 
 * Environment is an element that a Host and/or Agent can Occupy
 *
 */
public class Environment extends Element {
  
  // The 2D area size of the environment
  private float area;
  
  public void setArea(float area) {
    this.area = area;
  }
  
  public float getArea() {
    return this.area;
  }
  
  @Override
  public String toString() {
    String info = 
      "Environment UID: " + getUID()
      + "; Area: " + getArea()
      ;
    return info;
  }
}

/** 
 * Place is an special Environment that a Host and/or Agent can Occupy
 *
 */
public class Place extends Environment {
  
  // The type of use or activity in this Place
  private LandUse type;
  
  public void setUse(LandUse type) {
    this.type = type;
  }
  
  public LandUse getUse() {
    return this.type;
  }
  
  @Override
  public String toString() {
    String info = 
      "Place UID: " + getUID()
      + "; Type: " + getUse() 
      + "; Area: " + getArea()
      ;
    return info;
  }
}
