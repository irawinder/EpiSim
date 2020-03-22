/**
 * Configure City View Model
 *
 * (Edit/modify how the simulation looks from here!)
 */
public void configView(CityModel model) {
  
  // Simulation Rates
  viz.setValue(SimulationSpeed.SLOWEST,         60); // ~Frames per second
  viz.setValue(SimulationSpeed.SLOWER,          30); // ~Frames per second
  viz.setValue(SimulationSpeed.SLOW,            20); // ~Frames per second
  viz.setValue(SimulationSpeed.NORMAL,          10); // ~Frames per second
  viz.setValue(SimulationSpeed.FAST,             5); // ~Frames per second
  viz.setValue(SimulationSpeed.FASTER,           3); // ~Frames per second
  viz.setValue(SimulationSpeed.FASTEST,          1); // ~Frames per second
  
  // Simulation Speed
  viz.setSpeed(SimulationSpeed.SLOW);
  
  // Default Layer Settings
  viz.setToggle(ViewParameter.AUTO_RUN,         false);
  viz.setToggle(ViewParameter.SHOW_PERSONS,     true);
  viz.setToggle(ViewParameter.SHOW_COMMUTES,    true);
  viz.setToggle(ViewParameter.SHOW_PLACES,      true);
  viz.setToggle(ViewParameter.SHOW_AGENTS,      true);
  viz.setToggle(ViewParameter.SHOW_FRAMERATE,   false);
  
  // Default View Mode Settings
  viz.setAgentMode(AgentMode.PATHOGEN);
  viz.setPersonMode(PersonMode.COMPARTMENT);
  viz.setPlaceMode(PlaceMode.DENSITY);
  
  // General Graphics Location Parameters
  viz.setValue(ViewParameter.LEFT_PANEL_WIDTH,   350); // pixels
  viz.setValue(ViewParameter.RIGHT_PANEL_WIDTH,  450); // pixels
  viz.setValue(ViewParameter.GENERAL_MARGIN,      50); // pixels
  viz.setModelLocation();                              // Set Screen location of model
  
  // Set extents of model to view in "real" units
  double buffer = 50;
  double xMin = model.xMin() - buffer;
  double xMax = model.xMax() + buffer;
  double yMin = model.yMin() - buffer;
  double yMax = model.yMax() + buffer;
  viz.setModelExtents(xMin, yMin, xMax, yMax);
  
  // Vertical Locations of Application Elements (0 is top)
  viz.setValue(ViewParameter.INFO_Y,              50); // pixels
  viz.setValue(ViewParameter.PATHOGEN_LEGEND_Y,  530); // pixels
  viz.setValue(ViewParameter.PLACE_LEGEND_Y,     610); // pixels
  viz.setValue(ViewParameter.PERSON_LEGEND_Y,    745); // pixels
  
  String info = 
    "Epidemic Simulation" + "\n" +
    "EDGEof Planetary Insight Center" + "\n" +
    "by Ira Winder, F. Calalang, D. Goldman" + "\n\n" +
    
    "A simple simulation of epidemic using an activity-based " +
    "land use and transportation model. " + 
    "Use keyboard commands:" + "\n\n" + 
    
    "Infection:" + "\n" +
    "Press 'n' to toggle infection of focus" + "\n\n" +
    
    "Population:" + "\n" +
    "Press 'd' to view demographics" + "\n" +
    "Press 's' to view infection status" + "\n\n" +
    
    "Places:" + "\n" +
    "Press 'l' to view land use" + "\n" +
    "Press 'g' to view gathering density" + "\n\n" +

    "Time:" + "\n" +
    "Press 'SPACEBAR' to pause" + "\n" +
    "Press '-' or '+' to change speed" + "\n" +
    "Press 't' to iterate one time step" + "\n\n" +
    
    "Quaurantine:" + "\n" +
    "Press 'q' to toggle quarantine" + "\n\n" +
    
    "Model:" + "\n" +
    "Press 'r' to regenerate random city" + "\n" +
    "Press '1' to move all to primary" + "\n" +
    "Press '2' to move all to secondary" + "\n" +
    "Press '3' to move all to tertiary" + "\n\n";
    
    //"Model Layers:" + "\n" +
    //"Press '1' to hide/show Places" + "\n" +
    //"Press '2' to hide/show Persons" + "\n" +
    //"Press '3' to hide/show Commutes" + "\n" +
    //"Press '4' to hide/show Contagions" + "\n" +
    
    //"View Modes:" + "\n" +
    //"Press 'q' to toggle Person Legend" + "\n" +
    //"Press 'w' to toggle Place Legend" + "\n" +
    //"Press 'e' to toggle Agent Legend" + "\n" +
    
  viz.setInfo(info);

  // Compartment Names
  viz.setName(Compartment.SUSCEPTIBLE,         "Susceptible");
  viz.setName(Compartment.INCUBATING,          "Incubating");
  viz.setName(Compartment.INFECTIOUS,          "Infectious");
  viz.setName(Compartment.RECOVERED,           "Recovered");
  viz.setName(Compartment.DEAD_TREATED,        "Dead");
  viz.setName(Compartment.DEAD_UNTREATED,      "Dead (Survivable)");
  
  // Compartment Colors
  viz.setColor(Compartment.SUSCEPTIBLE,        color(250, 250, 250, 255)); // White;
  viz.setColor(Compartment.INCUBATING,         color(255, 150,   0, 255)); // Orange
  viz.setColor(Compartment.INFECTIOUS,         color(255,   0,   0, 255)); // Dark Red
  viz.setColor(Compartment.RECOVERED,          color(100, 100, 100, 255)); // Black
  viz.setColor(Compartment.DEAD_TREATED,       color(  0,  50, 255, 255)); // Teal
  viz.setColor(Compartment.DEAD_UNTREATED,     color(  0, 255,   0, 255)); // Green
  
  // Pathogen Names
  viz.setName(PathogenType.CORONAVIRUS,       "Coronavirus");
  viz.setName(PathogenType.RHINOVIRUS,        "Rhinovirus");
  viz.setName(PathogenType.INFLUENZA,         "Influenza");
  
  // Pathogen Colors
  viz.setColor(PathogenType.CORONAVIRUS,       color(200,   0,   0, 255)); // Dark Red
  viz.setColor(PathogenType.RHINOVIRUS,        color(190, 100,   0, 255)); // Dark Orange
  viz.setColor(PathogenType.INFLUENZA,         color(  0,   0, 200, 255)); // Green
  
  // Host Demographic Names
  viz.setName(Demographic.CHILD,               "Child");
  viz.setName(Demographic.ADULT,               "Adult");
  viz.setName(Demographic.SENIOR,              "Senior");
  
  // Host Demographic Colors
  viz.setColor(Demographic.CHILD,              color(255, 150,   0, 255)); // Yello
  viz.setColor(Demographic.ADULT,              color(  0, 255, 150, 255)); // Dark Green
  viz.setColor(Demographic.SENIOR,             color(150,   0, 255, 255)); // Magenta
  
  // Host Demographic Alphas
  viz.setValue(Demographic.CHILD,              255); // 0 - 255
  viz.setValue(Demographic.ADULT,              255); // 0 - 255
  viz.setValue(Demographic.SENIOR,             255); // 0 - 255
  
  // Place Names
  viz.setName(LandUse.DWELLING,                "Dwelling Unit");
  viz.setName(LandUse.OFFICE,                  "Office Space");
  viz.setName(LandUse.RETAIL,                  "Retail Space");
  viz.setName(LandUse.SCHOOL,                  "School or Daycare");
  viz.setName(LandUse.PUBLIC,                  "Public Space");
  viz.setName(LandUse.HOSPITAL,                "Hospital");
  
  // Place Colors
  viz.setColor(LandUse.DWELLING,                color(150, 150,   0, 150)); // Yellow
  viz.setColor(LandUse.OFFICE,                  color( 50,  50, 200, 150)); // Blue
  viz.setColor(LandUse.RETAIL,                  color(200,  50, 200, 150)); // Magenta
  viz.setColor(LandUse.SCHOOL,                  color(200, 100,  50, 150)); // Brown
  viz.setColor(LandUse.PUBLIC,                  color( 50, 200,  50, 150)); // Green
  viz.setColor(LandUse.HOSPITAL,                color(  0, 255, 255, 150)); // Teal
  
  // Phase Names
  viz.setName(Phase.SLEEP,                      "Asleep");
  viz.setName(Phase.HOME,                       "At Home");
  viz.setName(Phase.GO_WORK,                    "Morning Commute");
  viz.setName(Phase.WORK,                       "Working Day");
  viz.setName(Phase.WORK_LUNCH,                 "Lunch Break");
  viz.setName(Phase.LEISURE,                    "Free Time");
  viz.setName(Phase.GO_HOME,                    "Evening Commute");
  
  // View Mode Names
  viz.setName(AgentMode.PATHOGEN,               "Infectious Agent");
  viz.setName(AgentMode.PATHOGEN_TYPE,          "Pathogen Type");
  viz.setName(PersonMode.DEMOGRAPHIC,           "Age Demographic");
  viz.setName(PersonMode.COMPARTMENT,           "Pathogen Status");
  viz.setName(PlaceMode.LANDUSE,                "Land Use Type");
  viz.setName(PlaceMode.DENSITY,                "Gathering Denisty");
  
  // Quarantine Paramters
  viz.setName(Quarantine.NONE,                  "Business As Usual\nPress 'q' to quarantine");
  viz.setName(Quarantine.STRICT,                "Quarantine In Effect");
  viz.setColor(Quarantine.NONE,                 color(200, 200, 200, 255)); // Gray
  viz.setColor(Quarantine.STRICT,               color(200,   0, 200, 255)); // Red
  viz.setValue(Quarantine.NONE,                 0);                         // stroke weight
  viz.setValue(Quarantine.STRICT,               4);                         // stroke weight
  
  // Text Settings
  viz.setValue(ViewParameter.TEXT_HEIGHT,       15);                        // pixels
  viz.setColor(ViewParameter.TEXT_FILL,         color( 75,  75,  75, 255)); // Dark Gray
  
  // Generic Place Parameters
  viz.setValue(ViewParameter.ENVIRONMENT_SCALER,      1.0);                       // scaler
  viz.setValue(ViewParameter.ENVIRONMENT_DIAMETER,    7);                         // pixels
  viz.setColor(ViewParameter.ENVIRONMENT_STROKE,      color(255, 255, 255, 255)); // White
  viz.setValue(ViewParameter.ENVIRONMENT_ALPHA,       200);                       // 0 - 255
  
  // Density Heatmap Paramters
  viz.setValue(ViewParameter.MIN_DENSITY,       0);               // people per area
  viz.setValue(ViewParameter.MAX_DENSITY,       1/50.0);          // people per area
  viz.setValue(ViewParameter.MIN_DENSITY_HUE,   90);              // Green (0 - 255)
  viz.setValue(ViewParameter.MAX_DENSITY_HUE,   180);             // Blue  (0 - 255)
  viz.setValue(ViewParameter.MIN_DENSITY_SAT,   25);              // Light (0 - 255)
  viz.setValue(ViewParameter.MAX_DENSITY_SAT,   255);             // Dark  (0 - 255)
  
  // Generic Agent Parameters
  viz.setValue(ViewParameter.AGENT_WEIGHT,      4);     // pixels
  viz.setValue(ViewParameter.AGENT_ALPHA,       150);   // 0 - 255
  viz.setValue(ViewParameter.AGENT_SCALER,      1.6);   // scaler
  
  // Generic Person Parameters
  viz.setValue(ViewParameter.HOST_DIAMETER,     8);                         // pixels
  viz.setColor(ViewParameter.HOST_STROKE,       color( 50,  50,  50, 255)); // Light Gray
  viz.setValue(ViewParameter.HOST_ALPHA,        255);                       // 0 - 255
  viz.setValue(ViewParameter.HOST_WEIGHT,       2);                         // 0 - 255
  
  // Generic Commute Paramters
  viz.setColor(ViewParameter.COMMUTE_STROKE,    color(  0,   0,   0,  20)); // Light Gray
  viz.setValue(ViewParameter.COMMUTE_WEIGHT,    2);                         // pixels
  
  // Other Parameters
  viz.setValue(ViewParameter.REDUCED_ALPHA,     125);                       // 0 - 255
  viz.setValue(ViewParameter.SELECTION_WEIGHT,  2);                         // pixels
  viz.setValue(ViewParameter.SELECTION_SCALER,  1.6);                       // scaler
  viz.setColor(ViewParameter.SELECTION_COLOR,   color( 75,  75,  75, 255)); // Black
  
  // Predraw Static Layers
  viz.preDraw(model);
  
  //Graph Names and Attributes
  viz.setName(TimePlot.HOSPITALIZED,            "Hospitalizations");
  viz.setColor(TimePlot.HOSPITALIZED,           color(  0,   0,   0,  100));  // Light Gray
  viz.setValue(TimePlot.HOSPITALIZED,           40);                         // Scaler for Hospitalization counts
  viz.setName(TimePlot.ENCOUNTER,               "Social Encounters");
  viz.setName(TimePlot.COMPARTMENT,             "Pathogen Status");
  viz.setName(TimePlot.TRIP,                    "Trips Made");
  viz.setName(TimePlot.SYMPTOM,                 "Symptoms Expressed");
  viz.setValue(ViewParameter.GRAPH_HEIGHT,      200);                        // pixels
  viz.setValue(ViewParameter.GRAPH_BAR_WIDTH,   1);        
  viz.setValue(ViewParameter.GRAPH_ALPHA,       150);                        // 0 - 255
  viz.setName(ViewParameter.GRAPH_LABEL_Y,      "Amount");
  viz.setColor(ViewParameter.AXES_STROKE,       color(  0,   0,   0,  80));  // Light Gray
  viz.initGraphs();
}
