/** 
 * Planetary Insight Center 
 * Agent Based Simulation of Epidemic
 * Ira Winder, jiw@mit.edu
 *
 * Epidemiological Model:
 *
 *   Pathogen: 
 *     The pathogen is the microorganism that actually causes the disease in question. 
 *     An pathogen could be some form of bacteria, virus, fungus, or parasite.
 *
 *   Agent:
 *     Agents are the vessels by which Pathogens spread. In a model there may be
 *     numerous Agents referencing the same generic Pathogen definition.
 *
 *   Host:  
 *     The agent infects the host, which is the organism that carries the disease. 
 *     A host doesn’t necessarily get sick; hosts can act as carriers for an agent 
 *     without displaying any outward symptoms of the disease. Hosts get sick or 
 *     carry an agent because some part of their physiology is hospitable or 
 *     attractive to the agent.
 *
 *   Compartment:  
 *     The Host's compartment with respect to a Pathogen 
 *     (Suceptible, Incubating, Infectious, Recovered, or Dead)
 *
 *     Compartmental models in epidemiology (Susceptible, Infectious, Carrier, Recovered):
 *       https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology
 *     Clade X Model (Susceptible, Incubating, Infectious (Mild or sever), Convalescent, Hospitalized, Recovered, Dead):
 *       http://www.centerforhealthsecurity.org/our-work/events/2018_clade_x_exercise/pdfs/Clade-X-model.pdf
 *     GLEAMviz Models:
 *       http://www.gleamviz.org/simulator/models/
 *
 *   Environment: 
 *     Outside factors can affect an epidemiologic outbreak as well; collectively 
 *     these are referred to as the environment. The environment includes any 
 *     factors that affect the spread of the disease but are not directly a part of 
 *     the agent or the host. For example, the temperature in a given location might 
 *     affect an agent’s ability to thrive, as might the quality of drinking water 
 *     or the accessibility of adequate medical facilities.
 *  
 *   Refer to Model of the Epidemiological Triangle:
 *   https://www.rivier.edu/academics/blog-posts/what-is-the-epidemiologic-triangle/
 *
 * Person Model: A Person is a human Host Element that may carry and/or transmit an Agent
 *
 *   Demographic:
 *     Host's attributes that affect its suceptibility to a Pathogen (e.g. Child, Adult, Senior)
 *
 *   Primary Place:
 *     The host's primary residence when they are not working or shopping. This often
 *     represents a dwelling with multiple household memebers
 *
 *   Secondary Place:  
 *     The Place where the host usually spends their time during the day. This is
 *     often at an office or employer for adults, or at school for children.
 *
 *   Tertiary Place: 
 *     All other Places that a host may spend their time throughout the day. This
 *     includes shopping, walking, commuting, dining, etc.
 *
 * Time Flow Model:
 *                
 * |     Phase 1     |         Phase 2          |  <- Phase Sequence
 *
 * |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |  9 |  <- Time Steps
 *                ^
 *                |
 *                e.g. currentTime  = timeStep*3; 
 *                e.g. currentPhase = Phase 1
 *
 * TimeDistribution Model: 
 * Utility Class for Generating Time Values within a Gaussian Distribution
 *
 *                     1x Std. Dev.
 *
 * |                    |     |
 * |                  .-|-.   |
 * |                -   |  -  |
 * |               /    |    \|
 * |            _ |     |     | _
 * |         _    |     |     |    _ 
 * |__._._-_|_____|_____|_____|_____|_-_.__.__
 *                      ^
 *                   Average (mean)
 *
 * Object Map Legend:
 *   - Class() dependency
 *   * Enum dependency
 *   @ Interface
 * 
 * Object Map:
 *
 * @ Model
 * - Processing Main()
 *    - CityModel()
 *    - ResultSeries()
 *         - Time()
 *         - Result()
 *    - ResultView()
 *         - CityModel()
 *         - ResultSeries()
 *         - ResultSeries()
 *         - BarGraph()
 *         - GraphAxes()
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
 *         - PathogenEffect()
 *         - Agent()
 *         - Environment()
 *         * Compartment 
 * - CityModel() extends EpiModel()
 *     - Time()
 *     - Schedule()
 *     - ChoiceModel()
 *     - Person() extends Host()
 *         - Place()
 *         * Demographic
 *     - Place() extends Environment()
 *         * LandUse
 *     * Phase
 * - ChoiceModel()
 *     - Person()
 *     - Place()
 *     * PlaceCategory
 *     * Demographic
 *     * LandUse
 * - ViewModel() extends ViewAttributes()
 *     * ViewParameter
 * - EpiView() extends ViewModel()
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
 * - Coordinate()
 * - Time()
 *     * TimeUnit
 * - TimeInterval()
 *     - Time()
 *     * TimeUnit
 */

// In-memory Object Model of Epidemic in a City
private CityModel epidemic;

