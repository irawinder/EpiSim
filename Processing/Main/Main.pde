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
  * - Processing Main()
  *    * EpiModel()
  *    * SimpleViewModel()
  * - SimpleViewModel()
  *     * extends ViewModel()
  * - ViewModel()
  *     * EpiModel()
  * - EpiModel()
  *     * Agent()
  *     * Host()
  *     * Environment()
  * - Agent()
  *     * extends Element()
  *     * enum AgentType
  * - Host()
  *     * Agent()
  *     * extends Element()
  *     * enum Demongraphic
  *     * enum AgentStatus
  * - Environment()
  *     * Agent()
  *     * Host()
  *     * extends Element()
  *     * enum EnvironmentPriority
  *     * enum EnvironmentType
  * - Element()
  *     * Coordinate()
  */
  
// Object Model of Epidemic
EpiModel epidemic;

// Visualization Model for Object Model
ViewModel viz;

// Global Demographic Thresholds
private static int ADULT_AGE;
private static int SENIOR_AGE;

// Random Variance added to coordinates to avoid overlap
private static int JITTER;

// setup() runs once at the very beginning
public void setup() {
  
  // Windowed Application Size (pixels)
  size(1000, 1000);
  
  // Initialize "Back-End" Object Model
  configureObjectModel();
  
  // Initialize "Front-End" View Model
  viz = new SimpleViewModel();
  viz.setModel(epidemic);
  
  // Draw Visualization
  viz.draw();
}

// draw() runs on an infinite loop after setup() is finished
public void draw() {
  
}

// keyPressed() runs whenever a key is pressed
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

//Configure a simple Epidemiological Model
private void configureObjectModel() {
  
  epidemic = new EpiModel();
  
  // Global Demographic Threshold
  ADULT_AGE = 18;
  SENIOR_AGE = 65;
  
  JITTER = 5; // pixels
  
  /**
   * Add randomly placed Environments to Model within a specified rectangle
   *
   * @param amount
   * @param name_prefix
   * @param type
   * @param x
   * @param y
   * @param w
   * @param h
   * @param minArea
   * @param maxArea
   */
  int MARGIN = 75; // Window Border Margin
  epidemic.randomEnvironments(25,  "Open Space",      EnvironmentType.OPENSPACE, 1*MARGIN, 1*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 500, 2000);
  epidemic.randomEnvironments(150, "Dwelling Unit",   EnvironmentType.DWELLING,  1*MARGIN, 1*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 50, 200);
  epidemic.randomEnvironments(10,  "Office Space",    EnvironmentType.OFFICE,    4*MARGIN, 4*MARGIN, width - 8*MARGIN, height - 8*MARGIN, 500, 2000);
  epidemic.randomEnvironments(2,   "Daycare Center",  EnvironmentType.SCHOOL,    4*MARGIN, 4*MARGIN, width - 8*MARGIN, height - 8*MARGIN, 500, 2000);
  epidemic.randomEnvironments(25,  "Retail Shopping", EnvironmentType.RETAIL,    2*MARGIN, 2*MARGIN, width - 4*MARGIN, height - 4*MARGIN, 50, 1000);
  epidemic.randomEnvironments(1,   "Hospital",        EnvironmentType.HOSPITAL,  4*MARGIN, 4*MARGIN, width - 8*MARGIN, height - 8*MARGIN, 2000, 2000);
  
  /**
   * Add hosts to model, initially located at their respective dwellings
   *
   * @param minAge
   * @param maxAge
   * @param minDwellingSize smallest household size of a dwelling unit
   * @param maxDwellingSize largest household size of a dwelling unit
   */
  epidemic.populate(5, 85, 1, 5);
  
  //// Print Model Configuration to Console
  //for(Environment env : epidemic.getEnvironments()) {
  //  println(env);
  //  for(Element ele : env.getElements()) {
  //    println("   " + ele);
  //  }
  //}
}
