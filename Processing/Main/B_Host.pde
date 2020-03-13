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
  
  // Infectious Agent Status
  private HashMap<PathogenType, Compartment> statusMap;
  
  // Host's current Environment
  private Environment environment;
  
  public Host() {
    statusMap = new HashMap<PathogenType, Compartment>();
  }
  
  /**
   * Set the Host's Agent Status for a Particular Agent Type
   */
  public void setCompartment(PathogenType pType, Compartment status) {
    statusMap.put(pType, status);
  }
  
  /**
   * Get the Host's Statuses for All Pathogens
   */
  public HashMap<PathogenType, Compartment> getCompartment() {
    return statusMap;
  }
  
  /**
   * Get the Host's Status for specified Pathogen
   *
   * @param type Pathogen
   */
  public Compartment getCompartment(PathogenType pType) {
    if(statusMap.containsKey(pType)) {
      return statusMap.get(pType);
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
    for(Element el : this.getElements()) {
      if(el instanceof Agent) {
        el.setCoordinate(this.getCoordinate());
      }
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
      ;
  }
}

/**
 * A Person is a human Host Element that may carry and/or transmit an Agent
 *
 *   Demographic:
 *     Host's attributes that affect its suceptibility to a Pathogen (e.g. Child, Adult, Senior)
 *
 *   Primary Place:
 *     The host's primary residence when they are not working or shopping. This often
 *     represents a dwelling with multiple household memebers
 *
 *   Secondary Place:  
 *     The Place where the host usually spends their time during the day. This is
 *     often at an office or employer for adults, or at school for children.
 *
 *   Tertiary Place: 
 *     All other Places that a host may spend their time throughout the day. This
 *     includes shopping, walking, commuting, dining, etc.
 */
public class Person extends Host {
  
  // Age of Person
  private int age;
  
  // Demographic of Person
  private Demographic demographic;
  
  // Primary Environment (e.g. home, dwelling, etc)
  private Place primaryPlace;
  
  // Secondary Environment (e.g. work, school, daycare)
  private Place secondaryPlace;
  
  /**
   * Construct new Person
   */
  public Person() {
  }
  
  /**
   * Set the Host's age
   *
   * @param age
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
   *
   * @param d Demographic
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
   * Set the Host's primary Place (e.g. home, dwelling, etc)
   *
   * @param primaryPlace Place
   */
  public void setPrimaryPlace(Place primaryPlace) {
    this.primaryPlace = primaryPlace;
  }
  
  /**
   * Get the Host's primary Place (e.g. home, dwelling, etc)
   */
  public Place getPrimaryPlace() {
    return primaryPlace;
  }
  
  /**
   * Set the Host's secondary Place (e.g. work, school, daycare)
   *
   * @param secondaryPlace Place
   */
  public void setSecondaryPlace(Place secondaryPlace) {
    this.secondaryPlace = secondaryPlace;
  }
  
  /**
   * Get the Host's secondary Place (e.g. work, school, daycare)
   */
  public Place getSecondaryPlace() {
    return secondaryPlace;
  }
  
  /**
   * Move Host to Primary Place
   */
  public void moveToPrimary() {
    Place destination = this.getPrimaryPlace();
    this.move(destination);
  }
  
  /**
   * Move Host to Secondary Place
   */
  public void moveToSecondary() {
    Place destination = this.getSecondaryPlace();
    this.move(destination);
  }
  
  ///**
  // * Update the Compartment value for the Host
  // */
  //public void updateCompartment() {
  //  for(switch(Compartment) {
  //    case SUCEPTIBLE:
  //      // check for exposure
  //      break;
  //    case SUCEPTIBLE:
  //      // check for exposure
  //      break;
  //}
  
  @Override
  public String toString() {
    return 
      "Person UID: " + getUID() 
      + "; Name: " + getName()
      + "; Age: " + getAge()
      + "; Demographic: " + getDemographic()
      ;
  }
}
