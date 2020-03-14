/** 
  * Planetary Insight Center 
  * Agent Based Simulation of Epidemic
  * Ira Winder, jiw@mit.edu
  *
  * Object Map Legend:
  *   - Class() dependency
  *   * Enum dependency
  *   @ Interface
  * 
  * Object Map (Updated 2020.03.13):
  *
  * @ Model
  * @ Simulation
  *    - Time()
  *    @ Model()
  * @ ViewModel
  *    @Model()
  * - Processing Main()
  *    - CityModel()
  *    - CityView()
  *    - Sim()
  * - EpiModel() implements @Model
  *     - Time()
  *     - Pathogen()
  *         * PathogenType
  *     - Agent() extends Element()
  *         - Pathogen()
  *         - Time()
  *         - Element()
  *         * Compartment
  *     - Environment() extends Element()
  *         - Agent()
  *         - Host()
  *     - Host() extends Element()
  *         - Agent()
  *         - Environment()
  *         * Compartment 
  * - CityModel() extends EpiModel()
  *     - Time()
  *     - Schedule()
  *     - BehaviorMap()
  *     - Person() extends Host()
  *         - Place()
  *         * Demographic
  *     - Place() extends Environment()
  *         * LandUse
  *     * Phase
  * - Sim() implements @Simulation
  *    - Time()
  *    @ Model()
  * - EpiView() implements @ViewModel
  *     - EpiModel()
  *     * PersonViewMode
  *     * PlaceViewMode
  * - CityView() extends EpiView()
  *     - CityModel()
  * - Element()
  *     - Coordinate()
  * - Schedule()
  *     - Time()
  *     - TimeInterval()
  *     * TimeUnit
  *     * Phase
  * - BehaviorMap()
  *     - Person()
  *     - Place()
  *     * PlaceCategory
  *     * Demographic
  *     * LandUse
  * - Coordinate()
  * - Time()
  *     * TimeUnit
  * - TimeInterval()
  *     - Time()
  *     * TimeUnit
  */

// Object Model of Epidemic
private CityModel epidemic;

// Visualization Model for Object Model
private CityView viz;

// Global Demographic Thresholds
private static int ADULT_AGE;
private static int SENIOR_AGE;

// Simulation Parameters
private boolean autoPlay;

/**
 * setup() runs once at the very beginning
 */
