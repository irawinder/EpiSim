/**
 * A Host is a person element that may carry and/or transmit an Agent 
 *
 * Refer to Compartmental models in epidemiology (Susceptible, Infectious, Carrier, Recovered):
 * https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology
 * 
 * Clade X Model (Susceptible, Incubating, Infectious (Mild or sever), Convalescent, Hospitalized, Recovered, Dead):
 * http://www.centerforhealthsecurity.org/our-work/events/2018_clade_x_exercise/pdfs/Clade-X-model.pdf
 * 
 * GLEAMviz Models:
 * http://www.gleamviz.org/simulator/models/
 */
public class Host extends Element {

  // Age of Host
  private int age;
  
  // Demographic of Host
  private Demographic demographic;
  
  // Infectious Agent Status
  HashMap<AgentType, AgentStatus> agentStatus;
  
  // Agent's current location
  private Environment location;
  
  // Primary Location (e.g. home, dwelling, etc)
  private Environment primaryLocation;
  
  // Secondary Location (e.g. work, school, daycare)
  private Environment secondaryLocation;
  
  /**
   * Set the Host's age
   */
  public void setAge(int age) {
    if (age < 0) {
      println("Age out of Range");
    } else {
      this.age = age;
      setDemographic();
    }
  }
  
  /**
   * Get the Host's age
   */
  public int getAge() {
    return this.age;
  }
  
  /**
   * Set the Host's Demographic
   */
  private void setDemographic() {
    if (age < ADULT_AGE) {
      this.demographic = Demographic.CHILD;
    } else if (age < SENIOR_AGE) {
      this.demographic = Demographic.ADULT;
    } else {
      this.demographic = Demographic.SENIOR;
    }
  }
  
  /**
   * Get the Host's Demographic
   */
  public Demographic getDemographic() {
    return this.demographic;
  }
  
  /**
   * Set the Host's Agent Status for a Particular Agent Type
   */
  public void setStatus(AgentType type, AgentStatus status) {
    agentStatus.put(type, status);
  }
  
  /**
   * Get the Host's Statuses for All AgentTypes
   */
  public HashMap<AgentType, AgentStatus> getStatus() {
    return agentStatus;
  }
  
  /**
   * Get the Host's Status for specified AgentType
   */
  public AgentStatus getStatus(AgentType type) {
    if(agentStatus.containsKey(type)) {
      return agentStatus.get(type);
    } else {
      return null;
    }
  }
  
  /**
   * Set the Host's current location
   */
  public void setLocation(Environment location) {
    this.location = location;
  }
  
  /**
   * Get the Host's current location
   */
  public Environment getLocation() {
    return location;
  }
  
  /**
   * Set the Host's primary location (e.g. home, dwelling, etc)
   */
  public void setPrimaryLocation(Environment primaryLocation) {
    this.primaryLocation = primaryLocation;
  }
  
  /**
   * Get the Host's primary location (e.g. home, dwelling, etc)
   */
  public Environment getPrimaryLocation() {
    return primaryLocation;
  }
  
  /**
   * Set the Host's secondary location (e.g. work, school, daycare)
   */
  public void setSecondaryLocation(Environment secondaryLocation) {
    this.secondaryLocation = secondaryLocation;
  }
  
  /**
   * Get the Host's secondary location (e.g. work, school, daycare)
   */
  public Environment getSecondaryLocation() {
    return secondaryLocation;
  }
  
  @Override
  public String toString() {
    return 
      "Host UID: " + getUID() 
      + "; Name: " + getName()
      + "; Age: " + getAge()
      ;
  }
}
