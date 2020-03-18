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
    Time bClean = b.reconcile(this); 
    
    double result = this.getAmount() + bClean.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value subtracted from this time.
   *
   * @param b time
   */
  public Time subtract(Time b) {
    
    // Check and convert mismatched units
    Time bClean = b.reconcile(this); 
    
    double result = this.getAmount() - bClean.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value multiplied by this time.
   *
   * @param b time
   */
  public Time multiply(Time b) {
    
    // Check and convert mismatched units
    Time bClean = b.reconcile(this); 
    
    double result = this.getAmount() * bClean.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value divided by this time.
   *
   * @param b time
   */
  public Time divide(Time b) {
    
    // Check and convert mismatched units
    Time bClean = b.reconcile(this); 
    
    double result = this.getAmount() / bClean.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Returns a copy of the specified value modulo'd by this time.
   *
   * @param b time
   */
  public Time modulo(Time b) {
    
    // Check and convert mismatched units
    Time bClean = b.reconcile(this); 
    
    double result = this.getAmount() % bClean.getAmount();
    return new Time(result, this.getUnit());
  }
  
  /**
   * Return a copy of Time converted to new units.
   *
   * @param unit TimeUnits to convert to
   */
  public Time convert(TimeUnit newUnit) {
    
    Time converted = new Time(this.getAmount(), newUnit);;
    
    // Return current time if new units already equal current units
    if(this.getUnit() == newUnit) {
      converted.setAmount(this.getAmount());
      return this;
    
    // Otherwise carry on with conversion
    } else {
      
      // Step 1: Convert current time to Milliseconds
      switch(this.getUnit()) {
        case YEAR:
          converted.setAmount(converted.getAmount() * MONTHS_IN_YEAR);
        case MONTH:
          converted.setAmount(converted.getAmount() * WEEKS_IN_MONTH);
        case WEEK:
          converted.setAmount(converted.getAmount() * DAYS_IN_WEEK);
        case DAY:
          converted.setAmount(converted.getAmount() * HOURS_IN_DAY);
        case HOUR:
          converted.setAmount(converted.getAmount() * MINUTES_IN_HOUR);
        case MINUTE:
          converted.setAmount(converted.getAmount() * SECONDS_IN_MINUTE);
        case SECOND:
          converted.setAmount(converted.getAmount() * MILLISECONDS_IN_SECOND);
        case MILLISECOND:
          // Do Nothing
          break;
      }
      
      // Step 2: Convert time to new units
      switch(newUnit) {
        case YEAR:
          converted.setAmount(converted.getAmount() / MONTHS_IN_YEAR);
        case MONTH:
          converted.setAmount(converted.getAmount() / WEEKS_IN_MONTH);
        case WEEK:
          converted.setAmount(converted.getAmount() / DAYS_IN_WEEK);
        case DAY:
          converted.setAmount(converted.getAmount() / HOURS_IN_DAY);
        case HOUR:
          converted.setAmount(converted.getAmount() / MINUTES_IN_HOUR);
        case MINUTE:
          converted.setAmount(converted.getAmount() / SECONDS_IN_MINUTE);
        case SECOND:
          converted.setAmount(converted.getAmount() / MILLISECONDS_IN_SECOND);
        case MILLISECOND:
          // Do Nothing
          break;
      }
      
      return converted;
    }
  }
  
  /** 
   * Return copy of time that is reconciled to have same units as specified dominant time
   *
   * @param dominant Time value whose existing units you would like to respect in reconciliation
   */
  public Time reconcile(Time dominant) {
    TimeUnit dominantUnit = dominant.getUnit();
    if(dominantUnit != this.getUnit()) {
      return convert(dominantUnit);
    } else {
      return this;
    }
  }
  
  @Override
  public String toString() {
    int decimalPlaces = 2;
    double multiplier = this.amount * (int) Math.pow(10, decimalPlaces);
    int truncate = (int) multiplier;
    double time = truncate / Math.pow(10, decimalPlaces);
    return time + " " + this.getUnit();
  }
  
  /**
   * Return Time formatted as a digital clock (e.g. military time)
   */
  public String toClock() {
    
    int hour = (int) this.convert(TimeUnit.HOUR).getAmount() % (int) HOURS_IN_DAY;
    int minute = (int) this.convert(TimeUnit.MINUTE).getAmount() % (int) MINUTES_IN_HOUR;
    
    String hourString = "";
    if(hour < 10) hourString += "0";
    hourString += hour;
    
    String minuteString = "";
    if(minute < 10) minuteString += "0";
    minuteString += minute;
    
    return hourString + ":" + minuteString;
  }
  
  /**
   * Return Time formatted as day of week
   */
  String toDayOfWeek() {
    
    int day = (int) this.convert(TimeUnit.DAY).getAmount();
    
    if(day % DAYS_IN_WEEK == 0) {
      return "Sunday";
    } else if(day % DAYS_IN_WEEK == 1) {
      return "Monday";
    } else if(day % DAYS_IN_WEEK == 2) {
      return "Tuesday";
    } else if(day % DAYS_IN_WEEK == 3) {
      return "Wednesay";
    } else if(day % DAYS_IN_WEEK == 4) {
      return "Thursday";
    } else if(day % DAYS_IN_WEEK == 5) {
      return "Friday";
    } else {
      return "Saturday";
    }
  }
}
