/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends ViewModel {
  
  // View State
  private AgentMode agentMode;
  
  // Current Pathogen Type to Focus On
  private PathogenType pathogenType;
  
  // Current Pathogen Index to Focus On
  int pathogenViewIndex;
  
  // List of Pathogens in Model
  ArrayList<Pathogen> pathogenList;
  
  // Array of Animated Hosts
  private HashMap<Host, Animated> animatedHost;
  
  /**
   * Construct EpiView Model
   */
  public EpiView(EpiModel model) {
    super();
    this.agentMode = AgentMode.values()[0];
    this.pathogenType = PathogenType.values()[0];
    this.pathogenViewIndex = 0;
    this.pathogenList = model.getPathogens();
    this.animatedHost = new HashMap<Host, Animated>();
    for(Host h : model.getHosts()) {
      this.setAnimated(h);
    }
  }
  
  /**
   * Set Animated Host
   *
   * @param h Host
   */
  public void setAnimated(Host h) {
    Animated aHost = new Animated();
    aHost.setCoordinate(h.getCoordinate());
    this.animatedHost.put(h, aHost);
  }
  
  /**
   * Get the Animated object associated with a person, creating it if one doesn't already exist
   *
   * @param p Person
   */
  public Animated getAnimated(Host h) {
    if(!this.animatedHost.keySet().contains(h)) {
      this.setAnimated(h);
    }
    return animatedHost.get(h);
  }
  
  /**
   * Toggle Auto Run
   */ 
  public void toggleAutoRun() {
    this.setToggle(ViewParameter.AUTO_RUN, !this.getToggle(ViewParameter.AUTO_RUN));
  }
  
  /**
   * SetAutoRun
   *
   * @param state boolean
   */ 
  public void setAutoRun(boolean state) {
    this.setToggle(ViewParameter.AUTO_RUN, state);
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
   * Expect this to be Overridden by Child Class
   */
  public void draw(Model model) {
    
  }
  
  /**
   * Set AgentMode in View Model
   */
  public void setAgentMode(AgentMode pMode) {
    this.agentMode = pMode;
  }
  
  /**
   * Get AgentMode in View Model
   */
  public AgentMode getAgentMode() {
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
   * Render a single agent
   *
   * @param a agent
   */
  protected void drawAgent(Agent a, boolean mapToScreen) {
    int viewWeight = (int) this.getValue(ViewParameter.AGENT_WEIGHT);
    color viewStroke = this.getColor(Compartment.INFECTIOUS);
    int alpha = (int) this.getValue(ViewParameter.AGENT_ALPHA);
    
    if(a.getVessel() instanceof Environment) {
      drawEnvironmentAgent(a, viewStroke, viewWeight, alpha, mapToScreen);
    } else if(a.getVessel() instanceof Host) {
      drawHostAgent(a, viewStroke, viewWeight, alpha, mapToScreen);
    }
  }
  
  /**
   * Render a single agent in an environment
   *
   * @param a agent
   */
  private void drawEnvironmentAgent(Agent a, color viewStroke, int viewWeight, int alpha, boolean mapToScreen) {
    if(a.getVessel() instanceof Environment) {
      Environment e = (Environment) a.getVessel();
      int x = (int) e.getCoordinate().getX();
      int y = (int) e.getCoordinate().getY();
      if(mapToScreen) {
        x = this.mapXToScreen(x);
        y = this.mapYToScreen(y);
      }
      double scaler = this.getValue(ViewParameter.ENVIRONMENT_SCALER);
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
   * Render a single agent in a host
   *
   * @param a agent
   */
  private void drawHostAgent(Agent a, color viewStroke, int viewWeight, int alpha, boolean mapToScreen) {
    if(a.getVessel() instanceof Host) {
      Host h = (Host) a.getVessel();
      int x = (int) h.getCoordinate().getX();
      int y = (int) h.getCoordinate().getY();
      if(mapToScreen) {
        x = this.mapXToScreen(x);
        y = this.mapYToScreen(y);
      }
      int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.HOST_DIAMETER));
      
      stroke(viewStroke, alpha);
      noFill();
      strokeWeight(viewWeight);
      ellipseMode(CENTER);
      ellipse(x, y, w, w);
      strokeWeight(1); // processing default
    }
  }
  
  /**
   * Render a Single Host and Compartment
   *
   * @param p person
   * @param pathogenson
   */
  protected void drawCompartment(Host h, Pathogen pathogen, int frame, boolean mapToScreen) {
    Animated dot = this.getAnimated(h);
    Coordinate location = dot.position(this.getFramesPerSimulation(), frame, h.getCoordinate());
    int x = (int) location.getX();
    int y = (int) location.getY();
    if(mapToScreen) {
      x = this.mapXToScreen(x);
      y = this.mapYToScreen(y);
    }
    int w = (int) this.getValue(ViewParameter.HOST_DIAMETER);
    Compartment c = h.getStatus(pathogen).getCompartment();
    color viewFill = this.getColor(c);
    color viewStroke = this.getColor(ViewParameter.HOST_STROKE);
    int alpha = (int) this.getValue(ViewParameter.HOST_ALPHA);
    int strokeWeight = (int) this.getValue(ViewParameter.HOST_WEIGHT);
    
    strokeWeight(strokeWeight);
    stroke(viewStroke);
    fill(viewFill, alpha);
    ellipseMode(CENTER);
    ellipse(x, y, w, w);
    strokeWeight(1); // back to default
  }
  
  /**
   * Render a Single Place's Density
   *
   * @param l place
   */
  protected void drawDensity(Environment e, boolean mapToScreen) {
    int x = (int) e.getCoordinate().getX();
    int y = (int) e.getCoordinate().getY();
    if(mapToScreen) {
      x = this.mapXToScreen(x);
      y = this.mapYToScreen(y);
    }
    double scaler = this.getValue(ViewParameter.ENVIRONMENT_SCALER);
    int w = (int) ( Math.sqrt(e.getSize()) * scaler);
    
    double density = e.getDensity();
    double minVal = this.getValue(ViewParameter.MIN_DENSITY);
    double maxVal = this.getValue(ViewParameter.MAX_DENSITY);
    double minHue = this.getValue(ViewParameter.MIN_DENSITY_HUE);
    double maxHue = this.getValue(ViewParameter.MAX_DENSITY_HUE);
    double minSat = this.getValue(ViewParameter.MIN_DENSITY_SAT);
    double maxSat = this.getValue(ViewParameter.MAX_DENSITY_SAT);
    color viewFill = this.mapToGradient(density, minVal, maxVal, minHue, maxHue, minSat, maxSat);
    color viewStroke = this.getColor(ViewParameter.ENVIRONMENT_STROKE);
    int alpha = (int) this.getValue(ViewParameter.ENVIRONMENT_ALPHA);
    
    stroke(viewStroke);
    fill(viewFill, alpha);
    rectMode(CENTER);
    rect(x, y, w, w);
    rectMode(CORNER);
  }
  
  /**
   * Render a Legend of Pathogens
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawPathogenLegend(String legendName, int x, int y, color textFill, int textHeight) {
    int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.HOST_DIAMETER));
    int strokeWeight = (int) (this.getValue(ViewParameter.AGENT_WEIGHT));
    boolean mapToScreen = false;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = 3*textHeight/2;
    for (Pathogen p : this.pathogenList) {
      int aX = (int) (x + w/2);
      int aY = (int) (y + yOffset - 0.25*textHeight);
      
      // Create and Draw a Straw-man Agent for Lengend Item
      Agent a = new Agent();
      a.setPathogen(p);
      Host h = new Host();
      h.setCoordinate(new Coordinate(aX, aY));
      a.setVessel(h);
      this.drawAgent(a, mapToScreen);
      
      // Draw Highlight
      int alpha;
      if(p == this.getCurrentPathogen()) {
        drawSelection(aX, aY, w + strokeWeight/2);
        alpha = 255;
      } else {
        alpha = (int) (this.getValue(ViewParameter.REDUCED_ALPHA));
      }
      
      // Draw Symbol Label
      fill(textFill, alpha);
      text(p.getName(), x + 1.5*textHeight, y + yOffset);
      
      yOffset += textHeight + 2*strokeWeight;
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
  protected void drawPathogenTypeLegend(String legendName, int x, int y, color textFill, int textHeight) {
    int w = (int) (this.getValue(ViewParameter.AGENT_SCALER) * this.getValue(ViewParameter.HOST_DIAMETER));
    int strokeWeight = (int) (this.getValue(ViewParameter.AGENT_WEIGHT));
    boolean mapToScreen = false;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible Pathogen
    int yOffset = 3*textHeight/2;
    for (PathogenType pT : PathogenType.values()) {
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
      drawAgent(a, mapToScreen);
      
      // Draw Highlight
      int alpha;
      if(pT == this.getCurrentPathogenType()) {
        drawSelection(aX, aY, w + strokeWeight/2);
        alpha = 255;
      } else {
        alpha = (int) (this.getValue(ViewParameter.REDUCED_ALPHA));
      }
      
      // Draw Symbol Label
      PathogenType aType = a.getPathogen().getType();
      String aName = this.getName(aType);
      fill(textFill, alpha);
      text(aName, x + 1.5*textHeight, y + yOffset);
      
      yOffset += textHeight + 2*strokeWeight;
    }
  }
  
  /**
   * Render a Legend of Host Compartment Types
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawCompartmentLegend(String legendName, int x, int y, color textFill, int textHeight) {
    int w = (int) this.getValue(ViewParameter.HOST_DIAMETER);
    boolean mapToScreen = false;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    int yOffset = (int) textHeight/2;
    for (Compartment c : Compartment.values()) {
      yOffset += textHeight;
      
      // Create and Draw a Straw-man Host for Lengend Item
      Host h = new Host();
      Pathogen pathogen = new Pathogen();
      switch(this.getAgentMode()) {
          case PATHOGEN:
            pathogen = this.getCurrentPathogen();
            break;
          case PATHOGEN_TYPE:
            pathogen.setType(getCurrentPathogenType());
            break;
        }
      PathogenEffect pE = new PathogenEffect();
      pE.setCompartment(c);
      h.setStatus(pathogen, pE);
      h.setCoordinate(new Coordinate(x + w, y + yOffset - 0.25*textHeight));
      
      // Draw Halo Around Infectious Compartment
      if(c == Compartment.INFECTIOUS) {
        Agent a = new Agent();
        a.setPathogen(pathogen);
        a.setVessel(h);
        drawAgent(a, mapToScreen);
      }
      
      // Draw Compartment Type
      drawCompartment(h, pathogen, 0, mapToScreen);
      
      // Draw Symbol Label
      String pName = this.getName(c);
      fill(textFill);
      text(pName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render a Legend of Environment Densities
   *
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawDensityLegend(String legendName, int x, int y, color textFill, int textHeight) {
    int w = (int) this.getValue(ViewParameter.ENVIRONMENT_DIAMETER);
    double minDensity = this.getValue(ViewParameter.MIN_DENSITY);
    double maxDensity = 1.1*this.getValue(ViewParameter.MAX_DENSITY);
    int numRows = 6;
    
    // Draw Legend Name
    fill(textFill);
    text(legendName + ":", x, y);
    
    // Iterate through all possible place types
    int yOffset = (int) textHeight/2;
    for (int i=0; i<numRows; i++) {
      yOffset += textHeight;
      int xP = int(x + w);
      int yP = int(y + yOffset - 0.25*textHeight);
      double density = minDensity + (maxDensity - minDensity) * i / (numRows - 1.0);
      double minVal = this.getValue(ViewParameter.MIN_DENSITY);
      double maxVal = this.getValue(ViewParameter.MAX_DENSITY);
      double minHue = this.getValue(ViewParameter.MIN_DENSITY_HUE);
      double maxHue = this.getValue(ViewParameter.MAX_DENSITY_HUE);
      double minSat = this.getValue(ViewParameter.MIN_DENSITY_SAT);
      double maxSat = this.getValue(ViewParameter.MAX_DENSITY_SAT);
      color viewFill = this.mapToGradient(density, minVal, maxVal, minHue, maxHue, minSat, maxSat);
      color viewStroke = this.getColor(ViewParameter.ENVIRONMENT_STROKE);
      int alpha = (int) this.getValue(ViewParameter.ENVIRONMENT_ALPHA);
    
      stroke(viewStroke);
      fill(viewFill, alpha);
      rectMode(CENTER);
      rect(xP, yP, 2*w, 2*w);
      rectMode(CORNER);
      
      // Draw Symbol Label
      String suffix = " people";
      if(i == numRows - 1) {
        suffix = "+" + suffix;
      }
      String dName = "" + (int) (density * 1000) + suffix;
      fill(textFill);
      text(dName, x + 1.5*textHeight, y + yOffset);
    }
  }
  
  /**
   * Render time info
   *
   * @param EpiModel
   * @param x
   * @param y
   * @param textFill color
   * @praam textHeight int
   */
  protected void drawTime(EpiModel model, int x, int y, color textFill) {
    int day = (int) model.getCurrentTime().convert(TimeUnit.DAY).getAmount();
    String clock = model.getCurrentTime().toClock();
    String dayOfWeek = model.getCurrentTime().toDayOfWeek();
    
    String text = 
      "Simulation Day: " + (day+1) + "\n" +
      "Day of Week: " + dayOfWeek + "\n" +
      "Simulation Time: " + clock;
    
    fill(textFill);
    text(text, x, y);
  }
}
