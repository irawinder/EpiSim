public class Animated {
  private Coordinate screen;
  
  public void setCoordinate(Coordinate c) {
    screen = new Coordinate();
    screen.setX(c.getX());
    screen.setY(c.getY());
    screen.setZ(c.getZ());
  }
  
  public Coordinate getCoordinate() {
    return this.screen;
  }
  
  /**
   * Animate screen coordinate according to simulation rate and current frame
   *
   * @param simulationRate number of frames rendered between each simulation step
   * @param current frame of animation
   */
  public Coordinate position(int simulationRate, int frame, Coordinate destination) {
    int modFrame = frame % simulationRate + 1;
    double ratio = 1.0 * modFrame / simulationRate;
    double newX = screen.getX() + ratio * (destination.getX() - screen.getX());
    double newY = screen.getY() + ratio * (destination.getY() - screen.getY());
    double newZ = screen.getZ() + ratio * (destination.getZ() - screen.getZ());
    screen.setX(newX);
    screen.setY(newY);
    screen.setZ(newZ);
    return screen;
  }
}
