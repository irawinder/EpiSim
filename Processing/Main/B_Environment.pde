/** 
 * Environment is an element that a Host and/or Agent can Occupy
 *
 */
public class Environment extends Element {

  // The type of use or activity in this environment
  private LandUse type;
  
  // The 2D area size of the environment
  private float area;
  
  public void setUse(LandUse type) {
    this.type = type;
  }
  
  public LandUse getUse() {
    return this.type;
  }
  
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
      + "; Type: " + getUse() 
      + "; Area: " + getArea()
      ;
    return info;
  }
}
