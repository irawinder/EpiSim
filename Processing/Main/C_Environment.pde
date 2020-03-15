/** 
 * Environment is an element that a Host and/or Agent can Occupy
 */
public class Environment extends Element {
  
  // The 2D Size size of the environment
  private double size;
  
  // Agents Present in Environment
  private ArrayList<Agent> agentList;
  
  // Hosts Present in Environment
  private ArrayList<Host> hostList;
  
  /**
   * Construct new Environment
   */
  public Environment() {
    super();
    this.agentList = new ArrayList<Agent>();
    this.hostList = new ArrayList<Host>();
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
   * Add host to host
   *
   * @param h host
   */
  public void addHost(Host h) {
    if (this.hostList.contains(h)) {
      println("Host already exists");
    } else {
      this.hostList.add(h);
    }
  }
  
  /**
   * Remove a host
   *
   * @param h Host
   */
  public void removeHost(Host h) {
    if (this.hostList.contains(h)) {
      this.hostList.remove(h);
    } else {
      println("No such host exists");
    }
  }
  
  /**
   * Return a list of Hosts
   */
  public ArrayList<Host> getHosts() {
    return this.hostList;
  }
  
  /**
   * Set Environment Size
   *
   * @param size
   */
  public void setSize(double size) {
    this.size = size;
  }
  
  /**
   * Get Environment Size
   */
  public double getSize() {
    return this.size;
  }
  
  @Override
  public String toString() {
    String info = 
      "Environment UID: " + getUID()
      + "; Size: " + getSize()
      ;
    return info;
  }
}
