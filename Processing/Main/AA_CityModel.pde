/*
 * Extentsion of EpiModel that allows initialization of city configuration
 *
 * Time Flow Model:
 *                
 * |     Phase 1     |         Phase 2          |  <- Phase Sequence
 *
 * |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 |  <- Time Steps
 *                ^
 *                |
 *                e.g. currentTime  = timeStep*3; 
 *                e.g. currentPhase = Phase 1
 */
public class CityModel extends EpiModel {
  
  // City Schedule
  private Schedule phaseSequence;
  
  // Current Phase of Person
  private Phase currentPhase;
  
  // Current Phase duration
  private Time phaseDuration;
  
  // Person-Place Category Association Map
  private BehaviorMap behavior;
  
  // Person Dictionary sorted by Demographic
  private HashMap<Demographic, ArrayList<Person>> person;
  
  // Place Dictionary sorted by Land Use
  private HashMap<LandUse, ArrayList<Place>> place;
  
  /**
   * Construct Simple Epidemiological Model
   */
  public CityModel() {
    super();
    this.phaseSequence = new Schedule();
    this.currentPhase = Phase.SLEEP;
    this.phaseDuration = new Time();
    this.behavior = new BehaviorMap();
    
    person = new HashMap<Demographic, ArrayList<Person>>();
    for(Demographic d : Demographic.values()) {
      person.put(d, new ArrayList<Person>());
    }
    
    place = new HashMap<LandUse, ArrayList<Place>>();
    for(LandUse use : LandUse.values()) {
      place.put(use, new ArrayList<Place>());
    }
  }
  
  /**
   * Set the Schedule for hosts
   * 
   * @param s Schedule
   */
  public void setSchedule(Schedule s) {
    this.phaseSequence = s;
    this.setPhase();
  }
  
  /**
   * Get the Schedule for hosts
   */
  public Schedule getSchedule() {
    return this.phaseSequence;
  }
  
  /**
   * Set the Phase
   * 
   * @param p Phase
   */
  public void setPhase(Phase p) {
    this.currentPhase = p;
  }
  
  /**
   * Set the Phase Duration
   * 
   * @param duration Time
   */
  public void setPhaseDuration(Time duration) {
    this.phaseDuration = duration;
  }
  
  /**
   * Set the behavior of population
   *
   * @param behavior BehaviorMap
   */
  public void setBehavior(BehaviorMap behavior) {
    this.behavior = behavior;
  }
  
  /**
   * Get the BehaviorMap
   *
   * @return behavior map
   */
  public BehaviorMap getBehavior() {
    return this.behavior;
  }
  
  /**
   * Get the Phase Duration
   *
   * @return current phase duration
   */
  public Time getPhaseDuration() {
    return this.phaseDuration;
  }
  
  /**
   * Set the Phase via existing schedule and current time
   */
  public void setPhase() {
    if(this.phaseSequence != null) {
      Time currentTime = this.getTime();
      Schedule s = this.getSchedule();
      Phase currentPhase = s.getPhase(currentTime);
      Time phaseDuration = s.getInterval(currentTime).getDuration();
      this.setPhase(currentPhase);
      this.setPhaseDuration(phaseDuration);
    } else {
      println("Must initialize host schedule before setting Phase");
    }
  }
  
  /**
   * Get the Phase
   *
   * @return current phase
   */
  public Phase getPhase() {
    return this.currentPhase;
  }
  
  /**
   * Make a new default person with unique ID
   */
  public Person makePerson() {
    Person p = new Person();
    int new_uid = this.nextUID();
    p.setUID(new_uid);
    return p;
  }
  
  /**
   * Make a new default environment with unique ID
   */
  public Place makePlace() {
    Place p = new Place();
    int new_uid = this.nextUID();
    p.setUID(new_uid);
    return p;
  }
  
  /**
   * Add Person to City Model
   *
   * @param p person
   */
  public void addPerson(Person p) {
    
    // Add To Person Dictionary sorted by Demographic
    Demographic d = p.getDemographic();
    ArrayList<Person> list = this.person.get(d);
    if(list.contains(p)) {
      println(p + " already exists.");
    } else {
      list.add(p);
    }
    
    // Add place element to EpiModel extension
    this.addHost(p);
  }
  
  /**
   * Remove Person from City Model
   *
   * @param p person
   */
  public void removePerson(Person p) {
    
    // Remove from Person Dictionary sorted by Demographic
    Demographic d = p.getDemographic();
    ArrayList<Person> list = this.person.get(d);
    if(list.contains(p)) {
      list.remove(p);
    } else {
      println("No such Person exists.");
    }
    
    // Remove person element from EpiModel extension
    this.removeHost(p);
  }
  
  /**
   * Add Place to City Model
   *
   * @param l place
   */
  public void addPlace(Place l) {
    
    // Add to Place Dictionary sorted by Land Use
    LandUse use = l.getUse();
    ArrayList<Place> list = this.place.get(use);
    if(list.contains(l)) {
      println(l + " already exists.");
    } else {
      list.add(l);
    }
    
    // Add to BehaviorMap
    this.behavior.addPlace(l);
    
    // Add place element to EpiModel extension
    this.addEnvironment(l);
  }
  
