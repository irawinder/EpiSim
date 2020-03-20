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
  public CityView(CityModel model) {
    super(model);
    this.personMode = PersonMode.values()[0];
    this.placeMode = PlaceMode.values()[0];
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
    int size = PlaceMode.values().length;
    if(ordinal < size - 1) {
      placeMode = PlaceMode.values()[ordinal + 1];
    } else {
      placeMode = PlaceMode.values()[0];
    }
  }
  
  /**
   * Render ViewModel to Processing Canvas
   *
   * @param mode CityModel
   */
  public void drawCity(CityModel model, int frame) {
    background(255);
    this.setModelLocation();
    
    if(this.resized(this.placeLayer)) preDraw(model);
    
    boolean showCommutes  = this.getToggle(ViewParameter.SHOW_COMMUTES);
    boolean showPlaces    = this.getToggle(ViewParameter.SHOW_PLACES);
    boolean showPersons   = this.getToggle(ViewParameter.SHOW_PERSONS);
    boolean showAgents    = this.getToggle(ViewParameter.SHOW_AGENTS);
    boolean showFrameRate = this.getToggle(ViewParameter.SHOW_FRAMERATE);
    
    int textFill = (int) this.getValue(ViewParameter.TEXT_FILL);
    int textHeight = (int) this.getValue(ViewParameter.TEXT_HEIGHT);
    
    boolean mapToScreen = true;
    
    // Draw Commutes
    if(showCommutes) {
      image(this.commuteLayer, 0, 0);
    }
    
    // Draw Places
    if(showPlaces) {
      switch(this.getPlaceMode()) {
        case LANDUSE:
          image(this.placeLayer, 0, 0);
          break;
        case DENSITY:
          for(Environment e : model.getEnvironments()) {
            if(e instanceof Place) {
              Place p = (Place) e;
              this.drawDensity(p, mapToScreen);
            }
          }
          break;
      }
    }
    
    // Draw Pathogen Agents
    if(showAgents) {
      for(Agent a : model.getAgents()) {
        switch(this.getAgentMode()) {
          case PATHOGEN:
            if(a.getPathogen() == this.getCurrentPathogen()) {
              this.drawAgent(a, mapToScreen);
            }
            break;
          case PATHOGEN_TYPE:
            if(a.getPathogen().getType() == this.getCurrentPathogenType()) {
              this.drawAgent(a, mapToScreen);
            }
            break;
        }
      }
    }
    
    // Draw People
    if(showPersons) {
      for(Host h : model.getHosts()) {
        if(h instanceof Person) {
          Person p = (Person) h;
          switch(this.getPersonMode()) {
            case DEMOGRAPHIC:
              this.drawDemographic(p, frame, mapToScreen);
              break;
            case COMPARTMENT:
              Pathogen pathogen = this.getCurrentPathogen();
              this.drawCompartment(p, pathogen, frame, mapToScreen);
              break;
          }
        }
      }
    }
    
    int generalMargin      = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int infoY              = (int) this.getValue(ViewParameter.INFO_Y);
    int pathogenLegendY    = (int) this.getValue(ViewParameter.PATHOGEN_LEGEND_Y);
    int personLegendY      = (int) this.getValue(ViewParameter.PERSON_LEGEND_Y);
    int placeLegendY       = (int) this.getValue(ViewParameter.PLACE_LEGEND_Y);
    
    // Draw Information
    this.drawInfo(generalMargin, infoY, textFill);
    this.drawTime(model, generalMargin, height - 2*generalMargin, textFill);
    
    String legendName;
    
    // Draw Agent Legend
    legendName = this.getName(this.getAgentMode());
    switch(this.getAgentMode()) {
      case PATHOGEN:
        this.drawPathogenLegend(legendName, generalMargin, pathogenLegendY, textFill, textHeight);
        break;
      case PATHOGEN_TYPE:
        this.drawPathogenTypeLegend(legendName, generalMargin, pathogenLegendY, textFill, textHeight);
        break;
    }
    
    // Draw Place Legend
    legendName = this.getName(this.placeMode);
    switch(this.getPlaceMode()) {
      case LANDUSE:
        this.drawLandUseLegend(legendName, generalMargin, personLegendY, textFill, textHeight);
        break;
      case DENSITY:
        this.drawDensityLegend(legendName, generalMargin, personLegendY, textFill, textHeight);
        break;
    }
    
    // Draw Person Legend
    legendName = this.getName(this.personMode);
    switch(this.getPersonMode()) {
      case DEMOGRAPHIC:
        this.drawDemographicLegend(legendName, generalMargin, placeLegendY, textFill, textHeight);
        break;
      case COMPARTMENT:
        this.drawCompartmentLegend(legendName, generalMargin, placeLegendY, textFill, textHeight);
        break;
    }
    
    if(showFrameRate) text("Framerate: " + frameRate, width - 2*generalMargin, height - 0.5*generalMargin);
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
        this.drawLandUse(placeLayer, p);
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
   * Check for resize event
   */
  private boolean resized(PGraphics p) {
    return p.width != width || p.height != height;
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
  private void drawInfo(int x, int y, color textFill) {
    fill(textFill);
    text(info, x, y);
  }
  
  /**
   * Render a Single Land Use
   *
   * @param g PGraphics
   * @param l place
   */
  protected void drawLandUse(PGraphics g, Place l) {
    int x = this.mapXToScreen(l.getCoordinate().getX());
    int y = this.mapYToScreen(l.getCoordinate().getY());
    double scaler = this.getValue(ViewParameter.ENVIRONMENT_SCALER);
    int w = (int) ( Math.sqrt(l.getSize()) * scaler);
    
    LandUse use = l.getUse();
    color viewFill = this.getColor(use);
    color viewStroke = this.getColor(ViewParameter.ENVIRONMENT_STROKE);
    int alpha = (int) this.getValue(ViewParameter.ENVIRONMENT_ALPHA);
    
    g.stroke(viewStroke);
    g.fill(viewFill, alpha);
    g.rectMode(CENTER);
    g.rect(x, y, w, w);
    g.rectMode(CORNER);
  }
  
  /**
   * Render a Single Land Use
   *
   * @param l place
   */
  protected void drawLandUse(Place l, boolean mapToScreen) {
    int x = (int) l.getCoordinate().getX();
    int y = (int) l.getCoordinate().getY();
    if(mapToScreen) {
      x = this.mapXToScreen(x);
      y = this.mapYToScreen(y);
    }
    double scaler = this.getValue(ViewParameter.ENVIRONMENT_SCALER);
    int w = (int) ( Math.sqrt(l.getSize()) * scaler);
    
    LandUse use = l.getUse();
    color viewFill = this.getColor(use);
    color viewStroke = this.getColor(ViewParameter.ENVIRONMENT_STROKE);
    
    stroke(viewStroke);
    fill(viewFill);
    rectMode(CENTER);
    rect(x, y, w, w);
    rectMode(CORNER);
  }
  
  /**
   * Render a Single Person Demographic
   *
   * @param p person
   * @param pathogenson
   */
  protected void drawDemographic(Person p, int frame, boolean mapToScreen) {
    int framesPerSimulation = (int) this.getValue(ViewParameter.FRAMES_PER_SIMULATION);
    Animated dot = this.getAnimated(p);
    Coordinate location = dot.position(framesPerSimulation, frame, p.getCoordinate());
    int x = (int) location.getX();
    int y = (int) location.getY();
    if(mapToScreen) {
      x = this.mapXToScreen(x);
      y = this.mapYToScreen(y);
    }
    int w = (int) this.getValue(ViewParameter.HOST_DIAMETER);
    Demographic d = p.getDemographic();
    color viewFill = this.getColor(d);
    color viewStroke = this.getColor(ViewParameter.HOST_STROKE);
    int alpha = (int) this.getValue(ViewParameter.HOST_ALPHA);
    
    stroke(viewStroke);
    fill(viewFill, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
  } 
  
  /**
   * Render a Single Person's Commute
   *
   * @param g PGraphics
   * @param p person
   */
  protected void drawCommute(PGraphics g, Person p) {
    int x1 = this.mapXToScreen(p.getPrimaryPlace().getCoordinate().getX());
    int y1 = this.mapYToScreen(p.getPrimaryPlace().getCoordinate().getY());
    int x2 = this.mapXToScreen(p.getSecondaryPlace().getCoordinate().getX());
    int y2 = this.mapYToScreen(p.getSecondaryPlace().getCoordinate().getY());
    color viewStroke = this.getColor(ViewParameter.COMMUTE_STROKE);
    
    g.stroke(viewStroke);
    g.line(x1, y1, x2, y2);
  }
  
  /**
   * Render a Legend of Demographic Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawDemographicLegend(String legendName, int x, int y, color textFill, int textHeight) {
    int w = (int) this.getValue(ViewParameter.HOST_DIAMETER);
    int yOffset = textHeight/2;
    boolean mapToScreen = false;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    for (Demographic d : Demographic.values()) {
      yOffset += textHeight;
      
      // Create a Straw-man Host for Lengend Item
      Person p = new Person();
      p.setDemographic(d);
      p.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawDemographic(p, 0, mapToScreen);
      
      // Draw Symbol Label
      String pName = this.getName(d);
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
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
  protected void drawLandUseLegend(String legendName, int x, int y, color textFill, int textHeight) {
    double scaler = this.getValue(ViewParameter.ENVIRONMENT_SCALER);
    int w = (int) (this.getValue(ViewParameter.ENVIRONMENT_DIAMETER));
    boolean mapToScreen = false;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible place types
    int yOffset = textHeight/2;
    for (LandUse type : LandUse.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Place for Lengend Item
      Place l = new Place();
      l.setUse(type);
      l.setSize(Math.pow(2*w/scaler, 2));
      l.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawLandUse(l, mapToScreen);
      
      // Draw Symbol Label
      String pName = this.getName(l.getUse());
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render Time and Phase Info
   *
   * @param model CityModel
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawTime(CityModel model, int x, int y, color textFill) {
    
    int day = (int) model.getCurrentTime().convert(TimeUnit.DAY).getAmount();
    String clock = model.getCurrentTime().toClock();
    String dayOfWeek = model.getCurrentTime().toDayOfWeek();
    
    String text = 
      "Simulation Day: " + (day+1) + "\n" +
      "Day of Week: " + dayOfWeek + "\n" +
      "Simulation Time: " + clock + "\n" +
      "Current City Phase: " + model.getCurrentPhase();
    
    fill(textFill);
    text(text, x, y);
  }
}
