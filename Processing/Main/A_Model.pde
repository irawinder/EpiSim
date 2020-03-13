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
  public void add(Host h) {
    
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
  public void add(Agent a) {
    
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
  public void add(Environment e) {
    
    // Master Model Dictionary
    this.environmentList.add(e);
  }
  
  /** 
   * Add Pathogen to Model
   *
   * @param p Pathogen
   */
  public void add(Pathogen p) {
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
  public void remove(Host h) {
    
    // Master Model Dictionary
    hostList.remove(h);
    
    // Location Sub-dictionary
    Environment e = h.getEnvironment();
    e.getHosts().remove(h);
  }
  
  /** 
   * Remove Agent from Model
   *
   * @param a Agent
   */
  public void remove(Agent a) {
    
    // Master Model Dictionary
    agentList.remove(a);
    
    // Location Sub-dictionary
    if(a.getLocation() instanceof Host) {
      Host h = (Host) a.getLocation();
      h.getAgents().remove(a);
    } else if(a.getLocation() instanceof Environment) {
      Environment e = (Environment) a.getLocation();
      e.getAgents().remove(a);
    }
  }
  
  /** 
   * Remove Environment from Model
   *
   * @param e Environment
   */
  public void remove(Environment e) {
    
    // Master Model Dictionary
    environmentList.remove(e);
  }
  
  /** 
   * Remove Pathogen from Model
   *
   * @param p Pathogen
   */
  public void remove(Pathogen p) {
    
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
        this.remove(a);
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
   * Infect a Host  with an pathogen
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
   * Infect an Environment with an pathogen
   *
   * @param e Environment
   * @param p Pathogen
   * @return new infectious Agent or null if infection fails
   */
  public Agent infect(Environment e, Pathogen p) {
    for(Agent a : e.getAgents()) {
      if(a.getPathogen() == p) return null;
    }
    return infect((Element) e, p);
  }
  
  /**
   * Infect an Element with a pathogen
   *
   * @param e Element
   * @param p Pathogen
   */
  private Agent infect(Element e, Pathogen p) {
    Agent a = newAgent(p);
    a.setCoordinate(e.getCoordinate());
    a.setLocation(e);
    this.add(a);
    return a;
  }
  
  
  /**
   * Updating the Object model moves time forward by one time step 
   * and implements relevent agent behaviors. 
   *
   * !!! This is currently overridden in SimpleEpiModel.update() !!!
   */
  public void update() {
    this.currentTime = currentTime.add(this.timeStep);
  }
}

/*
 * Simple extentsion of EpiModel that allows initialization of basic configuration
 */
public class SimpleEpiModel extends EpiModel {
  
  // Person Schedule
  private Schedule phaseSequence;
  
  // Current Phase of Person
  private Phase currentPhase;
  
  /**
   * Set the Schedule for hosts
   * 
   * @param s Schedule
   */
  public void setSchedule(Schedule s) {
    this.phaseSequence = s;
    this.setPhase();
  }
  
  /**
   * Get the Schedule for hosts
   */
  public Schedule getSchedule() {
    return this.phaseSequence;
  }
  
  /**
   * Set the Host Phase
   * 
   * @param p Phase
   */
  public void setPhase(Phase p) {
    this.currentPhase = p;
  }
  
  /**
   * Set the Host Phase
   * 
   * @param t Time
   */
  public void setPhase() {
    if(this.phaseSequence != null) {
      Time currentTime = this.getTime();
      Schedule s = this.getSchedule();
      Phase currentPhase = s.getPhase(currentTime);
      this.setPhase(currentPhase);
    } else {
      println("Must initialize host schedule before setting Phase");
    }
  }
  
  /**
   * Get the Host Phase
   *
   * @return current phase
   */
  public Phase getPhase() {
    return this.currentPhase;
  }
  
  /**
   * Add randomly placed Environments to Model within a specified rectangle
   *
   * @param amount
   * @param name_prefix
   * @param type
   * @param minSize
   * @param maxSize
   * @param minX
   * @param maxY
   */
  public void randomPlaces(int amount, String name_prefix, LandUse type, int x1, int y1, int x2, int y2, int minSize, int maxSize) {
    for(int i=0; i<amount; i++) {
      Place l = new Place();
      int new_uid = this.nextUID();
      l.setUID(new_uid);
      l.setCoordinate(new Coordinate(random(x1, x2), random(y1, y2)));
      l.setName(name_prefix + " " + l.getUID());
      l.setUse(type);
      l.setSize(random(minSize, maxSize));
      this.add(l);
    }
  }
  
  /**
   * Adds hosts to model, initially located at their respective dwellings
   *
   * @param minAge
   * @param maxAge
   * @param minDwellingSize smallest household size of a dwelling unit
   * @param maxDwellingSize largest household size of a dwelling unit
   */
  public void populate(int minAge, int maxAge, int minDwellingSize, int maxDwellingSize) {
    for(Environment e : this.getEnvironments()) {
      if(e instanceof Place) {
        Place l = (Place) e;
        if(l.getUse() == LandUse.DWELLING) {
          int numTenants = (int) random(minDwellingSize, maxDwellingSize+1);
          for (int i=0; i<numTenants; i++) {
            Person person = new Person();
            
            // Set Unique ID
            int new_uid = this.nextUID();
            person.setUID(new_uid);
            person.setName("House of " + l.getUID() + ", " + person.getUID());
            
            // Set Age and Demographic
            int age = (int) random(minAge, maxAge);
            person.setAge(age);
            
            // Set Primary Place
            person.setPrimaryPlace(l);
            
            // Set Secondary Place
            Place secondaryPlace = this.getRandomSecondaryPlace(person);
            person.setSecondaryPlace(secondaryPlace);
            
            // Set Current Environment and Location to Primary
            person.setEnvironment(person.getPrimaryPlace());
            
            // Add Person to List
            this.add(person);
          }
        }
      }
    }
  }
  
  /**
   * Add Infectious Agents to Model at one or more random patients "zero"
   *
   * @param pathogen
   * @param numHosts
   */
  public void patientZero(Pathogen pathogen, int numHosts) {
    this.add(pathogen);
    for(int i=0; i<numHosts; i++) {
      Host host = this.getRandomHost();
      if(host instanceof Person) {
        Person patientZero = (Person) host;
        this.infect(patientZero, pathogen);
      }
    }
  }
  
  /**
   * Get a random secondary Environment from within list of existing Environments
   *
   * @param p Person
   */
  public Place getRandomSecondaryPlace(Person p) {
    
    double MAX_DISTANCE = 150;
    
    // Set secondary environment to be same as primary environment by default
    Place secondaryPlace = p.getPrimaryPlace();
    
    // Grab a random environment and check if it's a Secondary Typology
    int counter = 0;
    while(counter < 1000) { // Give up after 1000 tries
      Environment thisEnvironment = this.getRandomEnvironment();
      
      // Calculate whether this environement is close enough to home
      Coordinate pCoord = p.getPrimaryPlace().getCoordinate();
      Coordinate tCoord = thisEnvironment.getCoordinate();
      boolean proximate = pCoord.distance(tCoord) < MAX_DISTANCE;
      
      if(thisEnvironment instanceof Place && proximate) {
        Place thisPlace = (Place) thisEnvironment;
        if(isSecondary(p, thisPlace)) {
          secondaryPlace = thisPlace;
          break;
        }
      }
      counter++;
    }
    return secondaryPlace;
  }
  
  /**
   * Determine if this environment qualifies as a Primary Environment for this Person
   *
   * @param p Person
   * @param l Place
   */
  public boolean isPrimary(Person p, Place l) {
    LandUse type = l.getUse();
    if(type == LandUse.DWELLING) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Determine if this environment qualifies as a Secondary Environment for this Host (i.e. the host spends the day at this Environment for work or school)
   *
   * @param p Person
   * @param l Place
   */
  public boolean isSecondary(Person p, Place l) {
    LandUse type = l.getUse();
    Demographic d = p.getDemographic();
    if(d == Demographic.CHILD) {
      if(type == LandUse.SCHOOL) {
        return true;
      } else {
        return false;
      }
    } else if (d == Demographic.ADULT) {
      if(type == LandUse.OFFICE || type == LandUse.RETAIL || type == LandUse.SCHOOL || type == LandUse.HOSPITAL) {
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
   * @param l Place
   */
  public boolean isTertiary(Person p, Place l) {
    LandUse type = l.getUse();
    if(type != LandUse.DWELLING && type != LandUse.OFFICE) {
      return true;
    } else {
      return false;
    }
  }
  
  /**
   * Force movement of all People to their secondary Place
   */
  public void allToSecondary() {
    for(Host h : this.getHosts()) {
      if (h instanceof Person) {
        Person p = (Person) h;
        p.moveToSecondary();
      }
    }
  }
  
  /**
   * Force movement of all People to their primary Place
   */
  public void allToPrimary() {
    for(Host h : this.getHosts()) {
      if (h instanceof Person) {
        Person p = (Person) h;
        p.moveToPrimary();
      }
    }
  }
  
  /**
   * Updating the Object model moves time forward by one time step 
   * and implements relevent agent behaviors.
   */
  @Override
  public void update() {
    
    // Set Time
    Time current = this.getTime();
    Time step = this.getTimeStep();
    this.setTime(current.add(step));
    Time currentTime = this.getTime();
    
    // Set Phase
    this.setPhase();
    Phase currentPhase = this.getPhase();
    
    // Move Hosts
    
    // Add New Agents
    int numAgents = this.getAgents().size();
    for(int i=0; i<numAgents; i++) {
      Agent a = this.getAgents().get(i);
      a.update(step);
      if(a.alive()) {
        Pathogen p = a.getPathogen();
        Element location = a.getLocation();
        
        // Agent Originates from Host
        if(location instanceof Host) {
          Host h = (Host) location;
          
          // Transmit pathogen from Host to Environment
          Environment e = h.getEnvironment();
          if(Math.random() < 0.25) this.infect(e, p);
          
          // Transmit pathogen from Host to Host
          for(Host h2 : e.getHosts()) {
            if(Math.random() < 0.025) this.infect(h2, p);
          }
          
        // Transmit from Environment to Host
        } else if (location instanceof Environment) {
          Environment e = (Environment) location;
          for(Host h : e.getHosts()) {
            if(Math.random() < 0.025) this.infect(h, p);
          }
        }
      }
    }
    
    // Update Compartment status
    
    // Clean "dead" agents
    for(int i=this.getAgents().size()-1; i>=0; i--) {
      Agent a = this.getAgents().get(i);
      if(!a.alive()) this.remove(a);
    }
  }
}
