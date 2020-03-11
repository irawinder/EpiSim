import java.util.Random;

/**
 * Utility Class for Generating Values within a Gaussian Distribution
 *
 *                     1x Std. Dev.
 *
 * |                    |     |
 * |                  .-|-.   |
 * |                -   |  -  |
 * |               /    |    \|
 * |            _ |     |     | _
 * |         _    |     |     |    _ 
 * |__._._-_|_____|_____|_____|_____|_-_.__.__
 *                      ^
 *                   Average (mean)
 */
public class GaussianDistribution {
  
  private double mean;
  private double standardDeviation;
  private Random random; 
  
  /**
   * Default Normal Distribution with Mean = 0 and Standard Deviation = 1
   */
  public GaussianDistribution() {
    this(0, 1);
  }
  
  /**
   * Construct a potentially non-normal Gaussian Distribution
   *
   * @param mean
   * @param standardDeviation
   */
  public GaussianDistribution(double mean, double standardDeviation) {
    this.mean = mean;
    this.standardDeviation = standardDeviation;
    random = new Random();
  }
  
  /**
   * Set Mean
   *
   * @param mean
   */
  private void setMean(double mean) {
    this.mean = mean; 
  }
  
  /**
   * Get Mean
   */
  private double getMean() {
    return this.mean; 
  }
  
  /**
   * Set Standard Deviation
   *
   * @param sD Standard Deviation
   */
  private void setStandardDeviation(double sD) {
    this.standardDeviation = sD; 
  }
  
  /**
   * Get Standard Deviation
   */
  private double getStandardDeviation() {
    return this.standardDeviation; 
  }
  
  /**
   * Pick a value within the Gaussian distribution
   */
  private double getValue() {
    return this.mean + this.standardDeviation * this.random.nextGaussian(); 
  }
  
  @Override
  public String toString() {
    return "Mean: " + this.mean + "; Standard Deviation: " + this.standardDeviation; 
  }
}
