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
  
  private Boolean contactTracingApp;
  
  private Boolean exposedToInfected;
  
  // Primary Environment (e.g. home, dwelling, etc)
  private Place primaryPlace;
  
  // Secondary Environment (e.g. work, school, daycare)
  private Place secondaryPlace;
  
  // Closest Hospital
  private Place closestHospital;
  
  /**
   * Construct new Person
   */
  public Person() {
    super();
    this.age = 18;
    this.setDemographic(18, 65);
    this.contactTracingApp = false; //by default
    this.exposedToInfected = false; //by default
    this.primaryPlace = new Place();
    this.secondaryPlace = new Place();
    this.closestHospital = new Place();
  }
  
  /**
   * Set the Person's age
   *
   * @param age
   */
  public void setAge(int age) {
    if (age < 0) {
      println("Age out of Range");
      this.age = 0;
    } else {
      this.age = age;
    }
  }
  
  /**
   * Get the Person's age
   */
  public int getAge() {
    return this.age;
  }
  
  public void setContactTracingApp(Boolean contactTracingApp) {
    this.contactTracingApp = contactTracingApp;
  }
  
  public Boolean hasContactTracingApp() {
    return this.contactTracingApp;
  }
  
  /**
   * Set the Person's Demographic
   *
   * @param d Demographic
   */
  private void setDemographic(Demographic d) {
    this.demographic = d;
  }
  
  /**
   * Set the Person's Demographic using Age Value
   */
  private void setDemographic(int adultAge, int seniorAge) {
    if (age < adultAge) {
      this.demographic = Demographic.CHILD;
    } else if (age < seniorAge) {
      this.demographic = Demographic.ADULT;
    } else {
      this.demographic = Demographic.SENIOR;
    }
  }
  
  /**
   * Get the Person's Demographic
   */
  public Demographic getDemographic() {
    return this.demographic;
  }
  
  /**
   * Get the Person's Current Place
   */
  public Place getPlace() {
    return (Place) this.getEnvironment();
  }
  
  /**
   * Set the Person's Current Place
   */
  public void setPlace(Place p) {
    this.setEnvironment((Environment) p);
  }
  
  /**
   * Set the Person's primary Place (e.g. home, dwelling, etc)
   *
   * @param primaryPlace Place
   */
  public void setPrimaryPlace(Place primaryPlace) {
    this.primaryPlace = primaryPlace;
  }
  
  /**
   * Get the Person's primary Place (e.g. home, dwelling, etc)
   */
  public Place getPrimaryPlace() {
    return primaryPlace;
  }
  
  /**
   * Set the Person's secondary Place (e.g. work, school, daycare)
   *
   * @param secondaryPlace Place
   */
  public void setSecondaryPlace(Place secondaryPlace) {
    this.secondaryPlace = secondaryPlace;
  }
  
  /**
   * Get the Person's secondary Place (e.g. work, school, daycare)
   */
  public Place getSecondaryPlace() {
    return secondaryPlace;
  }
  
  /**
   * Set the Person's closest Hospital
   *
   * @param hospital Place
   */
  public void setClosestHospital(Place hospital) {
    this.closestHospital = hospital;
  }
  
  /**
   * Get the Person's closest Hospital
   */
  public Place getClosestHospital() {
    return this.closestHospital;
  }
  
  /**
   * Move Person to Primary Place
   */
  public void moveToPrimary() {
    Place destination = this.getPrimaryPlace();
    this.move(destination);
  }
  
  public void notifyExposure() {
    this.exposedToInfected = true;
  }
  
  public Boolean hasBeenExposedToInfected() {
    return this.exposedToInfected;
  }
  
  /**
   * Move Person to Secondary Place
   */
  public void moveToSecondary() {
    Place destination = this.getSecondaryPlace();
    this.move(destination);
  }
  
  /**
   * Move Person to Closest Hospital
   */
  public void moveToHospital() {
    Place destination = this.getClosestHospital();
    this.move(destination);
  }
  
  /**
   * Move person to a specified destination
   *
   * @param destination Place
   */
  public void moveTo(Place destination) {
    // Cast to Environment to call inhereted "public void move(Environment e)" method
    this.move((Environment)destination);
  }
  
  /**
   * Check if Person is Hospitalized
   *
   * @return true if hospitalized
   */
  public boolean hospitalized() {
    for(HashMap.Entry<Pathogen, PathogenEffect> entry : this.getStatusMap().entrySet()) {
      if(!entry.getValue().hospitalized()) {
        return true;
      }
    }
    return false;
  }
  
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
