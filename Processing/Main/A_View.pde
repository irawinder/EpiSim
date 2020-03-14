/**
 * Visualization Model
 */
public class View implements ViewModel {
  
  // Dictionaries for View Attributes
  private HashMap<Enum, Integer> viewColor;
  private HashMap<Enum, String> viewName;
  
  /**
   * Construct View Model
   */
  public View() {
    this.viewColor = new HashMap<Enum, Integer>();
    this.viewName = new HashMap<Enum, String>();
  }
  
  /**
   * Add a color and string association to a specified Enum
   *
   * @param e Enum
   * @param col color
   * @param name String
   */
  public void setViewMap(Enum e, Integer col, String name) {
    this.viewColor.put(e, col);
    this.viewName.put(e, name);
  }
  
  /**
   * Get Color Associated with Enum
   *
   * @param e Enum
   * @return color
   */
  public Integer getColor(Enum e) {
    if(this.viewColor.containsKey(e)) {
      return this.viewColor.get(e);
    } else {
      return color(0); // default black
    }
  }
  
  /**
   * Get Name Associated with Enum
   *
   * @param e Enum
   * @return name
   */
  public String getName(Enum e) {
    if(this.viewName.containsKey(e)) {
      return this.viewName.get(e);
    } else {
      return ""; // default blank
    }
  }
  
  /**
   * Expect this to be Overridden by Child Class
   */
  public void draw(Model model) {
    
  }
}

/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends View {
  
  /**
   * Construct EpiView Model
   */
  public EpiView() {
    super();
    
    // Preload Compartment ViewModel
    for(Compartment c : Compartment.values()) {
      this.setViewMap(c, color(0), "");
    }
    
    // Preload Pathogen ViewModel
    for(PathogenType p : PathogenType.values()) {
      this.setViewMap(p, color(0), "");
    }
  }
}

/**
 * City Visualization Model extending Epidemiological Object Model
 */
public class CityView extends EpiView {
  
  private int TEXT_HEIGHT                = 15;  // pixels
  private color TEXT_FILL                = color(  0,   0,   0, 200); // Dark Gray
  
  // Generic Place Parameters
  private color PLACE_STROKE             = color(255, 255, 255, 255); // White
  
  // Generic Agent Parameters
  private int AGENT_DIAMETER             = 10;  // pixels
  private int AGENT_STROKE_WEIGHT        = 3;   // pixels
  
  // Generic Person Parameters
  private int PERSON_DIAMETER            = 5;   // pixels
  private color PERSON_STROKE            = color(  0,   0,   0, 100); // Gray
  
  // Generic Commute Paramters
  private color COMMUTE_STROKE           = color(  0,   0,   0,  20); // Light Gray
  
  // View Mode Settings
  public boolean showPersons = true;
  public boolean showCommutes = true;
  public boolean showPlaces = true;
  public boolean showAgents = true;
  public PersonViewMode personViewMode = PersonViewMode.COMPARTMENT;
  public PathogenType pathogenType = PathogenType.COVID_19;
  
  // Information text
  private String info;
  
  // Graphics (Pre-rendered)
  private PGraphics placeLayer;
  private PGraphics commuteLayer;
  
  /**
   * Construct EpiView Model
   */
  public CityView() {
    super();
    
    // Preload Demographic View Model
    for(Demographic d :Demographic.values()) {
      this.setViewMap(d, color(0), "");
    }
    
    // Preload Land Use View Model
    for(LandUse use: LandUse.values()) {
      this.setViewMap(use, color(0), "");
    }
  }
  
  /**
   * Set Text in Info Pane
   *
   * @param info String
   */
  public void setInfo(String info) {
    this.info = info;
  }
  
  /**
   * Pre Draw Static Graphics Objects
   */
  public void preDraw(CityModel model) {
    this.renderPlaces(model);
    this.renderCommutes(model);
  }
  
  /**
   * Render static image of places to PGraphics object
   *
   * @param model CityModel
   */
  private void renderPlaces(CityModel model) {
    placeLayer = createGraphics(width, height);
    placeLayer.beginDraw();
    for(Environment e : model.getEnvironments()) {
      if(e instanceof Place) {
        Place p = (Place) e;
        this.drawPlace(placeLayer, p);
      }
    }
    placeLayer.endDraw();
  }
  
