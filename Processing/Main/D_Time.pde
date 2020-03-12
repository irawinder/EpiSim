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
    
    // Check and convert mismatched units
    f.reconcile(i);
    
    this.timeInitial = i;
    this.timeFinal = f;
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

/**
 * Time represents a unitized quantity of time
 */
public class Time {
  
  private final double MONTHS_IN_YEAR = 12;
  private final double WEEKS_IN_MONTH = 4.34524;
  private final double DAYS_IN_WEEK = 7;
  private final double HOURS_IN_DAY = 24;
  private final double MINUTES_IN_HOUR = 60;
  private final double SECONDS_IN_MINUTE = 60;
  private final double MILLISECONDS_IN_SECOND = 1000;
  
  private TimeUnit unit;
  private double amount;
  
  /**
   * Construct 0 seconds of time
   */ 
  public Time() {
    this.setUnit(TimeUnit.SECOND);
    this.setAmount(0);
  }
  
  /**
   * Construct 0 units of time
   */ 
  public Time(TimeUnit unit) {
    this.setUnit(unit);
    this.setAmount(0);
  }
  
  /**
   * Construct amount of time in seconds
   *
   * @param time amount
   */ 
  public Time(double amount) {
    this.setUnit(TimeUnit.SECOND);
    this.setAmount(amount);
  }
  
  /**
   * Construct amount of unitized time
   *
   * @param time amount
   * @param unit TimeUnit
   */ 
  public Time(double amount, TimeUnit unit) {
    this.setUnit(unit);
    this.setAmount(amount);
  }
  
  /**
   * Set the amount of time
   *
   * @param time amount
   */ 
  public void setAmount(double amount) {
    this.amount = amount;
  }
  
  /**
   * Get the amount of time as a double
   */ 
  public double getAmount() {
    return this.amount;
  }
  
  /**
   * Set the unit of time
   *
   * @param unit TimeUnit
   */ 
  public void setUnit(TimeUnit unit) {
    this.unit = unit;
  }
  
  /**
   * Get the unit of time
   */ 
  public TimeUnit getUnit() {
    return this.unit;
  }
  
  /**
   * Returns a copy of the specified value added to this time.
   *
   * @param b time
   */
  public Time add(Time b) {
    
    // Check and convert mismatched units
    b.reconcile(this); 
    
    double result = this.getAmount() + b.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value subtracted from this time.
   *
   * @param b time
   */
  public Time subtract(Time b) {
    
    // Check and convert mismatched units
    b.reconcile(this); 
    
    double result = this.getAmount() - b.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value multiplied by this time.
   *
   * @param b time
   */
  public Time multiply(Time b) {
    
    // Check and convert mismatched units
    b.reconcile(this); 
    
    double result = this.getAmount() * b.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value divided by this time.
   *
   * @param b time
   */
  public Time divide(Time b) {
    
    // Check and convert mismatched units
    b.reconcile(this); 
    
    double result = this.getAmount() / b.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value modulo'd by this time.
   *
   * @param b time
   */
  public Time modulo(Time b) {
    
    // Check and convert mismatched units
    b.reconcile(this); 
    
    double result = this.getAmount() % b.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Convert time to new units
   *
   * @param unit TimeUnits to convert to
   */
  public Time convert(TimeUnit newUnit) {
    
    // Return current time if new units already equal current units
    if(this.getUnit() == newUnit) {
      println("Time is already in " + this.getUnit() + " unit");
      return this;
    
    // Otherwise carry on with conversion
    } else {
      
      // Step 1: Convert current time to Milliseconds
      switch(this.getUnit()) {
        case YEAR:
          this.setAmount(this.getAmount() * MONTHS_IN_YEAR);
        case MONTH:
          this.setAmount(this.getAmount() * WEEKS_IN_MONTH);
        case WEEK:
          this.setAmount(this.getAmount() * DAYS_IN_WEEK);
        case DAY:
          this.setAmount(this.getAmount() * HOURS_IN_DAY);
        case HOUR:
          this.setAmount(this.getAmount() * MINUTES_IN_HOUR);
        case MINUTE:
          this.setAmount(this.getAmount() * SECONDS_IN_MINUTE);
        case SECOND:
          this.setAmount(this.getAmount() * MILLISECONDS_IN_SECOND);
        case MILLISECOND:
          // Do Nothing
          break;
      }
      
      // Step 2: Convert time to new units
      switch(newUnit) {
        case YEAR:
          this.setAmount(this.getAmount() / MONTHS_IN_YEAR);
        case MONTH:
          this.setAmount(this.getAmount() / WEEKS_IN_MONTH);
        case WEEK:
          this.setAmount(this.getAmount() / DAYS_IN_WEEK);
        case DAY:
          this.setAmount(this.getAmount() / HOURS_IN_DAY);
        case HOUR:
          this.setAmount(this.getAmount() / MINUTES_IN_HOUR);
        case MINUTE:
          this.setAmount(this.getAmount() / SECONDS_IN_MINUTE);
        case SECOND:
          this.setAmount(this.getAmount() / MILLISECONDS_IN_SECOND);
        case MILLISECOND:
          // Do Nothing
          break;
      }
      
      // Step 3: Change units to new UnitType
      this.setUnit(newUnit);
      
      return this;
    }
  }
  
  /** 
   * Reconcile units with another time by converting the units of this time.
   *
   * @param dominant Time value whose existing units you would like to respect in reconciliation
   */
  public Time reconcile(Time dominant) {
    TimeUnit dominantUnit = dominant.getUnit();
    if(dominantUnit != this.getUnit()) {
      println("Unit mismatch found. Converted " + this.getUnit() + " to " + dominantUnit + ".");
      this.convert(dominantUnit);
    }
    return this;
  }
  
  @Override
  public String toString() {
    return this.getAmount() + " " + this.getUnit();
  }
}