  /**
   * Remove Place from City Model
   *
   * @param l place
   */
  public void removePlace(Place l) {
    
    // Remove from Place Dictionary sorted by Land Use
    LandUse use = l.getUse();
    ArrayList<Place> list = this.place.get(use);
    if(list.contains(l)) {
      list.remove(l);
    } else {
      println("No such Place exists.");
    }
    
    // Remove place element from EpiModel extension
    this.removeEnvironment(l);
  }
  
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
      Place l = this.makePlace();
      l.setName(name_prefix + " " + l.getUID());
      l.setCoordinate(new Coordinate(random(x1, x2), random(y1, y2)));
      l.setUse(type);
      l.setSize(random(minSize, maxSize));
      
      // Add Place to EpiModel extension
      this.addPlace(l);
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
    for(Place l : this.place.get(LandUse.DWELLING)) {
      int numTenants = (int) random(minDwellingSize, maxDwellingSize+1);
      for (int i=0; i<numTenants; i++) {
        
        // Create New Person using makePerson() (ensures proper UID instantiation)
        Person person = this.makePerson();
        person.setName("House of " + l.getUID() + ", " + person.getUID());
        
        // Set Age and Demographic
        int age = (int) random(minAge, maxAge);
        person.setAge(age);
        
        // Set Current Environment
        person.setEnvironment(l);
        
        // Set Primary Place
        person.setPrimaryPlace(l);
        
        // Set Secondary Place
        Place secondaryPlace = this.behavior.getRandomPlace(person, PlaceCategory.SECONDARY);
        person.setSecondaryPlace(secondaryPlace);
        
        // Add Person to EpiModel extension
        this.addPerson(person);
      }
    }
  }
  
  /**
   * Add Infectious Agents to Model at one or more random patients "zero"
   *
   * @param pathogen
   * @param numHosts
   */
  public void patientZero(Pathogen pathogen, int numHosts) {
    
    //Adds new pathogen to model if first instance
    if(!this.getPathogens().contains(pathogen)) {
      this.addPathogen(pathogen);
    }
    
    for(int i=0; i<numHosts; i++) {
      ArrayList<Person> options = this.person.get(Demographic.ADULT);
      int randomIndex = (int) (Math.random() * (options.size() - 1));
      Person patientZero = options.get(randomIndex);
      this.infect(patientZero, pathogen);
    }
  }
  
  /**
   * Force movement of all People to their secondary Place
   */
  public void allToSecondary() {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        p.moveToSecondary();
      }
    }
  }
  
  /**
   * Force movement of all People to their primary Place
   */
  public void allToPrimary() {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        p.moveToPrimary();
      }
    }
  }
  
  /**
   * Update Person Movements according to current phase, phase duration, and timestep
   *
   * @param phase
   * @param phaseDuration
   * @param timeStep
   */
  public void movePersons(Phase phase, Time phaseDuration, Time timeStep) {
    for(Demographic d : Demographic.values()) {
      for(Person p : this.person.get(d)) {
        
        // Calculate probability of agent movement during transitions
        Time phaseTimePerStepTime = timeStep.divide(phaseDuration); // Uses Time.divide() for Unit Checking
        Rate flowRate = new Rate(phaseTimePerStepTime.getAmount()); // [unitless phase time per step time]
        
        // TO DO
        switch(phase) {
          case SLEEP:
            p.moveToPrimary();
            break;
          case HOME:
            p.moveToPrimary();
            break;
          case GO_WORK:
            p.moveToSecondary();
            break;
          case WORK:
            p.moveToSecondary();
            break;
          case WORK_LUNCH:
            p.moveToSecondary();
            break;
          case LEISURE:
            p.moveToPrimary();
            break;
          case GO_HOME:
            p.moveToPrimary();
            break;
        }
      }
    }
  }
  
  /**
   * Updating the Object model moves time forward by one time step 
   * and implements relevent agent behaviors.
   */
  @Override
  public void update() {
    
    // Set Time
    Time current = this.getTime();
    Time step = this.getTimeStep();
    this.setTime(current.add(step));
    
    // Set Phase
    this.setPhase();
    Phase currentPhase = this.getPhase();
    Time phaseDuration = this.getPhaseDuration();
    
    // Move Hosts
    this.movePersons(currentPhase, phaseDuration, step);
    
    // Add New Agents
    int numAgents = this.getAgents().size();
    for(int i=0; i<numAgents; i++) {
      Agent a = this.getAgents().get(i);
      a.update(step);
      if(a.alive()) {
        Pathogen p = a.getPathogen();
        Element vessel = a.getVessel();
        
        // Agent Originates from Host
        if(vessel instanceof Host) {
          Host h = (Host) vessel;
          
          // Transmit pathogen from Host to Environment
          Environment e = h.getEnvironment();
          if(Math.random() < 0.25) this.infect(e, p);
          
          // Transmit pathogen from Host to Host
          for(Host h2 : e.getHosts()) {
            if(Math.random() < 0.025) this.infect(h2, p);
          }
          
        // Transmit from Environment to Host
        } else if (vessel instanceof Environment) {
          Environment e = (Environment) vessel;
          for(Host h : e.getHosts()) {
            if(Math.random() < 0.025) this.infect(h, p);
          }
        }
      }
    }
    
    // Update Compartment status
    
    // Clean "dead" agents
    for(int i=this.getAgents().size()-1; i>=0; i--) {
      Agent a = this.getAgents().get(i);
      if(!a.alive()) this.removeAgent(a);
    }
  }
}
