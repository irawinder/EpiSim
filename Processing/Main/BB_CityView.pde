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
    
    Pathogen pathogen = getCurrentPathogen(model);
    
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
          this.drawPerson(p, pathogen);
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
    drawInfo(X_INDENT, 100, 250, 800, textFill);
    drawTime(model, X_INDENT, height - 125, textFill);
    
    // Draw Legends
    drawPathogenLegend(model, X_INDENT, 400, textFill, textHeight);
    drawPlaceLegend(X_INDENT, 500, textFill, textHeight);
    drawPersonLegend(X_INDENT, 650, textFill, textHeight);
  }
  
  /**
   * Render a Single Place
   *
   * @param g PGraphics
   * @param l place
   */
  protected void drawPlace(PGraphics g, Place l) {
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
  protected void drawPlace(Place l) {
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
   * @param pathogenson
   */
  protected void drawPerson(Person p, Pathogen pathogen) {
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
        Compartment c = p.getCompartment(pathogen);
        viewFill = this.getColor(c);
        break;
    }
    
    stroke(viewStroke);
    fill(viewFill, 150);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
  }
  
  /**
   * Render a Single Person
   *
   * @param p person
   */
  protected void drawPerson(Person p) {
    Pathogen pathogen = new Pathogen();
    this.drawPerson(p, pathogen);
  }
  
  /**
   * Render a Single Person's Commute
   *
   * @param g PGraphics
   * @param p person
   */
  protected void drawCommute(PGraphics g, Person p) {
    int x1 = (int) p.getPrimaryPlace().getCoordinate().getX();
    int y1 = (int) p.getPrimaryPlace().getCoordinate().getY();
    int x2 = (int) p.getSecondaryPlace().getCoordinate().getX();
    int y2 = (int) p.getSecondaryPlace().getCoordinate().getY();
    color viewStroke = this.getColor(ViewParameter.COMMUTE_STROKE);
    
    g.stroke(viewStroke);
    g.line(x1, y1, x2, y2);
  }
  
  /**
   * Draw Application Info
   *
   * @param x
   * @param y
   * @param w
   * @param h
   * @param textFill color
   */
  private void drawInfo(int x, int y, int w, int h, color textFill) {
    fill(textFill);
    text(info, x, y, w, h);
  }
  
  /**
   * Render a Legend of Person Demographic Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPersonLegend(int x, int y, color textFill, int textHeight) {
    String legendName;
    int w = (int) this.getValue(ViewParameter.PERSON_DIAMETER);
    int yOffset = textHeight/2;
    
    switch(this.getPersonMode()) {
      case DEMOGRAPHIC:
        
        // Draw Legend Name
        legendName = this.getName(this.personMode);
        fill(textFill);
        text(legendName + ":", x, y);
        
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
          text(pName, x + 1.5*textHeight, y + yOffset);
        }
        break;
      case COMPARTMENT:
      
        // Draw Legend Name
        legendName = this.getName(this.getPathogenMode()) + " Status";
        fill(textFill);
        text(legendName + ":", x, y);
        
        for (Compartment c : Compartment.values()) {
          yOffset += textHeight;
          
          // Create and Draw a Straw-man Host for Lengend Item
          Person p = new Person();
          Pathogen pathogen = new Pathogen();
          p.setCompartment(pathogen, c);
          p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
          drawPerson(p, pathogen);
          
          // Draw Symbol Label
          String pName = this.getName(c);
          fill(textFill);
          text(pName, x + 1.5*textHeight, y + yOffset);
        }
        break;
    }
  }
  
  /**
   * Render a Legend of Place Land Use Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPlaceLegend(int x, int y, color textFill, int textHeight) {
    String legendName = this.getName(this.placeMode);
    int w = (int) this.getValue(ViewParameter.PLACE_DIAMETER);
    
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
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render Time and Phase Info
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawTime(CityModel model, int x, int y, color textFill) {
    
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
  
  public Pathogen getCurrentPathogen(CityModel model) {
    for(Pathogen p : model.getPathogens()) {
      if (p.getType() == this.getPathogenMode()) {
        return p;
      }
    }
    return new Pathogen();
  }
}
