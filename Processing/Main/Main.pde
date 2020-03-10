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
  size(1200, 1000);
  
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
  
  JITTER = 7; // pixels
  
  /**
   * Add randomly placed Environments to Model within a specified rectangle
   *
   * @param amount
   * @param name_prefix
   * @param type
   * @param x1
   * @param y1
   * @param x2
   * @param y2
   * @param minArea
   * @param maxArea
   */
  int MARGIN = 100; // Window Border Margin
  epidemic.randomEnvironments(25,  "Open Space",      EnvironmentType.OPENSPACE, 2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 500, 2000);
  epidemic.randomEnvironments(250, "Dwelling Unit",   EnvironmentType.DWELLING,  2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 50, 200);
  epidemic.randomEnvironments(10,  "Office Space",    EnvironmentType.OFFICE,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500, 2000);
  epidemic.randomEnvironments(2,   "Daycare Center",  EnvironmentType.SCHOOL,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500, 2000);
  epidemic.randomEnvironments(25,  "Retail Shopping", EnvironmentType.RETAIL,    2*MARGIN + 2*MARGIN, 2*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 50, 1000);
  epidemic.randomEnvironments(1,   "Hospital",        EnvironmentType.HOSPITAL,  2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 2000, 2000);
  
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
