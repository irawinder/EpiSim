/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends View {
  
  // View Mode Setting
  private PathogenType pathogenMode;
  
  // Current Pathogen of View
  private Pathogen focus;
  
  /**
   * Construct EpiView Model
   */
  public EpiView() {
    super();
    
    pathogenMode = PathogenType.values()[0];
    focus = new Pathogen();
  }
  
  /**
   * Set Pathogen of Focus in View Model
   *
   * @param pM PathogenType
   */
  public void setPathogenFocus(Pathogen p) {
    this.focus = p;
  }
  
  /**
   * Get Pathogen Focus in View Model
   */
  public Pathogen getPathogenFocus() {
    return this.focus;
  }
  
  /**
   * Set Pathogen Mode in View Model
   *
   * @param pM PathogenType
   */
  public void setPathogenMode(PathogenType pM) {
    this.pathogenMode = pM;
  }
  
  /**
   * Get Pathogen Mode in View Model
   */
  public PathogenType getPathogenMode() {
    return this.pathogenMode;
  }
  
  /**
   * Next Pathogen Mode in View Model
   */
  public void nextPathogenMode() {
    int ordinal = pathogenMode.ordinal();
    int size = PathogenType.values().length;
    if(ordinal < size - 1) {
      pathogenMode = PathogenType.values()[ordinal + 1];
    } else {
      pathogenMode = PathogenType.values()[0];
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
   * Render a Legend of Pathogens
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPathogenLegend(EpiModel model, int x, int y, color textFill, int textHeight) {
    String legendName = "Pathogens:";
    int w = (int) this.getValue(ViewParameter.AGENT_DIAMETER);
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = textHeight/2;
    for (Pathogen p : model.getPathogens()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      a.setPathogen(p);
      a.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawAgent(a);
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill);
      text(aName, x + 1.5*textHeight, y + yOffset);
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
  protected void drawAgentLegend(int x, int y, color textFill, int textHeight) {
    String legendName = "Pathogen";
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
      a.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      drawAgent(a);
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill);
      text(aName, x + 1.5*textHeight, y + yOffset);
    }
  }
}
