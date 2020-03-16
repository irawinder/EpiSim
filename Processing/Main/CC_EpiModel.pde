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

  // The current time of the model (begins at t=0)
  private Time currentTime;
  
  // Amount of time to pass during each iteration of the model
  private Time timeStep;
  
  // Counter that preserves next Unique ID value
  private int uidCounter;
  
  // Generic Pathogen Types
  private ArrayList<Pathogen> pathogenList;
  
  // Epidimiological Model Objects (Elements)
  private ArrayList<Environment> environmentList;
  private ArrayList<Host> hostList;
  private ArrayList<Agent> agentList;
  
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
  protected int nextUID() {
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
    if(this.hostList.contains(h)) {
      println(h + " already exists.");
    } else {
      this.hostList.add(h);
    }
    
    // Initialize Host With pre-determined Pathogen Effect
    for(Pathogen p : this.pathogenList) {
      PathogenEffect pE = new PathogenEffect();
      pE.preDetermine(p, h.getResilience());
      h.setStatus(p, pE);
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
    if(this.agentList.contains(a)) {
      println(a + " already exists.");
    } else {
      this.agentList.add(a);
    }
    
    // Vessel Sub-dictionary
    if(a.getVessel() instanceof Host) {
      Host h = (Host) a.getVessel();
      h.addAgent(a);
    } else if(a.getVessel() instanceof Environment) {
      Environment e = (Environment) a.getVessel();
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
    if(this.environmentList.contains(e)) {
      println(e + " already exists.");
    } else {
      this.environmentList.add(e);
    }
  }
  
  /** 
   * Add Pathogen to Model
   *
   * @param p Pathogen
   */
  public void addPathogen(Pathogen p) {
    
    // Master Model Dictionary
    if(this.pathogenList.contains(p)) {
      println(p + " already exists.");
    } else {
      this.pathogenList.add(p);
    }
    
    // Initialize Host Compartments with New Pathogen
    for(Host h : hostList) {
      PathogenEffect pE = new PathogenEffect();
      pE.preDetermine(p, h.getResilience());
      h.setStatus(p, pE);
    }
  }
  
  /** 
   * Remove Host from Model
   *
   * @param h Host
   */
  public void removeHost(Host h) {
    
    // Master Model Dictionary
    if(hostList.contains(h)) {
      hostList.remove(h);
    } else {
      println("No such Host exists");
    }
    
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
    if(agentList.contains(a)) {
      agentList.remove(a);
    } else {
      println("No such Agent exists");
    }
    
    // Vessel Sub-dictionary
    if(a.getVessel() instanceof Host) {
      Host h = (Host) a.getVessel();
      h.removeAgent(a);
    } else if(a.getVessel() instanceof Environment) {
      Environment e = (Environment) a.getVessel();
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
    if(environmentList.contains(e)) {
      environmentList.remove(e);
    } else {
      println("No such Environment exists");
    }
  }
  
  /** 
   * Remove Pathogen from Model
   *
   * @param p Pathogen
   */
  public void removePathogen(Pathogen p) {
    
    // Master Model Dictionary
    if(pathogenList.contains(p)) {
      pathogenList.remove(p);
    } else {
      println("No such PAthogen exists");
    }
    
    // Remove Host Compartments containing Pathogen
    for(Host h : hostList) {
      h.getStatusMap().remove(p);
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
   * Get the Map of Model Pathogens
   */
  public ArrayList<Pathogen> getPathogens() {
    return pathogenList;
  }
  
  /** 
   * Get Random Host from Model
   */
  public Host getRandomHost() {
    Random generator = new Random();
    int random_index = generator.nextInt(hostList.size());
    return hostList.get(random_index);
  }
  
  /** 
   * Get Random Agent from Model
   */
  public Agent getRandomAgent() {
    Random generator = new Random();
    int random_index = generator.nextInt(agentList.size());
    return agentList.get(random_index);
  }
  
  /** 
   * Get Random Environment from Model
   */
  public Environment getRandomEnvironment() {
    Random generator = new Random();
    int random_index = generator.nextInt(environmentList.size());
    return environmentList.get(random_index);
  }
  
  /** 
   * Get Random Pathogen from Model
   */
  public Pathogen getRandomPathogen() {
    Random generator = new Random();
    int random_index = generator.nextInt(pathogenList.size());
    return pathogenList.get(random_index);
  }
  
  /**
   * Make a duplicate of the specified Agent with new unique ID
   *
   * @param a Agent
   */
  protected Agent copyAgent(Agent a) {
    Pathogen p = a.getPathogen();
    Agent copy = makeAgent();
    copy.setPathogen(p);
    copy.setCoordinate(a.getCoordinate());
    copy.setVessel(a.getVessel());
    return copy;
  }
  
  /**
   * Make a new default agent with unique ID
   */
  protected Agent makeAgent() {
    Agent a = new Agent();
    int new_uid = this.nextUID();
    a.setUID(new_uid);
    return a;
  }
  
  /**
   * Make a new default host with unique ID
   */
  protected Host makeHost() {
    Host h = new Host();
    int new_uid = this.nextUID();
    h.setUID(new_uid);
    return h;
  }
  
  /**
   * Make a new default environment with unique ID
   */
  protected Environment makeEnvironment() {
    Environment e = new Environment();
    int new_uid = this.nextUID();
    e.setUID(new_uid);
    return e;
  }
  
  /**
   * Infect Host with a pathogen if not already exposed
   *
   * @param h Host
   * @param p Pathogen
   */
  protected void infectHost(Host h, Pathogen p) {
    PathogenEffect pE = h.getStatus(p);
    if(!pE.exposed()) {
      pE.expose(this.currentTime);
    }
  }
  
  /**
   * Infect an Element with a pathogen-carrying Agent
   *
   * @param e Element
   * @param p Pathogen
   */
  protected Agent putAgent(Element e, Pathogen p) {
    Agent a = makeAgent();
    a.setPathogen(p);
    a.setCoordinate(e.getCoordinate());
    a.setVessel(e);
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
