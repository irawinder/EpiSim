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
    super();
    this.age = ADULT_AGE;
    this.setDemographic();
    this.primaryPlace = new Place();
    this.secondaryPlace = new Place();
  }
  
  /**
   * Set the Person's age
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
   * Get the Person's age
   */
  public int getAge() {
    return this.age;
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
   * Get the Person's Demographic
   */
  public Demographic getDemographic() {
    return this.demographic;
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
   * Move Person to Primary Place
   */
  public void moveToPrimary() {
    Place destination = this.getPrimaryPlace();
    this.move(destination);
  }
  
  /**
   * Move Person to Secondary Place
   */
  public void moveToSecondary() {
    Place destination = this.getSecondaryPlace();
    this.move(destination);
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
