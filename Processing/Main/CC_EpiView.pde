/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends View {
  
  // View States
  private AgentMode agentMode;
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
    this.agentMode = AgentMode.values()[0];
    this.pathogenType = PathogenType.values()[0];
    this.pathogenViewIndex = 0;
    
    // List of Pathogens in Model
    this.pathogenList = model.getPathogens();
  }
  
  /**
   * Toggle Auto Run
   */ 
  public void toggleAutoRun() {
    this.setToggle(ViewParameter.AUTO_RUN, !this.getToggle(ViewParameter.AUTO_RUN));
  }
  
  /**
   * Toggle FrameRate
   */ 
  public void toggleFrameRate() {
    this.setToggle(ViewParameter.SHOW_FRAMERATE, !this.getToggle(ViewParameter.SHOW_FRAMERATE));
  }
  
  /**
   * Check if Simulation is Running
   *
   * @return true if running
   */
  public boolean isRunning() {
    return this.getToggle(ViewParameter.AUTO_RUN);
  }
  
  /**
   * Check Number Of Frames to visualize before iterating model
   *
   * @return frames per simulation
   */
  public int framesPerSim() {
    return (int) this.getValue(ViewParameter.FRAMES_PER_SIMULATION);
  }
  
  /**
   * Expect this to be Overridden by Child Class
   */
  public void draw(Model model) {
    
  }
  
  /**
   * Set AgentMode in View Model
   */
  public void setPathogenMode(AgentMode pMode) {
    this.agentMode = pMode;
  }
  
  /**
   * Get AgentMode in View Model
   */
  public AgentMode getPathogenMode() {
    return this.agentMode;
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
   * Next AgentMode in View Model
   */
  public void nextAgentMode() {
    int ordinal = agentMode.ordinal();
    int size = AgentMode.values().length;
    if(ordinal < size - 1) {
      agentMode = AgentMode.values()[ordinal + 1];
    } else {
      agentMode = AgentMode.values()[0];
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
    int viewWeight = (int) this.getValue(ViewParameter.AGENT_WEIGHT);
    PathogenType aType = a.getPathogen().getType();
    color viewStroke = this.getColor(aType);
    int alpha = (int) this.getValue(ViewParameter.AGENT_ALPHA);
    
    if(a.getVessel() instanceof Environment) {
      drawEnvironmentAgent(a, viewStroke, viewWeight, alpha);
    } else if(a.getVessel() instanceof Host) {
      drawHostAgent(a, viewStroke, viewWeight, alpha);
    }
  }
  
  /**
   * Render a Single Agent
   *
   * @param a agent
   */
  private void drawEnvironmentAgent(Agent a, color viewStroke, int viewWeight, int alpha) {
    if(a.getVessel() instanceof Environment) {
      Environment e = (Environment) a.getVessel();
      int x = (int) e.getCoordinate().getX();
      int y = (int) e.getCoordinate().getY();
      double scaler = this.getValue(ViewParameter.PLACE_SCALER);
      int w = (int) ( Math.sqrt(e.getSize()) * scaler);
      
      stroke(viewStroke, alpha);
      noFill();
      strokeWeight(viewWeight);
      rectMode(CENTER);
      rect(x, y, w, w);
      rectMode(CORNER);
      strokeWeight(1); // processing default
    }
  }
  
  /**
   * Render a Single Agent
   *
   * @param a agent
   */
  private void drawHostAgent(Agent a, color viewStroke, int viewWeight, int alpha) {
    if(a.getVessel() instanceof Host) {
      Host h = (Host) a.getVessel();
      int x = (int) h.getCoordinate().getX();
      int y = (int) h.getCoordinate().getY();
      int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.PERSON_DIAMETER));
      
      stroke(viewStroke, alpha);
      noFill();
      strokeWeight(viewWeight);
      ellipseMode(CENTER);
      ellipse(x, y, w, w);
      strokeWeight(1); // processing default
    }
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
    String legendName = this.getName(this.agentMode);
    int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.PERSON_DIAMETER));
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = textHeight/2;
    for (Pathogen p : this.pathogenList) {
      yOffset += textHeight;
      int aX = (int) (x + w/2);
      int aY = (int) (y + yOffset - 0.25*textHeight);
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      a.setPathogen(p);
      Host h = new Host();
      h.setCoordinate(new Coordinate(aX, aY));
      a.setVessel(h);
      this.drawAgent(a);
      
      // Draw Highlight
      if(p == this.getCurrentPathogen()) {
        drawSelection(aX, aY, w);
      }
      
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
    String legendName = this.getName(this.agentMode);
    int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.PERSON_DIAMETER));
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = textHeight/2;
    for (PathogenType pT : PathogenType.values()) {
      yOffset += textHeight;
      int aX = (int) (x + w/2);
      int aY = (int) (y + yOffset - 0.25*textHeight);
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      Pathogen p = new Pathogen();
      p.setType(pT);
      a.setPathogen(p);
      Host h = new Host();
      h.setCoordinate(new Coordinate(aX, aY));
      a.setVessel(h);
      drawAgent(a);
      
      // Draw Highlight
      if(pT == this.getCurrentPathogenType()) {
        drawSelection(aX, aY, w);
      }
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill);
      text(aName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  protected void drawSelection(int x, int y, int selectedDiameter) {
    color selectionStroke = (int) this.getValue(ViewParameter.TEXT_FILL);
    int selectionAlpha = (int) this.getValue(ViewParameter.REDUCED_ALPHA);
    int selectionWeight = (int) this.getValue(ViewParameter.SELECTION_WEIGHT);
    int selectionDiameter = (int) (this.getValue(ViewParameter.SELECTION_SCALER) * selectedDiameter);
    
    strokeWeight(selectionWeight);
    stroke(selectionStroke, selectionAlpha);
    noFill();
    ellipse(x, y, selectionDiameter, selectionDiameter);
    strokeWeight(1); // back to default stroke weight
  }
}
