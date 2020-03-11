/** 
 * Instance of an Infectious Agent that can exist in Host or Environment
 */
public class Agent extends Element {
  
  // The specific variety of this pathogen (e.g. INFLUENZA)
  private Pathogen type;
  
  /**
   * Set Pathogen Type
   *
   * @param type Pathogen
   */
  public void setPathogen(Pathogen type) {
    this.type = type;
  }
  
  /**
   * Get Pathogen Type
   */
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
