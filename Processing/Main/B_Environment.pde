/** 
 * Environment is an element that Host and Agent can Occupy
 *
 *   Primary Environment:
 *     The host's primary residence when they are not working or shopping. This often
 *     represents a dwelling with multiple household memebers
 *
 *   Secondary Environment:  
 *     The location where the host usually spends their time during the day. This is
 *     often at an office or employer for adults, or at school for children.
 *
 *   Tertiary Environment: 
 *     All other locations that a host may spend their time throughout the day. This
 *     includes shopping, walking, commuting, dining, etc.
 */
public class Environment extends Element {

  private EnvironmentType type;
  private float area;
  
  public void setType(EnvironmentType type) {
    this.type = type;
  }
  
  public EnvironmentType getType() {
    return this.type;
  }
  
  public void setArea(float area) {
    this.area = area;
  }
  
  public float getArea() {
    return this.area;
  }
  
  public boolean isPrimary() {
    if(this.type == EnvironmentType.DWELLING) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Determine if this environment qualifies as a Secondary Location for this Host (i.e. the host spends the day at this location for work or school)
   *
   * @param h Host
   */
  public boolean isSecondary(Host h) {
    Demographic d = h.getDemographic();
    if(d == Demographic.CHILD) {
      if(type == EnvironmentType.SCHOOL) {
        return true;
      } else {
        return false;
      }
    } else if (d == Demographic.ADULT) {
      if(type == EnvironmentType.OFFICE || type == EnvironmentType.RETAIL || type == EnvironmentType.SCHOOL || type == EnvironmentType.HOSPITAL) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  
  public boolean isTertiary() {
    if(this.type == EnvironmentType.DWELLING) {
      return true;
    } else {
      return false;
    }
  }
  
  @Override
  public String toString() {
    String info = 
      "Environment UID: " + getUID()
      + "; Type: " + getType() 
      + "; Area: " + getArea()
      ;
    return info;
  }
}
