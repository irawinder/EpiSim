/**
 * Epidemiological Model:
 *
 *   Agent:
 *     The agent is the microorganism that actually causes the disease in question. 
 *     An agent could be some form of bacteria, virus, fungus, or parasite.
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
 * Refer to Model of the Epidemiological Triangle:
 * https://www.rivier.edu/academics/blog-posts/what-is-the-epidemiologic-triangle/
 */
class EpiModel {
  
  // Epidimiological Model Objects
  private int uidCounter;
  private ArrayList<Environment> environmentList;
  private ArrayList<Host> hostList;
  private ArrayList<Agent> agentList;
  
  public EpiModel() {
    uidCounter = -1;
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
   */
  public void add(Host h) {
    hostList.add(h);
  }
  
  /** 
   * Add Agent to Model
   */
  public void add(Agent a) {
    agentList.add(a);
  }
  
  /** 
   * Add Environment to Model
   */
  public void add(Environment e) {
    environmentList.add(e);
  }
  
  /** 
   * Remove Host from Model
   */
  public void remove(Host h) {
    hostList.remove(h);
  }
  
  /** 
   * Remove Agent from Model
   */
  public void remove(Agent a) {
    agentList.remove(a);
  }
  
  /** 
   * Remove Environment from Model
   */
  public void remove(Environment e) {
    environmentList.remove(e);
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
   * Force movement of all Hosts to their secondary environment
   */
  public void allToSecondary() {
    for(Host h : this.getHosts()) {
      h.moveToSecondary();
    }
  }
  
  /**
   * Force movement of all Hosts to their primary environment
   */
  public void allToPrimary() {
    for(Host h : this.getHosts()) {
      h.moveToPrimary();
    }
  }
}

public class SimpleEpiModel extends EpiModel {
  
  /**
   * Add randomly placed Environments to Model within a specified rectangle
   *
   * @param amount
   * @param name_prefix
   * @param type
   * @param minArea
   * @param maxArea
   * @param minX
   * @param maxY
   */
  public void randomEnvironments(int amount, String name_prefix, EnvironmentType type, int x1, int y1, int x2, int y2, int minArea, int maxArea) {
    for(int i=0; i<amount; i++) {
      Environment e = new Environment();
      int new_uid = this.nextUID();
      e.setUID(new_uid);
      e.setCoordinate(new Coordinate(random(x1, x2), random(y1, y2)));
      e.setName(name_prefix + " " + e.getUID());
      e.setType(type);
      e.setArea(random(minArea, maxArea));
      this.add(e);
    }
  }
  
  /**
   * Add hosts to model, initially located at their respective dwellings
   *
   * @param minAge
   * @param maxAge
   * @param minDwellingSize smallest household size of a dwelling unit
   * @param maxDwellingSize largest household size of a dwelling unit
   */
  public void populate(int minAge, int maxAge, int minDwellingSize, int maxDwellingSize) {
    for(Environment e : this.getEnvironments()) {
      if(e.getType() == EnvironmentType.DWELLING) {
        int numTenants = (int) random(minDwellingSize, maxDwellingSize+1);
        for (int i=0; i<numTenants; i++) {
          Host person = new Host();
          
          // Set Unique ID
          int new_uid = this.nextUID();
          person.setUID(new_uid);
          person.setName("House of " + e.getUID() + ", " + person.getUID());
          
          // Set Age and Demographic
          int age = (int) random(minAge, maxAge);
          person.setAge(age);
          this.add(person);
          
          // Set Primary Environment
          person.setPrimaryEnvironment(e);
          
          // Set Secondary Environment
          Environment secondaryEnvironment = this.getRandomSecondaryEnvironment(person);
          person.setSecondaryEnvironment(secondaryEnvironment);
          
          // Set Current Environment and Location to Primary
          person.setEnvironment(person.getPrimaryEnvironment());
          
          e.addElement(person);
        }
      }
    }
  }
  
  /**
   * Get a random secondary Environment from within list of existing Environments
   *
   * @param h Host
   */
  public Environment getRandomSecondaryEnvironment(Host h) {
    
    // Set secondary environment to be same as primary environment by default
    Environment secondaryEnvironment = h.getPrimaryEnvironment();
    
    int numEnvironments = this.getEnvironments().size();
    int counter = 0;
    boolean found = false;
    while(found == false) {
      
      if(counter < 1000) {
        counter++;
      } else {
        break; // give up after 100 tries
      }
      
      // grab a random envirnment and check if it's a Secondary Typology
      int random_index = (int) random(0, numEnvironments);
      Environment thisEnvironment = this.getEnvironments().get(random_index);
      if(thisEnvironment.isSecondary(h)) {
        secondaryEnvironment = thisEnvironment;
        found = true;
      }
    }
    return secondaryEnvironment;
  }
}
