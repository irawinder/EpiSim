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
  configModel();
  
  // Initialize "Front-End" View Model
  viz = new CityView();
  configView();
  
  // Draw Visualization
  viz.preDraw(epidemic);
  viz.draw(epidemic);
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
public void draw() {
  if(autoPlay) {
    epidemic.update();
    viz.draw(epidemic);
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
      configModel();
      viz.preDraw(epidemic);
      break;
    case 'h':
      epidemic.allToPrimary();
      break;
    case 'w':
      epidemic.allToSecondary();
      break;
    case '1':
      viz.switchToggle(ViewParameter.SHOW_PLACES);
      break;
    case '2':
      viz.switchToggle(ViewParameter.SHOW_PERSONS);
      break;
    case '3':
      viz.switchToggle(ViewParameter.SHOW_COMMUTES);
      break;
    case '4':
      viz.switchToggle(ViewParameter.SHOW_AGENTS);
      break;
    case 'p':
      viz.nextPathogenMode();
      break;
    case 's':
      viz.nextPersonMode();
      break;
    //case 'l':
    //  viz.nextPlaceMode();
    //  break;
    case 't': // step model forward by one tick
      epidemic.update();
      break;
    case 'a': // autoplay
      autoPlay = !autoPlay;
      break;
  }
  viz.draw(epidemic);
}
