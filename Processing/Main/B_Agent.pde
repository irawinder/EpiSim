/** 
 * Instance of an Infectious Agent that can exist in Host or Environment
 */
public class Agent extends Element {
  
  // Pathogen carried by this agent
  private Pathogen pathogen;
  
  // How long the agent will survive
  private Time life;
  
  // Environment or Host that this Agent is within
  private Element vessel;
  
  /**
   * Construct new agent
   */
  public Agent() {
    super();
    this.setPathogen(new Pathogen());
  }
  
  /**
   * Construct new agent with lifespan
   *
   * @param p Pathogen
   */
  public Agent(Pathogen p) {
    super();
    this.setPathogen(p);
  }
  
  /**
   * Set pathogen type
   *
   * @param p Pathogen
   */
  public void setPathogen(Pathogen p) {
    this.pathogen = p;
    this.setLifeSpan(p.getAgentLife());
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
   * Set Agent vessel (Environment or Host)
   *
   * @param vessel Element
   */
  public void setVessel(Element v) {
    this.vessel = v;
  }
  
  /**
   * Get Agent vessel (Environment or Host)
   */
  public Element getVessel() {
    return this.vessel;
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
