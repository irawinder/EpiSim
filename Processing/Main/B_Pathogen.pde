/**
 * Generic attributes of an Infectious Pathogen
 */
public class Pathogen {
  
  // Name of Pathogen
  private String name;
  
  // Agent life span (i.e. how long it can live outside of host)
  private Time agentLife;
  
  // The specific variety of this pathogen (e.g. COMMON_COLD)
  private PathogenType type;
  
  // Transmission Rate (probabily of transmission per contact between infected and susceptible)
  private Rate attackRate;
  
  // Duration of Incubation (days)
  private TimeDistribution incubationDuration;
  
  // Duration of Infectiousness (days)
  private TimeDistribution infectiousDuration;
  
  // Mortality Rate with Treatment
  private HashMap<Demographic, Rate> mortalityTreated;
  
  // Mortality Rate without Treatment
  private HashMap<Demographic, Rate> mortalityUntreated;
  
  // Rate of expression for various Symptoms
  private HashMap<Demographic, HashMap<Symptom, Rate>> symptomExpression;
  
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
    
    this.mortalityTreated = new HashMap<Demographic, Rate>();
    this.mortalityUntreated = new HashMap<Demographic, Rate>();
    this.symptomExpression = new HashMap<Demographic, HashMap<Symptom, Rate>>(); 
    
    for (Demographic d : Demographic.values()) {
      this.mortalityTreated.put(d, new Rate());
      this.mortalityUntreated.put(d, new Rate());
      HashMap<Symptom, Rate> expression = new HashMap<Symptom, Rate>();
      for (Symptom s : Symptom.values()) {
        expression.put(s, new Rate());
      }
      this.symptomExpression.put(d, expression);
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
  public Time getIncubationDuration() {
    Time value = this.incubationDuration.getValue();
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
  public Time getInfectiousDuration() {
    Time value = this.infectiousDuration.getValue();
    value.setAmount(Math.max(0, value.getAmount())); // no negative values allowed
    return value;
  }
  
  /** 
   * Set mortality rate for treated demographic
   *
   * @param d demographic
   * @param r rate
   */
  public void setMortalityTreated(Demographic d, Rate r) {
    this.mortalityTreated.put(d, r);
  }
  
  /** 
   * Get mortality rate for treated demographic
   *
   * @param d demographic
   */
  public Rate getMortalityTreated(Demographic d) {
    return this.mortalityTreated.get(d);
  }
  
  /** 
   * Set mortality rate for untreated demographic
   *
   * @param d demographic
   * @param r rate
   */
  public void setMortalityUntreated(Demographic d, Rate r) {
    this.mortalityUntreated.put(d, r);
  }
  
  /** 
   * Get mortality rate for untreated demographic
   *
   * @param d demographic
   */
  public Rate getMortalityUntreated(Demographic d) {
    return this.mortalityUntreated.get(d);
  }
  
  /** 
   * Set symptom expression rate for demographic
   *
   * @param d demographic
   * @param s Symptom
   * @param r rate
   */
  public void setSymptomExpression(Demographic d, Symptom s, Rate r) {
    this.symptomExpression.get(d).put(s, r);
  }
  
  /** 
   * Get symptom expression rate for demographic
   *
   * @param d demographic
   * @param s Symptom
   */
  public Rate getSymptomExpression(Demographic d, Symptom s) {
    return this.symptomExpression.get(d).get(s);
  }
  
  @Override
  public String toString() {
    String info = 
      this.getName() + "\n" +
      "Attack Rate: " + this.getAttackRate() + "\n" +
      "Incubation[days]: " + this.getIncubationDistribution() + "\n" +
      "Infectious[days]: " + this.getInfectiousDistribution() + "\n";
    for (Demographic d : Demographic.values()) {
      info += d + " Mortality (Treated): " + mortalityTreated.get(d) + "\n";
      info += d + " Mortality (Untreated): " + mortalityUntreated.get(d) + "\n";
      for (Symptom s : Symptom.values()) {
        info += d + " " + s + " Expression: " + getSymptomExpression(d, s) + "\n";
      }
    }
    return info;
  }
}
