/**
 * Visualization Model for Epidemiological Object Model
 */
public class ViewModel {
  
  // Object Model in need of visual representation
  public EpiModel model;
  
  // Color Definition:
  // color(red, green, blue, alpha) where values are between 0 and 255
  
  // Graphics Constants
  public final color EDGE_STROKE              = color(  0,   0,   0,  25); // Light Gray
  public final color POLYGON_STROKE           = color(255, 255, 255, 255); // White
  public final color NODE_STROKE              = color(  0,   0,   0, 200); // Dark Gray
  public final color DEFAULT_FILL             = color(255, 255, 255, 255); // White
  public final color DEFAULT_TEXT_FILL        = color(  0,   0,   0, 200); // Dark Gray
  
  public final int HOST_DIAMETER              = 5; // pixels
  public final int TEXT_HEIGHT                = 15; // pixels
  
  // Host Demographic Names
  public final String CHILD_NAME              = "Child";
  public final String ADULT_NAME              = "Adult";
  public final String SENIOR_NAME             = "Senior";
  
  // Host Demographic Colors
  public final color CHILD_COLOR              = color(255,   0, 255, 200); // Magenta
  public final color ADULT_COLOR              = color(255, 255,   0, 200); // Yellow
  public final color SENIOR_COLOR             = color(  0, 255, 255, 200); // Teal
  
  // Environment Names
  public final String DWELLING_NAME           = "Dwelling Unit";
  public final String OFFICE_NAME             = "Office Space";
  public final String RETAIL_NAME             = "Retail Space";
  public final String SCHOOL_NAME             = "School or Daycare";
  public final String OPENSPACE_NAME          = "Open Space";
  public final String HOSPITAL_NAME           = "Hospital";
  
  // Environment Colors
  public final color DWELLING_COLOR           = color(100, 100, 100, 200); // Gray
  public final color OFFICE_COLOR             = color( 50,  50, 200, 200); // Blue
  public final color RETAIL_COLOR             = color(200,  50, 200, 200); // Magenta
  public final color SCHOOL_COLOR             = color(200, 100,  50, 200); // Brown
  public final color OPENSPACE_COLOR          = color( 50, 200,  50, 100); // Green
  public final color HOSPITAL_COLOR           = color(  0, 255, 255, 200); // Teal
  
  // Compartment Names
  public final String SUSCEPTIBLE_NAME        = "Susceptible";
  public final String EXPOSED_NAME            = "Exposed";
  public final String INFECTIOUS_NAME         = "Infectious";
  public final String RECOVERED_NAME          = "Recovered";
  public final String DEAD_NAME               = "Dead";
  
  // Compartment Colors
  public final color SUSCEPTIBLE_COLOR        = color(100, 100, 100, 255); // White
  public final color EXPOSED_COLOR            = color( 50,  50, 200, 255); // Yellow
  public final color INFECTIOUS_COLOR         = color(200,  50,  50, 255); // Dark Red
  public final color RECOVERED_COLOR          = color(  0,   0,   0, 255); // Black
  public final color DEAD_COLOR               = color(200,   0, 200, 255); // Magenta
  
  // Pathogen Names
  public final String COVID_19_NAME           = "Covid-19";
  public final String INFLUENZA_NAME          = "Influenza";
  public final String COMMON_COLD_NAME        = "Common Cold";
  
  // Pathogen Colors
  public final color COVID_19_COLOR           = color(255,   0,   0, 255); // Red
  public final color INFLUENZA_COLOR          = color(  0, 255,   0, 255); // Green
  public final color COMMON_COLD_COLOR        = color(  0,   0, 255, 255); // Blue
  
  // Dictionaries for View Attributes
  private HashMap<Enum, Integer> viewColor;
  private HashMap<Enum, String> viewName;
  
