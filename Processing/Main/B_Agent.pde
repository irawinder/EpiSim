/** 
 * Viral Agent that can exist in Host or Envoronment
 */
public class Agent extends Element {
  
  private AgentType type;
  
  public void setType(AgentType type) {
    this.type = type;
  }
  
  public AgentType getType() {
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