// Sequence of model results comprising a simulation over time
private ResultSeries outcome;

// Visualization Model for Epidemic Model, City Model, and Results
private ResultView viz;

int frameCounter;

/**
 * setup() runs once at the very beginning
 */
public void setup() {
 
  // Default Application Window Settings
  size(1600, 900);
  surface.setTitle("Planetary Insight Center | Epidemic Simulation");
  surface.setResizable(true);
  surface.setLocation(100, 100);
  
  // Frame Counter
  this.frameCounter = 0;
  
  /** 
   * Initialize "Back-End" Object Model
   * Edit/modify the initial city model and epidemic state from "A_ConfigModel" tab
   */
  this.epidemic = new CityModel();
  configModel();
  
  /** 
   * Initialize "Back-End" Result Model
   */
  this.outcome = new ResultSeries();
  epidemic.update(outcome);
  
  /** 
   * Initialize "Front-End" View Model
   * Edit/modify how the simulation looks from the "A_ConfigView" tab
   */
  this.viz = new ResultView(epidemic);
  configView(epidemic);
  
  // Draw City Model
  viz.drawCity(epidemic, frameCounter);
  
  // Draw Results and Graphs
  viz.drawResults(outcome);
}

/**
 * draw() runs on an infinite loop after setup() is finished
 */
public void draw() {
  
  if(viz.isRunning()) {
    // Update Model Simulation and outcome table
    if(frameCounter % viz.getFramesPerSimulation() == 0 ) {
      epidemic.update(outcome);
    }
  }
  
  // Draw City Model
  viz.drawCity(epidemic, frameCounter);
  
  // Draw Results and Graphs
  viz.drawResults(outcome);
  
  frameCounter++;
}

/**
 * keyPressed() runs whenever a key is pressed
 */
public void keyPressed() {
  switch(key) {
    
    // View Controls
    //case '1':
    //  viz.switchToggle(ViewParameter.SHOW_PLACES);
    //  break;
    //case '2':
    //  viz.switchToggle(ViewParameter.SHOW_PERSONS);
    //  break;
    //case '3':
    //  viz.switchToggle(ViewParameter.SHOW_COMMUTES);
    //  break;
    //case '4':
    //  viz.switchToggle(ViewParameter.SHOW_AGENTS);
    //  break;
      
    case 'n':
      switch(viz.getAgentMode()) {
        case PATHOGEN:
          viz.nextPathogen();
          viz.initGraphs();
          break;
        case PATHOGEN_TYPE:
          viz.nextPathogenType();
          viz.initGraphs();
          break;
      }
      break;
    case 'a':
      Pathogen p = viz.getCurrentPathogen();
      epidemic.patientZero(p, 1);
      break;
      
    case 'd':
      viz.setPersonMode(PersonMode.DEMOGRAPHIC);
      break;
    case 's':
      viz.setPersonMode(PersonMode.COMPARTMENT);
      break;
    case 'l':
      viz.setPlaceMode(PlaceMode.LANDUSE);
      break;
    case 'g':
      viz.setPlaceMode(PlaceMode.DENSITY);
      break;
      
    // Quarantine:
    case 'q':
      epidemic.toggleQuarantine();
      break;
      
    //case 'q':
    //  viz.nextPersonMode();
    //  break;
    //case 'e':
    //  viz.nextAgentMode();
    //  break;
    //case 'w':
    //  viz.nextPlaceMode();
    //  viz.preDraw(epidemic);
    //  break;
    
    // Simulation Controls
    case 'r':
      epidemic = new CityModel();
      configModel();
      outcome = new ResultSeries();
      epidemic.update(outcome);
      viz = new ResultView(epidemic);
      configView(epidemic);
      viz.preDraw(epidemic);
      break;
    case '1':
      epidemic.allToPrimary();
      frameCounter = 0;
      if(viz.isRunning()) viz.toggleAutoRun();
      break;
    case '2':
      epidemic.allToSecondary();
      frameCounter = 0;
      if(viz.isRunning()) viz.toggleAutoRun();
      break;
    case '3':
      epidemic.allToTertiary();
      frameCounter = 0;
      if(viz.isRunning()) viz.toggleAutoRun();
      break;
      
    // Time Controls
    case ' ': // autoplay
      viz.toggleAutoRun();
      break;
    case '+': // speed up
      viz.increaseSpeed();
      break;
    case '-': // slow down
      viz.decreaseSpeed();
      break;
    case 't': // step model forward by one tick
      epidemic.update(outcome);
      frameCounter = 0;
      if(viz.isRunning()) viz.toggleAutoRun();
      break;
    case 'f':
      viz.toggleFrameRate();
      break;
  }
  
  // Update Graphics every keystroke
  viz.drawCity(epidemic, frameCounter);
  viz.drawResults(outcome);
}