  public ViewModel() {
    
    // Make color map
    viewColor = new HashMap<Enum, Integer>();
    viewColor.put(Demographic.CHILD, CHILD_COLOR);
    viewColor.put(Demographic.ADULT, ADULT_COLOR);
    viewColor.put(Demographic.SENIOR, SENIOR_COLOR);
    viewColor.put(LandUse.DWELLING, DWELLING_COLOR);
    viewColor.put(LandUse.OFFICE, OFFICE_COLOR);
    viewColor.put(LandUse.RETAIL, RETAIL_COLOR);
    viewColor.put(LandUse.SCHOOL, SCHOOL_COLOR);
    viewColor.put(LandUse.OPENSPACE, OPENSPACE_COLOR);
    viewColor.put(LandUse.HOSPITAL, HOSPITAL_COLOR);
    viewColor.put(Compartment.SUSCEPTIBLE, SUSCEPTIBLE_COLOR);
    viewColor.put(Compartment.EXPOSED, EXPOSED_COLOR);
    viewColor.put(Compartment.INFECTIOUS, INFECTIOUS_COLOR);
    viewColor.put(Compartment.RECOVERED, RECOVERED_COLOR);
    viewColor.put(Compartment.DEAD, DEAD_COLOR);
    viewColor.put(Pathogen.COVID_19, COVID_19_COLOR);
    viewColor.put(Pathogen.INFLUENZA, INFLUENZA_COLOR);
    viewColor.put(Pathogen.COMMON_COLD, COMMON_COLD_COLOR);

    // Make name map
    viewName = new HashMap<Enum, String>();
    viewName.put(Demographic.CHILD, CHILD_NAME);
    viewName.put(Demographic.ADULT, ADULT_NAME);
    viewName.put(Demographic.SENIOR, SENIOR_NAME);
    viewName.put(LandUse.DWELLING, DWELLING_NAME);
    viewName.put(LandUse.OFFICE, OFFICE_NAME);
    viewName.put(LandUse.RETAIL, RETAIL_NAME);
    viewName.put(LandUse.SCHOOL, SCHOOL_NAME);
    viewName.put(LandUse.OPENSPACE, OPENSPACE_NAME);
    viewName.put(LandUse.HOSPITAL, HOSPITAL_NAME);
    viewName.put(Compartment.SUSCEPTIBLE, SUSCEPTIBLE_NAME);
    viewName.put(Compartment.EXPOSED, EXPOSED_NAME);
    viewName.put(Compartment.INFECTIOUS, INFECTIOUS_NAME);
    viewName.put(Compartment.RECOVERED, RECOVERED_NAME);
    viewName.put(Compartment.DEAD, DEAD_NAME);
    viewName.put(Pathogen.COVID_19, COVID_19_NAME);
    viewName.put(Pathogen.INFLUENZA, INFLUENZA_NAME);
    viewName.put(Pathogen.COMMON_COLD, COMMON_COLD_NAME);
  }
  
  /**
   * Set the Object Model to be viewed
   */
  public void setModel(EpiModel model) {
    this.model = model;
  }
  
