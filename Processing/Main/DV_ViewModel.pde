/**
 * Visualization Model
 */
public class ViewModel extends ViewAttributes{
  
  // View Extents of Model Vizualization
  private int uMin;
  private int vMin;
  private int uMax;
  private int vMax;
  
  // View Extents of Model Vizualization
  private double xMin;
  private double yMin;
  private double xMax;
  private double yMax;
  
  private SimulationSpeed speed;
  private int framesPerSimulation;
  
  /**
   * Construct View Model
   */
  public ViewModel() {
    this.setModelExtents(0, 0, 100, 100);
    this.setModelLocation();
    
    this.setSpeed(SimulationSpeed.NORMAL);
  }
  
  /**
   * Set Model Extents in Model Distance Units
   */
  protected void setModelExtents(double xMin, double yMin, double xMax, double yMax) {
    this.xMin = xMin;
    this.yMin = yMin;
    this.xMax = xMax;
    this.yMax = yMax;
  }
  
  /**
   * Set View Extents for Model Visualization to exclude margins and panels in pixels
   */
  protected void setModelLocation() {
    int generalMargin      = (int) this.getValue(ViewParameter.GENERAL_MARGIN);
    int leftPanelWidth     = (int) this.getValue(ViewParameter.LEFT_PANEL_WIDTH);
    int rightPanelWidth    = (int) this.getValue(ViewParameter.RIGHT_PANEL_WIDTH);
    this.uMin = leftPanelWidth;
    this.vMin = generalMargin;
    this.uMax = width - rightPanelWidth;
    this.vMax = height - generalMargin;
  }
  
  /**
   * Expect this to be Overridden by Child Class
   */
  public void draw(Model model) {
    
  }
  
  /**
   * Map Coordinate value to a location on the screen
   *
   * @param c coordinate to map to screen
   * @param xMin
   * @param xMax
   * @param yMin
   * @param yMax
   */
  protected Coordinate mapToScreen(Coordinate c) {
    double uRatio = c.getX() / (this.xMax - this.xMin);
    double vRatio = c.getY() / (this.yMax - this.yMin);
    int u = (int) (this.uMin + uRatio * (this.uMax - this.uMin));
    int v = (int) (this.vMin + vRatio * (this.vMax - this.vMin));
    return new Coordinate(u, v);
  }
  
  /**
   * Map Coordinate x value to a location on the screen
   *
   * @param x coordinate to map to screen
   * @param xMin
   * @param xMax
   * @param uMin minimum screen u (left extent)
   * @param uMax maximum screen u (right extent)
   */
  protected int mapXToScreen(double x) {
    double uRatio = (x - this.xMin) / (this.xMax - this.xMin);
    return (int) (this.uMin + uRatio * (this.uMax - this.uMin));
  }
  
  /**
   * Map Coordinate x value to a location on the screen
   *
   * @param y coordinate to map to screen
   * @param yMin
   * @param yMax
   * @param vMin minimum screen v (top extent)
   * @param vMax maximum screen v (bottom extent)
   */
  protected int mapYToScreen(double y) {
    double vRatio = (y - this.yMin) / (this.yMax - this.yMin);
    return (int) (this.vMin + vRatio * (this.vMax - this.vMin));
  }
  
  /**
   * Map model extents width to pixel width
   */
  protected int modelWidth() {
    return this.uMax - this.uMin;
  }
  
  /**
   * Map model extents height to pixel width
   */
  protected int modelHeight() {
    return this.vMax - this.vMin;
  }
  
  /**
   * Get Screen Location of Left screen coordinate of model graphic
   */
  protected int modelU() {
    return this.uMin;
  }
  
  /**
   * Get Screen Location of Upper coordinate of model graphic
   */
  protected int modelV() {
    return this.vMin;
  }
  
  /**
   * Set Simulation Speed
   */
  public void setSpeed(SimulationSpeed speed) {
    this.speed = speed;
    
    switch(speed) {
      case SLOWEST:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.SLOWEST);
        break;
      case SLOWER:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.SLOWER);
        break;
      case SLOW:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.SLOW);
        break;
      case NORMAL:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.NORMAL);
        break;
      case FAST:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.FAST);
        break;
      case FASTER:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.FASTER);
        break;
      case FASTEST:
        this.framesPerSimulation = (int) this.getValue(SimulationSpeed.FASTEST);
        break;
    }
  }
  
  /**
   * Get the enum SimulationSpeed
   */
  public SimulationSpeed getSpeed() {
    return this.speed;
  }
  
  /**
   * Get the number of frames to render in between simulations
   */
  public int getFramesPerSimulation() {
    return this.framesPerSimulation;
  }
  
  /**
   * Increment Speed by one
   */
  public void increaseSpeed() {
    int index = this.speed.ordinal();
    SimulationSpeed[] speedList = SimulationSpeed.values();
    int numSpeeds = speedList.length;
    if(index < numSpeeds - 1) {
      this.setSpeed(speedList[index+1]);
    }
  }
  
  /**
   * Decrease Speed by one
   */
  public void decreaseSpeed() {
    int index = this.speed.ordinal();
    SimulationSpeed[] speedList = SimulationSpeed.values();
    if(index > 0) {
      this.setSpeed(speedList[index-1]);
    }
  }
}
