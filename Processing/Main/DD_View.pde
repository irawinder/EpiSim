/**
 * Visualization Model
 */
public class View implements ViewModel {
  
  // Dictionaries for View Attributes
  private HashMap<Enum, Integer> viewColor;
  private HashMap<Enum, String> viewName;
  private HashMap<Enum, Double> viewValue;
  private HashMap<Enum, Boolean> viewToggle;
  
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
   * Map a value to a specific hue color along a gradient
   *
   * @param value
   * @param min
   * @param max
   * @param minHue
   * @param maxHue
   */
  public color mapToGradient(double value, double v1, double v2, double hue1, double hue2) {
    
    int FULL = 255;
    double ratio = (value - v1) / (v2 - v1);
    int hue = (int) (hue1 + ratio * (hue2 - hue1));
    hue = (int) Math.max(hue, hue1);
    hue = (int) Math.min(hue, hue2);
    
    colorMode(HSB);
    color map = color(hue, FULL, FULL, FULL);
    colorMode(RGB);
    return map;
  }
}
