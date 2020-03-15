/**
 * Configure City View Model
 */
public void configView() {
  
  // Default View Mode Settings
  viz.setToggle(ViewParameter.SHOW_PERSONS,     true);
  viz.setToggle(ViewParameter.SHOW_COMMUTES,    true);
  viz.setToggle(ViewParameter.SHOW_PLACES,      true);
  viz.setToggle(ViewParameter.SHOW_AGENTS,      true);
  
  viz.setPathogenMode(PathogenType.COVID_19);
  viz.setPersonMode(PersonMode.DEMOGRAPHIC);
  viz.setPlaceMode(PlaceMode.LANDUSE);
  
  String info = 
    "Epidemic Simulation" + "\n" +
    "EDGEof Planetary Insight Center" + "\n\n" +
    "Layer Controls:" + "\n" +
    "Press '1' to hide/show Places" + "\n" +
    "Press '2' to hide/show Persons" + "\n" +
    "Press '3' to hide/show Commutes" + "\n" +
    "Press '4' to hide/show Pathogens" + "\n" +
    "Press 'p' to toggle Pathogen" + "\n" +
    "Press 's' to toggle Person Status" + "\n\n" +
    //"Press 'l' to toggle Place Status" + "\n\n" +
    
    "Simulation Controls:" + "\n" +
    "Press 'r' to regenerate random city" + "\n" +
    "Press 't' to iterate one time step" + "\n" +
    "Press 'a' to autoplay simulation" + "\n" +
    "Press 'w' to send everyone to work" + "\n" +
    "Press 'h' to send everyone home" + "\n";
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
  viz.setName(PathogenType.COVID_19,           "Covid-2019");
  viz.setName(PathogenType.COMMON_COLD,        "Common Cold");
  
  // Pathogen Colors
  viz.setColor(PathogenType.COVID_19,          color(255,   0,   0, 230)); // Red
  viz.setColor(PathogenType.COMMON_COLD,       color(  0,   0, 255, 230)); // Blue
  
  // Host Demographic Names
  viz.setName(Demographic.CHILD,               "Child");
  viz.setName(Demographic.ADULT,               "Adult");
  viz.setName(Demographic.SENIOR,              "Senior");
  
  // Host Demographic Colors
  viz.setColor(Demographic.CHILD,              color(255, 255, 255, 230)); // Light Gray
  viz.setColor(Demographic.ADULT,              color(100, 100, 100, 230)); // Dark Gray
  viz.setColor(Demographic.SENIOR,             color(  0,   0,   0, 230)); // Black
  
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
  viz.setName(PersonMode.DEMOGRAPHIC,           "Demographic");
  viz.setName(PersonMode.COMPARTMENT,           "Pathogen Status");
  viz.setName(PlaceMode.LANDUSE,                "Land Use");
  viz.setName(PlaceMode.DENSITY,                "Denisty");

  // Text Settings
  viz.setValue(ViewParameter.TEXT_HEIGHT,        15);  // pixels
  viz.setValue(ViewParameter.TEXT_FILL,          color(  0,   0,   0, 200)); // Dark Gray
  
  // Generic Place Parameters
  viz.setValue(ViewParameter.PLACE_SCALE,        1.0);  // scaler
  viz.setColor(ViewParameter.PLACE_STROKE,       color(255, 255, 255, 255)); // White
  viz.setValue(ViewParameter.PLACE_DIAMETER,     5);  // scaler
  
  // Generic Agent Parameters
  viz.setValue(ViewParameter.AGENT_DIAMETER,     10);  // pixels
  viz.setValue(ViewParameter.AGENT_WEIGHT,       3);   // pixels
  viz.setValue(ViewParameter.AGENT_ALPHA,        125); // 0 - 255
  
  // Generic Person Parameters
  viz.setValue(ViewParameter.PERSON_DIAMETER,    5);   // pixels
  viz.setColor(ViewParameter.PERSON_STROKE,      color(  0,   0,   0, 100)); // Gray
  
  // Generic Commute Paramters
  viz.setColor(ViewParameter.COMMUTE_STROKE,     color(  0,   0,   0,  20)); // Light Gray
  viz.setValue(ViewParameter.COMMUTE_WEIGHT,     1);   // pixels
  
  // Other Parameters
  viz.setValue(ViewParameter.REDUCED_ALPHA,      25); // 0 - 255
}
