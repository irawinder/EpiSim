/**
 * Sequence of Referenceable TimeIntervals (Phases) that Define a Periodic Schedule
 */
public class Schedule {
  
  // Parameters of Phase Schedule
  private TimeUnit unit;
  private ArrayList<TimeInterval> phaseSequence;
  private HashMap<TimeInterval, Phase> phaseMap;
  
  /**
   * Construct Empty Schedule
   */
  public Schedule() {
    this.unit = null;
    this.phaseSequence = new ArrayList<TimeInterval>();
    this.phaseMap = new HashMap<TimeInterval, Phase>();
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
   * Get the unit of time.
   */ 
  public TimeUnit getUnit() {
    return this.unit;
  }
  
  /**
   * Get phase sequence.
   */
  public ArrayList<TimeInterval> getSequence() {
    return this.phaseSequence;
  }
  
  /**
   * Get phase map.
   */
  public HashMap<TimeInterval, Phase> getPhaseMap() {
    return this.phaseMap;
  }
  
  /**
   * Add Phase to the end of the schedule sequence
   *
   * @param phaseType Phase
   * @param phaseDuration Time
   */
  public void addPhase(Phase phaseType, Time phaseDuration) {
    
    // Input Validation
    if(phaseDuration.getAmount() <= 0) {
      println("Error: Cannot add phase of zero or negative duration");
      
    } else {
      
      TimeInterval phaseInterval;
      
      // If phase sequence list is empty:
      if (this.getSequence().size() == 0) {
      
        // Set the Schedule's units to the same as specified value
        this.setUnit(phaseDuration.getUnit());
        
        // Creat a new TimeInterval with start time at t = 0
        Time initialTime = new Time(0, this.getUnit());
        Time finalTime = phaseDuration;
        phaseInterval = new TimeInterval(initialTime, finalTime);
      
      // If phase sequence list is NOT empty:
      } else {
      
        // Creat a new TimeInterval with start time that begins at the previous interval
        TimeInterval last = this.phaseSequence.get(this.phaseSequence.size()-1);
        Time initialTime = last.getFinalTime();
        Time finalTime = initialTime.add(phaseDuration);
        phaseInterval = new TimeInterval(initialTime, finalTime);
      }
      
      // Add this new phase (interval and type) to schedule
      this.phaseSequence.add(phaseInterval);
      this.phaseMap.put(phaseInterval, phaseType);
    }
  }
  
  /**
   * Get Total Schedule Period (Length)
   */
  public Time getPeriod() {
    Time period = new Time(this.getUnit());
    for(TimeInterval phaseInterval : phaseSequence) {
      Time phaseDuration = phaseInterval.getDuration();
      period = period.add(phaseDuration);
    }
    return period;
  }
  
  /**
   * Retrieve the Phase associated with the given Time, assuming that the sequence 
   * of phases repeats indefinitely.
   *
   * @param currentTime instant passed to schedule
   */
  public Phase getPhase(Time currentTime) {
    TimeInterval currentInterval = this.getInterval(currentTime);
    if(currentInterval != null) {
      return this.phaseMap.get(currentInterval);
    } else {
      return null;
    }
  }
  
  /**
   * Retrieve current phase interval, assuming that the sequence of phases repeats 
   * indefinitely.
   *
   * @param Time currentTime instant passed to schedule
   */
  public TimeInterval getInterval(Time currentTime) {
    
    // If phase sequence list is empty:
    if (this.getSequence().size() == 0) {
      println("Error: There are no phases in the sequence");
      return new TimeInterval();
    
    // If phase sequence list is NOT empty:
    } else {
      
      // Get modulo of specified time with regard to schedule period.
      Time period = this.getPeriod();
      Time modulo = currentTime.modulo(period);
      
      // Iterate through phase sequences until it dosovers the phase at currentTime
      Time cumulativeTime = new Time(currentTime.getUnit());
      TimeInterval currentInterval = null;
      for(TimeInterval phaseInterval : phaseSequence) {
        
        // Set Current Time Interval
        currentInterval = phaseInterval;
        
        // Check if modulo is within current phase interal. break if so.
        Time phaseDuration = phaseInterval.getDuration();
        cumulativeTime = cumulativeTime.add(phaseDuration);
        if(cumulativeTime.getAmount() > modulo.getAmount()) {
          break;
        }
      }
      if(currentInterval == null) {
        println("Error: Phase interval not found");
      }
      return currentInterval;
    }
  }
}
