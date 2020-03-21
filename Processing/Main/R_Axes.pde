
/**
 * Axes is designed for other specific graph classes (e.g. BarGraph) to extend
 */
class Axes {
  
  // Title and Labels for Axes
  private String title, labelX, labelY;
  
  public Axes() {
    this.title = "";
    this.labelX = "";
    this.labelY = "";
  }
  
  /**
   * Set title of bar graph
   *
   * @param title
   */
  public void setTitle(String title) {
    this.title = title;
  }
  
  /**
   * Get title of bar graph
   */
  public String getTitle() {
    return this.title;
  }
  
  /**
   * Set X-Axis Labal of bar graph
   *
   * @param labelX
   */
  public void setLabelX(String labelX) {
    this.labelX = labelX;
  }
  
  /**
   * Get X-Axis Labal of bar graph
   */
  public String getLabelX() {
    return this.labelX;
  }
  
  /**
   * Set Y-Axis Labal of bar graph
   *
   * @param labelY
   */
  public void setLabelY(String labelY) {
    this.labelY = labelY;
  }
  
  /**
   * Get Y-Axis Labal of bar graph
   */
  public String getLabelY() {
    return this.labelY;
  }
}
