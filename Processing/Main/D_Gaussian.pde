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
  public void setMean(double mean) {
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
  public void setStandardDeviation(double sD) {
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
  public double getValue() {
    return this.mean + this.standardDeviation * this.random.nextGaussian(); 
  }
  
  @Override
  public String toString() {
    return "Mean: " + this.mean + "; Standard Deviation: " + this.standardDeviation; 
  }
}

/**
 * Utility Class for Generating Time Values within a Gaussian Distribution
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
public class TimeDistribution{
  
  private Time mean;
  private Time standardDeviation;
  private Random random;
  
  /**
   * Default Normal Time Distribution with Mean = 0 seconds and Standard Deviation = 1 second
   */
  public TimeDistribution() {
    this(new Time(0), new Time(1));
  }
  
  /**
   * Construct a potentially non-normal Gaussian Time Distribution
   *
   * @param mean Time
   * @param standardDeviation Time
   */
  public TimeDistribution(Time mean, Time standardDeviation) {
    this.mean = mean;
    this.standardDeviation = standardDeviation;
    this.random = new Random();
  }
  
  /**
   * Set Mean Time
   *
   * @param mean Time
   */
  public void setMean(Time mean) {
    this.mean = mean; 
  }
  
  /**
   * Get Mean Time
   */
  private Time getMean() {
    return this.mean; 
  }
  
  /**
   * Set Standard Deviation
   *
   * @param sD Standard Deviation
   */
  public void setStandardDeviation(Time sD) {
    this.standardDeviation = sD; 
  }
  
  /**
   * Get Standard Deviation
   */
  private Time getStandardDeviation() {
    return this.standardDeviation; 
  }
  
  /**
   * Pick a Time value within the Gaussian distribution, using units of mean value
   */
  public Time getValue() {
    double variance = this.random.nextGaussian();
    TimeUnit unit = this.mean.getUnit();
    Time value = new Time(variance, unit);
    value = value.multiply(this.standardDeviation);
    value = value.add(this.mean);
    return value; 
  }
  
  @Override
  public String toString() {
    return "Mean: " + this.mean + "; Standard Deviation: " + this.standardDeviation; 
  }
}
