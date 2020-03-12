/**
 * Generic attributes of an Infectious Pathogen
 */
public class Pathogen {
  
  // Name of Pathogen
  private String name;
  
  // The specific variety of this pathogen (e.g. COMMON_COLD)
  private PathogenType type;
  
  // Transmission Rate (probabily of transmission per contact between infected and susceptible)
  private Rate attackRate;
  
  // Duration of Incubation (days)
  private GaussianDistribution incubationDuration;
  
  // Duration of Infectiousness (days)
  private GaussianDistribution infectiousDuration;
  
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
    this.attackRate = new Rate();
    this.incubationDuration = new GaussianDistribution();
    this.infectiousDuration = new GaussianDistribution();
    
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
  public void setIncubationDistribution(double mean, double standardDeviation) {
    this.incubationDuration = new GaussianDistribution(mean, standardDeviation);
  }
  
  /** 
   * Get the probablity distribution for incubation duration
   */
  public GaussianDistribution getIncubationDistribution() {
    return this.incubationDuration;
  }
  
  /** 
   * Get a value for incubation duration [days]
   */
  public double getIncubationDuration() {
    return Math.max(0, this.incubationDuration.getValue());
  }
  
  /** 
   * Set the probablity distribution for infectious duration
   *
   * @param mean days
   * @param standardDeviation days
   */
  public void setInfectiousDistribution(double mean, double standardDeviation) {
    this.infectiousDuration = new GaussianDistribution(mean, standardDeviation);
  }
  
  /** 
   * Get the probablity distribution for infectious duration
   */
  public GaussianDistribution getInfectiousDistribution() {
    return this.infectiousDuration;
  }
  
  /** 
   * Get a value for infectious duration [days]
   */
  public double getInfectiousDuration() {
    return Math.max(0, this.infectiousDuration.getValue());
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
