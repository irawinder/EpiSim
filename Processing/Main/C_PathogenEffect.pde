/**
 * Effects of an Infectious Pathogen on an instance of a Host
 */
public class PathogenEffect {
  
  // Current Host's Compartment Status
  private Compartment compartment;
  
  // Initial Time of Infection
  private boolean exposed;
  private Time initialTime;
  
  // Pre-destined: Duration of Incubation (days) (pre-destined)
  private Time incubationDuration;
  
  // Pre-destined: Duration of Infectiousness (days) (pre-destined)
  private Time infectiousDuration;
  
  // Pre-destined: Mortality Rates (pre-destined)
  private boolean fatalTreated;
  private boolean fatalUntreated;
  
  // Pre-destined: Rate of expression for various Symptoms
  private HashMap<Symptom, Boolean> symptomExpression;
  
  /**
   * Construct Empty Pathogen Effect
   */
  public PathogenEffect() {
    this.compartment = Compartment.SUSCEPTIBLE;
    this.exposed = false;
    this.initialTime = new Time();
    
    this.incubationDuration = new Time();
    this.infectiousDuration = new Time();
    this.fatalTreated = false;
    this.fatalUntreated = false;
    symptomExpression = new HashMap<Symptom, Boolean>();
  }
  
  /**
   * Expose pathogen at initial time T
   *
   * @param t Time
   */
  public void expose(Time t) {
    this.initialTime = t;
    this.exposed = true;
    this.compartment = Compartment.INCUBATING;
  }
  
  /**
   * Return true if Host is Exposed to this pathogen
   */
  public boolean exposed() {
    return this.exposed;
  }
  
  /**
   * Return true if Host is Infectious
   */
  public boolean infectious() {
    return compartment == Compartment.INFECTIOUS;
  }
  
  /**
   * Pre-determine pathogen effects for given pathogen and host resilience
   *
   * @param p Pathogen
   * @param resilience Rate
   */
  public void preDetermine(Pathogen p, Rate resilience) {
    
    // Host is initially unexposed and susceptible
    this.setCompartment(Compartment.SUSCEPTIBLE);
    
    // Determine gestation and infectiousness periods
    this.setIncubationDuration(p.generateIncubationDuration());
    this.setInfectiousDuration(p.generateIncubationDuration());
    
    // Determine Fatality
    double random = Math.random(); // random number 0.0 - 1.0
    boolean fatalTreated = p.getMortalityTreated().toDouble() / resilience.toDouble() > random;
    this.setFatalTreated(fatalTreated);
    boolean fatalUntreated = p.getMortalityUntreated().toDouble() / resilience.toDouble() > random;
    this.setFatalTreated(fatalUntreated);
    
    // Determine Non-Death Symptoms
    for(Symptom s : Symptom.values()) {
      boolean expressed = p.getSymptomExpression(s).toDouble() / resilience.toDouble() > Math.random();
      this.setSymptom(s, expressed);
    }
  }
  
  /**
   * Update pathogen Compartment
   *
   * @param t Time
   * @param t whether the host is receiving treatment
   */
  public void update(Time current, boolean treated) {
    
    if(exposed) {
      Time ellapsed = current.subtract(this.initialTime);
      Time incubating = this.incubationDuration;
      Time infectious = this.infectiousDuration;
      
      println(current, initialTime, ellapsed, incubating, infectious); 
      
      // Check if has become DEAD or RECOVERED
      if(compartment == Compartment.INFECTIOUS) {
        if(ellapsed.subtract(incubating.add(infectious)).getAmount() < 0) {
          if(fatalTreated && treated) {
            compartment = Compartment.DEAD;
          } else if(fatalUntreated && !treated) {
            compartment = Compartment.DEAD;
          } else {
            compartment = Compartment.RECOVERED;
          }
        } 
      }
      
      // Check if has become INFECTIOUS
      else if(compartment == Compartment.INCUBATING) {
        if(ellapsed.subtract(incubating).getAmount() < 0) {
          compartment = Compartment.INFECTIOUS;
        }
      }
    }
  }
  
  /**
   * Get List of Symptoms Currently Expressed
   */
  public ArrayList<Symptom> getCurrentSymptoms() {
    ArrayList symptoms = new ArrayList<Symptom>();
    if(this.compartment == Compartment.INFECTIOUS) {
      for (Symptom s : Symptom.values()) {
        if(symptomExpression.keySet().contains(s)) {
          if(symptomExpression.get(s) == true) {
            symptoms.add(s);
          }
        }
      }
    }
    return symptoms;
  }
  
  /**
   * Set Initial Time
   *
   * @param t Time
   */
  public void setInitialTime(Time t) {
    this.initialTime = t;
  }
  
  /**
   * Get Initial Time
   */
  public Time getInitialTime() {
    return this.initialTime;
  }
  
  /**
   * Set Compartment
   *
   * @param c Compartment
   */
  public void setCompartment(Compartment c) {
    this.compartment = c;
  }
  
  /**
   * Get Compartment
   */
  public Compartment getCompartment() {
    return this.compartment;
  }
  
  /**
   * Set Incubation Duration
   *
   * @param t Time
   */
  public void setIncubationDuration(Time t) {
    this.incubationDuration = t;
  }
  
  /**
   * Get Incubation Duration
   */
  public Time getIncubationDuration() {
    return this.incubationDuration;
  }
  
  /**
   * Set Infectious Duration
   *
   * @param t Time
   */
  public void setInfectiousDuration(Time t) {
    this.infectiousDuration = t;
  }
  
  /**
   * Get Infectious Duration
   */
  public Time getInfectiousDuration() {
    return this.infectiousDuration;
  } 
  
  /**
   * Set Fatality (Treated)
   *
   * @param fatal boolean
   */
  public void setFatalTreated(boolean fatal) {
    this.fatalTreated = fatal;
  }
  
  /**
   * Get Fatality (Treated)
   */
  public boolean getFatalTreated() {
    return this.fatalTreated;
  }
  
  /**
   * Set Fatality (Untreated)
   *
   * @param fatal boolean
   */
  public void setFatalUntreated(boolean fatal) {
    this.fatalUntreated = fatal;
  }
  
  /**
   * Get Fatality (Untreated)
   */
  public boolean getFatalUntreated() {
    return this.fatalUntreated;
  }
  
  /**
   * Set Symptom Status
   */
  public void setSymptom(Symptom s, boolean hasSymptom) {
    this.symptomExpression.put(s, hasSymptom);
  }
  
  /**
   * Set Symptom Status
   */
  public boolean hasSymptom(Symptom s) {
    return this.symptomExpression.get(s);
  }
  
  /**
   * Check if Alive
   *
   * @return true if alive
   */
  public boolean alive() {
    if(this.compartment == Compartment.DEAD) {
      return false;
    } else {
      return true;
    }
  }
}
