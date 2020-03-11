/** 
  * Planetary Insight Center 
  * Agent Based Simulation of Viral Outbreak
  * Ira Winder, jiw@mit.edu
  *
  * Legend:
  * - Class()
  *     * Dependency or Parent
  * 
  * Object Map:
  *
  * - Processing Main()
  *    * SimpleEpiModel()
  *    * SimpleViewModel()
  
  * - SimpleViewModel()
  *     * extends ViewModel()
  * - ViewModel()
  *     * SimpleEpiModel()
  *
  * - SimpleEpiModel()
  *     * extends EpiModel()
  *     * depends on Person()
  *     * depends on Place()
  * - EpiModel()
  *     * depends on Agent()
  *     * depends on Host()
  *     * depends on Environment()
  *
  * - Person()
  *     * extends Host()
  *     * depends on Place()
  *     * enum Demographic
  * - Host()
  *     * extends Element()
  *     * depends on Environment()
  *     * enum Compartment  
  *
  * - Place()
  *     * extends Environment()
  *     * enum LandUse
  * - Environment()
  *     * extends Element()
  *
  * - Agent()
  *     * extends Element()
  *     * depends on Pathogen()
  *
  * - Pathogen()
  *     * enum PathogenType
  * - Element()
  *     * Coordinate()
  * - Coordinate()
  */

// Object Model of Epidemic
private SimpleEpiModel epidemic;

// Visualization Model for Object Model
private ViewModel viz;

// Global Demographic Thresholds
private static int ADULT_AGE;
private static int SENIOR_AGE;

/**
 * setup() runs once at the very beginning
 */
public void setup() {
  
  // Windowed Application Size (pixels)
  size(1200, 1000);
  
  // Initialize "Back-End" Object Model
  configureObjectModel();
  
  // Initialize "Front-End" View Model
  viz = new SimpleViewModel();
  viz.setModel(epidemic);
  
  // Draw Visualization
  viz.draw();
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
public void draw() {
  
}

/**
 * keyPressed() runs whenever a key is pressed
 */
public void keyPressed() {
  switch(key) {
    case 'r':
      configureObjectModel();
      viz = new SimpleViewModel();
      viz.setModel(epidemic);
      viz.draw();
      break;
    case 'p':
      epidemic.allToPrimary();
      viz.draw();
      break;
    case 's':
      epidemic.allToSecondary();
      viz.draw();
      break;
  }
}

/**
 * Configure a simple Epidemiological Model
 */
private void configureObjectModel() {
  
  epidemic = new SimpleEpiModel();
  
  // Global Demographic Threshold
  ADULT_AGE = 18;
  SENIOR_AGE = 65;
  
  // Window Border Margin
  int MARGIN = 100; 
  
  /**
   * Add randomly placed Places to Model within a specified rectangle (x1, y1, x2, y2)
   * Parameters (amount, name_prefix, type, x1, y1, x2, y2, minSize, maxSize)
   */
  epidemic.randomPlaces(25,       "Open Space",      LandUse.OPENSPACE, 2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 500,       2000);
  epidemic.randomPlaces(250,      "Dwelling Unit",   LandUse.DWELLING,  2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 50,        200);
  epidemic.randomPlaces(10,       "Office Space",    LandUse.OFFICE,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500,       2000);
  epidemic.randomPlaces(2,        "Daycare Center",  LandUse.SCHOOL,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500,       2000);
  epidemic.randomPlaces(25,       "Retail Shopping", LandUse.RETAIL,    2*MARGIN + 2*MARGIN, 2*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 50,        1000);
  epidemic.randomPlaces(1,        "Hospital",        LandUse.HOSPITAL,  2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 2000,      2000);
  
  /**
   * Add people to Model, initially located at their respective dwellings
   * Parameters (minAge, maxAge, minDwellingSize, maxDwellingSize)
   */
  epidemic.populate(5, 85, 1, 5);
  
  // Configure Covid Pathogen
  Pathogen covid = new Pathogen();
  configureCovid(covid);
  
  // Configure Cold Pathogen
  Pathogen cold = new Pathogen();
  configureCold(cold);
  
  // Deploy Pathogens as Agents into the Host (Person) Population
  //epidemic.patientZero(cold, 10);
  //epidemic.patientZero(covid, 1);
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
  covid.setIncubationDistribution( 7.0, 3.0);
  covid.setInfectiousDistribution(14.0, 2.0);
  
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
  cold.setIncubationDistribution( 2.0, 0.5);
  cold.setInfectiousDistribution(7.0, 2.0);
  
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