public void setup() {
  
  // Windowed Application Size (pixels)
  size(1200, 1000);
  frameRate(30);
  
  // Initialize "Back-End" Object Model
  epidemic = new CityModel();
  configureCityModel();
  
  // Initialize "Front-End" View Model
  viz = new CityView(epidemic);
  
  // Draw Visualization
  viz.draw();
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
public void draw() {
  if(autoPlay) {
    epidemic.update();
    viz.draw();
    text("Framerate: " + frameRate, width - 225, height - 75);
  }
}

/**
 * keyPressed() runs whenever a key is pressed
 */
public void keyPressed() {
  switch(key) {
    case 'r':
      epidemic = new CityModel();
      configureCityModel();
      viz = new CityView(epidemic);
      break;
    case 'h':
      epidemic.allToPrimary();
      break;
    case 'w':
      epidemic.allToSecondary();
      break;
    case '1':
      viz.showPlaces = !viz.showPlaces;
      break;
    case '2':
      viz.showPersons = !viz.showPersons;
      break;
    case '3':
      viz.showCommutes = !viz.showCommutes;
      break;
    case '4':
      viz.showAgents = !viz.showAgents;
      break;
    case 'p':
      if(viz.pathogenType == PathogenType.COVID_19) {
        viz.pathogenType = PathogenType.COMMON_COLD;
      } else {
        viz.pathogenType = PathogenType.COVID_19;
      }
      break;
    case 's':
      if(viz.personViewMode == PersonViewMode.DEMOGRAPHIC) {
        viz.personViewMode = PersonViewMode.COMPARTMENT;
      } else {
        viz.personViewMode = PersonViewMode.DEMOGRAPHIC;
      }
      break;
    case 't': // step model forward by one tick
      epidemic.update();
      break;
    case 'a': // autoplay
      autoPlay = !autoPlay;
      break;
  }
  viz.draw();
}

/**
 * Configure a simple Epidemiological Model
 */
private void configureCityModel() {
  
  epidemic.setTime(new Time(0, TimeUnit.HOUR));
  epidemic.setTimeStep(new Time(1, TimeUnit.HOUR));
  
  /**
   * Behaviors (Demographic, Travel Category, Land Use, Max Distance Willing to Travel)
   */
  double BASE_DIST = 100;
  BehaviorMap behavior = new BehaviorMap();
  behavior.setMap(Demographic.CHILD,  PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
  behavior.setMap(Demographic.CHILD,  PlaceCategory.SECONDARY, LandUse.SCHOOL,     BASE_DIST*2.0);
  behavior.setMap(Demographic.CHILD,  PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
  behavior.setMap(Demographic.CHILD,  PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.OFFICE,     BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.SCHOOL,     BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.HOSPITAL,   BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.RETAIL,     BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
  behavior.setMap(Demographic.ADULT,  PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
  behavior.setMap(Demographic.SENIOR, PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
  behavior.setMap(Demographic.SENIOR, PlaceCategory.SECONDARY, LandUse.DWELLING,   BASE_DIST*1.0);
  behavior.setMap(Demographic.SENIOR, PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
  behavior.setMap(Demographic.SENIOR, PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
  epidemic.setBehavior(behavior);
  
  /**
   * Add randomly placed Places to Model within a specified rectangle (x1, y1, x2, y2)
   * Parameters (amount, name_prefix, type, x1, y1, x2, y2, minSize, maxSize)
   */
  int MARGIN = 100; // Window Border Margin
  int N = 2;
  epidemic.randomPlaces(N*25,       "Public Space",    LandUse.PUBLIC,    2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 500,       2000);
  epidemic.randomPlaces(N*250,      "Dwelling Unit",   LandUse.DWELLING,  2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 50,        200);
  epidemic.randomPlaces(N*10,       "Office Space",    LandUse.OFFICE,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500,       2000);
  epidemic.randomPlaces(N*4,        "School",          LandUse.SCHOOL,    2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 500,       2000);
  epidemic.randomPlaces(N*25,       "Retail Shopping", LandUse.RETAIL,    2*MARGIN + 2*MARGIN, 2*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 50,        1000);
  epidemic.randomPlaces(N*1,        "Hospital",        LandUse.HOSPITAL,  2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 2000,      2000);
  
  /**
   * Global Demographic Thresholds
   */
  ADULT_AGE = 18;
  SENIOR_AGE = 65;
  
  /**
   * Add people to Model, initially located at their respective dwellings
   * Parameters (minAge, maxAge, minDwellingSize, maxDwellingSize)
   */
  epidemic.populate(5, 85, 1, 5);
  
  //Configure City Schedule
  Schedule nineToFive = new Schedule();
  
  // Sunday
  nineToFive.addPhase(Phase.SLEEP,              new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00
  nineToFive.addPhase(Phase.HOME,               new Time(16, TimeUnit.HOUR)); // 06:00 - 22:00
  nineToFive.addPhase(Phase.SLEEP,              new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
  
  // Monday - Friday
  for(int i=0; i<5; i++) {
    nineToFive.addPhase(Phase.SLEEP,            new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00
    nineToFive.addPhase(Phase.HOME,             new Time( 1, TimeUnit.HOUR)); // 06:00 - 07:00
    nineToFive.addPhase(Phase.GO_WORK,          new Time( 2, TimeUnit.HOUR)); // 07:00 - 09:00
    nineToFive.addPhase(Phase.WORK,             new Time( 3, TimeUnit.HOUR)); // 09:00 - 12:00
    nineToFive.addPhase(Phase.WORK_LUNCH,       new Time( 1, TimeUnit.HOUR)); // 12:00 - 13:00
    nineToFive.addPhase(Phase.WORK,             new Time( 4, TimeUnit.HOUR)); // 13:00 - 17:00
    nineToFive.addPhase(Phase.GO_HOME,          new Time( 2, TimeUnit.HOUR)); // 17:00 - 19:00
    nineToFive.addPhase(Phase.LEISURE,          new Time( 3, TimeUnit.HOUR)); // 19:00 - 22:00
    nineToFive.addPhase(Phase.SLEEP,            new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
  }
  
  // Saturday
  nineToFive.addPhase(Phase.SLEEP,              new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00
  nineToFive.addPhase(Phase.LEISURE,            new Time(16, TimeUnit.HOUR)); // 06:00 - 22:00
  nineToFive.addPhase(Phase.SLEEP,              new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
  
  epidemic.setSchedule(nineToFive);
  
  //Chance that person will shift state from dominant state to tertiary state (per HOUR)
  epidemic.setPhaseAnomoly(Phase.SLEEP,      new Rate(0.05));
  epidemic.setPhaseAnomoly(Phase.HOME,       new Rate(0.10));
  epidemic.setPhaseAnomoly(Phase.GO_WORK,    new Rate(0.00));
  epidemic.setPhaseAnomoly(Phase.WORK,       new Rate(0.10));
  epidemic.setPhaseAnomoly(Phase.WORK_LUNCH, new Rate(0.90));
  epidemic.setPhaseAnomoly(Phase.GO_HOME,    new Rate(0.00));
  epidemic.setPhaseAnomoly(Phase.LEISURE,    new Rate(0.20));
  
  // Chance that Person will recover from a tertiary anomoly and return to their primary or secondary state (per HOUR)
  epidemic.setRecoverAnomoly(new Rate(0.40));
  
  // Phase Domains for each Phase (A person's dominant domain state during a specified phase)
  epidemic.setPhaseDomain(Phase.SLEEP,      PlaceCategory.PRIMARY);   // e.g. home
  epidemic.setPhaseDomain(Phase.HOME,       PlaceCategory.PRIMARY);   // e.g. home
  epidemic.setPhaseDomain(Phase.GO_WORK,    PlaceCategory.SECONDARY); // e.g. work or school
  epidemic.setPhaseDomain(Phase.WORK,       PlaceCategory.SECONDARY); // e.g. work or school
  epidemic.setPhaseDomain(Phase.WORK_LUNCH, PlaceCategory.SECONDARY); // e.g. work or school
  epidemic.setPhaseDomain(Phase.GO_HOME,    PlaceCategory.PRIMARY);   // e.g. home
  epidemic.setPhaseDomain(Phase.LEISURE,    PlaceCategory.PRIMARY);   // e.g. home
  
  // Configure Covid Pathogen
  Pathogen covid = new Pathogen();
  configureCovid(covid);
  
  // Configure Cold Pathogen
  Pathogen cold = new Pathogen();
  configureCold(cold);
  
  /**
   * Deploy Pathogens as Agents into the Host (Person) Population
   * Parameters: pathogen, initial host count
   */
  epidemic.patientZero(cold, 10);
  epidemic.patientZero(covid, 1);
}

/**
 * Configure a pathogen to have COVID-19 attributes
 *
 * @param covid pathogen to configure
 */
void configureCovid(Pathogen covid) {
  
  covid.setName("COVID-19");
  covid.setType(PathogenType.COVID_19);
  covid.setAttackRate(new Rate(0.3));
  
  Time agentLife = new Time(24, TimeUnit.HOUR);
  covid.setAgentLife(agentLife);
  
  Time incubationMean              = new Time( 7, TimeUnit.DAY);
  Time incubationStandardDeviation = new Time( 3, TimeUnit.DAY);
  Time infectiousMean              = new Time(14, TimeUnit.DAY);
  Time infectiousStandardDeviation = new Time( 2, TimeUnit.DAY);
  covid.setIncubationDistribution(incubationMean, incubationStandardDeviation);
  covid.setInfectiousDistribution(infectiousMean, infectiousStandardDeviation);
  
  covid.setMortalityTreated(Demographic.CHILD,  new Rate(0.001));
  covid.setMortalityTreated(Demographic.ADULT,  new Rate(0.01));
  covid.setMortalityTreated(Demographic.SENIOR, new Rate(0.02));
  
  covid.setMortalityUntreated(Demographic.CHILD,  new Rate(0.002));
  covid.setMortalityUntreated(Demographic.ADULT,  new Rate(0.02));
  covid.setMortalityUntreated(Demographic.SENIOR, new Rate(0.08));
  
  covid.setSymptomExpression(Demographic.CHILD, Symptom.FEVER,               new Rate(0.5*0.50));
  covid.setSymptomExpression(Demographic.CHILD, Symptom.COUGH,               new Rate(0.5*0.50));
  covid.setSymptomExpression(Demographic.CHILD, Symptom.SHORTNESS_OF_BREATH, new Rate(0.5*0.25));
  covid.setSymptomExpression(Demographic.CHILD, Symptom.FATIGUE,             new Rate(0.5*0.05));
  covid.setSymptomExpression(Demographic.CHILD, Symptom.MUSCLE_ACHE,         new Rate(0.5*0.05));
  covid.setSymptomExpression(Demographic.CHILD, Symptom.DIARRHEA,            new Rate(0.5*0.05));
  
  covid.setSymptomExpression(Demographic.ADULT, Symptom.FEVER,               new Rate(1.0*0.50));
  covid.setSymptomExpression(Demographic.ADULT, Symptom.COUGH,               new Rate(1.0*0.50));
  covid.setSymptomExpression(Demographic.ADULT, Symptom.SHORTNESS_OF_BREATH, new Rate(1.0*0.25));
  covid.setSymptomExpression(Demographic.ADULT, Symptom.FATIGUE,             new Rate(1.0*0.05));
  covid.setSymptomExpression(Demographic.ADULT, Symptom.MUSCLE_ACHE,         new Rate(1.0*0.05));
  covid.setSymptomExpression(Demographic.ADULT, Symptom.DIARRHEA,            new Rate(1.0*0.05));
  
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.FEVER,              new Rate(1.5*0.50));
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.COUGH,              new Rate(1.5*0.50));
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.SHORTNESS_OF_BREATH,new Rate(1.5*0.25));
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.FATIGUE,            new Rate(1.5*0.05));
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.MUSCLE_ACHE,        new Rate(1.5*0.05));
  covid.setSymptomExpression(Demographic.SENIOR, Symptom.DIARRHEA,           new Rate(1.5*0.05));
}

/**
 * Configure a pathogen to have Common Cold attributes
 *
 * @param cold pathogen to configure
 */
public void configureCold(Pathogen cold) {
  
  cold.setName("Common Cold");
  cold.setType(PathogenType.COMMON_COLD);
  cold.setAttackRate(new Rate(0.3));
  
  Time agentLife = new Time(8, TimeUnit.HOUR);
  cold.setAgentLife(agentLife);
  
  Time incubationMean              = new Time(  2, TimeUnit.DAY);
  Time incubationStandardDeviation = new Time(0.5, TimeUnit.DAY);
  Time infectiousMean              = new Time(  7, TimeUnit.DAY);
  Time infectiousStandardDeviation = new Time(  2, TimeUnit.DAY);
  cold.setIncubationDistribution(incubationMean, incubationStandardDeviation);
  cold.setInfectiousDistribution(infectiousMean, infectiousStandardDeviation);
  
  cold.setMortalityTreated(Demographic.CHILD,  new Rate(0.0));
  cold.setMortalityTreated(Demographic.ADULT,  new Rate(0.0));
  cold.setMortalityTreated(Demographic.SENIOR, new Rate(0.0));
  
  cold.setMortalityUntreated(Demographic.CHILD,  new Rate(0.0));
  cold.setMortalityUntreated(Demographic.ADULT,  new Rate(0.0));
  cold.setMortalityUntreated(Demographic.SENIOR, new Rate(0.001));
  
  cold.setSymptomExpression(Demographic.CHILD, Symptom.FEVER,               new Rate(1.0*0.50));
  cold.setSymptomExpression(Demographic.CHILD, Symptom.COUGH,               new Rate(1.0*0.50));
  
  cold.setSymptomExpression(Demographic.ADULT, Symptom.FEVER,               new Rate(1.0*0.50));
  cold.setSymptomExpression(Demographic.ADULT, Symptom.COUGH,               new Rate(1.0*0.50));
  
  cold.setSymptomExpression(Demographic.SENIOR, Symptom.FEVER,              new Rate(1.5*0.50));
  cold.setSymptomExpression(Demographic.SENIOR, Symptom.COUGH,              new Rate(1.5*0.50));
}
