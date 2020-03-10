/**
 * Visualization Model for Epidemiological Object Model
 */
public class ViewModel {
  
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
  
  // AgentStatus Names
  public final String SUSCEPTIBLE_NAME        = "Susceptible";
  public final String INCUBATING_NAME         = "Incubating";
  public final String INFECTIOUS_MILD_NAME    = "Mildly Infectious";
  public final String INFECTIOUS_SEVERE_NAME  = "Severely Infectious";
  public final String CONVALESCENT_NAME       = "Convalescent";
  public final String HOSPITALIZED_NAME       = "Hospitalized";
  public final String RECOVERED_NAME          = "Recovered";
  public final String DEAD_NAME               = "Dead";
  
  // AgentStatus Colors
  public final color SUSCEPTIBLE_COLOR        = color(100, 100, 100, 255); // White
  public final color INCUBATING_COLOR         = color( 50,  50, 200, 255); // Yellow
  public final color INFECTIOUS_MILD_COLOR    = color(200,  50, 200, 255); // Light Red
  public final color INFECTIOUS_SEVERE_COLOR  = color(200,  50,  50, 255); // Dark Red
  public final color CONVALESCENT_COLOR       = color(200, 200,  50, 255); // Yellow
  public final color HOSPITALIZED_COLOR       = color(200, 150,  50, 255); // Orange
  public final color RECOVERED_COLOR          = color(  0,   0,   0, 255); // Black
  public final color DEAD_COLOR               = color(200,   0, 200, 255); // Magenta
  
  // AgentType Names
  public final String COVID_19_NAME           = "Covid-19";
  public final String INFLUENZA_NAME          = "Influenza";
  public final String COMMON_COLD_NAME        = "Common Cold";
  
  // AgentType Colors
  public final color COVID_19_COLOR           = color(255,   0,   0, 255); // Red
  public final color INFLUENZA_COLOR          = color(  0, 255,   0, 255); // Green
  public final color COMMON_COLD_COLOR        = color(  0,   0, 255, 255); // Blue
  
  private HashMap<Enum, Integer> viewColor;
  private HashMap<Enum, String> viewName;
  
  public EpiModel model;
  
  public ViewModel() {
    
    // Make color map
    viewColor = new HashMap<Enum, Integer>();
    viewColor.put(HostDemographic.CHILD, CHILD_COLOR);
    viewColor.put(HostDemographic.ADULT, ADULT_COLOR);
    viewColor.put(HostDemographic.SENIOR, SENIOR_COLOR);
    viewColor.put(EnvironmentType.DWELLING, DWELLING_COLOR);
    viewColor.put(EnvironmentType.OFFICE, OFFICE_COLOR);
    viewColor.put(EnvironmentType.RETAIL, RETAIL_COLOR);
    viewColor.put(EnvironmentType.SCHOOL, SCHOOL_COLOR);
    viewColor.put(EnvironmentType.OPENSPACE, OPENSPACE_COLOR);
    viewColor.put(EnvironmentType.HOSPITAL, HOSPITAL_COLOR);
    viewColor.put(AgentStatus.SUSCEPTIBLE, SUSCEPTIBLE_COLOR);
    viewColor.put(AgentStatus.INCUBATING, INCUBATING_COLOR);
    viewColor.put(AgentStatus.INFECTIOUS_MILD, INFECTIOUS_MILD_COLOR);
    viewColor.put(AgentStatus.INFECTIOUS_SEVERE, INFECTIOUS_SEVERE_COLOR);
    viewColor.put(AgentStatus.CONVALESCENT, CONVALESCENT_COLOR);
    viewColor.put(AgentStatus.HOSPITALIZED, HOSPITALIZED_COLOR);
    viewColor.put(AgentStatus.RECOVERED, RECOVERED_COLOR);
    viewColor.put(AgentStatus.DEAD, DEAD_COLOR);
    viewColor.put(AgentType.COVID_19, COVID_19_COLOR);
    viewColor.put(AgentType.INFLUENZA, INFLUENZA_COLOR);
    viewColor.put(AgentType.COMMON_COLD, COMMON_COLD_COLOR);

    // Make name map
    viewName = new HashMap<Enum, String>();
    viewName.put(HostDemographic.CHILD, CHILD_NAME);
    viewName.put(HostDemographic.ADULT, ADULT_NAME);
    viewName.put(HostDemographic.SENIOR, SENIOR_NAME);
    viewName.put(EnvironmentType.DWELLING, DWELLING_NAME);
    viewName.put(EnvironmentType.OFFICE, OFFICE_NAME);
    viewName.put(EnvironmentType.RETAIL, RETAIL_NAME);
    viewName.put(EnvironmentType.SCHOOL, SCHOOL_NAME);
    viewName.put(EnvironmentType.OPENSPACE, OPENSPACE_NAME);
    viewName.put(EnvironmentType.HOSPITAL, HOSPITAL_NAME);
    viewName.put(AgentStatus.SUSCEPTIBLE, SUSCEPTIBLE_NAME);
    viewName.put(AgentStatus.INCUBATING, INCUBATING_NAME);
    viewName.put(AgentStatus.INFECTIOUS_MILD, INFECTIOUS_MILD_NAME);
    viewName.put(AgentStatus.INFECTIOUS_SEVERE, INFECTIOUS_SEVERE_NAME);
    viewName.put(AgentStatus.CONVALESCENT, CONVALESCENT_NAME);
    viewName.put(AgentStatus.HOSPITALIZED, HOSPITALIZED_NAME);
    viewName.put(AgentStatus.RECOVERED, RECOVERED_NAME);
    viewName.put(AgentStatus.DEAD, DEAD_NAME);
    viewName.put(AgentType.COVID_19, COVID_19_NAME);
    viewName.put(AgentType.INFLUENZA, INFLUENZA_NAME);
    viewName.put(AgentType.COMMON_COLD, COMMON_COLD_NAME);
  }
  
