/**
 * A Host is a human element that may carry and/or transmit an Agent
 *
 *   Compartment:  
 *     The Host's compartment with respect to a Pathogen (e.g. Suceptible, Incubating, Infectious, Recovered, or Dead)
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
  
  // Resilience of host to Pathogens (1.0 == no impact; < 1 == less resilient; > 1 == more resilient)
  private Rate resilience;
  
  // Agents Carried by Host
  private ArrayList<Agent> agentList;
  
  // Host's current pathogen effects
  private HashMap<Pathogen, PathogenEffect> status;
  
  public Host() {
    super();
    this.environment = new Environment();
    this.agentList = new ArrayList<Agent>();
    this.status = new HashMap<Pathogen, PathogenEffect>();
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
   * Set Pathogenic Resilience for Demographic
   *
   * @param d Demographic
   * @ param r rate
   */
  public void setResilience(Rate r) {
    this.resilience = r;
  }
  
/**
   * Get Pathogenic Resilience for Demographic
   *
   * @param d Demographic
   */
  public Rate getResilience() {
    return this.resilience;
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
   * Set the Host's status for a Particular Pathogen
   *
   * @param p pathogen
   * @param status PathogenEffect
   */
  public void setStatus(Pathogen p, PathogenEffect status) {
    this.status.put(p, status);
  }
  
  /**
   * Get the Host's status for specified Pathogen
   *
   * @param type Pathogen
   */
  public PathogenEffect getStatus(Pathogen p) {
    if(this.status.containsKey(p)) {
      return this.status.get(p);
    } else {
      return null;
    }
  }
  
  /**
   * Get the Host's status map for all specified Pathogens
   */
  public HashMap<Pathogen, PathogenEffect> getStatusMap() {
    return this.status;
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
  
  // Update the effect status for all pathogens affecting the host
  public void update(Time current, boolean treated) {
    for(HashMap.Entry<Pathogen, PathogenEffect> entry : this.status.entrySet()) {
      if(entry.getValue().alive()) {
        entry.getValue().update(current, treated);
      }
    }
  }
  
  /**
   * Check if Host is Alive
   *
   * @return true if alive
   */
  public boolean alive() {
    for(HashMap.Entry<Pathogen, PathogenEffect> entry : this.status.entrySet()) {
      if(!entry.getValue().alive()) {
        return false;
      }
    }
    return true;
  }
  
  @Override
  public String toString() {
    return 
      "Host UID: " + getUID() 
      + "; Name: " + getName()
      ;
  }
}
