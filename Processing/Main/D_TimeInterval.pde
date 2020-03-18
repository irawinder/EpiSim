/**
 * TimeInterval defines a unitized duration of time
 */ 
public class TimeInterval {
  
  private Time timeInitial;
  private Time timeFinal;
  
  /**
   * Construct Default Interval of 1 second from t=0 to t=1
   */
  public TimeInterval() {
    Time i = new Time(0);
    Time f = new Time(1);
    setInterval(i, f);
  }
  
  /**
   * Construct Time Interval. Units of initial time are used in case of mismatch with final.
   *
   * @param i initial time
   * @param f final time
   */
  public TimeInterval(Time i, Time f) {
    setInterval(i, f);
  }
  
  /**
   * Set time interval. Units of initial time are used in case of mismatch with final.
   *
   * @param i initial time
   * @param f final time
   */
  public void setInterval(Time i, Time f) {
    this.timeInitial = i;
    this.timeFinal = f.reconcile(i);;
  }
  
  /**
   * Get the initial time
   */ 
  public Time getInitialTime() {
    return this.timeInitial;
  }
  
  /**
   * Get the final time
   */ 
  public Time getFinalTime() {
    return this.timeFinal;
  }
  
  /**
   * Get the length of time represented by this interval
   */
  public Time getDuration() {
    return timeFinal.subtract(timeInitial);
  }
  
  @Override
  public String toString() {
    return "Initial Time: " + this.getInitialTime() + "\nFinal Time: " + this.getFinalTime() + "\nDuration: " + this.getDuration();
  }
}