  /**
   * Get color associated with Enviroment
   */
  public color getColor(Environment e) {
    color col; 
    LandUse type = e.getUse();
    if(viewColor.containsKey(type)) {
      col = viewColor.get(type);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Enviroment
   */
  public String getName(Environment e) {
    String name; 
    LandUse type = e.getUse();
    if(viewColor.containsKey(type)) {
      name = viewName.get(type);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with Enviroment Type
   */
  public color getColor(LandUse type) {
    color col;
    if(viewColor.containsKey(type)) {
      col = viewColor.get(type);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Enviroment Type
   */
  public String getName(LandUse type) {
    String name;
    if(viewName.containsKey(type)) {
      name = viewName.get(type);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with Compartment type
   */
  public color getColor(Compartment status) {
    color col; 
    if(viewColor.containsKey(status)) {
      col = viewColor.get(status);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Compartment type
   */
  public String getName(Compartment status) {
    String name; 
    if(viewName.containsKey(status)) {
      name = viewName.get(status);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with Host Demographic
   */
  public color getColor(Host h) {
    Demographic d = h.getDemographic();
    color col; 
    if(viewColor.containsKey(d)) {
      col = viewColor.get(d);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Host Demographic
   */
  public String getName(Host h) {
    Demographic d = h.getDemographic();
    String name; 
    if(viewName.containsKey(d)) {
      name = viewName.get(d);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with Host Compartment for specified Pathogen
   */
  public color getColor(Host h, Pathogen type) {
    Compartment status = h.getCompartment(type);
    color col; 
    if(viewColor.containsKey(status)) {
      col = viewColor.get(status);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Host Compartment for specified Pathogen
   */
  public String getName(Host h, Pathogen type) {
    Compartment status = h.getCompartment(type);
    String name; 
    if(viewName.containsKey(status)) {
      name = viewName.get(status);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Expect this to be Overridden by Child Class
   */
  public void draw() {
    
  }
}

class SimpleViewModel extends ViewModel {
  
  public SimpleViewModel() {
    super();
    init();
  }
  
  private void init() {
  }
  
  @Override
  public void draw() {
    background(255);
    
    // Draw Commutes
    for(Host h : model.getHosts()) {
      this.drawCommute(h);
    }
    
    // Draw Environment
    for(Environment e : model.getEnvironments()) {
      this.drawEnvironment(e);
    }
    
    // Draw People
    for(Host h : model.getHosts()) {
      this.drawHost(h);
    }
    
    // Draw Legends:
    drawEnvironmentLegend(100, 100);
    drawHostLegend(100, 230);
  }
  
  private void drawEnvironment(Environment e) {
    int x = (int) e.getCoordinate().getX();
    int y = (int) e.getCoordinate().getY();
    int w = (int) Math.sqrt(e.getArea());
    color viewColor = this.getColor(e);
    
    stroke(POLYGON_STROKE);
    fill(viewColor);
    rectMode(CENTER);
    rect(x, y, w, w);
  }
  
  private void drawHost(Host h) {
    int x = (int) h.getCoordinate().getX();
    int y = (int) h.getCoordinate().getY();
    color viewColor = this.getColor(h);
    
    stroke(this.NODE_STROKE);
    fill(viewColor);
    ellipseMode(CENTER);
    ellipse(x, y, HOST_DIAMETER, HOST_DIAMETER);
  }
  
  private void drawCommute(Host h) {
    int x1 = (int) h.getPrimaryEnvironment().getCoordinate().getX();
    int y1 = (int) h.getPrimaryEnvironment().getCoordinate().getY();
    int x2 = (int) h.getSecondaryEnvironment().getCoordinate().getX();
    int y2 = (int) h.getSecondaryEnvironment().getCoordinate().getY();
    stroke(EDGE_STROKE);
    line(x1, y1, x2, y2);
  }
  
  private void drawHostLegend(int x, int y) {
    fill(DEFAULT_TEXT_FILL);
    text("Demographics:", x, y);
    
    // Iterate through all possible host types
    int yOffset = TEXT_HEIGHT/2;
    for (Demographic d : Demographic.values()) {
      yOffset += TEXT_HEIGHT;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Host h = new Host();
      h.setDemographic(d);
      h.setCoordinate(new Coordinate(x + HOST_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
      drawHost(h);
      
      // Draw Symbol Label
      fill(DEFAULT_TEXT_FILL);
      text(this.getName(h), x + 4*HOST_DIAMETER, y + yOffset);
    }
  }
  
  private void drawEnvironmentLegend(int x, int y) {
    fill(DEFAULT_TEXT_FILL);
    text("Land Uses:", x, y);
    
    // Iterate through all possible host types
    int yOffset = TEXT_HEIGHT/2;
    for (LandUse type : LandUse.values()) {
      yOffset += TEXT_HEIGHT;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Environment e = new Environment();
      e.setUse(type);
      e.setArea(50);
      e.setCoordinate(new Coordinate(x + HOST_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
      drawEnvironment(e);
      
      // Draw Symbol Label
      fill(DEFAULT_TEXT_FILL);
      text(this.getName(e), x + 4*HOST_DIAMETER, y + yOffset);
    }
  }
}
