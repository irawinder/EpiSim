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
  
  /**
   * Determine if this environment qualifies as a Primary Environment for this Person
   *
   * @param p Person
   */
  public boolean isPrimary(Person p) {
    if(this.type == LandUse.DWELLING) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Determine if this environment qualifies as a Secondary Environment for this Person (i.e. the host spends the day at this Environment for work or school)
   *
   * @param p Person
   */
  public boolean isSecondary(Person p) {
    Demographic d = p.getDemographic();
    if(d == Demographic.CHILD) {
      if(this.type == LandUse.SCHOOL) {
        return true;
      } else {
        return false;
      }
    } else if (d == Demographic.ADULT) {
      if(this.type == LandUse.OFFICE || this.type == LandUse.RETAIL || this.type == LandUse.SCHOOL || this.type == LandUse.HOSPITAL) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  
  /**
   * Determine if this environment qualifies as a Tertiary Environment for this Person
   *
   * @param p Person
   */
  public boolean isTertiary(Person p) {
    if(this.type != LandUse.DWELLING && this.type != LandUse.OFFICE) {
      return true;
    } else {
      return false;
    }
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