  public void setModel(EpiModel model) {
    this.model = model;
  }
  
  /**
   * Get color associated with Enviroment
   */
  public color getColor(Environment e) {
    color col; 
    EnvironmentType type = e.getType();
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
    EnvironmentType type = e.getType();
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
  public color getColor(EnvironmentType type) {
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
  public String getName(EnvironmentType type) {
    String name;
    if(viewName.containsKey(type)) {
      name = viewName.get(type);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with AgentStatus type
   */
  public color getColor(AgentStatus status) {
    color col; 
    if(viewColor.containsKey(status)) {
      col = viewColor.get(status);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with AgentStatus type
   */
  public String getName(AgentStatus status) {
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
    HostDemographic d = h.getDemographic();
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
    HostDemographic d = h.getDemographic();
    String name; 
    if(viewName.containsKey(d)) {
      name = viewName.get(d);
    } else {
      name = ""; // default blank
    }
    return name;
  }
  
  /**
   * Get color associated with Host AgentStatus for specified AgentType
   */
  public color getColor(Host h, AgentType type) {
    AgentStatus status = h.getStatus(type);
    color col; 
    if(viewColor.containsKey(status)) {
      col = viewColor.get(status);
    } else {
      col = color(0); // default black
    }
    return col;
  }
  
  /**
   * Get name associated with Host AgentStatus for specified AgentType
   */
  public String getName(Host h, AgentType type) {
    AgentStatus status = h.getStatus(type);
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
    text("Host Demographics:", x, y);
    
    // Iterate through all possible host types
    int yOffset = TEXT_HEIGHT/2;
    for (HostDemographic d : HostDemographic.values()) {
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
    text("Environment Types:", x, y);
    
    // Iterate through all possible host types
    int yOffset = TEXT_HEIGHT/2;
    for (EnvironmentType eT : EnvironmentType.values()) {
      yOffset += TEXT_HEIGHT;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Environment e = new Environment();
      e.setType(eT);
      e.setArea(50);
      e.setCoordinate(new Coordinate(x + HOST_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
      drawEnvironment(e);
      
      // Draw Symbol Label
      fill(DEFAULT_TEXT_FILL);
      text(this.getName(e), x + 4*HOST_DIAMETER, y + yOffset);
    }
  }
}
