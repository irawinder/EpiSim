/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends View {
  
  // View States
  private PathogenMode pathogenMode;
  private PathogenType pathogenType;
  int pathogenViewIndex;
  
  // List of Pathogens in Model
  ArrayList<Pathogen> pathogenList;
  
  /**
   * Construct EpiView Model
   */
  public EpiView(EpiModel model) {
    super();
    
    // View States
    pathogenMode = PathogenMode.values()[0];
    pathogenType = PathogenType.values()[0];
    pathogenViewIndex = 0;
    
    // List of Pathogens in Model
    pathogenList = model.getPathogens();
  }
  
  /**
   * Expect this to be Overridden by Child Class
   */
  public void draw(Model model) {
    
  }
  
  /**
   * Set PathogenMode in View Model
   */
  public void setPathogenMode(PathogenMode pMode) {
    this.pathogenMode = pMode;
  }
  
  /**
   * Get PathogenMode in View Model
   */
  public PathogenMode getPathogenMode() {
    return this.pathogenMode;
  }
  
  /**
   * Get PathogenType in View Model
   */
  public PathogenType getCurrentPathogenType() {
    return this.pathogenType;
  }
  
  /**
   * Get current Pathogen in List
   */ 
  protected Pathogen getCurrentPathogen() {
    return this.pathogenList.get(this.pathogenViewIndex);
  }
  
  /**
   * Next PathogenType in View Model
   */
  public void nextPathogenMode() {
    int ordinal = pathogenMode.ordinal();
    int size = PathogenMode.values().length;
    if(ordinal < size - 1) {
      pathogenMode = PathogenMode.values()[ordinal + 1];
    } else {
      pathogenMode = PathogenMode.values()[0];
    }
  }
  
  /**
   * Next PathogenType in View Model
   */
  public void nextPathogenType() {
    int ordinal = pathogenType.ordinal();
    int size = PathogenType.values().length;
    if(ordinal < size - 1) {
      pathogenType = PathogenType.values()[ordinal + 1];
    } else {
      pathogenType = PathogenType.values()[0];
    }
  }
  
  /**
   * Next Pathogen In List
   */
  public void nextPathogen() {
    if(pathogenViewIndex < pathogenList.size() - 1) {
      this.pathogenViewIndex++;
    } else {
      this.pathogenViewIndex = 0;
    }
  }
  
  /**
   * Render a Single Agent
   *
   * @param a agent
   */
  protected void drawAgent(Agent a) {
    int x = (int) a.getCoordinate().getX();
    int y = (int) a.getCoordinate().getY();
    int w = (int) this.getValue(ViewParameter.AGENT_DIAMETER);
    int viewWeight = (int) this.getValue(ViewParameter.AGENT_WEIGHT);
    PathogenType aType = a.getPathogen().getType();
    color viewStroke = this.getColor(aType);
    int alpha = (int) this.getValue(ViewParameter.AGENT_ALPHA);
    
    switch(pathogenMode) {
      case PATHOGEN:
        if(this.getCurrentPathogen() != a.getPathogen()) {
          alpha = (int) this.getValue(ViewParameter.REDUCED_ALPHA);
        }
        break;
      case PATHOGEN_TYPE:
        if(this.getCurrentPathogenType() != a.getPathogen().getType()) {
          alpha = (int) this.getValue(ViewParameter.REDUCED_ALPHA);
        }
        break;
    }
    
    stroke(viewStroke, alpha);
    noFill();
    strokeWeight(viewWeight);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
    strokeWeight(1); // processing default
  }
  
  /**
   * Render a Legend of Pathogens
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPathogenLegend(int x, int y, color textFill, int textHeight) {
    String legendName = "Pathogens";
    int w = (int) this.getValue(ViewParameter.AGENT_DIAMETER);
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = textHeight/2;
    for (Pathogen p : this.pathogenList) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      a.setPathogen(p);
      a.setCoordinate(new Coordinate(x + w/2, y + yOffset - 0.25*textHeight));
      drawAgent(a);
      
      // Draw Symbol Label
      fill(textFill);
      text(p.getName(), x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Pathogen Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPathogenTypeLegend(int x, int y, color textFill, int textHeight) {
    String legendName = "Pathogen Types";
    int w = (int) this.getValue(ViewParameter.AGENT_DIAMETER);
    
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
      a.setCoordinate(new Coordinate(x + w/2, y + yOffset - 0.25*textHeight));
      drawAgent(a);
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill);
      text(aName, x + 1.5*textHeight, y + yOffset);
    }
  }
}
