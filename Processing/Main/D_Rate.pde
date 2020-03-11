/**
 * Rate or Probability of Attribute Occurence
 */
public class Rate {
  
  // Numerical Rate Value
  private double rate;
  
  /**
   * Construct new Rate
   */
  public Rate() {
    rate = 0;
  }
  
  public Rate(double r) {
    set(r);
  }
  
  /**
   * Set the Rate as a decimal numeric value (0-1)
   */
  public void set(double rate) {
    this.rate = rate;
  }
  
  /**
   * Get the Rate as a decimal numeric value (0-1)
   */
  public double get() {
    return rate;
  }
  
  /**
   * Get the percent value as a String (0-100%)
   *
   * @param decimal Places
   */
  @Override
  public String toString() {
    int decimalPlaces = 2;
    double multiplier = 100 * rate * (int) Math.pow(10, decimalPlaces);
    int truncate = (int) multiplier;
    double percent = truncate / Math.pow(10, decimalPlaces);
    return percent + "%";
  }
}
