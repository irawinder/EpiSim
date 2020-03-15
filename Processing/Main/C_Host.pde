/**
 * A Host is a human element that may carry and/or transmit an Agent
 *
 *   Compartment:  
 *     The Host's status with respect to a Pathogen (e.g. Suceptible, Incubating, Infectious, Recovered, or Dead)
 *
 *     Compartmental models in epidemiology (Susceptible, Infectious, Carrier, Recovered):
 *       https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology
 *     Clade X Model (Susceptible, Incubating, Infectious (Mild or sever), Convalescent, Hospitalized, Recovered, Dead):
 *       http://www.centerforhealthsecurity.org/our-work/events/2018_clade_x_exercise/pdfs/Clade-X-model.pdf
 *     GLEAMviz Models:
 *       http://www.gleamviz.org/simulator/models/
 */
public class Host extends Element {
  
  // Host's current environment
  private Environment environment;
  
  // Agents Carried by Host
  private ArrayList<Agent> agentList;
  
  // Host's current compartment status
  private HashMap<Pathogen, Compartment> statusMap;
  
  //// Whether host has already been exposed to Pathogen
  //private HashMap<PathogenType, Boolean> exposed;
  
  public Host() {
    super();
    this.agentList = new ArrayList<Agent>();
    this.statusMap = new HashMap<Pathogen, Compartment>();
  }
  
  /**
   * Add agent to host
   *
   * @param a Agent
   */
  public void addAgent(Agent a) {
    this.agentList.add(a);
  }
  
  /**
   * Remove an agent
   *
   * @param a Agent
   */
  public void removeAgent(Agent a) {
    if (this.agentList.contains(a)) {
      this.agentList.remove(a);
    } else {
      println("No such agent exists");
    }
  }
  
  /**
   * Return a list of Agents
   */
  public ArrayList<Agent> getAgents() {
    return this.agentList;
  }
  
  /**
   * Set the Host's compartment status for a Particular Pathogen
   */
  public void setCompartment(Pathogen p, Compartment status) {
    statusMap.put(p, status);
  }
  
  /**
   * Get the Host's Statuses for All Pathogens
   */
  public HashMap<Pathogen, Compartment> getCompartments() {
    return statusMap;
  }
  
  /**
   * Get the Host's Status for specified Pathogen
   *
   * @param type Pathogen
   */
  public Compartment getCompartment(Pathogen p) {
    if(statusMap.containsKey(p)) {
      return statusMap.get(p);
    } else {
      return null;
    }
  }
  
  /**
   * Set the Host's current environment
   *
   * @param environment
   */
  public void setEnvironment(Environment environment) {
    this.environment = environment;
    int jitter = (int)(0.35*Math.sqrt(this.environment.getSize()));
    this.setCoordinate(environment.getCoordinate().jitter(jitter));
    
    // Move all associated agents along with host
    for(Agent a : this.getAgents()) {
      a.setCoordinate(this.getCoordinate());
    }
  }
  
  /**
   * Get the Host's current environment
   */
  public Environment getEnvironment() {
    return environment;
  }
  
  /**
   * Move Host to another Environment
   *
   * @param destination Environment
   */
  public void move(Environment destination) {
    Environment origin = this.environment;
    if(origin != destination) {
      origin.removeHost(this);
      destination.addHost(this);
      this.setEnvironment(destination);
    }
  }
  
  @Override
  public String toString() {
    return 
      "Host UID: " + getUID() 
      + "; Name: " + getName()
      ;
  }
}
