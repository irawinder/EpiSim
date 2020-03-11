/** 
 * Unit Instance of an Infectious Agent that can exist in Host or Environment
 */
public class Agent extends Element {
  
  private Pathogen type;
  
  public void setPathogen(Pathogen type) {
    this.type = type;
  }
  
  public Pathogen getPathogen() {
    return this.type;
  }
  
  @Override
  public String toString() {
    return 
      "Agent UID: " + getUID() 
      + "; Name: " + getName()
      ;
  }
}