  /**
   * Render static image of commutes to PGraphics object
   *
   * @param model CityModel
   */
  private void renderCommutes(CityModel model) {
    commuteLayer = createGraphics(width, height);
    commuteLayer.beginDraw();
    for(Host h : model.getHosts()) {
      if(h instanceof Person) {
        Person p = (Person) h;
        this.drawCommute(commuteLayer, p);
      }
    }
    commuteLayer.endDraw();
  }
  
  /**
   * Render ViewModel to Processing Canvas
   *
   * @param mode CityModel
   */
  public void draw(CityModel model) {
    background(255);
    
    // Draw Commutes
    if(showCommutes) {
      image(commuteLayer, 0, 0);
    }
    
    // Draw Places
    if(showPlaces) {
      image(placeLayer, 0, 0);
    }
    
    // Draw Persons
    if(showPersons) {
      for(Host h : model.getHosts()) {
        if(h instanceof Person) {
          Person p = (Person) h;
          this.drawPerson(p);
        }
      }
    }
    
    // Draw Agents
    if(showAgents) {
      for(Agent a : model.getAgents()) {
        this.drawAgent(a);
      }
    }
    
    int X_INDENT = 50;
    
    // Draw Information
    drawInfo(X_INDENT, 100);
    drawTime(model, X_INDENT, height - 125);
    
    // Draw Legends
    drawAgentLegend(X_INDENT, 400);
    drawPlaceLegend(X_INDENT, 500);
    drawPersonLegend(X_INDENT, 650);
  }
  
  /**
   * Render a Single Place
   *
   * @param g PGraphics
   * @param l place
   */
  private void drawPlace(PGraphics g, Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    int w = (int) Math.sqrt(l.getSize());
    color viewColor = this.getColor(l.getUse());
    
    g.stroke(PLACE_STROKE);
    g.fill(viewColor);
    g.rectMode(CENTER);
    g.rect(x, y, w, w);
  }
  
  /**
   * Render a Single Place
   *
   * @param l place
   */
  private void drawPlace(Place l) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    int w = (int) Math.sqrt(l.getSize());
    color viewColor = this.getColor(l.getUse());
    
