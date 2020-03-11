/** 
 * Instance of an Infectious Agent that can exist in Host or Environment
 */
public class Agent extends Element {
  
  private Pathogen pathogen;
  
  /**
   * Construct new Agent
   */
  public Agent() {
  }
  
  /**
   * Set Pathogen Type
   *
   * @param p Pathogen
   */
  public void setPathogen(Pathogen p) {
    this.pathogen = p;
  }
  
  /**
   * Get Pathogen
   */
  public Pathogen getPathogen() {
    return this.pathogen;
  }
  
  @Override
  public String toString() {
    return 
      "Agent UID: " + getUID() 
      + "; Name: " + getName()
      ;
  }
}
