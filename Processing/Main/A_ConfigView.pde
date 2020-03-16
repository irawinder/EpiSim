/**
 * Configure City View Model
 *
  (Edit/modify how the simulation looks from here!)
 */
public void configView() {
  
  // Simulation Rate
  viz.setValue(ViewParameter.FRAMES_PER_SIMULATION, 10); // Frames
  
  // Default View Mode Settings
  viz.setToggle(ViewParameter.AUTO_RUN,         false);
  viz.setToggle(ViewParameter.SHOW_PERSONS,     true);
  viz.setToggle(ViewParameter.SHOW_COMMUTES,    true);
  viz.setToggle(ViewParameter.SHOW_PLACES,      true);
  viz.setToggle(ViewParameter.SHOW_AGENTS,      true);
  viz.setToggle(ViewParameter.SHOW_FRAMERATE,   false);
  
  viz.setPathogenMode(AgentMode.PATHOGEN);
  viz.setPersonMode(PersonMode.COMPARTMENT);
  viz.setPlaceMode(PlaceMode.LANDUSE);
  
  // Graphics Location Parameters
  viz.setValue(ViewParameter.LEFT_MARGIN,        50);  // pixels
  viz.setValue(ViewParameter.GENERAL_MARGIN,     125); // pixels
  viz.setValue(ViewParameter.INFO_Y,             100); // pixels
  viz.setValue(ViewParameter.PATHOGEN_LEGEND_Y,  500); // pixels
  viz.setValue(ViewParameter.PERSON_LEGEND_Y,    610); // pixels
  viz.setValue(ViewParameter.PLACE_LEGEND_Y,     760); // pixels
  
  String info = 
    "Epidemic Simulation" + "\n" +
    "EDGEof Planetary Insight Center" + "\n\n" +
    "Layers:" + "\n" +
    "Press '1' to hide/show Places" + "\n" +
    "Press '2' to hide/show Persons" + "\n" +
    "Press '3' to hide/show Commutes" + "\n" +
    "Press '4' to hide/show Pathogens" + "\n\n" +
    
    "Filters:" + "\n" +
    "Press 'n' for next Infection Type" + "\n" +
    "Press 'q' to toggle Agent Legend" + "\n" +
    "Press 'w' to toggle Place Legend" + "\n" +
    "Press 'e' to toggle Person Legend" + "\n\n" +
    
    "Simulation:" + "\n" +
    "Press 'r' to regenerate random city" + "\n" +
    "Press 'z' to teleport all to primary" + "\n" +
    "Press 'x' to teleport all to secondary" + "\n" +
    "Press 'c' to teleport all to tertiary" + "\n\n" +
    
    "Time:" + "\n" +
    "Press 'a' to autoplay simulation" + "\n" +
    "Press 's' to iterate one time step" + "\n";
    
    
  viz.setInfo(info);

  // Compartment Names
  viz.setName(Compartment.SUSCEPTIBLE,         "Susceptible");
  viz.setName(Compartment.INCUBATING,          "Incubating");
  viz.setName(Compartment.INFECTIOUS,          "Infectious");
  viz.setName(Compartment.RECOVERED,           "Recovered");
  viz.setName(Compartment.DEAD,                "Dead");
  
  // Compartment Colors
  viz.setColor(Compartment.SUSCEPTIBLE,        color(255, 255, 255, 255)); // White;
  viz.setColor(Compartment.INCUBATING,         color(255, 150,   0, 255)); // Orange
  viz.setColor(Compartment.INFECTIOUS,         color(255,   0,   0, 255)); // Dark Red
  viz.setColor(Compartment.RECOVERED,          color(  0,   0,   0, 255)); // Black
  viz.setColor(Compartment.DEAD,               color(255,   0, 255, 255)); // Magenta
  
  // Pathogen Names
  viz.setName(PathogenType.CORONAVIRUS,       "Coronavirus");
  viz.setName(PathogenType.RHINOVIRUS,        "Rhinovirus");
  viz.setName(PathogenType.INFLUENZA,         "Influenza");
  
  // Pathogen Colors
  viz.setColor(PathogenType.CORONAVIRUS,       color(255,   0,   0, 230)); // Red
  viz.setColor(PathogenType.RHINOVIRUS,        color(  0,   0, 255, 230)); // Blue
  viz.setColor(PathogenType.INFLUENZA,         color(  0, 150,   0, 230)); // Green
  
  // Host Demographic Names
  viz.setName(Demographic.CHILD,               "Child");
  viz.setName(Demographic.ADULT,               "Adult");
  viz.setName(Demographic.SENIOR,              "Senior");
  
  // Host Demographic Colors
  viz.setColor(Demographic.CHILD,              color(255, 255, 255, 255)); // Light Gray
  viz.setColor(Demographic.ADULT,              color(100, 100, 100, 255)); // Dark Gray
  viz.setColor(Demographic.SENIOR,             color(  0,   0,   0, 255)); // Black
  
  // Place Names
  viz.setName(LandUse.DWELLING,                "Dwelling Unit");
  viz.setName(LandUse.OFFICE,                  "Office Space");
  viz.setName(LandUse.RETAIL,                  "Retail Space");
  viz.setName(LandUse.SCHOOL,                  "School or Daycare");
  viz.setName(LandUse.PUBLIC,                  "Public Space");
  viz.setName(LandUse.HOSPITAL,                "Hospital");
  
  // Place Colors
  viz.setColor(LandUse.DWELLING,                color(150, 150,   0, 100)); // Yellow
  viz.setColor(LandUse.OFFICE,                  color( 50,  50, 200, 100)); // Blue
  viz.setColor(LandUse.RETAIL,                  color(200,  50, 200, 100)); // Magenta
  viz.setColor(LandUse.SCHOOL,                  color(200, 100,  50, 100)); // Brown
  viz.setColor(LandUse.PUBLIC,                  color( 50, 200,  50,  50)); // Green
  viz.setColor(LandUse.HOSPITAL,                color(  0, 255, 255, 100)); // Teal

  // View Mode Names
  viz.setName(AgentMode.PATHOGEN,               "Infectious Agent");
  viz.setName(AgentMode.PATHOGEN_TYPE,          "Pathogen Type");
  viz.setName(PersonMode.DEMOGRAPHIC,           "Age Demographic");
  viz.setName(PersonMode.COMPARTMENT,           "Pathogen Status");
  viz.setName(PlaceMode.LANDUSE,                "Land Use Type");
  viz.setName(PlaceMode.DENSITY,                "Gathering Denisty");
  
  // Text Settings
  viz.setValue(ViewParameter.TEXT_HEIGHT,       15);                        // pixels
  viz.setValue(ViewParameter.TEXT_FILL,         color(  0,   0,   0, 200)); // Dark Gray
  
  // Generic Place Parameters
  viz.setValue(ViewParameter.PLACE_SCALER,      1.0);                       // scaler
  viz.setColor(ViewParameter.PLACE_STROKE,      color(255, 255, 255, 255)); // White
  viz.setValue(ViewParameter.PLACE_DIAMETER,    7);                         // pixels
  viz.setValue(ViewParameter.PLACE_ALPHA,       125);                       // 0 - 255
  
  // Density Heatmap Paramters
  viz.setValue(ViewParameter.MIN_DENSITY,       0);               // people per area
  viz.setValue(ViewParameter.MAX_DENSITY,       1/50.0);          // people per area
  viz.setValue(ViewParameter.MIN_DENSITY_HUE,   90);              // Green
  viz.setValue(ViewParameter.MAX_DENSITY_HUE,   0);               // Red
  
  // Generic Agent Parameters
  viz.setValue(ViewParameter.AGENT_DIAMETER,    7);    // pixels
  viz.setValue(ViewParameter.AGENT_WEIGHT,      3);    // pixels
  viz.setValue(ViewParameter.AGENT_ALPHA,       100);   // 0 - 255
  
  // Generic Person Parameters
  viz.setValue(ViewParameter.PERSON_DIAMETER,   5);                         // pixels
  viz.setColor(ViewParameter.PERSON_STROKE,     color(200, 200, 200, 255)); // Light Gray
  viz.setValue(ViewParameter.PERSON_ALPHA,      255);                       // 0 - 255
  
  // Generic Commute Paramters
  viz.setColor(ViewParameter.COMMUTE_STROKE,    color(  0,   0,   0,  20)); // Light Gray
  viz.setValue(ViewParameter.COMMUTE_WEIGHT,    2);                         // pixels
  
  // Other Parameters
  viz.setValue(ViewParameter.REDUCED_ALPHA,     50);  // 0 - 255
}
