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
class EpiModel {

  private int uidCounter;
  
  // Generic Pathogen Types
  private ArrayList<Pathogen> pathogenList;
  
  // Epidimiological Model Objects (Elements)
  private ArrayList<Environment> environmentList;
  private ArrayList<Host> hostList;
  private ArrayList<Agent> agentList;
  
  public EpiModel() {
    uidCounter = -1;
    pathogenList = new ArrayList<Pathogen>();
    environmentList = new ArrayList<Environment>();
    hostList = new ArrayList<Host>();
    agentList = new ArrayList<Agent>();
  }
  
  /**
   * Iterates and returns the next Unique ID
   */
  public int nextUID() {
    uidCounter++;
    return uidCounter;
  }
  
  /** 
   * Add Host to Model
   *
   * @param h Host
   */
  public void add(Host h) {
    hostList.add(h);
  }
  
  /** 
   * Add Agent to Model
   *
   * @param a Agent
   */
  public void add(Agent a) {
    agentList.add(a);
  }
  
  /** 
   * Add Environment to Model
   *
   * @param e Environment
   */
  public void add(Environment e) {
    environmentList.add(e);
  }
  
  /** 
   * Add Pathogen to Model
   *
   * @param p Pathogen
   */
  public void add(Pathogen p) {
    pathogenList.add(p);
    
    // Initialize Host Compartment with New Pathogen
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
    hostList.remove(h);
  }
  
  /** 
   * Remove Agent from Model
   *
   * @param a Agent
   */
  public void remove(Agent a) {
    agentList.remove(a);
  }
  
  /** 
   * Remove Environment from Model
   *
   * @param e Environment
   */
  public void remove(Environment e) {
    environmentList.remove(e);
  }
  
  /** 
   * Remove Pathogen from Model
   *
   * @param p Pathogen
   */
  public void remove(Pathogen p) {
    pathogenList.remove(p);
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
   * Infect a Host with an infectious agent
   *
   * @param h Host
   * @param a Agent
   */
  public void infect(Host h, Agent a) {
    
    //Update Agent Location to Host and Add to Model Dictionaries
    a.setCoordinate(h.getCoordinate());
    h.addElement(a);
    this.add(a);
    
    // Update Host's Compartment Status
    Pathogen p = a.getPathogen();
    PathogenType pType = p.getType();
    if(h.getCompartment(pType) == Compartment.SUSCEPTIBLE) {
      h.setCompartment(pType, Compartment.INFECTIOUS);
    }
  }
}

/*
 * Simple extentsion of EpiModel that allows initialization of basic configuration
 */
public class SimpleEpiModel extends EpiModel {
  
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
            l.addElement(person);
          }
        }
      }
    }
  }
  
  /**
   * Add Infectious Agents to Model at one or more patients "zero"
   *
   * @param pathogen
   * @param numHosts
   */
  public void patientZero(Pathogen pathogen, int numHosts) {
    this.add(pathogen);
    for(int i=0; i<numHosts; i++) {
      Agent initial = new Agent();
      int new_uid = this.nextUID();
      initial.setUID(new_uid);
      initial.setPathogen(pathogen);
      Host host = this.getRandomHost();
      if(host instanceof Person) {
        Person person = (Person) host;
        this.infect(person, initial);
      }
    }
  }
  
  /**
   * Get a random secondary Environment from within list of existing Environments
   *
   * @param p Person
   */
  public Place getRandomSecondaryPlace(Person p) {
    
    // Set secondary environment to be same as primary environment by default
    Place secondaryPlace = p.getPrimaryPlace();
    
    // Grab a random environment and check if it's a Secondary Typology
    int counter = 0;
    while(counter < 1000) { // Give up after 1000 tries
      Environment thisEnvironment = this.getRandomEnvironment();
      if(thisEnvironment instanceof Place) {
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
}
