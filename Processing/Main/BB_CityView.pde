/**
 * City Visualization Model extending Epidemiological Object Model
 */
public class CityView extends EpiView {
  
  // Information text
  private String info;
  
  // Graphics (Pre-rendered)
  private PGraphics placeLayer;
  private PGraphics commuteLayer;
  
  // View Mode Setting
  private PersonMode personMode;
  private PlaceMode placeMode;
  
  /**
   * Construct EpiView Model
   */
  public CityView() {
    super();
    
    personMode = PersonMode.values()[0];
    placeMode = PlaceMode.values()[0];
  }
  
  /**
   * Set Person Mode in View Model
   *
   * @param pM PersonMode
   */
  public void setPersonMode(PersonMode pM) {
    this.personMode = pM;
  }
  
  /**
   * Set Place Mode in View Model
   *
   * @param pM PlaceMode
   */
  public void setPlaceMode(PlaceMode pM) {
    this.placeMode = pM;
  }
  
  /**
   * Get Person Mode in View Model
   */
  public PersonMode getPersonMode() {
    return this.personMode;
  }
  
  /**
   * Get Place Mode in View Model
   */
  public PlaceMode getPlaceMode() {
    return this.placeMode;
  }
  
  /**
   * Next Person Mode in View Model
   */
  public void nextPersonMode() {
    int ordinal = personMode.ordinal();
    int size = PersonMode.values().length;
    if(ordinal < size - 1) {
      personMode = PersonMode.values()[ordinal + 1];
    } else {
      personMode = PersonMode.values()[0];
    }
  }
  
  /**
   * Next Place Mode in View Model
   */
  public void nextPlaceMode() {
    int ordinal = placeMode.ordinal();
    int size = PathogenType.values().length;
    if(ordinal < size - 1) {
      placeMode = PlaceMode.values()[ordinal + 1];
    } else {
      placeMode = PlaceMode.values()[0];
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
    
    boolean showCommutes = this.getToggle(ViewParameter.SHOW_COMMUTES);
    boolean showPlaces   = this.getToggle(ViewParameter.SHOW_PLACES);
    boolean showPersons  = this.getToggle(ViewParameter.SHOW_PERSONS);
    boolean showAgents   = this.getToggle(ViewParameter.SHOW_AGENTS);
    
    int textFill = (int) this.getValue(ViewParameter.TEXT_FILL);
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    
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
    drawInfo(X_INDENT, 100, textFill);
    drawTime(model, X_INDENT, height - 125, textFill);
    
    // Draw Legends
    drawAgentLegend(X_INDENT, 400, textFill, textHeight);
    drawPlaceLegend(X_INDENT, 500, textFill, textHeight);
    drawPersonLegend(X_INDENT, 650, textFill, textHeight);
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
    color viewStroke = this.getColor(ViewParameter.PLACE_STROKE);
    
    g.stroke(viewStroke);
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
    color viewFill = this.getColor(l.getUse());
    color viewStroke = this.getColor(ViewParameter.PLACE_STROKE);
    
    stroke(viewStroke);
    fill(viewFill);
    rectMode(CENTER);
    rect(x, y, w, w);
    rectMode(CORNER);
  }
  
  /**
   * Render a Single Person
   *
   * @param p person
   */
  private void drawPerson(Person p) {
    int x = (int) p.getCoordinate().getX();
    int y = (int) p.getCoordinate().getY();
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    color viewFill = color(0); // black by default
    color viewStroke = this.getColor(ViewParameter.PERSON_STROKE);
    
    switch(this.personMode) {
      case DEMOGRAPHIC:
        Demographic d = p.getDemographic();
        viewFill = this.getColor(d);
        break;
      case COMPARTMENT:
        Compartment c = p.getCompartment(this.getPathogenMode());
        viewFill = this.getColor(c);
        break;
    }
    
    stroke(viewStroke);
    fill(viewFill, 150);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
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
    color viewStroke = this.getColor(ViewParameter.COMMUTE_STROKE);
    
    g.stroke(viewStroke);
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
    int w = (int) this.getValue(ViewParameter.AGENT_DIAMETER);
    int viewWeight = (int) this.getValue(ViewParameter.AGENT_WEIGHT);
    PathogenType aType = a.getPathogen().getType();
    color viewStroke = this.getColor(aType);
    int alpha = (int) this.getValue(ViewParameter.AGENT_ALPHA);
    
    if(aType != this.getPathogenMode()) {
      alpha = (int) this.getValue(ViewParameter.REDUCED_ALPHA);
    }
    
    stroke(viewStroke, alpha);
    noFill();
    strokeWeight(viewWeight);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
    strokeWeight(1); // processing default
  }
  
  /**
   * Draw Application Info
   *
   * @param x
   * @param y
   */
  private void drawInfo(int x, int y, color textFill) {
    fill(textFill);
    text(info, x, y, 200, 800);
  }
  
  /**
   * Render a Legend of Person Demographic Types
   *
   * @param x
   * @param y
   */
  private void drawPersonLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.personMode);
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    int yOffset = textHeight/2;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
        
    switch(this.getPersonMode()) {
      case DEMOGRAPHIC:
        for (Demographic d : Demographic.values()) {
          yOffset += textHeight;
          
          // Create a Straw-man Host for Lengend Item
          Person p = new Person();
          p.setDemographic(d);
          p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
          drawPerson(p);
          
          // Draw Symbol Label
          String pName = this.getName(d);
          fill(textFill);
          text(pName, x + 4*w, y + yOffset);
        }
        break;
      case COMPARTMENT:
        for (Compartment c : Compartment.values()) {
          yOffset += textHeight;
          
          // Create and Draw a Straw-man Host for Lengend Item
          Person p = new Person();
          PathogenType pType = this.getPathogenMode();
          p.setCompartment(pType, c);
          p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
          drawPerson(p);
          
          // Draw Symbol Label
          String pName = this.getName(c);
          fill(textFill);
          text(pName, x + 4*w, y + yOffset);
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
  private void drawPlaceLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.placeMode);
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible place types
    int yOffset = textHeight/2;
    for (LandUse type : LandUse.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Place l = new Place();
      l.setUse(type);
      l.setSize(Math.pow(2*w, 2));
      l.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawPlace(l);
      
      // Draw Symbol Label
      String pName = this.getName(l.getUse());
      fill(textFill);
      text(pName, x + 4*w, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Pathogen Types
   *
   * @param x
   * @param y
   */
  private void drawAgentLegend(int x, int y, color textFill, int textHeight) {
    String legendName = "Pathogen Mode";
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = textHeight/2;
    for (PathogenType pT : PathogenType.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      Pathogen p = new Pathogen();
      p.setType(pT);
      a.setPathogen(p);
      a.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawAgent(a);
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill);
      text(aName, x + 4*w, y + yOffset);
    }
  }
  
  /**
   * Render Time and Phase Info
   *
   * @param x
   * @param y
   */
  private void drawTime(CityModel model, int x, int y, color textFill) {
    
    int day = (int) model.getTime().convert(TimeUnit.DAY).getAmount();
    String clock = model.getTime().toClock();
    String dayOfWeek = model.getTime().toDayOfWeek();
    
    String text = 
      "Simulation Day: " + (day+1) + "\n" +
      "Day of Week: " + dayOfWeek + "\n" +
      "Simulation Time: " + clock + "\n" +
      "Current City Phase: " + model.getPhase();
    
    fill(textFill);
    text(text, x, y);
  }
  
}
