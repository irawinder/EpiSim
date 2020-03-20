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
  
  /**
   * Construct View Model
   */
  public ViewModel() {
    this.setModelExtents(0, 0, 100, 100);
    this.setScreen();
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
