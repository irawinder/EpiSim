/**
 * Visualization Model for Epidemiological Object Model
 */
public class EpiView extends View {
  
  // View Mode Setting
  private PathogenType pathogenMode;
  
  /**
   * Construct EpiView Model
   */
  public EpiView() {
    super();
    
    pathogenMode = PathogenType.values()[0];
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
}
