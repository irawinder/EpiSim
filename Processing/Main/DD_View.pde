/**
 * Visualization Model
 */
public class View implements ViewModel {
  
  // Dictionaries for View Attributes
  private HashMap<Enum, Integer> viewColor;
  private HashMap<Enum, String> viewName;
  private HashMap<Enum, Double> viewValue;
  private HashMap<Enum, Boolean> viewToggle;
  
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
  
  /**
   * Construct View Model
   */
  public View() {
    this.viewColor = new HashMap<Enum, Integer>();
    this.viewName = new HashMap<Enum, String>();
    this.viewValue = new HashMap<Enum, Double>();
    this.viewToggle = new HashMap<Enum, Boolean>();
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
  protected void setScreen() {
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
   * Add a color association to a specified Enum
   *
   * @param e Enum
   * @param col color
   */
  public void setColor(Enum e, Integer col) {
    this.viewColor.put(e, col);
  }
  
  /**
   * Add a name association to a specified Enum
   *
   * @param e Enum
   * @param name String
   */
  public void setName(Enum e, String name) {
    this.viewName.put(e, name);
  }
  
  /**
   * Add a size association to a specified Enum
   *
   * @param e Enum
   * @param size double
   */
  public void setValue(Enum e, double size) {
    this.viewValue.put(e, size);
  }
  
  /**
   * Add a size association to a specified Enum
   *
   * @param e Enum
   * @param size double
   */
  public void setToggle(Enum e, boolean toggle) {
    this.viewToggle.put(e, toggle);
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
   * Get Value Associated with Enum
   *
   * @param e Enum
   * @return size
   */
  public double getValue(Enum e) {
    if(this.viewValue.containsKey(e)) {
      return this.viewValue.get(e);
    } else {
      return 0; // default blank
    }
  }
  
  /**
   * Get Toggle Associated with Enum
   *
   * @param e Enum
   * @return toggle Boolean
   */
  public boolean getToggle(Enum e) {
    if(this.viewToggle.containsKey(e)) {
      return this.viewToggle.get(e);
    } else {
      return false;
    }
  }
  
  /**
   * Switch Toggle Associated with Enum
   *
   * @param e Enum
   * @return new toggle status
   */
  public Boolean switchToggle(Enum e) {
    if(this.viewToggle.containsKey(e)) {
      boolean status = !this.viewToggle.get(e);
      this.viewToggle.put(e, status);
      return status;
    }
    
    // Create a new toggle set to true if no toggle exists
    else {
      this.setToggle(e, true);
      return this.getToggle(e);
    }
  }
  
  /** 
   * Map a value to a specific color between two hues
   *
   * @param value
   * @param v1
   * @param v2
   * @param hue1
   * @param hue2
   */
  public color mapToGradient(double value, double v1, double v2, double hue1, double hue2, double sat1, double sat2) {
    
    int FULL = 255;
    double ratio = (value - v1) / (v2 - v1);
    
    int hue = (int) (hue1 + ratio * (hue2 - hue1));
    hue = Math.abs(hue);
    hue = (int) Math.max(hue, hue1);
    hue = (int) Math.min(hue, hue2);
    
    int sat = (int) (sat1 + ratio * (sat2 - sat1));
    
    colorMode(HSB);
    color map = color(hue, sat, FULL - sat, FULL);
    colorMode(RGB);
    return map;
  }
  
  /**
   * Draw a circle around a circular object at a specified location to show it's selected
   *
   * @param x
   * @param y
   * @param selectedDiamter Diameter of object you wish to select, in pixels
   */
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
    double uRatio = x / (this.xMax - this.xMin);
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
    double vRatio = y / (this.yMax - this.yMin);
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
}
