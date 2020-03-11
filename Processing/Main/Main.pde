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
  *    * SimpleEpiModel()
  *    * SimpleViewModel()
  * - SimpleViewModel()
  *     * extends ViewModel()
  * - ViewModel()
  *     * SimpleEpiModel()
  * - SimpleEpiModel()
  *     * extends EpiModel()
  *     * depends on Person()
  *     * depends on Place()
  * - EpiModel()
  *     * depends on Agent()
  *     * depends on Host()
  *     * depends on Environment()
  * - Person()
  *     * extends Host()
  *     * enum Demographic
  * - Host()
  *     * extends Element()
  *     * depends on Environment()
  *     * enum Compartment  
  * - Agent()
  *     * extends Element()
  *     * enum Pathogen
  * - Place()
  *     * extends Environment()
  *     * enum LandUse
  * - Environment()
  *     * extends Element()
  * - Element()
  *     * Coordinate()
  */
  
import java.util.Random;
  
// Object Model of Epidemic
SimpleEpiModel epidemic;

// Visualization Model for Object Model
ViewModel viz;

// Global Demographic Thresholds
private static int ADULT_AGE;
private static int SENIOR_AGE;

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
  
  epidemic = new SimpleEpiModel();
  
  // Global Demographic Threshold
  ADULT_AGE = 18;
  SENIOR_AGE = 65;
  
  /**
   * Add randomly placed Places to Model within a specified rectangle
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
  epidemic.randomPlaces(25,  "Open Space",      LandUse.OPENSPACE, 2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 500, 2000);
  epidemic.randomPlaces(250, "Dwelling Unit",   LandUse.DWELLING,  2*MARGIN + 1*MARGIN, 1*MARGIN, width - 1*MARGIN, height - 1*MARGIN, 50, 200);
  epidemic.randomPlaces(10,  "Office Space",    LandUse.OFFICE,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500, 2000);
  epidemic.randomPlaces(2,   "Daycare Center",  LandUse.SCHOOL,    2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 500, 2000);
  epidemic.randomPlaces(25,  "Retail Shopping", LandUse.RETAIL,    2*MARGIN + 2*MARGIN, 2*MARGIN, width - 2*MARGIN, height - 2*MARGIN, 50, 1000);
  epidemic.randomPlaces(1,   "Hospital",        LandUse.HOSPITAL,  2*MARGIN + 3*MARGIN, 4*MARGIN, width - 3*MARGIN, height - 3*MARGIN, 2000, 2000);
  
  /**
   * Add hosts to model, initially located at their respective dwellings
   *
   * @param minAge
   * @param maxAge
   * @param minDwellingSize smallest household size of a dwelling unit
   * @param maxDwellingSize largest household size of a dwelling unit
   */
  epidemic.populate(5, 85, 1, 5);
}
