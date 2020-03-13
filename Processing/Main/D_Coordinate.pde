/**
 * 3D coordinate object
 */
 public class Coordinate {
  
  // coordinates
  private double x, y, z;
  
  /**
   * Construct new Coordinate
   */
  Coordinate() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }
  
  /**
   * Construct new Coordinate
   *
   * @param x
   * @param y
   */
  Coordinate(double x, double y) {
    this.x = x;
    this.y = y;
    this.z = 0;
  }
  
  /**
   * Construct new Coordinate
   *
   * @param x
   * @param y
   * @param z
   */
  Coordinate(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
   * Set X Coordinate
   *
   * @param x
   */
  public void setX(double x) {
    this.x = x;
  }
  
  /**
   * Set Y Coordinate
   *
   * @param y
   */
  public void setY(double y) {
    this.y = y;
  }
  
  /**
   * Set Z Coordinate
   *
   * @param z
   */
  public void setZ(double z) {
    this.z = z;
  }
  
  /**
   * Get X Coordinate
   */
  public double getX() {
    return this.x;
  }
  
  /**
   * Get Y Coordinate
   */
  public double getY() {
    return this.y;
  }
  
  /**
   * Get Z Coordinate
   */
  public double getZ() {
    return this.z;
  }
  
  /**
   * Return the distance between this and a specified coordinate
   *
   * @param other
   */
  public double distance(Coordinate other) {
    double dX2 = Math.pow(this.x - other.x, 2);
    double dY2 = Math.pow(this.y - other.y, 2);
    double dZ2 = Math.pow(this.z - other.z, 2);
    return Math.sqrt(dX2 + dY2 + dZ2);
  }
  
  /**
   * Return a new Coordinate that is slightly jittered from the Parent
   *
   * @param jitter amount of jitter
   */
  public Coordinate jitter(double amount) {
    Coordinate jittered = new Coordinate();
    double jitterX = amount*(2*Math.random() - 1);
    double jitterY = amount*(2*Math.random() - 1);
    jittered.setX(this.getX() + jitterX);
    jittered.setY(this.getY() + jitterY);
    jittered.setZ(this.getZ());
    return jittered;
  }
}