    stroke(PLACE_STROKE);
    fill(viewColor);
    rectMode(CENTER);
    rect(x, y, w, w);
  }
  
  /**
   * Render a Single Person
   *
   * @param p person
   */
  private void drawPerson(Person p) {
    int x = (int) p.getCoordinate().getX();
    int y = (int) p.getCoordinate().getY();
    color viewColor = color(0); // DEFAULT BLACK
    switch(personViewMode) {
      case DEMOGRAPHIC:
        Demographic d = p.getDemographic();
        viewColor = this.getColor(d);
        break;
      case COMPARTMENT:
        Compartment c = p.getCompartment(pathogenType);
        viewColor = this.getColor(c);
        break;
    }
    
    stroke(PERSON_STROKE);
    fill(viewColor, 150);
    ellipseMode(CENTER);
    ellipse(x, y, PERSON_DIAMETER, PERSON_DIAMETER);
  }
  
  /**
   * Render a Single Person's Commute
   *
   * @param g PGraphics
   * @param p person
   */
  private void drawCommute(PGraphics g, Person p) {
    int x1 = (int) p.getPrimaryPlace().getCoordinate().getX();
    int y1 = (int) p.getPrimaryPlace().getCoordinate().getY();
    int x2 = (int) p.getSecondaryPlace().getCoordinate().getX();
    int y2 = (int) p.getSecondaryPlace().getCoordinate().getY();
    g.stroke(COMMUTE_STROKE);
    g.line(x1, y1, x2, y2);
  }
  
  /**
   * Render a Single Agent
   *
   * @param a agent
   */
  private void drawAgent(Agent a) {
    int x = (int) a.getCoordinate().getX();
    int y = (int) a.getCoordinate().getY();
    PathogenType type = a.getPathogen().getType();
    color viewColor = this.getColor(type);
    
    int alpha;
    if(pathogenType == a.getPathogen().getType()) {
      alpha = 125;
    } else {
      alpha = 25;
    }
    stroke(viewColor, alpha);
    noFill();
    strokeWeight(AGENT_STROKE_WEIGHT);
    ellipseMode(CENTER);
    ellipse(x, y, AGENT_DIAMETER, AGENT_DIAMETER);
    strokeWeight(1);
  }
  
  /**
   * Draw Application Info
   *
   * @param x
   * @param y
   */
  private void drawInfo(int x, int y) {
    fill(TEXT_FILL);
    rectMode(CORNER);
    text(info, x, y, 200, 800);
  }
  
  /**
   * Render a Legend of Person Demographic Types
   *
   * @param x
   * @param y
   */
  private void drawPersonLegend(int x, int y) {
    fill(TEXT_FILL);
    int yOffset = TEXT_HEIGHT/2;
    
    switch(personViewMode) {
      case DEMOGRAPHIC:
        text("Demographic:", x, y);
        for (Demographic d : Demographic.values()) {
          yOffset += TEXT_HEIGHT;
          
          // Create and Draw a Straw-man Host for Lengend Item
          Person p = new Person();
          p.setDemographic(d);
          p.setCoordinate(new Coordinate(x + PERSON_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
          drawPerson(p);
          
          // Draw Symbol Label
          fill(TEXT_FILL);
          text(this.getName(d), x + 4*PERSON_DIAMETER, y + yOffset);
        }
        break;
      case COMPARTMENT:
        text("Pathogen Status:", x, y);
        for (Compartment c : Compartment.values()) {
          yOffset += TEXT_HEIGHT;
          
          // Create and Draw a Straw-man Host for Lengend Item
          Person p = new Person();
          p.setCompartment(pathogenType, c);
          p.setCoordinate(new Coordinate(x + PERSON_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
          drawPerson(p);
          
          // Draw Symbol Label
          fill(TEXT_FILL);
          text(this.getName(c), x + 4*PERSON_DIAMETER, y + yOffset);
        }
        break;
    }
  }
  
  /**
   * Render a Legend of Place Land Use Types
   *
   * @param x
   * @param y
   */
  private void drawPlaceLegend(int x, int y) {
    fill(TEXT_FILL);
    text("Land Uses:", x, y);
    
    // Iterate through all possible host types
    int yOffset = TEXT_HEIGHT/2;
    for (LandUse type : LandUse.values()) {
      yOffset += TEXT_HEIGHT;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Place l = new Place();
      l.setUse(type);
      l.setSize(Math.pow(2*PERSON_DIAMETER, 2));
      l.setCoordinate(new Coordinate(x + PERSON_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
      drawPlace(l);
      
      // Draw Symbol Label
      fill(TEXT_FILL);
      text(this.getName(l.getUse()), x + 4*PERSON_DIAMETER, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Pathogen Types
   *
   * @param x
   * @param y
   */
  private void drawAgentLegend(int x, int y) {
    fill(TEXT_FILL);
    text("Pathogens:", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = TEXT_HEIGHT/2;
    for (PathogenType pT : PathogenType.values()) {
      yOffset += TEXT_HEIGHT;
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      Pathogen p = new Pathogen();
      p.setType(pT);
      a.setPathogen(p);
      a.setCoordinate(new Coordinate(x + PERSON_DIAMETER, y + yOffset - 0.25*TEXT_HEIGHT));
      drawAgent(a);
      
      // Draw Symbol Label
      fill(TEXT_FILL);
      PathogenType type = a.getPathogen().getType();
      text(this.getName(type), x + 4*PERSON_DIAMETER, y + yOffset);
    }
  }
  
  /**
   * Render Time and Phase Info
   *
   * @param x
   * @param y
   */
  private void drawTime(CityModel model, int x, int y) {
    
    int day = (int) model.getTime().convert(TimeUnit.DAY).getAmount();
    int hour = (int) model.getTime().convert(TimeUnit.HOUR).getAmount() % 24;
    int minute = (int) model.getTime().convert(TimeUnit.MINUTE).getAmount() % 60;
    
    String hourString = "";
    if(hour < 10) hourString += "0";
    hourString += hour;
    
    String minString = "";
    if(minute < 10) minString += "0";
    minString += minute;
    
    String dayOfWeek = "";
    if(day % 7 == 0) {
      dayOfWeek = "Sunday";
    } else if(day % 7 == 1) {
      dayOfWeek = "Monday";
    } else if(day % 7 == 2) {
      dayOfWeek = "Tuesday";
    } else if(day % 7 == 3) {
      dayOfWeek = "Wednesay";
    } else if(day % 7 == 4) {
      dayOfWeek = "Thursday";
    } else if(day % 7 == 5) {
      dayOfWeek = "Friday";
    } else if(day % 7 == 6) {
      dayOfWeek = "Saturday";
    }
    
    String text = 
      "Simulation Day: " + (day+1) + "\n" +
      "Day of Week: " + dayOfWeek + "\n" +
      "Simulation Time: " + hourString + ":" + minString + "\n" +
      "Current City Phase: " + model.getPhase();
    
    fill(TEXT_FILL);
    text(text, x, y);
  }
  
}
