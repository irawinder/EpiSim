/**
 * Generic attributes of an Infectious Pathogen that can infect Hosts and Environments
 */
public class Pathogen {
  
  // Name of Pathogen
  private String name;
  
  // The specific variety of this pathogen (e.g. COMMON_COLD)
  private PathogenType type;
  
  // Transmission Rate (probabily of transmission per contact between infected and susceptible)
  private Rate attackRate;
  
  // Agent life span (i.e. how long it can live outside of host)
  private Time agentLife;
  
  // Duration of Incubation (days)
  private TimeDistribution incubationDuration;
  
  // Duration of Infectiousness (days)
  private TimeDistribution infectiousDuration;
  
  // Mortality Rate with Treatment
  private Rate mortalityTreated;
  
  // Mortality Rate without Treatment
  private Rate mortalityUntreated;
  
  // Rate of expression for various Symptoms
  private HashMap<Symptom, Rate> symptomExpression;
  
  /**
   * Construct new Pathogen
   */
  public Pathogen() {
    init();
  }
  
  /** 
   * Initialize Values to Zero
   */
  public void init() {
    this.name = "";
    this.agentLife = new Time();
    this.attackRate = new Rate();
    this.incubationDuration = new TimeDistribution();
    this.infectiousDuration = new TimeDistribution();
    this.mortalityTreated = new Rate();
    this.mortalityUntreated = new Rate();
    this.symptomExpression = new HashMap<Symptom, Rate>();
    for(Symptom s : Symptom.values()) {
      this.symptomExpression.put(s, new Rate());
    }
  }
  
  /**
   * Set the Name of the Pathogen
   *
   * @param name
   */
  void setName(String name) {
    this.name = name;
  }
  
  /**
   * Get the Name of the Pathogen
   */
  String getName() {
    return this.name;
  }
  
  /**
   * Set Pathogen Type
   *
   * @param type Pathogen
   */
  public void setType(PathogenType type) {
    this.type = type;
  }
  
  /**
   * Get Pathogen Type
   */
  public PathogenType getType() {
    return this.type;
  }
  
  /**
   * Set the Attack Rate (probabily of transmission per contact between infected and susceptible)
   *
   * @param r rate
   */
  public void setAttackRate(Rate r) {
    this.attackRate = r;
  }
  
  /**
   * Get the Attack Rate (probabily of transmission per contact between infected and susceptible)
   */
  public Rate getAttackRate() {
    return this.attackRate;
  }
  
  /**
   * Set the agentLife of the Pathogen
   *
   * @param agentLife Time
   */
  void setAgentLife(Time agentLife) {
    this.agentLife = agentLife;
  }
  
  /**
   * Get the agentLife of the Pathogen
   */
  public Time getAgentLife() {
    return this.agentLife;
  }
  
  /** 
   * Set the probablity distribution for incubation duration
   *
   * @param mean days
   * @param standardDeviation days
   */
  public void setIncubationDistribution(Time mean, Time standardDeviation) {
    this.incubationDuration = new TimeDistribution(mean, standardDeviation);
  }
  
  /** 
   * Get the probablity distribution for incubation duration
   */
  public TimeDistribution getIncubationDistribution() {
    return this.incubationDuration;
  }
  
  /** 
   * Get a value for incubation duration [days]
   */
  public Time generateIncubationDuration() {
    Time value = this.incubationDuration.generateValue();
    value.setAmount(Math.max(0, value.getAmount())); // no negative values allowed
    return value;
  }
  
  /** 
   * Set the probablity distribution for infectious duration
   *
   * @param mean days
   * @param standardDeviation days
   */
  public void setInfectiousDistribution(Time mean, Time standardDeviation) {
    this.infectiousDuration = new TimeDistribution(mean, standardDeviation);
  }
  
  /** 
   * Get the probablity distribution for infectious duration
   */
  public TimeDistribution getInfectiousDistribution() {
    return this.infectiousDuration;
  }
  
  /** 
   * Get a value for infectious duration [days]
   */
  public Time generateInfectiousDuration() {
    Time value = this.infectiousDuration.generateValue();
    value.setAmount(Math.max(0, value.getAmount())); // no negative values allowed
    return value;
  }
  
  /** 
   * Set mortality rate for treated
   *
   * @param r rate
   */
  public void setMortalityTreated(Rate r) {
    this.mortalityTreated = r;
  }
  
  /** 
   * Get mortality rate for treated
   */
  public Rate getMortalityTreated() {
    return this.mortalityTreated;
  }
  
  /** 
   * Set mortality rate for untreated
   *
   * @param r rate
   */
  public void setMortalityUntreated(Rate r) {
    this.mortalityUntreated = r;
  }
  
  /** 
   * Get mortality rate for untreated
   *
   * @param d demographic
   */
  public Rate getMortalityUntreated() {
    return this.mortalityUntreated;
  }
  
  /** 
   * Set symptom expression rate
   *
   * @param s Symptom
   * @param r rate
   */
  public void setSymptomExpression(Symptom s, Rate r) {
    this.symptomExpression.put(s, r);
  }
  
  /** 
   * Get symptom expression rate
   *
   * @param s Symptom
   */
  public Rate getSymptomExpression(Symptom s) {
    return this.symptomExpression.get(s);
  }
  
  @Override
  public String toString() {
    String info = 
      this.getName() + "\n" +
      "Attack Rate: " + this.getAttackRate() + "\n" +
      "Incubation[days]: " + this.getIncubationDistribution() + "\n" +
      "Infectious[days]: " + this.getInfectiousDistribution() + "\n";
    info += "Mortality (Treated): " + this.mortalityTreated + "\n";
    info += " Mortality (Untreated): " + this.mortalityUntreated + "\n";
    for (Symptom s : Symptom.values()) {
      info += s + " Expression: " + getSymptomExpression(s) + "\n";
    }
    return info;
  }
}
