/** 
 * Instance of an Infectious Agent that can exist in Host or Environment
 */
public class Agent extends Element {
  
  // Pathogen carried by this agent
  private Pathogen pathogen;
  
  // How long the agent will survive
  private Time life;
  
  // Environment or Host that this Agent is within
  private Element location;
  
  /**
   * Construct new agent
   */
  public Agent() {
    this.setPathogen(new Pathogen());
    this.setLifeSpan(new Time());
  }
  
  /**
   * Construct new agent with lifespan
   *
   * @param lifeSpan remaining life span of agent
   */
  public Agent(Time lifeSpan) {
    this.setPathogen(new Pathogen());
    this.setLifeSpan(lifeSpan);
  }
  
  /**
   * Construct new agent with pathogen
   *
   * @param p Pathogen
   */
  public Agent(Pathogen p) {
    this.setPathogen(p);
    this.setLifeSpan(new Time());
  }
  
  /**
   * Construct new agent with lifespan
   *
   * @param lifeSpan remaining life span of agent
   */
  public Agent(Pathogen p, Time lifeSpan) {
    this.setPathogen(p);
    this.setLifeSpan(lifeSpan);
  }
  
  /**
   * Set pathogen type
   *
   * @param p Pathogen
   */
  public void setPathogen(Pathogen p) {
    this.pathogen = p;
  }
  
  /**
   * Get pathogen
   */
  public Pathogen getPathogen() {
    return this.pathogen;
  }
  
  /**
   * Set remaining life span of agent
   *
   * @param lifeSpan
   */
  public void setLifeSpan(Time lifeSpan) {
    this.life = lifeSpan;
  }
  
  /**
   * Get remaining life span of agent
   */
  public Time getLifeSpan() {
    return this.life;
  }
  
  /**
   * Set Agent location (Environment or Host)
   *
   * @param location Element
   */
  public void setLocation(Element loc) {
    this.location = loc;;
  }
  
  /**
   * Get Agent location (Environment or Host)
   */
  public Element getLocation() {
    return this.location;
  }
  
  /**
   * Returns true if agent is alive
   */
  public boolean alive() {
    return life.getAmount() > 0;
  }
  
  /**
   * Update agent attributes 
   *
   * @param timeStep Time
   */
  public void update(Time timeStep) {
    this.life = this.life.subtract(timeStep);
  }
  
  @Override
  public String toString() {
    return 
      "Agent UID: " + getUID() 
      + "; Name: " + getName()
      ;
  }
}
