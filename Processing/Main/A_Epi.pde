/**
 * Epidemiological Model:
 *
 *   Pathogen: 
 *     The pathogen is the microorganism that actually causes the disease in question. 
 *     An pathogen could be some form of bacteria, virus, fungus, or parasite.
 *
 *   Agent:
 *     Agents are the vessels by which Pathogens spread. In a models there may be
 *     numerous Agents referencing the same generic Pathogen definition.
 *
 *   Host:  
 *     The agent infects the host, which is the organism that carries the disease. 
 *     A host doesn’t necessarily get sick; hosts can act as carriers for an agent 
 *     without displaying any outward symptoms of the disease. Hosts get sick or 
 *     carry an agent because some part of their physiology is hospitable or 
 *     attractive to the agent.
 *
 *   Environment: 
 *     Outside factors can affect an epidemiologic outbreak as well; collectively 
 *     these are referred to as the environment. The environment includes any 
 *     factors that affect the spread of the disease but are not directly a part of 
 *     the agent or the host. For example, the temperature in a given location might 
 *     affect an agent’s ability to thrive, as might the quality of drinking water 
 *     or the accessibility of adequate medical facilities.
 * 
 *   Refer to Model of the Epidemiological Triangle:
 *   https://www.rivier.edu/academics/blog-posts/what-is-the-epidemiologic-triangle/
 */
class EpiModel implements Model, Cloneable {

  private int uidCounter;
  
  // Generic Pathogen Types
  private ArrayList<Pathogen> pathogenList;
  
  // Epidimiological Model Objects (Elements)
  private ArrayList<Environment> environmentList;
  private ArrayList<Host> hostList;
  private ArrayList<Agent> agentList;
  
  // The current time of the model (begins at t=0)
  private Time currentTime;
  
  // Amount of time to pass during each iteration of the model
  private Time timeStep;
  
  /**
   * Construct Epidemiological Model
   */
  public EpiModel() {
    
    // Time Dimension (Initialize to t = 0 seconds)
    this.currentTime = new Time(0);
    
    // Time Step (Initialize to 1 second per step)
    this.timeStep = new Time(1);
    
    this.uidCounter = -1;
    this.pathogenList = new ArrayList<Pathogen>();
    this.environmentList = new ArrayList<Environment>();
    this.hostList = new ArrayList<Host>();
    this.agentList = new ArrayList<Agent>();
  }
  
  /**
   * copies the object to a new in-memory object
   */
  public Object clone() throws CloneNotSupportedException {
    return this.clone();
  }
  
  /**
   * Iterates and returns the next Unique ID
   */
  public int nextUID() {
    uidCounter++;
    return uidCounter;
  }
  
  /**
   * Set the current time
   *
   * @param t time
   */ 
  public void setTime(Time t) {
    this.currentTime = t;
  }
  
  /**
   * Get the current time
   */ 
  public Time getTime() {
    return this.currentTime;
  }
  
  /**
   * Set the Time Step
   *
   * @param t time
   */ 
  public void setTimeStep(Time t) {
    this.timeStep = t;
  }
  
  /**
   * Get the current time
   */ 
  public Time getTimeStep() {
    return this.timeStep;
  }
  
  /** 
   * Add Host to Model
   *
   * @param h Host
   */
  public void addHost(Host h) {
    
    // Master Model Dictionary
    this.hostList.add(h);
    
    // Initialize Host Compartments with Pathogens
    for(Pathogen p : this.pathogenList) {
      h.setCompartment(p.getType(), Compartment.SUSCEPTIBLE);
    }
    
    // Location Sub-dictionary
    Environment e = h.getEnvironment();
    e.addHost(h);
  }
  
  /** 
   * Add Agent to Model
   *
   * @param a Agent
   */
  public void addAgent(Agent a) {
    
    // Master Model Dictionary
    this.agentList.add(a);
    
    // Location Sub-dictionary
    if(a.getLocation() instanceof Host) {
      Host h = (Host) a.getLocation();
      h.addAgent(a);
    } else if(a.getLocation() instanceof Environment) {
      Environment e = (Environment) a.getLocation();
      e.addAgent(a);
    }
  }
  
  /** 
   * Add Environment to Model
   *
   * @param e Environment
   */
  public void addEnvironment(Environment e) {
    
    // Master Model Dictionary
    this.environmentList.add(e);
  }
  
  /** 
   * Add Pathogen to Model
   *
   * @param p Pathogen
   */
  public void addPathogen(Pathogen p) {
    this.pathogenList.add(p);
    
    // Initialize Host Compartments with New Pathogen
    for(Host h : hostList) {
      h.setCompartment(p.getType(), Compartment.SUSCEPTIBLE);
    }
  }
  
  /** 
   * Remove Host from Model
   *
   * @param h Host
   */
  public void removeHost(Host h) {
    
    // Master Model Dictionary
    hostList.remove(h);
    
    // Location Sub-dictionary
    Environment e = h.getEnvironment();
    e.removeHost(h);
  }
  
