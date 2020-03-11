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
 *
 *   Demographic:
 *     Host's attributes that affect its suceptibility to a Pathogen (e.g. Child, Adult, Senior)
 *
 *   Compartment:  
 *     The Host's status with respect to a Pathogen (e.g. Suceptible, Exposed, Infectious, Recovered, or Dead)
 *
 *   Primary Environment:
 *     The host's primary residence when they are not working or shopping. This often
 *     represents a dwelling with multiple household memebers
 *
 *   Secondary Environment:  
 *     The environment where the host usually spends their time during the day. This is
 *     often at an office or employer for adults, or at school for children.
 *
 *   Tertiary Environment: 
 *     All other environments that a host may spend their time throughout the day. This
 *     includes shopping, walking, commuting, dining, etc.
 */
public class Host extends Element {

  // Age of Host
  private int age;
  
  // Demographic of Host
  private Demographic demographic;
  
  // Infectious Agent Status
  HashMap<Pathogen, Compartment> statusMap;
  
  // Agent's current Environment
  private Environment environment;
  
  // Primary Environment (e.g. home, dwelling, etc)
  private Environment primaryEnvironment;
  
  // Secondary Environment (e.g. work, school, daycare)
  private Environment secondaryEnvironment;
  
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
  private void setDemographic(Demographic d) {
    this.demographic = d;
  }
  
  /**
   * Set the Host's Demographic using Age Value
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
  public void setCompartment(Pathogen type, Compartment status) {
    statusMap.put(type, status);
  }
  
  /**
   * Get the Host's Statuses for All Pathogens
   */
  public HashMap<Pathogen, Compartment> getCompartment() {
    return statusMap;
  }
  
  /**
   * Get the Host's Status for specified Pathogen
   */
  public Compartment getCompartment(Pathogen type) {
    if(statusMap.containsKey(type)) {
      return statusMap.get(type);
    } else {
      return null;
    }
  }
  
  /**
   * Set the Host's current environment
   */
  public void setEnvironment(Environment environment) {
    this.environment = environment;
    int jitter = (int)(0.35*Math.sqrt(this.environment.getArea()));
    this.setCoordinate(environment.getCoordinate().jitter(jitter));
  }
  
  /**
   * Get the Host's current environment
   */
  public Environment getEnvironment() {
    return environment;
  }
  
  /**
   * Set the Host's primary environment (e.g. home, dwelling, etc)
   */
  public void setPrimaryEnvironment(Environment primaryEnvironment) {
    this.primaryEnvironment = primaryEnvironment;
  }
  
  /**
   * Get the Host's primary environment (e.g. home, dwelling, etc)
   */
  public Environment getPrimaryEnvironment() {
    return primaryEnvironment;
  }
  
  /**
   * Set the Host's secondary environment (e.g. work, school, daycare)
   */
  public void setSecondaryEnvironment(Environment secondaryEnvironment) {
    this.secondaryEnvironment = secondaryEnvironment;
  }
  
  /**
   * Get the Host's secondary environment (e.g. work, school, daycare)
   */
  public Environment getSecondaryEnvironment() {
    return secondaryEnvironment;
  }
  
  /**
   * Move Host to Primary Environment
   */
  public void moveToPrimary() {
    Environment destination = this.getPrimaryEnvironment();
    this.move(destination);
  }
  
  /**
   * Move Host to Secondary Environment
   */
  public void moveToSecondary() {
    Environment destination = this.getSecondaryEnvironment();
    this.move(destination);
  }
  
  /**
   * Move Host to another Environment
   *
   * @param destination
   */
  public void move(Environment destination) {
    Environment origin = environment;
    if(origin != destination) {
      origin.removeElement(this);
      destination.addElement(this);
      this.setEnvironment(destination);
    } else {
      println(this.getName() + " is already at this Environment");
    }
  }
  
  @Override
  public String toString() {
    return 
      "Host UID: " + getUID() 
      + "; Name: " + getName()
      + "; Age: " + getAge()
      + "; Demographic: " + getDemographic()
      ;
  }
}