  /** 
   * Remove Agent from Model
   *
   * @param a Agent
   */
  public void removeAgent(Agent a) {
    
    // Master Model Dictionary
    agentList.remove(a);
    
    // Location Sub-dictionary
    if(a.getLocation() instanceof Host) {
      Host h = (Host) a.getLocation();
      h.removeAgent(a);
    } else if(a.getLocation() instanceof Environment) {
      Environment e = (Environment) a.getLocation();
      e.removeAgent(a);
    }
  }
  
  /** 
   * Remove Environment from Model
   *
   * @param e Environment
   */
  public void removeEnvironment(Environment e) {
    
    // Master Model Dictionary
    environmentList.remove(e);
  }
  
  /** 
   * Remove Pathogen from Model
   *
   * @param p Pathogen
   */
  public void removePathogen(Pathogen p) {
    
    // Master Model Dictionary
    pathogenList.remove(p);
    
    // Remove Host Compartments containing Pathogen
    for(Host h : hostList) {
      h.getCompartment().remove(p);
    }
    
    // Remove Agents containing this Pathogen
    for(int i=this.agentList.size()-1; i>=0; i--) {
      Agent a = this.agentList.get(i);
      if(a.getPathogen() == p) {
        this.removeAgent(a);
      }
    }
  }
  
  /** 
   * Get Host Population
   */
  public ArrayList<Host> getHosts() {
    return hostList;
  }
  
  /** 
   * Get Infectious Agents
   */
  public ArrayList<Agent> getAgents() {
    return agentList;
  }
  
  /** 
   * Get the List of Model Environments
   */
  public ArrayList<Environment> getEnvironments() {
    return environmentList;
  }
  
  /** 
   * Get the List of Model Pathogens
   */
  public ArrayList<Pathogen> getPathogens() {
    return pathogenList;
  }
  
  /** 
   * Get Random Host from Model
   */
  public Host getRandomHost() {
    int random_index = (int) random(0, hostList.size());
    return hostList.get(random_index);
  }
  
  /** 
   * Get Random Agent from Model
   */
  public Agent getRandomAgent() {
    int random_index = (int) random(0, agentList.size());
    return agentList.get(random_index);
  }
  
  /** 
   * Get Random Environment from Model
   */
  public Environment getRandomEnvironment() {
    int random_index = (int) random(0, environmentList.size());
    return environmentList.get(random_index);
  }
  
  /** 
   * Get Random Pathogen from Model
   */
  public Pathogen getRandomPathogen() {
    int random_index = (int) random(0, pathogenList.size());
    return pathogenList.get(random_index);
  }
  
  /**
   * Make a duplicate of the specified Agent with new unique ID
   *
   * @param a Agent
   */
  public Agent copyAgent(Agent a) {
    Pathogen p = a.getPathogen();
    Time lifeSpan = p.getAgentLife();
    Agent copy = new Agent(p, lifeSpan);
    int new_uid = this.nextUID();
    copy.setUID(new_uid);
    copy.setCoordinate(a.getCoordinate());
    copy.setLocation(a.getLocation());
    return copy;
  }
  
  /**
   * Make a new default agent with unique ID and Pathogen
   *
   * @param p Pathogen
   */
  private Agent newAgent(Pathogen p) {
    Agent newAgent = new Agent();
    int new_uid = this.nextUID();
    newAgent.setUID(new_uid);
    newAgent.setPathogen(p);
    newAgent.setLifeSpan(p.getAgentLife());
    return newAgent;
  }
  
  /**
   * Infect a Host  with a pathogen-carrying Agent
   *
   * @param h Host
   * @param p Pathogen
   */
  public Agent infect(Host h, Pathogen p) {
    
    // Check If Agent Already Present
    for(Agent a : h.getAgents()) {
      if(a.getPathogen() == p) return null;
    }
    
    // Update Host's Compartment Status
    PathogenType pType = p.getType();
    if(h.getCompartment(pType) == Compartment.SUSCEPTIBLE) {
      h.setCompartment(pType, Compartment.INCUBATING);
    }
    return infect((Element) h, p);
  }
  
  /**
   * Infect an Environment with a pathogen-carrying Agent
   *
   * @param e Environment
   * @param p Pathogen
   * @return new infectious Agent or null if infection fails
   */
  public Agent infect(Environment e, Pathogen p) {
    
    // Check If Agent Already Present
    for(Agent a : e.getAgents()) {
      if(a.getPathogen() == p) return null;
    }
    
    return infect((Element) e, p);
  }
  
  /**
   * Infect an Element with a pathogen-carrying Agent
   *
   * @param e Element
   * @param p Pathogen
   */
  private Agent infect(Element e, Pathogen p) {
    Agent a = newAgent(p);
    a.setCoordinate(e.getCoordinate());
    a.setLocation(e);
    this.addAgent(a);
    return a;
  }
  
  
  /**
   * Updating the Object model moves time forward by one time step 
   * and implements relevent agent behaviors. 
   *
   * !!! This is currently overridden in CityModel.update() !!!
   */
  public void update() {
    this.currentTime = currentTime.add(this.timeStep);
  }
}
